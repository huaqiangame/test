package com.tencent.morefun.naruto.plugin.battle.messageConverter
{
	import com.tencent.morefun.naruto.plugin.motion.data.ActivityHero;
	import com.tencent.morefun.naruto.plugin.motion.data.KathaChangedInfo;
	import com.tencent.morefun.naruto.plugin.motion.data.PassiveHero;
	
	import serverProto.fight.CahootNinjaAttackType;
	import serverProto.fight.ProtoActiveNinjaInfo;
	import serverProto.fight.ProtoMetaAction;

	public class MasterActionConverter
	{
		public function MasterActionConverter()
		{
			
		}
		
		/**
		 *解析 召唤攻击
		 * @param metaAction
		 * 
		 */		
		public static function convertMasterAction(metaAction:ProtoMetaAction):Boolean
		{
			var isFollowEnd:Boolean;
			var isLastCahootNinja:Boolean;
			
			var activityHero:ActivityHero;
			var cahootNinja:ProtoActiveNinjaInfo;
			
			var skillStatus:Array = [];
			var cahootActivityHero:ActivityHero;
			
			var enchantmentSkillId:int;
			var kathaChangeInfo:KathaChangedInfo;
			var enchantmentNinjaHpChangedList:Array;
			
			
			enchantmentNinjaHpChangedList = EnchantmentConverter.getActionEnchantmentNinjaHpChange(metaAction);
			if(enchantmentNinjaHpChangedList != null && metaAction.normalAction != null)
			{
				metaAction.normalAction.ninjaHpChange = metaAction.normalAction.ninjaHpChange.concat(enchantmentNinjaHpChangedList);
			}
			
			//解析攻击者Action
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
			activityHero.kathaChangedList = BaseConverter.convertKathaChangeByNormalAction(metaAction.normalAction.teamKathaChange, metaAction.normalAction, metaAction.normalAction.passiveNinja);
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
					kathaChangeInfo = BaseConverter.convertKathaChangeByPos(activityHero.pos, metaAction.normalAction.teamKathaChange);
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
			
			//检测是否有后续Action和是否最后一回合
			if(metaAction.normalAction.ninjaAttackType == CahootNinjaAttackType.CAHOOT_ATTACK_AFTER_MASTER &&
				metaAction.normalAction.cahootNinja.length != 0)
			{
				ConverterResultInfo.addAttackAction(activityHero, false, false);
			}
			else
			{
				ConverterResultInfo.addAttackAction(activityHero, isFollowEnd, metaAction.isOver);
			}
			
			//分身Action
			for(var i:int = 0;i < metaAction.normalAction.cahootNinja.length;i ++)
			{
				cahootNinja = metaAction.normalAction.cahootNinja[i];
				isLastCahootNinja = (i == metaAction.normalAction.cahootNinja.length - 1);
				
				//影分身攻击
				if(metaAction.normalAction.ninjaAttackType == CahootNinjaAttackType.CAHOOT_ATTACK_WITH_MASTER)
				{
					activityHero.cahootPos.push(cahootNinja.activeNinjaPos);
				}
				
				//傀儡攻击
				if(metaAction.normalAction.ninjaAttackType == CahootNinjaAttackType.CAHOOT_ATTACK_AFTER_MASTER)
				{
					activityHero.hold = false;
					cahootActivityHero = BaseConverter.convertCahootNinja(cahootNinja);
					cahootActivityHero.realPassiveBeHit = false;
					cahootActivityHero.passiveHeros = activityHero.passiveHeros;
					activityHero.puppetPos = cahootActivityHero.pos;
					
					ConverterResultInfo.addAttackAction(cahootActivityHero, isFollowEnd, isLastCahootNinja && metaAction.isOver);
				}
			}
			
			return !isFollowEnd;
		}
																
		public function autoSetNull():void
		{

		}
	}
}