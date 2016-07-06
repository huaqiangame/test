package com.tencent.morefun.naruto.plugin.battle.messageConverter
{
	import com.tencent.morefun.naruto.plugin.motion.manager.buff.data.BuffInfo;
	import com.tencent.morefun.naruto.plugin.motion.manager.shield.data.ShieldConfig;
	import com.tencent.morefun.naruto.util.CollectionClearUtil;
	import flash.utils.Dictionary;
	import serverProto.fight.BuffActionTime;
	import serverProto.fight.MetaActionType;
	import serverProto.fight.ProtoBuffAction;
	import serverProto.fight.ProtoMetaAction;
	import com.tencent.morefun.naruto.util.CollectionClearUtil
	import com.tencent.morefun.naruto.util.CollectionClearUtil

	public class BuffConverter
	{
		private static var metaActionBuffMap:Dictionary = new Dictionary();
		
		public function BuffConverter()
		{
			
		}
		
		/**
		 *扫描Action列表 将其中BUFFAction单独提出来存放 供后续Action解析查询用
		 * @param metaActions
		 * 
		 */		
		public static function convertMetaBuffs(metaActions:Array):void
		{
			var buffInfo:BuffInfo;
			var buffAction:ProtoBuffAction;
			
			var buffList:Array;
			var beforeBuffActionList:Array = [];
			
			var lastAttackAction:ProtoMetaAction;
			
			for each(var metaAction:ProtoMetaAction in metaActions)
			{
				//定位最后的攻击类Action
				//常规攻击类
				if(metaAction.type == MetaActionType.MASTER_ACTION ||
					metaAction.type == MetaActionType.NORMAL_ACTION ||
					metaAction.type == MetaActionType.REBIRTH_ACTION)
				{
					lastAttackAction = metaAction;
					buffList = getMetaActionBuffList(lastAttackAction);
					buffList = buffList.concat(beforeBuffActionList);
					setMetaActionBuffList(lastAttackAction, buffList);
					beforeBuffActionList.splice(0, beforeBuffActionList.length);
				}
				
				//结界类
				if(metaAction.type == MetaActionType.ENCHANTMENT_ACITON)
				{
					if(metaAction.enchantmentAction.hasActiveNinja == true)
					{
						lastAttackAction = metaAction;
						buffList = getMetaActionBuffList(lastAttackAction);
						buffList = buffList.concat(beforeBuffActionList);
						setMetaActionBuffList(lastAttackAction, buffList);
						beforeBuffActionList.splice(0, beforeBuffActionList.length);
					}
				}
				
				//将BUFF添加到最后的攻击类action中或先存起来
				if(metaAction.type == MetaActionType.BUFF_ACTION)
				{
					buffAction = metaAction.buffAction;
					
					if(buffAction.buff && ShieldConfig.isShieldBuff(buffAction.buff.buffId) == true)
					{
						continue ;
					}
					
					if(buffAction.buffActionTime == BuffActionTime.AFTER_HIT ||
						buffAction.buffActionTime == BuffActionTime.AFTER_ATTACK ||
						buffAction.buffActionTime == BuffActionTime.BEFORE_ATTACK)
					{
						buffList = getMetaActionBuffList(lastAttackAction);
						buffList.push(buffAction);
						setMetaActionBuffList(lastAttackAction, buffList);
					}
				}
			}
		}
		
		/**
		 *传入Action列表 输出列表中的BUFFInfo 用在大回合同步时 
		 * @param metaActions
		 * @return 
		 * 
		 */		
		public static function getBuffInfoList(metaActions:Array):Array
		{
			var buffInfoArr:Array = new Array();
			for each (var metaAction:ProtoMetaAction in metaActions)
			{
				if (metaAction.type != MetaActionType.BUFF_ACTION)
				{
					continue;
				}
				
				if(ShieldConfig.isShieldBuff(metaAction.buffAction.buff.buffId) == true)
				{
					continue ;
				}
				
				buffInfoArr.push(BaseConverter.convertBuffAction(metaAction.buffAction, metaAction.isOver));
			}
			return buffInfoArr;
		}
		
		public static function reset():void
		{
			CollectionClearUtil.clearDictionary(metaActionBuffMap);
		}
		
		/**
		 *获取与指定Action绑定的BUFFAction 
		 * @param metaAction
		 * @return 
		 * 
		 */		
		public static function getMetaBuffInfoList(metaAction:ProtoMetaAction):Array
		{
			var buffList:Array;
			var buffInfoList:Array = [];
			
			buffList = getMetaActionBuffList(metaAction);
			for each(var buffAction:ProtoBuffAction in buffList)
			{
				if(buffAction.addBuffType == 0)
				{
					buffInfoList.push(BaseConverter.convertBuffAction(buffAction, metaAction.isOver));
				}
			}
			
			return buffInfoList;
		}
		
		public static function getMetaBuffEffectInfoList(metaAction:ProtoMetaAction):Array
		{
			var buffList:Array;
			var buffEffectInfoList:Array = [];
			
			buffList = getMetaActionBuffList(metaAction);
			for each(var buffAction:ProtoBuffAction in buffList)
			{
				if(buffAction.addBuffType != 0)
				{
					buffEffectInfoList.push(BaseConverter.convertBuffEffectAction(buffAction, metaAction.isOver));
				}
			}
			
			return buffEffectInfoList;
		}
		
		private static function setMetaActionBuffList(metaAction:ProtoMetaAction, buffList:Array):void
		{
			metaActionBuffMap[metaAction] = buffList;
		}
		
		private static function getMetaActionBuffList(metaAction:ProtoMetaAction):Array
		{
			var buffList:Array;
			
			buffList = metaActionBuffMap[metaAction];
			if(buffList == null)
			{
				buffList = [];
				metaActionBuffMap[metaAction] = buffList;
			}
			
			return buffList;
		}
																
		public function autoSetNull():void
		{

			metaActionBuffMap = null;
		}
	}
}