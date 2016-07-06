package com.tencent.morefun.naruto.plugin.battle.messageConverter
{
	
	import com.tencent.morefun.naruto.plugin.battle.data.BattleData;
	import com.tencent.morefun.naruto.plugin.battle.data.UIData;
	import com.tencent.morefun.naruto.plugin.battle.notice.UpdatePlayerInfoNotice;
	import com.tencent.morefun.naruto.plugin.motion.data.ActivityHero;
	import com.tencent.morefun.naruto.plugin.motion.data.CallupActionInfo;
	import com.tencent.morefun.naruto.plugin.motion.data.NinjaBattleCfgInfo;
	import com.tencent.morefun.naruto.plugin.motion.data.StageActionInfo;
	import com.tencent.morefun.naruto.plugin.motion.data.StageActionType;
	import com.tencent.morefun.naruto.plugin.motion.data.StageInfo;
	import com.tencent.morefun.naruto.plugin.motion.data.StageNinjaActionType;
	import com.tencent.morefun.naruto.plugin.motion.manager.ninja.NinjaConfig;
	import com.tencent.morefun.naruto.plugin.motion.manager.ninja.data.NinjaInfo;
	import com.tencent.morefun.naruto.plugin.motion.notice.base.BaseNotice;
	import utils.PlayerNameUtil;
	
	import flash.utils.Dictionary;
	
	import serverProto.fight.MetaActionType;
	import serverProto.fight.ProtoMetaAction;
	import serverProto.fight.ProtoNinja;
	import serverProto.fight.ProtoPlayerTeamPos;
	import serverProto.fight.ProtoStageAction;
	import serverProto.fight.ProtoStageInfo;
	
    import com.tencent.morefun.naruto.i18n.I18n;
	public class StageActionConverter
	{
		private static var stageInfoList:Array = [];
		private static var stageActionMap:Dictionary = new Dictionary();
		private static var realStageNinja:Dictionary = new Dictionary();
		
		public function StageActionConverter()
		{
			
		}
		
		public static function clearRealStageNinja():void
		{
			realStageNinja = new Dictionary();
		}
		
		public static function getStageActionList(metaActions:Array):Array
		{
			var stageInfo:StageInfo;
			var stageActionInfos:Array = [];
			
			var masterTeamId:int;
			var stageActionInfo:StageActionInfo;
			
			var protoPlayerTeamPos:ProtoPlayerTeamPos;
			var ninjaInfoList:Array = [];
			var kathaChangedList:Array = [];
			var delayTime:int;
			
			for each(var metaAction:ProtoMetaAction in metaActions)
			{
				if(metaAction.type != MetaActionType.STAGE_ACTION)
				{
					continue ;
				}
				
				//将多个stageActionInfo合并成一个
				for(var i:int = 0;i < metaAction.stageAction.playerTeamPos.length;i ++)
				{
					protoPlayerTeamPos = metaAction.stageAction.playerTeamPos[i];
					
					//只是更新玩家信息的不组包
					if(protoPlayerTeamPos.stageInfo.type == StageActionType.JUST_SHOW_INFO)
					{
						continue ;
					}
					
					//召唤登场
					if (protoPlayerTeamPos.stageInfo.type == StageActionType.SUMMON_ENTER_STAGE)  
					{
						throw new Error(I18n.lang("as_battle_1451031565_364"));
					}
					
					if(protoPlayerTeamPos.hasMasterTeam)
					{
						masterTeamId = protoPlayerTeamPos.masterTeam;
					}
					else
					{
						masterTeamId = protoPlayerTeamPos.teamId;
					}
					
					//获取类型相同的常规登场action
					stageInfo = stageActionMap[protoPlayerTeamPos.stageInfo.type];
					if(!stageInfo)
					{
						stageInfo = new StageInfo();
						stageInfo.type = protoPlayerTeamPos.stageInfo.type;
						stageActionMap[protoPlayerTeamPos.stageInfo.type] = stageInfo;
						stageInfoList.push(stageInfo);
					}
					
					ninjaInfoList = BaseConverter.convertNinjaInfos(protoPlayerTeamPos.teamId, protoPlayerTeamPos.arenaLevel, protoPlayerTeamPos.stageInfo.ninja, PlayerNameUtil.standardlizeName(protoPlayerTeamPos.player, protoPlayerTeamPos.playerName), masterTeamId);
					stageInfo.ninjaInfos = stageInfo.ninjaInfos.concat(ninjaInfoList);
					BaseConverter.settingExeuntStageAction(ninjaInfoList, protoPlayerTeamPos);
				}
				
				delayTime += metaAction.stageAction.battleEndDelayTime;
				kathaChangedList = kathaChangedList.concat(BaseConverter.convertKathaChange(metaAction.stageAction.teamKathaChange));
			}
			
			stageActionInfo = getStageActionInfo();
			if(stageActionInfo != null)
			{
				stageActionInfo.kathaChangedList = kathaChangedList;
				stageActionInfo.delayTime = delayTime;
				stageActionInfos.push(stageActionInfo);
				
				for each(stageInfo in stageActionInfo.stageInfos)
				{
					updateRealStageNinja(stageInfo);
				}
			}
			
			return stageActionInfos;
		}
		
		public static function convertStageAction(metaAction:ProtoMetaAction):void
		{
			var stageInfo:StageInfo;
			var isLastStageAction:Boolean;
			
			var masterTeamId:int;
			var ninjaInfoList:Array;
			var protoPlayerTeamPos:ProtoPlayerTeamPos;
			var isNeedToCheck:Boolean;
			var kathaChangedList:Array = [];
			var delayTime:int;
			var isSummonType:Boolean;
			
			var ORDER_HASH:Array = [6, 3, 0, 7, 4, 1, 8, 5, 2];
			
			if(metaAction.stageAction.hasBattleStartFlag)
			{
				checkAndExeuntNinja(metaAction.stageAction);
			}
			
			if(metaAction.stageAction.hasBattleStartFlag)
			{
				UIData.singleton.monster.teamId = getMonsterId(metaAction.stageAction.playerTeamPos);
			}
			
			kathaChangedList = kathaChangedList.concat(BaseConverter.convertKathaChange(metaAction.stageAction.teamKathaChange));
			
			//将多个stageActionInfo合并成一个
			for(var i:int = 0;i < metaAction.stageAction.playerTeamPos.length;i ++)
			{
				protoPlayerTeamPos = metaAction.stageAction.playerTeamPos[i];
				
				//只是更新玩家信息的不组包
				if(protoPlayerTeamPos.stageInfo.type == StageActionType.JUST_SHOW_INFO)
				{
					continue ;
				}
				
				if(metaAction.stageAction.hasBattleStartFlag)
				{
					checkReplaceNinja(protoPlayerTeamPos);
				}
				
				if(protoPlayerTeamPos.stageInfo.ninja.length == 0)
				{
					continue ;
				}
				
				if(protoPlayerTeamPos.hasMasterTeam)
				{
					masterTeamId = protoPlayerTeamPos.masterTeam;
				}
				else
				{
					masterTeamId = protoPlayerTeamPos.teamId;
				}
				
				isLastStageAction = (i == metaAction.stageAction.playerTeamPos.length - 1);
				delayTime += metaAction.stageAction.battleEndDelayTime;
				//召唤登场
				if (protoPlayerTeamPos.stageInfo.type == StageActionType.SUMMON_ENTER_STAGE)  
				{
					isSummonType = true;
					
					//将刚刚的登场行为组包
					addStageActionInfo(isLastStageAction && metaAction.isOver, metaAction.id, kathaChangedList, delayTime);
					//创建召唤登场包
					addCallupStageActionInfo(protoPlayerTeamPos, metaAction.stageAction.ninjaHpChange, kathaChangedList, masterTeamId, isLastStageAction && metaAction.isOver, metaAction.id);
					delayTime = 0;
					
					kathaChangedList.splice(0, kathaChangedList.length);
					continue ;
				}
				
				//获取类型相同的常规登场action
				stageInfo = stageActionMap[protoPlayerTeamPos.stageInfo.type];
				if(!stageInfo)
				{
					stageInfo = new StageInfo();
					stageInfo.type = protoPlayerTeamPos.stageInfo.type;
					stageActionMap[protoPlayerTeamPos.stageInfo.type] = stageInfo;
					stageInfoList.push(stageInfo);
				}
				
				ninjaInfoList = BaseConverter.convertNinjaInfos(protoPlayerTeamPos.teamId, protoPlayerTeamPos.arenaLevel, protoPlayerTeamPos.stageInfo.ninja, PlayerNameUtil.standardlizeName(protoPlayerTeamPos.player, protoPlayerTeamPos.playerName), masterTeamId);
				stageInfo.ninjaInfos = stageInfo.ninjaInfos.concat(ninjaInfoList);
				BaseConverter.settingExeuntStageAction(ninjaInfoList, protoPlayerTeamPos);
			}
			
			for each(stageInfo in stageInfoList)
			{
				updateRealStageNinja(stageInfo);
			}
			
			for each(stageInfo in stageActionMap)
			{
				ninjaInfoList = stageInfo.ninjaInfos;
				ninjaInfoList.sort(function(n1:NinjaInfo, n2:NinjaInfo):int
				{
					if(n1.skillIndex != -1)
					{
						return -1;
					}
					if(n2.skillIndex != -1)
					{
						return 1;
					}
					else
					{
						return (ORDER_HASH[n1.pos] < ORDER_HASH[n2.pos])? 1 : -1;
					}
				});
			}
			
			//确保玩家在召唤兽前更新信息
			for each(protoPlayerTeamPos in metaAction.stageAction.playerTeamPos)
			{
				//1 玩家 2辅助者
				if(protoPlayerTeamPos.teamType == 1 || protoPlayerTeamPos.teamType == 2)
				{
					metaAction.stageAction.playerTeamPos.splice(metaAction.stageAction.playerTeamPos.indexOf(protoPlayerTeamPos), 1);
					metaAction.stageAction.playerTeamPos.unshift(protoPlayerTeamPos);
					break;
				}
			}
			
			//将刚刚的登场行为组包
			addStageActionInfo(isLastStageAction && metaAction.isOver, metaAction.id, kathaChangedList, delayTime);
			ConverterResultInfo.callCancelSkillCommand(metaAction.abortNinjaAwakenSkill);
			
			kathaChangedList.splice(0, kathaChangedList.length);
			if(isSummonType == false)
			{
				var notice:BaseNotice;
				var noticeList:Array;
				
				if(metaAction.stageAction.hasBattleStartFlag)
				{
					noticeList = ConverterResultInfo.getUpdatePlayerNotices(metaAction.stageAction.playerTeamPos, metaAction.stageAction.hasBattleStartFlag);
					for each(notice in noticeList)
					{
						notice.send();
					}
				}else {
					for each (protoPlayerTeamPos in metaAction.stageAction.playerTeamPos)
					{
						if (protoPlayerTeamPos.stageInfo && protoPlayerTeamPos.stageInfo.type == StageActionType.NORMAL_ENTER_STAGE) {
							notice = ConverterResultInfo.getUpdatePlayerInfoNotice(protoPlayerTeamPos);
							notice.send();
						}
					}
				}
				/*else
				{
				for each(notice in noticeList)
				{
				ConverterResultInfo.addUpdatePlayerNotice(notice as UpdatePlayerInfoNotice);
				}
				}*/
			}
		}
		
		public static function getMonsterId(protoPlayerTeamPos:Array):int
		{
			var monsterId:int = int.MAX_VALUE;
			
			for each(var playerTeamPos:ProtoPlayerTeamPos in protoPlayerTeamPos)
			{
				if(!UIData.singleton.isOurPlayerPos(playerTeamPos.teamId))
				{
					if(playerTeamPos.teamId <= monsterId)
					{
						monsterId = playerTeamPos.teamId;
					}
				}
			}
			
			return monsterId;
		}
		
		public static function isAutoFight(protoPlayerTeamPos:Array, uin:uint, role:uint, svr:uint):Boolean
		{
			var monsterId:int = int.MAX_VALUE;
			
			for each(var playerTeamPos:ProtoPlayerTeamPos in protoPlayerTeamPos)
			{
				if(playerTeamPos.player.uin == uin && playerTeamPos.player.roleId == role && playerTeamPos.player.svrId == svr)
				{
					return playerTeamPos.hasAiLevel;
				}
			}
			
			return false;
		}
		
		private static function checkReplaceNinja(protoPlayerTeamPos:ProtoPlayerTeamPos):void
		{
			var isMatch:Boolean;
			var stageInfo:StageInfo;
			var replaceNinjaList:Array = [];
			var exeuntNinjaList:Array = [];
			var matchNinjaInfo:ProtoNinja;
			var matchPlayerTeamPos:ProtoPlayerTeamPos;
			var ninjaCfg1:NinjaBattleCfgInfo;
			var masterTeamId:int;
			var protoNinja:ProtoNinja;
			var ninjaInfoList:Array = [];
			var ninjaCfg2:NinjaBattleCfgInfo;
			
			for each(var ninjaInfo:NinjaInfo in realStageNinja)
			{
				isMatch = false;
				//				if(protoPlayerTeamPos.teamId == (ninja.data as NinjaInfo).playerId)
				//				{
				if(isMatch){continue ;}
				for each(protoNinja in protoPlayerTeamPos.stageInfo.ninja)
				{
					if(isMatch){continue ;}
					
					ninjaCfg2 = NinjaConfig.getNinjaInfoById(ninjaInfo.ninjaId);
					if(protoNinja.pos == ninjaInfo.pos)
					{
						ninjaCfg1 = NinjaConfig.getNinjaInfoById(protoNinja.id);
						if(ninjaCfg1.cfgInfo.refId == ninjaCfg2.cfgInfo.refId && ninjaCfg1.cfgInfo.type == ninjaCfg2.cfgInfo.type)
						{
							isMatch = true;
							matchPlayerTeamPos = protoPlayerTeamPos;
							matchNinjaInfo = protoNinja;
						}
					}
				}
				
				//					for each(protoNinja in protoPlayerTeamPos.stageInfo.ninja)
				//					{
				//						if(isMatch){continue ;}
				//						
				//						ninjaCfg = NinjaConfig.getNinjaInfoById(protoNinja.id);
				//						if(ninjaCfg.refId == ninja.cfg.refId)
				//						{
				//							isMatch = true;
				//							matchPlayerTeamPos = protoPlayerTeamPos;
				//							matchNinjaInfo = protoNinja;
				//							matchNinja = ninja;
				//						}
				//					}
				//				}
				
				if(isMatch)
				{
					if(protoPlayerTeamPos.svrReplaceFlag == 2)
					{
						if(BattleData.singleton.fightState == BattleData.FIGHT_STATE_PREWAR_OPTION)
						{
							ninjaInfo.exeuntStageAction = StageNinjaActionType.EXIT_VANISH;
						}
						
						exeuntNinjaList.push(ninjaInfo);
					}
					else
					{
						if(protoPlayerTeamPos.hasMasterTeam)
						{
							masterTeamId = protoPlayerTeamPos.masterTeam;
						}
						else
						{
							masterTeamId = protoPlayerTeamPos.teamId;
						}
						ninjaInfoList = BaseConverter.convertNinjaInfos(protoPlayerTeamPos.teamId, protoPlayerTeamPos.arenaLevel, [matchNinjaInfo], PlayerNameUtil.standardlizeName(protoPlayerTeamPos.player, protoPlayerTeamPos.playerName), masterTeamId);
						replaceNinjaList = replaceNinjaList.concat(ninjaInfoList);
						BaseConverter.settingExeuntStageAction(ninjaInfoList, protoPlayerTeamPos);
						matchPlayerTeamPos.stageInfo.ninja.splice(matchPlayerTeamPos.stageInfo.ninja.indexOf(matchNinjaInfo), 1);
						(replaceNinjaList[replaceNinjaList.length - 1] as NinjaInfo).stagePos = ninjaInfo.stagePos;
					}
				}
			}
			
			if(replaceNinjaList.length != 0)
			{
				stageInfo = stageActionMap[StageActionType.REPLACE_ENTER_STAGE];
				if(!stageInfo)
				{
					stageInfo = new StageInfo();
					stageInfo.type = StageActionType.REPLACE_ENTER_STAGE;
					stageActionMap[StageActionType.REPLACE_ENTER_STAGE] = stageInfo;
					stageInfoList.push(stageInfo);
				}
				stageInfo.ninjaInfos = stageInfo.ninjaInfos.concat(replaceNinjaList);
			}
			
			if(exeuntNinjaList.length != 0)
			{
				stageInfo = stageActionMap[StageActionType.EXIT_STAGE];
				if(!stageInfo)
				{
					stageInfo = new StageInfo();
					stageInfo.type = StageActionType.EXIT_STAGE;
					stageActionMap[StageActionType.EXIT_STAGE] = stageInfo;
					stageInfoList.push(stageInfo);
				}
				stageInfo.ninjaInfos = stageInfo.ninjaInfos.concat(exeuntNinjaList);
			}
		}
		
		private static function checkAndExeuntNinja(stageAction:ProtoStageAction):void
		{
			var isFind:Boolean;
			var stageInfo:StageInfo;
			var exeuntNinjaList:Array = [];
			var ninjaCfg1:NinjaBattleCfgInfo;
			var ninjaCfg2:NinjaBattleCfgInfo;
			
			for each(var ninjaInfo:NinjaInfo in realStageNinja)
			{
				isFind = false;
				for each(var protoPlayerTeamPos:ProtoPlayerTeamPos in stageAction.playerTeamPos)
				{
					//					if(protoPlayerTeamPos.teamId == (ninja.data as NinjaInfo).playerId)
					//					{
					for each(var protoNinja:ProtoNinja in protoPlayerTeamPos.stageInfo.ninja)
					{
						if(protoNinja.pos == ninjaInfo.pos)
						{
							ninjaCfg1 = NinjaConfig.getNinjaInfoById(protoNinja.id);
							ninjaCfg2 = NinjaConfig.getNinjaInfoById(ninjaInfo.ninjaId);
							if(ninjaCfg1.cfgInfo.refId == ninjaCfg2.cfgInfo.refId && ninjaCfg1.cfgInfo.type == ninjaCfg2.cfgInfo.type)
							{
								isFind = true;
							}
						}
					}
				}
				
				if(!isFind)
				{
					if(BattleData.singleton.fightState == BattleData.FIGHT_STATE_PREWAR_OPTION)
					{
						ninjaInfo.exeuntStageAction = StageNinjaActionType.EXIT_VANISH;
					}
					
					exeuntNinjaList.push(ninjaInfo);
				}
			}
			
			if(exeuntNinjaList.length != 0)
			{
				stageInfo = stageActionMap[StageActionType.EXIT_STAGE];
				if(!stageInfo)
				{
					stageInfo = new StageInfo();
					stageInfo.type = StageActionType.EXIT_STAGE;
					stageActionMap[StageActionType.EXIT_STAGE] = stageInfo;
					stageInfoList.push(stageInfo);
				}
				stageInfo.ninjaInfos = stageInfo.ninjaInfos.concat(exeuntNinjaList);
			}
		}
		
		private static function addStageActionInfo(isOver:Boolean, actionId:int, kathaChangedList:Array, delayTime:int):void
		{
			var stageInfo:StageInfo;
			var stageActionInfo:StageActionInfo;
			var protoStageInfo:ProtoStageInfo;
			
			if(stageInfoList.length == 0)
			{
				return ;
			}
			
			stageActionInfo = new StageActionInfo();
			stageActionInfo.stageInfos = stageInfoList.concat();
			stageActionInfo.isOver = isOver;
			stageActionInfo.kathaChangedList = kathaChangedList.concat();
			stageActionInfo.delayTime = delayTime;
			stageInfoList.splice(0, stageInfoList.length);
			kathaChangedList.splice(0, kathaChangedList.length);
			
			stageActionMap = new Dictionary();
			
			ConverterResultInfo.addStageAction(stageActionInfo);
		}
		
		private static function addCallupStageActionInfo(protoPlayerTeamPos:ProtoPlayerTeamPos, ninjaHpChanged:Array, kathaChangedList:Array, masterTeamId:int, isOver:Boolean, actionId:int):void
		{
			var passiveHerosPos:Array = [];
			var callupActionInfo:CallupActionInfo = new CallupActionInfo();
			
			passiveHerosPos = BaseConverter.getCallUpActionPasssiveHerosPos(protoPlayerTeamPos.stageInfo);
			
			callupActionInfo.activiteHero = new ActivityHero();
			callupActionInfo.activiteHero.pos = protoPlayerTeamPos.stageInfo.summonPos;
			callupActionInfo.activiteHero.hpChangedInfo = BaseConverter.convertNinjaBaseChangedInfo(callupActionInfo.activiteHero.pos, ninjaHpChanged);
			callupActionInfo.activiteHero.otherHpChangedInfoList = BaseConverter.convertOtherNinjaBaseChangedInfoList(callupActionInfo.activiteHero.pos, ninjaHpChanged, passiveHerosPos);
			callupActionInfo.activiteHero.attributeChangedInfo = BaseConverter.convertNinjaAttributeChangedInfo(callupActionInfo.activiteHero.pos, ninjaHpChanged);
			callupActionInfo.activiteHero.kathaChangedNotifyList = kathaChangedList.concat();
			callupActionInfo.activiteHero.otherAttributeChangedInfoList = BaseConverter.convertOtherNinjaAttributeChangedInfoList(callupActionInfo.activiteHero.pos, ninjaHpChanged, passiveHerosPos);
			callupActionInfo.activiteHero.skillId = protoPlayerTeamPos.stageInfo.summonSkillInfo.skillId;
			callupActionInfo.ninjaInfos = BaseConverter.convertNinjaInfos(protoPlayerTeamPos.teamId, protoPlayerTeamPos.arenaLevel, protoPlayerTeamPos.stageInfo.ninja, PlayerNameUtil.standardlizeName(protoPlayerTeamPos.player, protoPlayerTeamPos.playerName), masterTeamId);
			BaseConverter.settingExeuntStageAction(callupActionInfo.ninjaInfos, protoPlayerTeamPos);
			callupActionInfo.isOver = isOver;
			if(protoPlayerTeamPos.stageInfo.summonSkillInfo.hasSkillIndex)
			{
				callupActionInfo.activiteHero.useSpecialSkill = true;
			}
			
			updateCallUpRealStageNinja(callupActionInfo.ninjaInfos);
			ConverterResultInfo.addCallupAction(callupActionInfo);
		}
		
		private static function getStageActionInfo():StageActionInfo
		{
			var stageInfo:StageInfo;
			var stageActionInfo:StageActionInfo;
			var protoStageInfo:ProtoStageInfo;
			
			if(stageInfoList.length == 0)
			{
				return null;
			}
			
			stageActionInfo = new StageActionInfo();
			stageActionInfo.stageInfos = stageInfoList.concat();
			stageInfoList.splice(0, stageInfoList.length);
			
			stageActionMap = new Dictionary();
			
			return stageActionInfo;
		}
		
		private static function updateCallUpRealStageNinja(ninjaInfos:Array):void
		{
			var ninjaInfo:NinjaInfo;
			
			for each(ninjaInfo in ninjaInfos)
			{
				realStageNinja[ninjaInfo.pos] = ninjaInfo;
				ninjaInfo.stagePos = ninjaInfo.pos;
			}
		}
		
		private static function updateRealStageNinja(stageInfo:StageInfo):void
		{
			var ninjaInfo:NinjaInfo;
			
			if(stageInfo.type == StageActionType.NORMAL_ENTER_STAGE)
			{
				for each(ninjaInfo in stageInfo.ninjaInfos)
				{
					realStageNinja[ninjaInfo.pos] = ninjaInfo;
					ninjaInfo.stagePos = ninjaInfo.pos;
				}
			}
			else if(stageInfo.type == StageActionType.REPLACE_ENTER_STAGE)
			{
				for each(ninjaInfo in stageInfo.ninjaInfos)
				{
					realStageNinja[ninjaInfo.pos] = ninjaInfo;
				}
			}
			else if(stageInfo.type == StageActionType.EXIT_STAGE)
			{
				for each(ninjaInfo in stageInfo.ninjaInfos)
				{
					delete realStageNinja[ninjaInfo.pos];
				}
			}
			else if(stageInfo.type == StageActionType.ESCAPE_EXIT_STAGE)
			{
				for each(ninjaInfo in stageInfo.ninjaInfos)
				{
					delete realStageNinja[ninjaInfo.pos];
				}
			}
		}
		
		public function autoSetNull():void
		{
			
			stageInfoList = null;
			stageActionMap = null;
			realStageNinja = null;
		}
	}
}