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

	public class ShieldConverter
	{
		private static var metaActionShieldMap:Dictionary = new Dictionary();
		
		public function ShieldConverter()
		{
		}
		
		/**
		 *扫描Action列表 将其中类型为护盾的BUFFAction单独提出来存放 供后续Action解析查询用
		 * @param metaActions
		 * 
		 */		
		public static function convertMetaBuffs(metaActions:Array):void
		{
			var buffInfo:BuffInfo;
			var buffAction:ProtoBuffAction;
			
			var shieldList:Array;
			var beforeShieldActionList:Array = [];
			
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
					shieldList = getMetaActionShieldList(lastAttackAction);
					shieldList = shieldList.concat(beforeShieldActionList);
					setMetaActionShieldList(lastAttackAction, shieldList);
					beforeShieldActionList.splice(0, beforeShieldActionList.length);
				}
				
				//结界类
				if(metaAction.type == MetaActionType.ENCHANTMENT_ACITON)
				{
					if(metaAction.enchantmentAction.hasActiveNinja == true)
					{
						lastAttackAction = metaAction;
						shieldList = getMetaActionShieldList(lastAttackAction);
						shieldList = shieldList.concat(beforeShieldActionList);
						setMetaActionShieldList(lastAttackAction, shieldList);
						beforeShieldActionList.splice(0, beforeShieldActionList.length);
					}
				}
				
				//将BUFF添加到最后的攻击类action中或先存起来
				if(metaAction.type == MetaActionType.BUFF_ACTION)
				{
					buffAction = metaAction.buffAction;
					
					if(!buffAction.buff || ShieldConfig.isShieldBuff(buffAction.buff.buffId) == false)
					{
						continue ;
					}
					
					if(buffAction.buffActionTime == BuffActionTime.AFTER_HIT ||
						buffAction.buffActionTime == BuffActionTime.AFTER_ATTACK ||
						buffAction.buffActionTime == BuffActionTime.BEFORE_ATTACK)
					{
						shieldList = getMetaActionShieldList(lastAttackAction);
						shieldList.push(buffAction);
						setMetaActionShieldList(lastAttackAction, shieldList);
					}
				}
			}
		}
		
		/**
		 *传入Action列表 输出列表中的类型为护盾的BUFFInfo 用在大回合同步时 
		 * @param metaActions
		 * @return 
		 * 
		 */		
		public static function getShieldInfoList(metaActions:Array):Array
		{
			var shieldInfoArr:Array = new Array();
			for each (var metaAction:ProtoMetaAction in metaActions)
			{
				if (metaAction.type != MetaActionType.BUFF_ACTION)
				{
					continue;
				}
				
				if(ShieldConfig.isShieldBuff(metaAction.buffAction.buff.buffId) == false)
				{
					continue ;
				}
				
				shieldInfoArr.push(BaseConverter.convertShieldAction(metaAction.buffAction));
			}
			return shieldInfoArr;
		}
		
		public static function reset():void
		{
			CollectionClearUtil.clearDictionary(metaActionShieldMap);
		}
		
		/**
		 *获取与指定Action绑定类型为护盾的BUFFAction 
		 * @param metaAction
		 * @return 
		 * 
		 */		
		public static function getMetaShieldInfoList(metaAction:ProtoMetaAction):Array
		{
			var buffList:Array;
			var shieldInfoList:Array = [];
			
			buffList = getMetaActionShieldList(metaAction);
			for each(var buffAction:ProtoBuffAction in buffList)
			{
				shieldInfoList.push(BaseConverter.convertShieldAction(buffAction));
			}
			
			return shieldInfoList;
		}
		
		private static function setMetaActionShieldList(metaAction:ProtoMetaAction, buffList:Array):void
		{
			metaActionShieldMap[metaAction] = buffList;
		}
		
		private static function getMetaActionShieldList(metaAction:ProtoMetaAction):Array
		{
			var buffList:Array;
			
			buffList = metaActionShieldMap[metaAction];
			if(buffList == null)
			{
				buffList = [];
				metaActionShieldMap[metaAction] = buffList;
			}
			
			return buffList;
		}
																
		public function autoSetNull():void
		{

			metaActionShieldMap = null;
		}
	}
}