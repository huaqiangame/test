package com.tencent.morefun.naruto.plugin.battle.messageConverter
{
	import com.tencent.morefun.naruto.plugin.motion.data.ActivityHero;
	import com.tencent.morefun.naruto.plugin.motion.data.KathaChangedInfo;
	import com.tencent.morefun.naruto.plugin.motion.data.PassiveHero;
	
	import serverProto.fight.ProtoMetaAction;

	public class NormalActionConverter
	{
		public function NormalActionConverter()
		{
		}
		
		/**
		 *转换普通攻击Action 
		 * @param metaAction
		 * 
		 */		
		public static function convertNormalAction(metaAction:ProtoMetaAction):Boolean
		{
			var isFollowEnd:Boolean;
			var activityHero:ActivityHero;
			var skillStatus:Array = [];
			var enchantmentSkillId:int;
			var kathaChangeInfo:KathaChangedInfo;
			var passiveHerosPos:Array = [];
			var enchantmentNinjaHpChangedList:Array;
			
			enchantmentNinjaHpChangedList = EnchantmentConverter.getActionEnchantmentNinjaHpChange(metaAction);
			if(enchantmentNinjaHpChangedList != null && metaAction.normalAction != null)
			{
				metaAction.normalAction.ninjaHpChange = metaAction.normalAction.ninjaHpChange.concat(enchantmentNinjaHpChangedList);
			}
			
			passiveHerosPos = BaseConverter.getNormalActionPassiveHerosPos(metaAction.normalAction);
			
			isFollowEnd = FollowActionConverter.getActionIsFollowEnd(metaAction);
			activityHero = BaseConverter.convertNormalActivtiyNinja(metaAction.normalAction.activeNinja, metaAction.normalAction);
			activityHero.passiveHeros = BaseConverter.convertPassiveNinjas(metaAction.normalAction.passiveNinja, metaAction.normalAction);
			skillStatus = BaseConverter.convertSkillStatus(metaAction.teamSkillState);
			skillStatus = skillStatus.concat(EnchantmentConverter.getEnchantmentSkillStatus(metaAction));
			activityHero.skillStatusChangedList = skillStatus;
			activityHero.buffInfos = BuffConverter.getMetaBuffInfoList(metaAction);
			activityHero.buffEffectInfos = BuffConverter.getMetaBuffEffectInfoList(metaAction);
			activityHero.shieldInfos = ShieldConverter.getMetaShieldInfoList(metaAction);
			activityHero.enchantment = EnchantmentConverter.getEnchantmentId(metaAction);
			activityHero.cancelSkillList = BaseConverter.convertAbortNinjaAwakenSkill(metaAction.abortNinjaAwakenSkill);
			activityHero.kathaChangedNotifyList = BaseConverter.convertKathaChangeNotify(metaAction.normalAction.teamKathaChange);
			activityHero.kathaChangedList = BaseConverter.convertKathaChangeByNormalAction(metaAction.normalAction.teamKathaChange, metaAction.normalAction, passiveHerosPos);
			if(activityHero.hpChangedInfo == null)//没有血量变化 补一下查克拉变更信息
			{
				kathaChangeInfo = BaseConverter.convertKathaChangeByPos(activityHero.pos, metaAction.normalAction.teamKathaChange);
				if(kathaChangeInfo)
				{
					activityHero.kathaChangedList.push(kathaChangeInfo);
				}
			}
			
			for each(var passiveHero:PassiveHero in activityHero.passiveHeros)
			{
				if(passiveHero.hpChangedInfo == null && passiveHero.pos != activityHero.pos)//没有血量变化 补一下查克拉变更信息
				{
					kathaChangeInfo = BaseConverter.convertKathaChangeByPos(passiveHero.pos, metaAction.normalAction.teamKathaChange);
					if(kathaChangeInfo)
					{
						activityHero.kathaChangedList.push(kathaChangeInfo);
					}
				}
			}
			
			enchantmentSkillId = EnchantmentConverter.getEnchantmentSkillId(metaAction);
			if(enchantmentSkillId != -1)
			{
				activityHero.useSkillIdList.push(enchantmentSkillId);
			}
			ConverterResultInfo.addAttackAction(activityHero, isFollowEnd, metaAction.isOver);
			return !isFollowEnd;
		}
																
		public function autoSetNull():void
		{

		}
	}
}