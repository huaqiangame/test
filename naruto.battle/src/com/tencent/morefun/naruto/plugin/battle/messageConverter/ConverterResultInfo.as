package com.tencent.morefun.naruto.plugin.battle.messageConverter
{

	import com.tencent.morefun.naruto.plugin.battle.command.CancelSkillActionCommand;
	import com.tencent.morefun.naruto.plugin.battle.data.BattleData;
	import com.tencent.morefun.naruto.plugin.battle.data.UIData;
	import com.tencent.morefun.naruto.plugin.battle.notice.ContractPetEnterNotice;
	import com.tencent.morefun.naruto.plugin.battle.notice.ContractPetExeuntNotice;
	import com.tencent.morefun.naruto.plugin.battle.notice.UpdatePlayerInfoNotice;
	import com.tencent.morefun.naruto.plugin.motion.data.AbortSkillActionInfo;
	import com.tencent.morefun.naruto.plugin.motion.data.ActivityHero;
	import com.tencent.morefun.naruto.plugin.motion.data.BubbleDialogueActionInfo;
	import com.tencent.morefun.naruto.plugin.motion.data.CallupActionInfo;
	import com.tencent.morefun.naruto.plugin.motion.data.ComboActionInfo;
	import com.tencent.morefun.naruto.plugin.motion.data.CommonActionInfo;
	import com.tencent.morefun.naruto.plugin.motion.data.EnchantmentActionInfo;
	import com.tencent.morefun.naruto.plugin.motion.data.FormatActionInfo;
	import com.tencent.morefun.naruto.plugin.motion.data.OnlyDefenceEffectActionInfo;
	import com.tencent.morefun.naruto.plugin.motion.data.ScriptActionInfo;
	import com.tencent.morefun.naruto.plugin.motion.data.StageActionInfo;
	import com.tencent.morefun.naruto.plugin.motion.data.TransformActionInfo;
	import com.tencent.morefun.naruto.plugin.motion.manager.skill.SkillConfig;
	import com.tencent.morefun.naruto.plugin.motion.manager.skill.data.SkillDef;
	import utils.PlayerNameUtil;
	
	import cfgData.CFGDataEnum;
	import cfgData.CFGDataLibs;
	import cfgData.dataStruct.ArenaBadgeCFG;
	
	import majorRole.def.MajorNinjaDef;
	
	import pvpBattlefield.command.CheckPvpBattleFieldCampCommand;
	import pvpBattlefield.model.def.PVPFieldModelDef;
	
	import serverProto.fight.FightStartType;
	import serverProto.fight.ProtoAbortNinjaAwakenSkill;
	import serverProto.fight.ProtoNinja;
	import serverProto.fight.ProtoPlayerTeamPos;

    import com.tencent.morefun.naruto.i18n.I18n;
	public class ConverterResultInfo
	{
		private static var actionInfoList:Array = [];
		private static var activityHeroList:Array = [];
		
		private static var noticeList:Array = [];
		
		private static var roundId:int;
		private static var actionIdList:Array = [];
		
		private static var playerTeamPos:Array = [];
		
		public function ConverterResultInfo()
		{
			
		}
		
		public static function pushActionId(actionId:int):void
		{
			actionIdList.push(actionId);
		}
		
		public static function updateRoundId(value:int):void
		{
			roundId = value;
		}
		
		public static function pushTeamPlayerInfo(info:ProtoPlayerTeamPos):void
		{
			playerTeamPos.push(info);
		}
		
		public static function getTeamPlayerInfo(teamId:int):ProtoPlayerTeamPos
		{
			for each(var loopPlayerTeamPos:ProtoPlayerTeamPos in playerTeamPos)
			{
				if(loopPlayerTeamPos.teamId == teamId)
				{
					return loopPlayerTeamPos;
				}
			}
			
			return null;
		}
		
		public static function clear():void
		{
			playerTeamPos = [];
		}
		
		public static function dumpActionInfos():Array
		{
			var resultActionInfo:Array;
			
			resultActionInfo = actionInfoList.concat();
			actionInfoList.splice(0, actionInfoList.length);
			return resultActionInfo;
		}
		
		public static function dumpUpdatePlayerNoticeInfo():Array
		{
			var resultNoticeInfo:Array;
			
			resultNoticeInfo = noticeList.concat();
			noticeList.splice(0, noticeList.length);
			return resultNoticeInfo;
		}
		
		public static function addAttackAction(value:ActivityHero,
											   isFollowEnd:Boolean,
											   isOver:Boolean):void
		{
			var subSkillType:int;
			
			activityHeroList.push(value);
			
			if(isFollowEnd == false)
			{
				return;
			}
			
			if(activityHeroList.length == 1)
			{
				subSkillType = SkillConfig.getSkillInfo(value.skillId).type
				
				if(subSkillType != SkillDef.TYPE_ONLY_DEFENCE_EFFECT)
				{
					actionInfoList.push(getCommonActionInfo(activityHeroList[0], isOver));
				}
				else
				{
					actionInfoList.push(getOnlyDefenceEffectActionInfo(activityHeroList[0], isOver));
				}
			}
			
			if(activityHeroList.length > 1)
			{
				actionInfoList.push(getComboAction(activityHeroList.concat(), isOver));
			}
			
			actionIdList = [];
			activityHeroList.splice(0, activityHeroList.length);
		}
		
		public static function addEnchantmentAction(value:EnchantmentActionInfo):void
		{
			value.roundId = roundId;
			value.actionIdList = actionIdList;
			actionInfoList.push(value);
			
			actionIdList = [];
		}
		
		public static function addBubbleDialogueAction(value:BubbleDialogueActionInfo):void
		{
			value.roundId = roundId;
			value.actionIdList = actionIdList;
			actionInfoList.push(value);
			
			actionIdList = [];
		}
		
		public static function addStageAction(value:StageActionInfo):void
		{
			value.roundId = roundId;
			value.actionIdList = actionIdList;
			actionInfoList.push(value);
			
			actionIdList = [];
		}
		
		public static function addCallupAction(value:CallupActionInfo):void
		{
			value.roundId = roundId;
			value.actionIdList = actionIdList;
			actionInfoList.push(value);
			
			actionIdList = [];
		}
		
		public static function addScriptAction(value:ScriptActionInfo):void
		{
			value.roundId = roundId;
			value.actionIdList = actionIdList;
			actionInfoList.push(value);
			
			actionIdList = [];
		}
		
		public static function addAbortSkillAction(value:AbortSkillActionInfo):void
		{
			value.roundId = roundId;
			value.actionIdList = actionIdList;
			actionInfoList.push(value);
			
			actionIdList = [];
		}
		
		public static function addFormationAction(value:FormatActionInfo):void
		{
			value.roundId = roundId;
			value.actionIdList = actionIdList;
			actionInfoList.push(value);
			
			actionIdList = [];
		}
		
		public static function addTransformAction(value:TransformActionInfo):void
		{
			value.roundId = roundId;
			value.actionIdList = actionIdList;
			actionInfoList.push(value);
			
			actionIdList = [];
		}
		
		public static function addUpdatePlayerNotice(value:UpdatePlayerInfoNotice):void
		{
			noticeList.push(value);
		}
		
		public static function callCancelSkillCommand(protoAbortNinjaAwakenSkill:Array):void
		{
			var abortNinjaAwakenSkillList:Array = [];
			
			if(protoAbortNinjaAwakenSkill.length != 0)
			{
				for each(var abortNinjaAwakenSkill:ProtoAbortNinjaAwakenSkill in protoAbortNinjaAwakenSkill)
				{
					abortNinjaAwakenSkillList.push(abortNinjaAwakenSkill.ninjaPos);
				}
				new CancelSkillActionCommand(abortNinjaAwakenSkillList).call();
			}
		}
		
		public static function getUpdatePlayerNotices(playerTeamPos:Array, hasBattleStartFlag:Boolean):Array
		{
			var noticeList:Array;
			var notice:UpdatePlayerInfoNotice;
			var contractEnter:Boolean;
			var contractPetPlayerTeamPos:ProtoPlayerTeamPos;
			var protoPlayerTeamPos:ProtoPlayerTeamPos;
			
			noticeList = [];
			
			if(hasBattleStartFlag)
			{
				for each(protoPlayerTeamPos in playerTeamPos)
				{
					if(protoPlayerTeamPos.teamType == 5)
					{
						contractEnter = true;
						contractPetPlayerTeamPos = protoPlayerTeamPos;
					}
				}
				
				if(contractEnter)
				{
					new ContractPetEnterNotice(getUpdatePlayerInfoNotice(contractPetPlayerTeamPos)).send();
				}
				else
				{
					if(UIData.singleton.isContractPet)
					{
						new ContractPetExeuntNotice().send();
					}
				}
			}
			
			for each (protoPlayerTeamPos in playerTeamPos)
			{
				notice = getUpdatePlayerInfoNotice(protoPlayerTeamPos);
				noticeList.push(notice);
				
//				notice.send();
			}
			
			return noticeList;
		}
		
		public static function getUpdatePlayerInfoNotice(protoPlayerTeamPos:ProtoPlayerTeamPos):UpdatePlayerInfoNotice
		{
			var hp:int;
			var maxHp:int;
			var stageNinjaList:Array;
			var notice:UpdatePlayerInfoNotice;
			
				//(CFGDataLibs.getRowData(CFGDataEnum.ENUM_ArenaBadgeCFG, 1) as ArenaBadgeCFG).name
			
			hp = BaseConverter.getTotalNinjaHp(protoPlayerTeamPos.stageInfo.ninja);
			maxHp = BaseConverter.getTotalNinjaMaxHp(protoPlayerTeamPos.stageInfo.ninja);
			stageNinjaList = BaseConverter.getBaseNinjaInfoList(protoPlayerTeamPos.stageInfo.ninja);
			
			notice = new UpdatePlayerInfoNotice();
			notice.uin = protoPlayerTeamPos.player.uin;
			notice.roleId = protoPlayerTeamPos.player.roleId;
			notice.svrId = protoPlayerTeamPos.player.svrId;
			notice.type = protoPlayerTeamPos.stageInfo.type;
			
			if(BattleData.singleton.fightType == FightStartType.FIGHT_START_TYPE_BATTLE_ROYALE && UIData.singleton.isOurPlayerPos(protoPlayerTeamPos.teamId) == false)
			{
				var checkCampNameCommand:CheckPvpBattleFieldCampCommand;
				
				checkCampNameCommand = new CheckPvpBattleFieldCampCommand(notice.uin, notice.roleId, notice.svrId);
				checkCampNameCommand.call();
				notice.name = PVPFieldModelDef.campToNinjaName(checkCampNameCommand.camp);
			}
			else if(BattleData.singleton.fightType == FightStartType.FIGHT_START_TYPE_PVP_SINGLE_ARENA_INFERIOR && UIData.singleton.isOurPlayerPos(protoPlayerTeamPos.teamId) == false)
			{
				//notice.name = (CFGDataLibs.getRowData(CFGDataEnum.ENUM_ArenaBadgeCFG, protoPlayerTeamPos.arenaLevel) as ArenaBadgeCFG).name;
				notice.name = protoPlayerTeamPos.player.svrId + I18n.lang("as_battle_1451031565_352") + (CFGDataLibs.getRowData(CFGDataEnum.ENUM_ArenaBadgeCFG, protoPlayerTeamPos.arenaLevel) as ArenaBadgeCFG).name;
			}
			else
			{
				if(protoPlayerTeamPos.teamType == 1)
				{
					notice.name = PlayerNameUtil.standardlizeName(protoPlayerTeamPos.player, protoPlayerTeamPos.playerName);
				}
				else if(BattleData.singleton.fightType == FightStartType.FIGHT_START_TYPE_PVP_SINGLE_ARENA_INFERIOR)
				{
					notice.name = protoPlayerTeamPos.player.svrId + I18n.lang("as_battle_1451031565_353") + protoPlayerTeamPos.playerName;
				}
				else
				{
					notice.name = protoPlayerTeamPos.playerName;
				}	
			}
			notice.teamId = protoPlayerTeamPos.teamId;
			if(BattleData.singleton.fightType == FightStartType.FIGHT_START_TYPE_PVP)
			{
				notice.isSelf = notice.uin == BattleData.singleton.userInfoProxy.uin && notice.roleId == BattleData.singleton.userInfoProxy.role && notice.svrId == BattleData.singleton.userInfoProxy.svrId;
			}
			else
			{
				notice.isSelf = notice.uin == BattleData.singleton.userInfoProxy.uin && notice.roleId == BattleData.singleton.userInfoProxy.role && notice.svrId == BattleData.singleton.userInfoProxy.svrId && notice.teamId % 2 == 0;
			}
			if(notice.isSelf)
			{
				notice.teamType = 0;
			}
			else
			{
				notice.teamType = protoPlayerTeamPos.teamType;
			}
			notice.mp = protoPlayerTeamPos.kathaValue;
			notice.hasMp = protoPlayerTeamPos.hasKathaValue;
			notice.contractPetId = protoPlayerTeamPos.contractPetId;
			notice.offlineFlg = protoPlayerTeamPos.offlineFlag != 0;
			if(protoPlayerTeamPos.hasLevel)
			{
				notice.level = protoPlayerTeamPos.level;
			}
			if(protoPlayerTeamPos.hasCombatPower)
			{
				notice.battlePower = protoPlayerTeamPos.combatPower;
			}
			if(BattleData.singleton.userInfoProxy.uin == protoPlayerTeamPos.player.uin && BattleData.singleton.userInfoProxy.svrId == protoPlayerTeamPos.player.svrId && BattleData.singleton.userInfoProxy.role == protoPlayerTeamPos.player.roleId)
			{
				notice.head = BattleData.singleton.userInfoProxy.ninja;
			}
			else
			{
				if(protoPlayerTeamPos.hasFaceId)
				{
					notice.head = protoPlayerTeamPos.faceId;
				}
				else if(protoPlayerTeamPos.player.uin != 0 && BattleData.singleton.userInfoProxy.uin != protoPlayerTeamPos.player.uin)
				{
					for each(var protoNinja:ProtoNinja in protoPlayerTeamPos.stageInfo.ninja)
					{
						if(MajorNinjaDef.isMajorNinjaId(protoNinja.id))
						{
							notice.head = protoNinja.id;
						}
					}
				}
			}
			

			
			notice.hp = hp;
			notice.maxHp = maxHp;
			notice.stageNinjaList = stageNinjaList;
			
			return notice;
		}
		
		public static function getActionInfoList():Array
		{
			return actionInfoList;
		}
		
		private static function getComboAction(activityHeroList:Array, isOver:Boolean):ComboActionInfo
		{
			var comboActionInfo:ComboActionInfo;
			comboActionInfo = new ComboActionInfo();
			comboActionInfo.activiteHeros = activityHeroList;
			comboActionInfo.isOver = isOver;
			comboActionInfo.roundId = roundId;
			comboActionInfo.actionIdList = actionIdList;
			return comboActionInfo;
		}
		
		private static function getCommonActionInfo(activityHero:ActivityHero, isOver:Boolean):CommonActionInfo
		{
			var commonActionInfo:CommonActionInfo;
			commonActionInfo = new CommonActionInfo();
			commonActionInfo.activiteHero = activityHero;
			commonActionInfo.isOver = isOver;
			commonActionInfo.roundId = roundId;
			commonActionInfo.actionIdList = actionIdList;
			return commonActionInfo;
		}
		
		private static function getOnlyDefenceEffectActionInfo(activityHero:ActivityHero, isOver:Boolean):OnlyDefenceEffectActionInfo
		{
			var commonActionInfo:OnlyDefenceEffectActionInfo;
			commonActionInfo = new OnlyDefenceEffectActionInfo();
			commonActionInfo.activiteHero = activityHero;
			commonActionInfo.isOver = isOver;
			commonActionInfo.roundId = roundId;
			commonActionInfo.actionIdList = actionIdList;
			return commonActionInfo;
		}
																
		public function autoSetNull():void
		{

			actionInfoList = null;
			activityHeroList = null;
			actionIdList = null;
		}
	}
}