package com.tencent.morefun.naruto.plugin.battle.messageConverter
{

	import com.tencent.morefun.naruto.plugin.motion.data.ActivityHero;
	import com.tencent.morefun.naruto.plugin.motion.data.EnchantmentActionInfo;
	import com.tencent.morefun.naruto.plugin.motion.data.SkillStatuInfo;
	import com.tencent.morefun.naruto.util.CollectionClearUtil;
	
	import flash.utils.Dictionary;
	
	import serverProto.fight.MetaActionType;
	import serverProto.fight.ProtoAbortNinjaAwakenSkill;
	import serverProto.fight.ProtoEnchantmentAction;
	import serverProto.fight.ProtoMetaAction;
	import serverProto.fight.ProtoNinjaHpChange;

    import com.tencent.morefun.naruto.i18n.I18n;
	public class EnchantmentConverter
	{
		private static var metaActionEnchantmentSkillStatuesMap:Dictionary = new Dictionary();
		private static var metaActionEnchantmentIdMap:Dictionary = new Dictionary();
		private static var metaActionEnchantmentSkillIdMap:Dictionary = new Dictionary();
		private static var metaActionEnchantmentNinjaHpChangeMap:Dictionary = new Dictionary();
		
		public function EnchantmentConverter()
		{
		}
		
		
		
		/**
		 *扫描Action列表先将附属在其他Action上的结界提取出来
		 * @param metaActions
		 * 
		 */		
		public static function convertEnchantments(metaActions:Array):void
		{
			var isTriggerFollowAction:Boolean;
			
			var skillStateList:Array = [];
			var lastSkillStatus:Array = [];
			
			var enchantmentId:int = -1;
			var enchantmentSkillId:int = -1;
			var ninjaHpChanges:Array;
			var enchantmentAction:ProtoEnchantmentAction;
			
			for each(var metaAction:ProtoMetaAction in metaActions)
			{
				//找出附加在其他Action上的结界切换
				if(metaAction.type == MetaActionType.ENCHANTMENT_ACITON)
				{
					enchantmentAction = metaAction.enchantmentAction;
					
					if(enchantmentAction.hasAdditionalSkill != 0)
					{
						enchantmentId = enchantmentAction.enchantmentId;
						enchantmentSkillId = enchantmentAction.activeNinja.skillInfo.skillId;
						ninjaHpChanges = enchantmentAction.ninjaHpChange;
						lastSkillStatus = BaseConverter.convertSkillStatus(metaAction.teamSkillState);
						ConverterResultInfo.callCancelSkillCommand(metaAction.abortNinjaAwakenSkill);
					}
				}
				
				//将对应的结界切换设置到对应的Action当中
				if(metaAction.type == MetaActionType.MASTER_ACTION ||
					metaAction.type == MetaActionType.NORMAL_ACTION ||
					metaAction.type == MetaActionType.REBIRTH_ACTION)
				{
					skillStateList = getMetaActionSkillStatusList(metaAction);
					for each(var skillStatusInfo:SkillStatuInfo in lastSkillStatus)
					{
						skillStateList.push(skillStatusInfo);
					}
					lastSkillStatus = [];
					setActionEnchantmentId(metaAction, enchantmentId);
					setActionEnchantmentSkillId(metaAction, enchantmentSkillId);
					setActionEnchantmentNinjaHpChange(metaAction, ninjaHpChanges);
					
					enchantmentId = -1;
					enchantmentSkillId = -1;
					ninjaHpChanges = null;
				}
			}
		}
		
		public static function getEnchatmentActions(metaActions:Array):Array
		{
			var enchantmentActionList:Array;
			var enchantmentAction:ProtoEnchantmentAction;
			
			enchantmentActionList = [];
			
			for each(var metaAction:ProtoMetaAction in metaActions)
			{
				if(metaAction.type == MetaActionType.ENCHANTMENT_ACITON)
				{
					enchantmentAction = metaAction.enchantmentAction;
					if(enchantmentAction.hasAdditionalSkill)
					{
						throw new Error(I18n.lang("as_battle_1451031565_354"));
						continue ;
					}
					
					if(enchantmentAction.hasActiveNinja)
					{
						throw new Error(I18n.lang("as_battle_1451031565_355"));
						continue ;
					}
					
					var enchantment:EnchantmentActionInfo = new EnchantmentActionInfo();
					enchantment.enchatmentId = enchantmentAction.enchantmentId;
					enchantment.type = enchantmentAction.actionType;
					enchantment.kathaChangedList = BaseConverter.convertKathaChangeNotify(enchantmentAction.teamKathaChange);
					enchantment.hpChangedList = BaseConverter.convertEnchantBaseCHnagedInfo(enchantmentAction.ninjaHpChange);
					enchantment.skillStatusChangedList = BaseConverter.convertSkillStatus(metaAction.teamSkillState);
					enchantmentActionList.push(enchantment);
				}
			}
			
			return enchantmentActionList;
		}
		
		public static function reset():void
		{
			CollectionClearUtil.clearDictionary(metaActionEnchantmentIdMap);
			CollectionClearUtil.clearDictionary(metaActionEnchantmentSkillIdMap);
			CollectionClearUtil.clearDictionary(metaActionEnchantmentSkillStatuesMap);
			CollectionClearUtil.clearDictionary(metaActionEnchantmentNinjaHpChangeMap);
		}
		
		/**
		 *转换结界Action 
		 * @param metaAction
		 * 
		 */		
		public static function convertEnchantment(metaAction:ProtoMetaAction):Boolean
		{
			var isFollowEnd:Boolean;
			var activityHero:ActivityHero;

			var passiveHerosPos:Array = [];
			var enchantmentAction:ProtoEnchantmentAction;
			var abortNinjaAwakenSkill:ProtoAbortNinjaAwakenSkill;
			
			enchantmentAction = metaAction.enchantmentAction;
			if(enchantmentAction.hasAdditionalSkill == 0)
			{
				if(enchantmentAction.hasActiveNinja == false)
				{
					var enchantment:EnchantmentActionInfo = new EnchantmentActionInfo();
					enchantment.enchatmentId = enchantmentAction.enchantmentId;
					enchantment.kathaChangedList = BaseConverter.convertKathaChangeNotify(enchantmentAction.teamKathaChange);
					enchantment.hpChangedList = BaseConverter.convertEnchantBaseCHnagedInfo(enchantmentAction.ninjaHpChange);
					enchantment.type = enchantmentAction.actionType;
					enchantment.skillStatusChangedList = BaseConverter.convertSkillStatus(metaAction.teamSkillState);
					for each(abortNinjaAwakenSkill in metaAction.abortNinjaAwakenSkill)
					{
						enchantment.cancelSkillList.push(abortNinjaAwakenSkill.ninjaPos);
					}
					ConverterResultInfo.addEnchantmentAction(enchantment);
				}
				
				if(enchantmentAction.hasActiveNinja)
				{
					isFollowEnd = FollowActionConverter.getActionIsFollowEnd(metaAction);
					
					passiveHerosPos = BaseConverter.getEmptyPassiveHerosPos();
					
					activityHero = BaseConverter.convertEnchantmentNinja(enchantmentAction.activeNinja);
					activityHero.enchantment = enchantmentAction.enchantmentId;
					activityHero.skillStatusChangedList = BaseConverter.convertSkillStatus(metaAction.teamSkillState);
					activityHero.buffInfos = BuffConverter.getMetaBuffInfoList(metaAction);
					activityHero.buffEffectInfos = BuffConverter.getMetaBuffEffectInfoList(metaAction);
					activityHero.shieldInfos = ShieldConverter.getMetaShieldInfoList(metaAction);
					activityHero.hpChangedInfo = BaseConverter.convertNinjaBaseChangedInfo(activityHero.pos, enchantmentAction.ninjaHpChange);
					activityHero.otherHpChangedInfoList = BaseConverter.convertOtherNinjaBaseChangedInfoList(activityHero.pos, enchantmentAction.ninjaHpChange, passiveHerosPos);
					activityHero.attributeChangedInfo =  BaseConverter.convertNinjaAttributeChangedInfo(activityHero.pos, enchantmentAction.ninjaHpChange);
					activityHero.otherAttributeChangedInfoList = BaseConverter.convertOtherNinjaAttributeChangedInfoList(activityHero.pos, enchantmentAction.ninjaHpChange, passiveHerosPos);
					activityHero.kathaChangedNotifyList = BaseConverter.convertKathaChangeNotify(enchantmentAction.teamKathaChange);
					activityHero.kathaChangedList = BaseConverter.convertKathaChangeNotify(enchantmentAction.teamKathaChange);
					for each(abortNinjaAwakenSkill in metaAction.abortNinjaAwakenSkill)
					{
						activityHero.cancelSkillList.push(abortNinjaAwakenSkill.ninjaPos);
					}
					
					ConverterResultInfo.addAttackAction(activityHero, isFollowEnd, metaAction.isOver);
				}
				
			}
			
			return !isFollowEnd;
		}
		
		/**
		 * 获取与该Action绑定的技能变更列表
		 * @param protoMetaAction
		 * @return 
		 * 
		 */		
		public static function getEnchantmentSkillStatus(protoMetaAction:ProtoMetaAction):Array
		{
			return metaActionEnchantmentSkillStatuesMap[protoMetaAction];
		}
		
		/**
		 * 获取与该Action版定的结界ID
		 * @param protoMetaAction
		 * @return 
		 * 
		 */		
		public static function getEnchantmentId(protoMetaAction:ProtoMetaAction):int
		{
			return metaActionEnchantmentIdMap[protoMetaAction];
		}
		
		public static function getEnchantmentSkillId(protoMetaAction:ProtoMetaAction):int
		{
			return metaActionEnchantmentSkillIdMap[protoMetaAction];
		}
		
		public static function getActionEnchantmentNinjaHpChange(protoMetaAction:ProtoMetaAction):Array
		{
			return metaActionEnchantmentNinjaHpChangeMap[protoMetaAction];
		}
		
		private static function getMetaActionSkillStatusList(metaAction:ProtoMetaAction):Array
		{
			var enchantmentList:Array;
			
			enchantmentList = metaActionEnchantmentSkillStatuesMap[metaAction];
			if(enchantmentList == null)
			{
				enchantmentList = [];
				metaActionEnchantmentSkillStatuesMap[metaAction] = enchantmentList;
			}
			
			return enchantmentList;
		}
		
		private static function setActionEnchantmentId(protoMetaAction:ProtoMetaAction, enchantmentId:int):void
		{
			metaActionEnchantmentIdMap[protoMetaAction] = enchantmentId;
		}
		
		private static function setActionEnchantmentSkillId(protoMetaAction:ProtoMetaAction, enchantmentSkillId:int):void
		{
			metaActionEnchantmentSkillIdMap[protoMetaAction] = enchantmentSkillId;
		}
		
		private static function setActionEnchantmentNinjaHpChange(protoMetaAction:ProtoMetaAction, hpChangeList:Array):void
		{
			metaActionEnchantmentNinjaHpChangeMap[protoMetaAction] = hpChangeList;
		}
																
		public function autoSetNull():void
		{

			metaActionEnchantmentSkillStatuesMap = null;
			metaActionEnchantmentIdMap = null;
			metaActionEnchantmentSkillIdMap = null;
		}
	}
}