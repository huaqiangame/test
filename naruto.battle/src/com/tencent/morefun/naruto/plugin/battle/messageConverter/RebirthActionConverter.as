package com.tencent.morefun.naruto.plugin.battle.messageConverter
{
	import com.tencent.morefun.naruto.plugin.motion.data.ActivityHero;
	import serverProto.fight.ProtoMetaAction;

	public class RebirthActionConverter
	{
		public function RebirthActionConverter()
		{
		}
		
		public static function convertRebirthAction(metaAction:ProtoMetaAction):void
		{
			switch(metaAction.rebirthAction.rebirthType)
			{
				case 1:
					convertPassiveRebirthAction(metaAction);
					break;
				case 2:
					convertSwapRebirthAction(metaAction);
					break;
				case 3:
					convertNormalRebirthAction(metaAction);
					break;
			}
		}
		
		private static function convertPassiveRebirthAction(metaAction:ProtoMetaAction):void
		{
			var isFollowEnd:Boolean;
			var activityHero:ActivityHero;
			var skillStatus:Array = [];
			var passiveHerosPos:Array = [];
			var enchantmentSkillId:int;
			var enchantmentNinjaHpChangedList:Array;
			
			enchantmentNinjaHpChangedList = EnchantmentConverter.getActionEnchantmentNinjaHpChange(metaAction);
			if(enchantmentNinjaHpChangedList != null && metaAction.rebirthAction != null)
			{
				metaAction.rebirthAction.ninjaHpChange = metaAction.rebirthAction.ninjaHpChange.concat(enchantmentNinjaHpChangedList);
			}
			
			passiveHerosPos = BaseConverter.getRebirthHerosPos(metaAction.rebirthAction);
			
			isFollowEnd = FollowActionConverter.getActionIsFollowEnd(metaAction);
			activityHero = BaseConverter.createActivityNinja(metaAction.rebirthAction.rebirthNinja, metaAction.rebirthAction.rebirthSkill);
			activityHero.passiveHeros = [BaseConverter.createPassiveNinja(metaAction.rebirthAction.rebirthNinja)];
			activityHero.buffInfos = BuffConverter.getMetaBuffInfoList(metaAction);
			activityHero.buffEffectInfos = BuffConverter.getMetaBuffEffectInfoList(metaAction);
			activityHero.shieldInfos = ShieldConverter.getMetaShieldInfoList(metaAction);
			activityHero.enchantment = EnchantmentConverter.getEnchantmentId(metaAction);
			activityHero.skillStatusChangedList = BaseConverter.convertSkillStatus(metaAction.teamSkillState);
			activityHero.hpChangedInfo = BaseConverter.convertNinjaBaseChangedInfo(activityHero.pos, metaAction.rebirthAction.ninjaHpChange);
			activityHero.otherHpChangedInfoList = BaseConverter.convertOtherNinjaBaseChangedInfoList(activityHero.pos, metaAction.rebirthAction.ninjaHpChange, passiveHerosPos);
			activityHero.attributeChangedInfo = BaseConverter.convertNinjaAttributeChangedInfo(activityHero.pos, metaAction.rebirthAction.ninjaHpChange);
			activityHero.otherAttributeChangedInfoList = BaseConverter.convertOtherNinjaAttributeChangedInfoList(activityHero.pos, metaAction.rebirthAction.ninjaHpChange, passiveHerosPos);
			enchantmentSkillId = EnchantmentConverter.getEnchantmentSkillId(metaAction);
			if(enchantmentSkillId != -1)
			{
				activityHero.useSkillIdList.push(enchantmentSkillId);
			}
			ConverterResultInfo.addAttackAction(activityHero, isFollowEnd, metaAction.isOver);
		}
		
		private static function convertSwapRebirthAction(metaAction:ProtoMetaAction):void
		{
			var isFollowEnd:Boolean;
			var activityHero:ActivityHero;
			var skillStatus:Array = [];
			var passiveHerosPos:Array = [];
			var enchantmentSkillId:int;
			var enchantmentNinjaHpChangedList:Array;
			
			enchantmentNinjaHpChangedList = EnchantmentConverter.getActionEnchantmentNinjaHpChange(metaAction);
			if(enchantmentNinjaHpChangedList != null && metaAction.rebirthAction != null)
			{
				metaAction.rebirthAction.ninjaHpChange = metaAction.rebirthAction.ninjaHpChange.concat(enchantmentNinjaHpChangedList);
			}
			passiveHerosPos = BaseConverter.getRebirthHerosPos(metaAction.rebirthAction);
			
			isFollowEnd = FollowActionConverter.getActionIsFollowEnd(metaAction);
			activityHero = BaseConverter.createActivityNinja(metaAction.rebirthAction.rebirthNinja, metaAction.rebirthAction.rebirthSkill);
			activityHero.passiveHeros = [BaseConverter.createPassiveNinja(metaAction.rebirthAction.killNinja)];
			activityHero.buffInfos = BuffConverter.getMetaBuffInfoList(metaAction);
			activityHero.buffEffectInfos = BuffConverter.getMetaBuffEffectInfoList(metaAction);
			activityHero.shieldInfos = ShieldConverter.getMetaShieldInfoList(metaAction);
			activityHero.enchantment = EnchantmentConverter.getEnchantmentId(metaAction);
			activityHero.skillStatusChangedList = BaseConverter.convertSkillStatus(metaAction.teamSkillState);
			activityHero.hpChangedInfo = BaseConverter.convertNinjaBaseChangedInfo(activityHero.pos, metaAction.rebirthAction.ninjaHpChange);
			activityHero.otherHpChangedInfoList = BaseConverter.convertOtherNinjaBaseChangedInfoList(activityHero.pos, metaAction.rebirthAction.ninjaHpChange, passiveHerosPos);
			activityHero.attributeChangedInfo = BaseConverter.convertNinjaAttributeChangedInfo(activityHero.pos, metaAction.rebirthAction.ninjaHpChange);
			activityHero.otherAttributeChangedInfoList = BaseConverter.convertOtherNinjaAttributeChangedInfoList(activityHero.pos, metaAction.rebirthAction.ninjaHpChange, passiveHerosPos);
			enchantmentSkillId = EnchantmentConverter.getEnchantmentSkillId(metaAction);
			if(enchantmentSkillId != -1)
			{
				activityHero.useSkillIdList.push(enchantmentSkillId);
			}
			ConverterResultInfo.addAttackAction(activityHero, isFollowEnd, metaAction.isOver);
		}
		
		private static function convertNormalRebirthAction(metaAction:ProtoMetaAction):void
		{
			var isFollowEnd:Boolean;
			var activityHero:ActivityHero;
			var skillStatus:Array = [];
			var passiveHerosPos:Array = [];
			var enchantmentSkillId:int;
			var enchantmentNinjaHpChangedList:Array;
			
			enchantmentNinjaHpChangedList = EnchantmentConverter.getActionEnchantmentNinjaHpChange(metaAction);
			if(enchantmentNinjaHpChangedList != null && metaAction.rebirthAction != null)
			{
				metaAction.rebirthAction.ninjaHpChange = metaAction.rebirthAction.ninjaHpChange.concat(enchantmentNinjaHpChangedList);
			}
			
			passiveHerosPos = BaseConverter.getRebirthHerosPos(metaAction.rebirthAction);
			
			isFollowEnd = FollowActionConverter.getActionIsFollowEnd(metaAction);
			activityHero = BaseConverter.convertActivityNinja(metaAction.rebirthAction.activeNinja);
			activityHero.passiveHeros = [BaseConverter.createPassiveNinja(metaAction.rebirthAction.rebirthNinja)];
			activityHero.buffInfos = BuffConverter.getMetaBuffInfoList(metaAction);
			activityHero.buffEffectInfos = BuffConverter.getMetaBuffEffectInfoList(metaAction);
			activityHero.shieldInfos = ShieldConverter.getMetaShieldInfoList(metaAction);
			activityHero.enchantment = EnchantmentConverter.getEnchantmentId(metaAction);
			activityHero.skillStatusChangedList = BaseConverter.convertSkillStatus(metaAction.teamSkillState);
			enchantmentSkillId = EnchantmentConverter.getEnchantmentSkillId(metaAction);
			activityHero.hpChangedInfo = BaseConverter.convertNinjaBaseChangedInfo(activityHero.pos, metaAction.rebirthAction.ninjaHpChange);
			activityHero.otherHpChangedInfoList = BaseConverter.convertOtherNinjaBaseChangedInfoList(activityHero.pos, metaAction.rebirthAction.ninjaHpChange, passiveHerosPos);
			activityHero.attributeChangedInfo = BaseConverter.convertNinjaAttributeChangedInfo(activityHero.pos, metaAction.rebirthAction.ninjaHpChange);
			activityHero.otherAttributeChangedInfoList = BaseConverter.convertOtherNinjaAttributeChangedInfoList(activityHero.pos, metaAction.rebirthAction.ninjaHpChange, passiveHerosPos);
			if(enchantmentSkillId != -1)
			{
				activityHero.useSkillIdList.push(enchantmentSkillId);
			}
			ConverterResultInfo.addAttackAction(activityHero, isFollowEnd, metaAction.isOver);
		}
																
		public function autoSetNull():void
		{

		}
	}
}