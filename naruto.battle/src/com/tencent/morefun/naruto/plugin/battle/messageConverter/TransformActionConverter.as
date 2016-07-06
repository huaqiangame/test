package com.tencent.morefun.naruto.plugin.battle.messageConverter
{

	import com.tencent.morefun.naruto.plugin.motion.data.ActivityHero;
	import com.tencent.morefun.naruto.plugin.motion.data.PassiveHero;
	import com.tencent.morefun.naruto.plugin.motion.data.SkillStatuInfo;
	import com.tencent.morefun.naruto.plugin.motion.data.TransformActionInfo;
	import com.tencent.morefun.naruto.plugin.motion.manager.FightManagerCenter;
	import com.tencent.morefun.naruto.plugin.motion.manager.ninja.Ninja;
	import com.tencent.morefun.naruto.plugin.motion.manager.ninja.data.NinjaInfo;
	import com.tencent.morefun.naruto.plugin.motion.manager.skill.SkillConfig;
	import com.tencent.morefun.naruto.plugin.motion.manager.skill.data.SkillDef;
	import com.tencent.morefun.naruto.plugin.motion.manager.skill.data.SkillInfo;
	
	import serverProto.fight.ProtoMetaAction;

	public class TransformActionConverter
	{
		public function TransformActionConverter()
		{
		}
		
		/**
		 *转换变身Action 
		 * @param metaAction
		 * 
		 */		
		public static function convertTransformAction(metaAction:ProtoMetaAction):void
		{
			var ninjaInfo:NinjaInfo;
			var changeNinjaSkillId:int;
			var changeNinjaActionInfo:TransformActionInfo;
			var activityHero:ActivityHero;
			var skillStatus:Array = [];
			var passiveHerosPos:Array = [];
			var skillInfo:SkillInfo;
			var ninja:Ninja;//临时
			var passiveHero:PassiveHero;
			var enterTeamSkillState:Array;
			var activityTeamSkillState:Array;
			
			passiveHerosPos = BaseConverter.getTransformPasssiveHerosPos(metaAction.transformAction);
			
			changeNinjaActionInfo = new TransformActionInfo();
			
			ninja = FightManagerCenter.ninjaMgr.getNinjaByPos(metaAction.transformAction.transformNinja.pos);
			
			passiveHero = BaseConverter.createPassiveNinja(metaAction.transformAction.transformNinja);
			passiveHero.hpChangedInfo = null;
			
			activityHero = BaseConverter.convertActivityNinja(metaAction.transformAction.activeNinja);
			activityHero.buffInfos = BuffConverter.getMetaBuffInfoList(metaAction);
			activityHero.buffEffectInfos = BuffConverter.getMetaBuffEffectInfoList(metaAction);
			activityHero.hpChangedInfo = BaseConverter.convertNinjaBaseChangedInfo(activityHero.pos, metaAction.transformAction.ninjaHpChange);
			activityHero.otherHpChangedInfoList = BaseConverter.convertOtherNinjaBaseChangedInfoList(activityHero.pos, metaAction.transformAction.ninjaHpChange, passiveHerosPos);
			activityHero.attributeChangedInfo = BaseConverter.convertNinjaAttributeChangedInfo(activityHero.pos, metaAction.transformAction.ninjaHpChange);
			activityHero.otherAttributeChangedInfoList = BaseConverter.convertOtherNinjaAttributeChangedInfoList(activityHero.pos, metaAction.transformAction.ninjaHpChange, passiveHerosPos);
			activityHero.passiveHeros.push(passiveHero);
			
			skillInfo = SkillConfig.getSkillInfo(activityHero.skillId);
			skillStatus = BaseConverter.convertSkillStatus(metaAction.teamSkillState);
			activityHero.skillStatusChangedList = skillStatus;
			if(skillInfo.type == SkillDef.TYPE_SPECIAL)
			{
				activityHero.useSpecialSkill = true;
			}
			
			
			changeNinjaActionInfo.activityHero = activityHero;
			changeNinjaActionInfo.enterNinjaInfo = BaseConverter.convertNinjaInfos(ninja.data.teamId, 0, [metaAction.transformAction.transformNinja], "", ninja.data.teamId)[0];
			changeNinjaActionInfo.enterNinjaInfo.skillStates = getEnterNinjaInfoSkillStatus(skillStatus, changeNinjaActionInfo.enterNinjaInfo.pos);
			BaseConverter.settingExeuntStageAction([changeNinjaActionInfo.enterNinjaInfo]);
//			changeNinjaActionInfo.enterNinjaInfo.skillStates = skillStatus;
			changeNinjaActionInfo.mask = metaAction.transformAction.hasNeedBlackScreen;
			changeNinjaActionInfo.visible = metaAction.transformAction.invisible == 0;
			ConverterResultInfo.addTransformAction(changeNinjaActionInfo);
		}
		
		private static function getEnterNinjaInfoSkillStatus(skillStatus:Array, enterNinjaPos:int):Array
		{
			var skillStatusInfo:SkillStatuInfo;
			var enterNinjaSkillStatus:Array = [];
			
			for(var i:int = 0;i < skillStatus.length;i ++)
			{
				skillStatusInfo = skillStatus[i];
				if(skillStatusInfo.pos == enterNinjaPos)
				{
					enterNinjaSkillStatus.push(skillStatusInfo);
					skillStatus.splice(i, 1);
					i --;
				}
			}
			
			return enterNinjaSkillStatus;
		}
																
		public function autoSetNull():void
		{

		}
	}
}