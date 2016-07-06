package com.tencent.morefun.naruto.plugin.battle.executer
{
	
	import com.tencent.morefun.framework.base.Command;
	import com.tencent.morefun.framework.log.logger;
	import com.tencent.morefun.naruto.plugin.battle.command.BattleScriptAckCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.BattleWatchResAckCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.ChangeFormationAckCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.ChangedCustomIDCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.DestroyBattleCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.FightResLoadedCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.GiveUpBattleCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.InitializeBattleCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.InsertBattleInitCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.NotifyAutoFightCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.NotifyCloseFightTipsCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.NotifyDelayStartCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.NotifyFightCompleteCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.NotifyFightOverCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.NotifyKathaSkillCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.NotifyRoundSyncCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.NotifyShowResLoadCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.NotifyStartBattleCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.NotifyTinyRoundsCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.NotifyWatchTransfomResAckCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.RequestAutoFightCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.RequestKathaSkillCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.RequestSummonContractPetCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.RoundSyncAckCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.SelfInsertNotifyCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.SendSpeedMessageCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.SummonContractPetResponseCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.UpdateLeftBattleRoundCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.UpdatePlayerOnlineInfoCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.UpdateSkillStateCommand;
	import com.tencent.morefun.naruto.plugin.battle.data.BattleData;
	import com.tencent.morefun.naruto.plugin.battle.data.CustomInfo;
	import com.tencent.morefun.naruto.plugin.battle.data.UIData;
	import com.tencent.morefun.naruto.plugin.battle.data.UIPlayerData;
	import com.tencent.morefun.naruto.plugin.battle.data.WaitLoadingData;
	import com.tencent.morefun.naruto.plugin.battle.executer.controlClasses.LoadAssetHelper;
	import com.tencent.morefun.naruto.plugin.battle.messageConverter.BaseConverter;
	import com.tencent.morefun.naruto.plugin.battle.messageConverter.BuffConverter;
	import com.tencent.morefun.naruto.plugin.battle.messageConverter.EnchantmentConverter;
	import com.tencent.morefun.naruto.plugin.battle.messageConverter.MessageConverter;
	import com.tencent.morefun.naruto.plugin.battle.messageConverter.ShieldConverter;
	import com.tencent.morefun.naruto.plugin.battle.messageConverter.StageActionConverter;
	import com.tencent.morefun.naruto.plugin.battle.messageConverter.UIInfoConverte;
	import com.tencent.morefun.naruto.plugin.battle.notice.GVGFightOverNotice;
	import com.tencent.morefun.naruto.plugin.battle.notice.GiveUpBroadcastNotice;
	import com.tencent.morefun.naruto.plugin.battle.notice.OtherPlayerResCompleteNotce;
	import com.tencent.morefun.naruto.plugin.battle.notice.SpeedUpNotice;
	import com.tencent.morefun.naruto.plugin.battle.notice.UpdateWatchFlagNotice;
	import com.tencent.morefun.naruto.plugin.battle.view.fightOver.damage.DamageInfo;
	import com.tencent.morefun.naruto.plugin.battle.view.fightOver.damage.DamageNinjaInfo;
	import com.tencent.morefun.naruto.plugin.battle.view.fightOver.damage.DamagePlayerInfo;
	import com.tencent.morefun.naruto.plugin.exui.loading.NarutoLoading;
	import com.tencent.morefun.naruto.plugin.motion.data.EnchantmentActionInfo;
	import com.tencent.morefun.naruto.plugin.motion.data.ScriptActionInfo;
	import com.tencent.morefun.naruto.plugin.ui.box.BoxManager;
	import utils.PlayerNameUtil;
	import com.tencent.morefun.naruto.util.Assert;
	
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import base.ApplicationData;
	import base.NarutoExecuter;
	
	import battle.command.FightRequestNotifyAckCommand;
	import battle.command.RequestInsertFightCommand;
	import battle.command.RequestPveFightStartCommand;
	import battle.command.RequestPvpFightStartCommand;
	import battle.data.BattleInfo;
	
	import chat.command.PasteMessageCommand;
	import chat.def.ChatChanelDef;
	
	import def.CGIReportTypeDef;
	import def.ExecuterDef;
	import def.ModelDef;
	import def.PluginDef;
	import def.ProtocolCmdDef;
	
	import player.commands.SetSelfPlayerPosAndDirCommand;
	
	import prewar.command.PrewarPlayerExitCommand;
	
	import server.SocketProtocol;
	import server.command.CGIReportCommand;
	
	import serverProto.fight.FightStartType;
	import serverProto.fight.ProtoBattleEndConfirmResp;
	import serverProto.fight.ProtoBattleScriptAck;
	import serverProto.fight.ProtoChangeFormationAck;
	import serverProto.fight.ProtoFightOverInfo;
	import serverProto.fight.ProtoFightOverNotify;
	import serverProto.fight.ProtoFightRequestNotifyAck;
	import serverProto.fight.ProtoFightResLoaded;
	import serverProto.fight.ProtoFightResToLoad;
	import serverProto.fight.ProtoFightStartErrorNotify;
	import serverProto.fight.ProtoFightStartNotify;
	import serverProto.fight.ProtoFightStartRequest;
	import serverProto.fight.ProtoFightStartResponse;
	import serverProto.fight.ProtoHasLoadedResBroadcast;
	import serverProto.fight.ProtoInsertFightDelayNotify;
	import serverProto.fight.ProtoInsertFightRequest;
	import serverProto.fight.ProtoInsertFightResponse;
	import serverProto.fight.ProtoInsertFightStageNotify;
	import serverProto.fight.ProtoKathaSkillBroadcast;
	import serverProto.fight.ProtoKathaSkillRequest;
	import serverProto.fight.ProtoKathaSkillResponse;
	import serverProto.fight.ProtoMetaAction;
	import serverProto.fight.ProtoNinjaDamageStat;
	import serverProto.fight.ProtoPlayerDisconnectBroadcast;
	import serverProto.fight.ProtoPlayerReconnectBroadcast;
	import serverProto.fight.ProtoPlayerSurrenderBroadcast;
	import serverProto.fight.ProtoPlayerTeamPos;
	import serverProto.fight.ProtoRoundSync;
	import serverProto.fight.ProtoRoundSyncAck;
	import serverProto.fight.ProtoSpeedUpNotify;
	import serverProto.fight.ProtoSpeedUpRequest;
	import serverProto.fight.ProtoSpeedUpResponse;
	import serverProto.fight.ProtoSummonContractPetRequest;
	import serverProto.fight.ProtoSummonContractPetResponse;
	import serverProto.fight.ProtoSurrenderRequest;
	import serverProto.fight.ProtoSurrenderResponse;
	import serverProto.fight.ProtoTeamDamageStat;
	import serverProto.fight.ProtoTeamKathaSkillUse;
	import serverProto.fight.ProtoTinyRoundNotify;
	import serverProto.fight.ProtoTrusteeNotify;
	import serverProto.fight.ProtoTrusteeRequest;
	import serverProto.fight.ProtoTrusteeResponse;
	import serverProto.fight.ProtoUnitKathaSkillUse;
	import serverProto.fight.ProtoWatchFightNotify;
	import serverProto.fight.ProtoWatchFightReadyResponse;
	import serverProto.inc.EmptyMessage;
	import serverProto.inc.ProtoPlayerKey;
	
	import team.data.TeamMemberData;
	import team.model.TeamModel;
	
	import ui.command.CloseTextBoxCommand;
	import ui.command.ShowErrorMessageCommand;
	import ui.command.ShowTextBoxCommand;
	
	import user.command.SetUserInitLocationCommand;
	import user.def.UserStateDef;
	
	import utils.MoneyUtil;
	
    import com.tencent.morefun.naruto.i18n.I18n;
	public class ServerExecuter extends NarutoExecuter
	{
		private var requestCmd:Dictionary;
		private var battleInfo:BattleInfo;
		private var teamModel:TeamModel;
		
		public function ServerExecuter()
		{		
			requestCmd = new Dictionary();
			
			super(PluginDef.BATTLE, ExecuterDef.BATTLE_SERVER);
			
			this.gameServer.registerMessage(ProtocolCmdDef.PVP_FIGHT_START_NOTIFY, ProtoFightStartNotify);
			this.gameServer.registerMessage(ProtocolCmdDef.FIGHT_START, ProtoFightStartResponse);
			this.gameServer.registerMessage(ProtocolCmdDef.FIGHT_OVER, ProtoFightOverNotify);
			this.gameServer.registerMessage(ProtocolCmdDef.KACHA_SKILL_BROADCAST, ProtoKathaSkillBroadcast);
			this.gameServer.registerMessage(ProtocolCmdDef.ROUND_SYNC, ProtoRoundSync);
			this.gameServer.registerMessage(ProtocolCmdDef.TINY_ROUND, ProtoTinyRoundNotify);
			this.gameServer.registerMessage(ProtocolCmdDef.INSERT_TINY_ROUND, ProtoInsertFightStageNotify);
			this.gameServer.registerMessage(ProtocolCmdDef.FIGHT_ERROR_NOTIFY, ProtoFightStartErrorNotify);
			this.gameServer.registerMessage(ProtocolCmdDef.FIGHT_DELAY_START_NOTIFY, ProtoInsertFightDelayNotify);
			this.gameServer.registerMessage(ProtocolCmdDef.BATTLE_PLAYER_DISCONNECT, ProtoPlayerDisconnectBroadcast);
			this.gameServer.registerMessage(ProtocolCmdDef.BATTLE_PLAYER_RECONNECT, ProtoPlayerReconnectBroadcast); 
			this.gameServer.registerMessage(ProtocolCmdDef.OTHER_PLAYER_RES_COMPLETE, ProtoHasLoadedResBroadcast);
			this.gameServer.registerMessage(ProtocolCmdDef.BATTLE_TRUSTEE_NOTIFY, ProtoTrusteeNotify);
			this.gameServer.registerMessage(ProtocolCmdDef.BATTLE_WATCH_TRANSFORM_NOTIFY, ProtoFightStartNotify);
			this.gameServer.registerMessage(ProtocolCmdDef.BATTLE_WATCH_READY_ACK, ProtoTinyRoundNotify);
			this.gameServer.registerMessage(ProtocolCmdDef.BATTLE_WATCH_NOTIFY, ProtoWatchFightNotify);
			this.gameServer.registerMessage(ProtocolCmdDef.BATTLE_CLOSE_TIPS, EmptyMessage);
			this.gameServer.registerMessage(ProtocolCmdDef.BATTLE_GIVE_UP_BROADCAST, ProtoPlayerSurrenderBroadcast);
			this.gameServer.registerMessage(ProtocolCmdDef.BATTLE_RES_LOAD_PROCESS_NOTIFY, ProtoFightStartNotify);
			this.gameServer.registerMessage(ProtocolCmdDef.SPPED_UP_NOTIFY, ProtoSpeedUpNotify);
			
			this.gameServer.registerBusy(ProtocolCmdDef.FIGHT_START, true);
			this.gameServer.registerBusy(ProtocolCmdDef.PVP_INSERT_FIGHT, true);
			this.gameServer.registerBusy(ProtocolCmdDef.PVP_FIGHT_CHALLENGE_NOTIFY, true);
			
			this.gameServer.addProtocolListener(ProtocolCmdDef.FIGHT_START, onResponseFightStart);  
			this.gameServer.addProtocolListener(ProtocolCmdDef.FIGHT_OVER, onNotifyFightOver);
			this.gameServer.addProtocolListener(ProtocolCmdDef.KACHA_SKILL, onResponseKachaSkill);  //这个不会主动下发，所以也不用注册
			this.gameServer.addProtocolListener(ProtocolCmdDef.KACHA_SKILL_BROADCAST, onKachaSkillBroadcast);
			this.gameServer.addProtocolListener(ProtocolCmdDef.ROUND_SYNC, onRoundSync);
			this.gameServer.addProtocolListener(ProtocolCmdDef.TINY_ROUND, onNotifyTinyRound);
			this.gameServer.addProtocolListener(ProtocolCmdDef.INSERT_TINY_ROUND, onInsertTinyRound);
			this.gameServer.addProtocolListener(ProtocolCmdDef.FIGHT_ERROR_NOTIFY, onFightErrorNotify);
			this.gameServer.addProtocolListener(ProtocolCmdDef.BATTLE_FIGHT_SUMMON_CONTRACT_PET, onSummonContractPetResponse);
			this.gameServer.addProtocolListener(ProtocolCmdDef.PVP_INSERT_FIGHT, onPvpInsertFightResponse);
			this.gameServer.addProtocolListener(ProtocolCmdDef.FIGHT_DELAY_START_NOTIFY, onFightDelayStartNotify);
			this.gameServer.addProtocolListener(ProtocolCmdDef.BATTLE_PLAYER_DISCONNECT, onPlayerDisConnectNotify);
			this.gameServer.addProtocolListener(ProtocolCmdDef.BATTLE_PLAYER_RECONNECT, onPlayerReConnectNotify);
			this.gameServer.addProtocolListener(ProtocolCmdDef.BATTLE_SPEED_UP, onSpeedUpResponse);
			this.gameServer.addProtocolListener(ProtocolCmdDef.SPPED_UP_NOTIFY, onSpeedUpNotify);
			
			this.gameServer.addProtocolListener(ProtocolCmdDef.PVP_FIGHT_START_NOTIFY, onFightStartNotify);//挑战者参战，加载资源？
			this.gameServer.addProtocolListener(ProtocolCmdDef.OTHER_PLAYER_RES_COMPLETE, onOhterPlayerResCompleteNotify);
			this.gameServer.addProtocolListener(ProtocolCmdDef.BATTLE_TRUSTEE, onBattleTrusteeResult);
			this.gameServer.addProtocolListener(ProtocolCmdDef.BATTLE_TRUSTEE_NOTIFY, onBattleTrusteeNotify);
			this.gameServer.addProtocolListener(ProtocolCmdDef.BATTLE_WATCH_NOTIFY, onWatchNotify);
			this.gameServer.addProtocolListener(ProtocolCmdDef.BATTLE_WATCH_TRANSFORM_NOTIFY, onWatchTransformNotify);//由观战变成参战，加载资源？
			this.gameServer.addProtocolListener(ProtocolCmdDef.BATTLE_WATCH_READY_ACK, onBattleWatchReayAckResult);
			this.gameServer.addProtocolListener(ProtocolCmdDef.BATTLE_CLOSE_TIPS, onCloseFightTipsNotify);
			this.gameServer.addProtocolListener(ProtocolCmdDef.BATTLE_GIVE_UP, onGiveUpBattleResult);
			this.gameServer.addProtocolListener(ProtocolCmdDef.BATTLE_GIVE_UP_BROADCAST, onGiveUpBattleBroadcast);
			this.gameServer.addProtocolListener(ProtocolCmdDef.BATTLE_OVER_CONFIRM, onNotifyCompleteResult);
			this.gameServer.addProtocolListener(ProtocolCmdDef.BATTLE_RES_LOAD_PROCESS_NOTIFY, onResLoadProcessNotify);
			this.gameServer.addEventListener(Event.CLOSE, onServerClose);
			
			battleInfo = plugin.retrieveModel(ModelDef.BATTLE) as BattleInfo;
		}
		
		override public function doCommand(command:Command):void
		{
			var type:uint;
			var id:uint;
			var story:int;
			var clientId:int;
			var difficulty:int;
			var uin:uint;
			var role_id:uint;
			var svr_id:uint;
			var active_pos:uint;
			var passive_pos:uint;
			var team_id:uint;
			var isAccept:Boolean;
			var contractPetIndex:uint;
			var skill_index:uint;
			var treasureMapId:uint;
			var treasureMapIndex:uint;
			
			switch(getQualifiedClassName(command))
			{
				case getQualifiedClassName(RequestPveFightStartCommand):
					type = (command as RequestPveFightStartCommand).type;
					id = (command as RequestPveFightStartCommand).id;
					story = (command as RequestPveFightStartCommand).story;
					clientId = (command as RequestPveFightStartCommand).clientId;
					difficulty = (command as RequestPveFightStartCommand).difficulty;
					treasureMapId = (command as RequestPveFightStartCommand).treasureMapId;
					treasureMapIndex = (command as RequestPveFightStartCommand).treasureMapIndex;
					battleInfo.id = id;
					battleInfo.type = type;
					battleInfo.clientId = clientId;
					requestPveFightStart(type, id, story, clientId, difficulty, treasureMapId, treasureMapIndex, command);
					break;
				
				case getQualifiedClassName(RequestPvpFightStartCommand):
					uin = (command as RequestPvpFightStartCommand).uin;
					type = (command as RequestPvpFightStartCommand).type;
					//					type = FightStartType.GUILD_ROBBERY;
					role_id = (command as RequestPvpFightStartCommand).role_id;
					svr_id = (command as RequestPvpFightStartCommand).svr_id;
					requestPvpFightStart(uin, type, role_id, svr_id, command);
					break;
				
				case getQualifiedClassName(RequestInsertFightCommand):
					requestInsertFight((command as RequestInsertFightCommand).uin, (command as RequestInsertFightCommand).roleId, (command as RequestInsertFightCommand).svrId);
					break;
				
				case getQualifiedClassName(RequestKathaSkillCommand):
					active_pos = (command as RequestKathaSkillCommand).activePos;
					passive_pos = (command as RequestKathaSkillCommand).passivePos;
					skill_index = (command as RequestKathaSkillCommand).skillIndex;
					requestKathaSkill(active_pos, passive_pos, skill_index, command);
					break;
				
				case getQualifiedClassName(RoundSyncAckCommand):
					team_id = (command as RoundSyncAckCommand).team_id;
					roundSyncAck(team_id);
					break;
				
				case getQualifiedClassName(FightRequestNotifyAckCommand):
					uin = (command as FightRequestNotifyAckCommand).uin;
					role_id = (command as FightRequestNotifyAckCommand).roleId;
					svr_id = (command as FightRequestNotifyAckCommand).svrId;
					isAccept = (command as FightRequestNotifyAckCommand).is_accept;
					fightRequestNotifyAck(uin, role_id, svr_id, isAccept);
					break;
				
				case getQualifiedClassName(FightResLoadedCommand):
					resLoadedAck((command as FightResLoadedCommand).isInsert);
					break;
				
				case getQualifiedClassName(BattleWatchResAckCommand):
					ackWatchRes();
					break;
				
				case getQualifiedClassName(BattleScriptAckCommand):
					team_id = (command as BattleScriptAckCommand).team_id;
					battleScriptAck(team_id);
					break;
				
				case getQualifiedClassName(ChangeFormationAckCommand):
					team_id = (command as ChangeFormationAckCommand).team_id;
					changeFormationAck(team_id);
					break;
				
				case getQualifiedClassName(RequestSummonContractPetCommand):
					requestSummonContractPet();
					break;
				
				case getQualifiedClassName(SendSpeedMessageCommand):
					sendSpeedMessage(SendSpeedMessageCommand(command).type, SendSpeedMessageCommand(command).notify);
					break;
				
				case getQualifiedClassName(RequestAutoFightCommand):
					requestBattleTrustee();
					break;
				
				case getQualifiedClassName(GiveUpBattleCommand):
					giveUpBattle(command as GiveUpBattleCommand);
					break;
				
				case getQualifiedClassName(NotifyFightCompleteCommand):
					notifyFightComplete();
					break;
			}
		}
		
		private function requestPveFightStart(type:uint, id:uint, stroyId:int, clientId:int, difficulty:int, treasureMapId:int, treasureMapIndex:int, command:Command):void
		{
			var request:ProtoFightStartRequest;
			var response:ProtoFightStartResponse;
			
			battleInfo.type = type;
			battleInfo.id = id;
			request = new ProtoFightStartRequest();
			request.type = type;
			request.npcClientId = clientId;
			request.dungeonDifficulty = difficulty;
			
			switch(type)
			{
				case FightStartType.FIGHT_START_TYPE_NINJA_EXAM:
					request.ninjaExamId = id;
					break;
				case FightStartType.FIGHT_START_TYPE_STORY:
					request.customBattleId = id;
					request.storyId = stroyId;
					break;
				case FightStartType.FIGHT_START_TYPE_CUSTOM_FIGHT:
				case FightStartType.FIGHT_START_TYPE_EXPEDITION:
				case FightStartType.FIGHT_START_TYPE_SANDBAG:
					request.customBattleId = id;
					break;
				case FightStartType.FIGHT_START_TYPE_DUNGEON_ELITE:
				case FightStartType.FIGHT_START_TYPE_DUNGEON_SPECIAL:
				case FightStartType.FIGHT_START_TYPE_BEFALL_DUNGEON:
					request.dungeonId = id;
					break;
				case FightStartType.FIGHT_START_TYPE_TRANSFER_ROLE:
					request.transferRoleId = id;
					break;
				case FightStartType.FIGHT_START_TYPE_TREASURE_MAP:
					request.treasureMapId = treasureMapId;
					request.treasureMapIndex = treasureMapIndex;
					break;
			}
			
			response = new ProtoFightStartResponse();
			gameServer.sendMessage(ProtocolCmdDef.FIGHT_START, request, response, command);
		}
		
		private function requestPvpFightStart(uin:uint, type:int, role_id:uint, svr_id:uint, command:Command):void
		{
			var request:ProtoFightStartRequest;
			var response:ProtoFightStartResponse;
			
			battleInfo.type = type;
			
			request = new ProtoFightStartRequest();
			request.type = type;
			request.passivePlayer = new ProtoPlayerKey();
			request.passivePlayer.uin = uin;
			request.passivePlayer.roleId = role_id;
			request.passivePlayer.svrId = svr_id;
			
			response = new ProtoFightStartResponse();
			gameServer.sendMessage(ProtocolCmdDef.FIGHT_START, request, response, command, false);
		}
		
		private function requestInsertFight(uin:uint, roleId:int, svrId:int):void
		{
			var playerKey:ProtoPlayerKey;
			var request:ProtoInsertFightRequest;
			var response:ProtoInsertFightResponse;
			
			playerKey = new ProtoPlayerKey();
			playerKey.uin = uin;
			playerKey.roleId = roleId;
			playerKey.svrId = svrId;
			
			request = new ProtoInsertFightRequest();
			request.fightingPlayer = playerKey;
			response = new ProtoInsertFightResponse();
			gameServer.sendMessage(ProtocolCmdDef.PVP_INSERT_FIGHT, request, response);
		}
		
		private function onPvpInsertFightResponse(protocol:SocketProtocol):void
		{
			var response:ProtoInsertFightResponse;
			
			//关闭挑战面板
			new CloseTextBoxCommand().call();
			
			response = protocol.serverMessage as ProtoInsertFightResponse;
			if (protocol.error != 0)
			{
				new ShowErrorMessageCommand(protocol.errorStr).call();
				battleInfo.battleFail();
				changeSelfState(UserStateDef.BASE_PVE, false);
				changeSelfState(UserStateDef.BASE_PVP, false);
				return;
			}
			
			new DestroyBattleCommand(false).call();
			
			battleInfo.battleStart();
			response.fightResToLoad.scriptId = 0;
			callStartBattleCmd(response.fightResToLoad, true, false);
			new SelfInsertNotifyCommand().call();
		}
		
		private function requestKathaSkill(active_pos:uint, passive_pos:uint, skill_index:int, cmd:Command):void
		{
			var request:ProtoKathaSkillRequest;
			var response:ProtoKathaSkillResponse;
			
			request = new ProtoKathaSkillRequest();
			request.activePos = active_pos;
			request.skillIndex = skill_index;
			if(passive_pos != uint.MAX_VALUE)
			{
				request.passivePos = passive_pos;
			}
			requestCmd[request] = cmd;
			
			response = new ProtoKathaSkillResponse();
			gameServer.sendMessage(ProtocolCmdDef.KACHA_SKILL, request, response);
		}
		
		private function roundSyncAck(team_id:uint):void
		{
			var request:ProtoRoundSyncAck;
			
			request = new ProtoRoundSyncAck();
			request.teamId = team_id;
			
			gameServer.sendMessage(ProtocolCmdDef.ROUND_SYNC, request,null, null, false);
		}
		
		private function battleScriptAck(team_id:uint):void
		{
			var request:ProtoBattleScriptAck;
			
			request = new ProtoBattleScriptAck();
			request.teamId = team_id;
			
			gameServer.sendMessage(ProtocolCmdDef.BATTLE_SCRIPT_ACK, request,null, null,false);
		}
		
		private function changeFormationAck(team_id:uint):void
		{
			var request:ProtoChangeFormationAck;
			
			request = new ProtoChangeFormationAck();
			request.teamId = team_id;
			
			gameServer.sendMessage(ProtocolCmdDef.BATTLE_CHANGE_FORMATION_ACK, request, null,null,false);
		}
		
		private function requestSummonContractPet():void
		{
			var request:ProtoSummonContractPetRequest;
			var response:ProtoSummonContractPetResponse;
			
			request = new ProtoSummonContractPetRequest();
			
			response = new ProtoSummonContractPetResponse();
			gameServer.sendMessage(ProtocolCmdDef.BATTLE_FIGHT_SUMMON_CONTRACT_PET, request, response);
		}
		
		private function onSummonContractPetResponse(protocol:SocketProtocol):void
		{
			var response:ProtoSummonContractPetResponse;
			
			response = protocol.serverMessage as ProtoSummonContractPetResponse;
			if (protocol.error != 0)
			{
				if (protocol.errorStr)
				{
					new ShowErrorMessageCommand(protocol.errorStr).call();
				}
				return;
			}
			
			new SummonContractPetResponseCommand().call();
		}
		
		private function fightRequestNotifyAck(uin:uint, roleId:uint, svrId:uint, isAccept:Boolean):void
		{
			var request:ProtoFightRequestNotifyAck;
			
			request = new ProtoFightRequestNotifyAck();
			
			request.player = new ProtoPlayerKey();
			request.player.uin = uin;
			request.player.roleId = roleId;
			request.player.svrId = svrId;
			request.isAccept = uint(isAccept);
			
			gameServer.sendMessage(ProtocolCmdDef.PVP_FIGHT_CHALLENGE_NOTIFY, request, null, null, false);
		}
		
		private function resLoadedAck(isInsert:Boolean):void
		{
			var request:ProtoFightResLoaded;
			request = new ProtoFightResLoaded();
			if(isInsert == false)
			{
				gameServer.sendMessage(ProtocolCmdDef.FIGHT_RES_LOADED, request, null, null, false);
			}
			else
			{
				gameServer.sendMessage(ProtocolCmdDef.PVP_INSERT_FIGHT_RES_LOAD, request, null, null, false);
			}
		}
		
		private function onFightStartNotify(protocol:SocketProtocol):void
		{
			var response:ProtoFightStartNotify;
			
			//关闭挑战面板
			//			new CloseTextBoxCommand().call();
			response = protocol.serverMessage as ProtoFightStartNotify;
			if (battleInfo.type == FightStartType.FIGHT_START_TYPE_WORLD_BOSS) {
				
				changeSelfState(UserStateDef.BASE_PVE, true);
				
			}else {
				
				battleInfo.type = response.fightResToLoad.fightType;
			}
			new DestroyBattleCommand(false).call();
			if(response.fightResToLoad.customBattleInfo == null)
			{
				battleInfo.id = 0;
				changeSelfState(UserStateDef.BASE_PVP, true);
			}
			else
			{
				changeSelfState(UserStateDef.BASE_PVE, true);
			}
			
			battleInfo.battleStart();
			callStartBattleCmd(response.fightResToLoad, response.insertBattleFlag != 0, response.fightResToLoad.hasHasStartTips, response.roundCount);
		}
		
		private function onOhterPlayerResCompleteNotify(protocol:SocketProtocol):void
		{
			var notify:ProtoHasLoadedResBroadcast;
			
			notify = protocol.serverMessage as ProtoHasLoadedResBroadcast;
			new OtherPlayerResCompleteNotce(notify.teamId).send();
			
		}
		
		private function onResponseFightStart(protocol:SocketProtocol):void
		{
			var response:ProtoFightStartResponse;
			var requestCommand:Command;
			var sectionId:int;
			var customFightId:int;
			var sceneId:int;
			
			logger.output("[onResponseFightStart]", "onResponseFightStart");
			
			//关闭挑战面板
			new CloseTextBoxCommand().call();
			
			response = protocol.serverMessage as ProtoFightStartResponse;
			if (protocol.error != 0)
			{
				requestCommand = protocol.clientData as Command;
				
				new ShowErrorMessageCommand(protocol.errorStr).call();
				if(requestCommand != null)
				{
					requestCommand.faild(protocol.error);
				}
				battleInfo.battleFail();
				NarutoLoading.loadingView.hide();
				changeSelfState(UserStateDef.BASE_PVE, false);
				changeSelfState(UserStateDef.BASE_PVP, false);
				return;
			}
			
			new DestroyBattleCommand(false).call();
			
			if (battleInfo.type == FightStartType.FIGHT_START_TYPE_WORLD_BOSS) {
				
				changeSelfState(UserStateDef.BASE_PVE, true);
				
			}else {
				
				battleInfo.type = response.fightResToLoad.fightType;
				
				if(response.fightResToLoad.customBattleInfo == null)
				{
					battleInfo.id = 0;
					changeSelfState(UserStateDef.BASE_PVP, true);
				}
				else
				{
					changeSelfState(UserStateDef.BASE_PVE, true);
				}
			}
			battleInfo.battleStart();
			callStartBattleCmd(response.fightResToLoad, false, response.fightResToLoad.hasHasStartTips);
		}
		
		private function onNotifyFightOver(protocol:SocketProtocol):void
		{
			var response:ProtoFightOverNotify;
			var overInfo:ProtoFightOverInfo;
			var notifyFightOverCommand:NotifyFightOverCommand;
			var setUserInitLocationCommand:SetUserInitLocationCommand;
			var plyerData:UIPlayerData;
			var selfUin:uint;
			var selfRole:uint;
			var selfSvr:uint;
			var selfIsLeft:Boolean;
			var isLeftTeam:Boolean;
			
			selfIsLeft = UIData.singleton.selfInLeft;
			
			response = protocol.serverMessage as ProtoFightOverNotify;
			
			if(UIData.singleton.self)
			{
				selfSvr = UIData.singleton.self.serId;
				selfRole = UIData.singleton.self.roleId;
				selfUin = UIData.singleton.self.uin;
			}
			else
			{
				selfSvr = ApplicationData.singleton.selfInfo.svrId;
				selfRole = ApplicationData.singleton.selfInfo.role;
				selfUin = ApplicationData.singleton.selfInfo.uin;
			}
			
			if(BattleData.singleton.fightType == FightStartType.FIGHT_START_TYPE_GVG || BattleData.singleton.fightType == FightStartType.FIGHT_START_TYPE_GUILD_ROBBERY)
			{
				response.needShow = 0;
			}
			
			if (protocol.error == 0)
			{
				if (BattleData.singleton.fightType == FightStartType.FIGHT_START_TYPE_GVG) {//GVG用新方式判断，
					overInfo = response.fightOverInfo[0];
					
					var isWin:Boolean = overInfo.fightResult == 1;
					
					var isOurSide:Boolean = UIData.singleton.isOurPlayerPos(overInfo.teamId);
					
					notifyFightOverCommand = new NotifyFightOverCommand();
					notifyFightOverCommand.isWin = isOurSide?isWin: !isWin ;
					notifyFightOverCommand.showResult = response.needShow == 1;
					notifyFightOverCommand.call();
					
					return;
				}
				
				trace(BattleData.singleton.fightType);
				if(BattleData.singleton.fightType == FightStartType.FIGHT_START_TYPE_GUILD_ROBBERY )//掠夺队友掉线了
				{
					for each (overInfo in response.fightOverInfo)
					{
						isLeftTeam = overInfo.teamId % 2 == 0;
						if(isLeftTeam == selfIsLeft)
						{
							notifyFightOverCommand = new NotifyFightOverCommand();
							notifyFightOverCommand.isWin = (overInfo.fightResult == 1);
							notifyFightOverCommand.showResult = response.needShow == 1;
							notifyFightOverCommand.call();
							return ;
						}
					}
				}
				
				for each (overInfo in response.fightOverInfo)
				{
					if(overInfo.player.uin == selfUin && overInfo.player.svrId == selfSvr && overInfo.player.roleId == selfRole)
					{
						notifyFightOverCommand = new NotifyFightOverCommand();
						notifyFightOverCommand.isWin = (overInfo.fightResult == 1);
						if(BattleData.singleton.fightType == FightStartType.FIGHT_START_TYPE_RANK_BATTLE || BattleData.singleton.fightType == FightStartType.FIGHT_START_TYPE_EXPEDITION || BattleData.singleton.fightType == FightStartType.FIGHT_START_TYPE_SANDBAG)
						{
							notifyFightOverCommand.damageInfo = getDamageInfo(response.teamDamageStat);
						}
						if(response.hasNeedShow)
						{
							notifyFightOverCommand.showResult = response.needShow == 1;
						}
						notifyFightOverCommand.call();
					}
					
					if (overInfo.player.uin == ApplicationData.singleton.selfuin && overInfo.player.svrId == ApplicationData.singleton.selfSrv && overInfo.player.roleId == ApplicationData.singleton.selfRole)
					{
						if(response.hasRelivePoint)
						{
							(callSetPlayerLocationCommand(new Point(response.relivePoint.x, response.relivePoint.y)));
						}
						
						//收集到的东西放在副本baseIncome里请求，这里先注释掉
						//						if(SceneConfig.getSceneInfo(ApplicationData.singleton.globelInfo.sceneId).type == SceneType.DUNGEON_SCENE)
						//						{
						//							new NotifyDungeonCollectionCommand(overInfo.collecionEvent).call();
						//						}
						
						notifyFightingStatusChange(response.fightOverInfo, false);//TODO :这个方法没用
						break;
					}
				}
			}
		}
		
		private function getDamageInfo(teamDamageStat:Array):DamageInfo
		{
			var damageInfo:DamageInfo;
			var damagePlayerInfo:DamagePlayerInfo;
			var damageNinjaInfo:DamageNinjaInfo;
			var maxMakeDamage:int = int.MIN_VALUE;
			var maxAffordDamage:int = int.MIN_VALUE;
			
			damageInfo = new DamageInfo();
			for each(var protoTeamDamageStat:ProtoTeamDamageStat in teamDamageStat)
			{
				damagePlayerInfo = new DamagePlayerInfo();
				damagePlayerInfo.uin = protoTeamDamageStat.playerKey.uin;
				damagePlayerInfo.role = protoTeamDamageStat.playerKey.roleId;
				damagePlayerInfo.srvId = protoTeamDamageStat.playerKey.svrId;
				damagePlayerInfo.teamPos = protoTeamDamageStat.teamPos;
				
				for each(var protoNinjaDamageStat:ProtoNinjaDamageStat in protoTeamDamageStat.ninjaDamageList)
				{
					damageNinjaInfo = new DamageNinjaInfo();
					damageNinjaInfo.ninjaId = protoNinjaDamageStat.ninjaId;
					damageNinjaInfo.level = protoNinjaDamageStat.ninjaLevel;
					damageNinjaInfo.starLevel = protoNinjaDamageStat.ninjaStarLevel;
					damageNinjaInfo.makeDamage = protoNinjaDamageStat.makeDamage;
					damageNinjaInfo.affordDamage = protoNinjaDamageStat.affordDamage;
					damageNinjaInfo.levelUpgrade = protoNinjaDamageStat.ninjaAwakenLevel;
					
					damagePlayerInfo.damageNinjaInfos.push(damageNinjaInfo);
					
					if(maxMakeDamage < damageNinjaInfo.makeDamage)
					{
						maxMakeDamage = damageNinjaInfo.makeDamage;
					}
					
					if(maxAffordDamage < damageNinjaInfo.affordDamage)
					{
						maxAffordDamage = damageNinjaInfo.affordDamage;
					}
				}
				
				damageInfo.damagePlayerInfos.push(damagePlayerInfo);
			}
			
			for each(damagePlayerInfo in damageInfo.damagePlayerInfos)
			{
				for each(damageNinjaInfo in damagePlayerInfo.damageNinjaInfos)
				{
					damageNinjaInfo.maxMakeDamage = maxMakeDamage;
					damageNinjaInfo.maxAffordDamage = maxAffordDamage;
				}
			}
			
			return damageInfo;
		}
		
		private function onResponseKachaSkill(protocol:SocketProtocol):void
		{
			var request:ProtoKathaSkillRequest;
			var response:ProtoKathaSkillResponse;
			var cmd:RequestKathaSkillCommand;
			
			request = protocol.clientMessage as ProtoKathaSkillRequest;
			response = protocol.serverMessage as ProtoKathaSkillResponse;
			cmd = requestCmd[request] as RequestKathaSkillCommand;
			Assert((cmd != null), I18n.lang("as_battle_1451031565_342"));
			delete requestCmd[request];
			
			if(protocol.error == 0)
			{
				cmd.skillStates = BaseConverter.convertSkillStatus(response.teamSkillState);
				cmd.kathaChange = response.teamKathaChange.kathaChange;
				cmd.teamPos = response.teamKathaChange.teamId;
				cmd.finish();
			}
			else
			{
				cmd.faild(protocol.error);
				new ShowErrorMessageCommand(protocol.errorStr).call();
			}
		}
		
		private function onKachaSkillBroadcast(protocol:SocketProtocol):void
		{
			var response:ProtoKathaSkillBroadcast;
			var cmd:NotifyKathaSkillCommand;
			var kathaTeamInfo:ProtoTeamKathaSkillUse;
			var kathaUnitUse:ProtoUnitKathaSkillUse;
			var kathaTeamList:Array;
			
			response = protocol.serverMessage as ProtoKathaSkillBroadcast;
			
			kathaTeamList = response.teamSkillUse;
			for each(kathaTeamInfo in kathaTeamList)
			{
				for(var i:int = 0;i < kathaTeamInfo.unitSkillUse.length;i ++)
				{
					kathaUnitUse = kathaTeamInfo.unitSkillUse[i];
					cmd = new NotifyKathaSkillCommand();
					cmd.playerTeamId = kathaTeamInfo.teamId;
					if(i == kathaTeamInfo.unitSkillUse.length - 1)
					{
						cmd.mp = kathaTeamInfo.kathaChange;
					}
					else
					{
						cmd.mp = 0;
					}
					cmd.ninjaPos = kathaUnitUse.pos;
					cmd.skillId = kathaUnitUse.skillInfo.skillId;
					cmd.skillIndex = kathaUnitUse.skillInfo.skillIndex;
					cmd.useSpecialSkill = kathaUnitUse.skillInfo.hasSkillIndex;
					cmd.call();
				}
			}
			
			if(response.teamSkillState.length != 0)
			{
				new UpdateSkillStateCommand(BaseConverter.convertSkillStatus(response.teamSkillState)).call();
			}
		}
		
		private function onRoundSync(protocol:SocketProtocol):void
		{
			var response:ProtoRoundSync;
			var cmd:NotifyRoundSyncCommand;
			var changedCustomIDCommand:ChangedCustomIDCommand;
			var player:UIPlayerData;
			var actionList:Array;
			
			response = protocol.serverMessage as ProtoRoundSync;
			
			if(response.customBattleInfo != null)
			{
				changedCustomIDCommand = new ChangedCustomIDCommand(response.customBattleInfo.sectionId,
					response.customBattleInfo.customId,
					(response.backgroundRes)?response.backgroundRes.backgroundMap:0,
					response.customBattleInfo.currentBattleWave,
					response.customBattleInfo.totalBattleWave
				);
				changedCustomIDCommand.call();
			}
			
			if (BattleData.singleton.fightType == FightStartType.FIGHT_START_TYPE_GVG && BattleData.singleton.isGVGFightOverState == 0) {
				if (response.isFightOver) {
					BattleData.singleton.isGVGFightOverState = 1;
				}
				for each(var metaAction:ProtoMetaAction in response.metaAction)
				{
					if (metaAction.isOver) {
						BattleData.singleton.isGVGFightOverState = 1;
						break;
					}
				}
			}
			
			actionList = [];
			//提取metaAction数组里面的StageAction; scriptAction也跟stageAction放在一起
			actionList = actionList.concat(StageActionConverter.getStageActionList(response.metaAction));
			//提取metaAction数组里面的EnchanmentAction; scriptAction也跟stageAction放在一起
			actionList = actionList.concat(EnchantmentConverter.getEnchatmentActions(response.metaAction));
			
			cmd = new NotifyRoundSyncCommand();
			cmd.buffInfos = BuffConverter.getBuffInfoList(response.metaAction);  //提取metaAction数组里面的BuffAction
			cmd.shieldInfos = ShieldConverter.getShieldInfoList(response.metaAction);  //提取metaAction数组里面的护盾BuffAction
			cmd.actionList = actionList; 
			cmd.teamInfos = UIInfoConverte.convertProtoTeamInfosToPlayerDataList(response.teamInfo);
			cmd.isFightOver = response.isFightOver;
			cmd.roundIndex = response.bigRoundIndex;
			cmd.skillStates = BaseConverter.convertSkillStatus(response.teamInfo);
			cmd.customEndRound = response.customBattleInfo != null;
			cmd.call();
		}
		
		private function onNotifyTinyRound(protocol:SocketProtocol):void
		{
			
			if (BattleData.singleton.isGVGFightOverState == 1) {
				BattleData.singleton.isGVGFightOverState = 2;
				new GVGFightOverNotice().send();
			}
			
			var response:ProtoTinyRoundNotify;
			var cmd:NotifyTinyRoundsCommand = new NotifyTinyRoundsCommand();
			var roundId:int;
			
			response = protocol.serverMessage as ProtoTinyRoundNotify;
			
			if(response.hasTinyRoundId)
			{
				roundId = response.tinyRoundId;//Math.random() * 1000
			}
			else
			{
				roundId = -1;
			}
			response.tinyRoundId = roundId;
			cmd.roundId = roundId;
			cmd.isFightOver = response.isFightOver;
			
			if (BattleData.singleton.fightType == FightStartType.FIGHT_START_TYPE_GVG && BattleData.singleton.isGVGFightOverState == 0) {
				if (response.isFightOver) {
					BattleData.singleton.isGVGFightOverState = 1;
				}
			}
			cmd.actions = MessageConverter.convertMetaActionArr(response.action, roundId);
			cmd.notice = MessageConverter.dumpUpdatePlayerInfoNotice();
			cmd.call();
			
			if(response.hasLeftBattleRound)
			{
				new UpdateLeftBattleRoundCommand(response.leftBattleRound).call();
			}
		}
		
		private function onInsertTinyRound(protocol:SocketProtocol):void
		{
			var metaAction:ProtoMetaAction;
			var response:ProtoInsertFightStageNotify;
			var initCmd:InsertBattleInitCommand = new InsertBattleInitCommand();
			var cmd:NotifyTinyRoundsCommand = new NotifyTinyRoundsCommand();
			
			response = protocol.serverMessage as ProtoInsertFightStageNotify;
			cmd.actions = [];
			
			if(response.hasEnchantmentId)
			{
				var enchantment:EnchantmentActionInfo = new EnchantmentActionInfo();
				enchantment.enchatmentId = response.enchantmentId;
				enchantment.skillStatusChangedList = [];
				cmd.actions.push(enchantment);
			}
			
			metaAction = response.action[0] as ProtoMetaAction;
			UIData.singleton.monster.teamId = StageActionConverter.getMonsterId(metaAction.stageAction.playerTeamPos);
			
			initCmd.isAuto = StageActionConverter.isAutoFight(metaAction.stageAction.playerTeamPos, selfInfo.uin, selfInfo.role, selfInfo.svrId);
			initCmd.call();
			
			cmd.roundId = 0;
			cmd.isFightOver = false;
			cmd.actions = cmd.actions.concat(MessageConverter.convertMetaActionArr(response.action, 0));
			cmd.notice = MessageConverter.dumpUpdatePlayerInfoNotice();
			cmd.call();
			
			if(response.hasLeftBattleRound)
			{
				new UpdateLeftBattleRoundCommand(response.leftBattleRound).call();
			}
		}
		
		private function onFightErrorNotify(protocol:SocketProtocol):void
		{
			var notify:ProtoFightStartErrorNotify;
			
			notify = protocol.serverMessage as ProtoFightStartErrorNotify;
			if (notify.hasErrorMsg)
			{
				NarutoLoading.loadingView.hide();
				//				new ClearWorldSnapshotCommand().call();
				new DestroyBattleCommand(false).call();
				new ShowErrorMessageCommand(notify.errorMsg).call();
				battleInfo.battleFail();
				
				
			}
		}
		
		private function onFightDelayStartNotify(protocol:SocketProtocol):void
		{
			var notice:ProtoInsertFightDelayNotify;
			
			notice = protocol.serverMessage as ProtoInsertFightDelayNotify;
			new NotifyDelayStartCommand(notice.scriptId).call();
			
			new ShowTextBoxCommand(I18n.lang("as_battle_1451031565_345")).call();
		}
		
		private function onPlayerDisConnectNotify(protocol:SocketProtocol):void
		{
			var response:ProtoPlayerDisconnectBroadcast;
			
			response = protocol.serverMessage as ProtoPlayerDisconnectBroadcast;
			new UpdatePlayerOnlineInfoCommand(false, response.teamId).call();
			
			new PrewarPlayerExitCommand(response.teamId).call();
			//BattleData.singleton.isGVGFightOver = true;
		}
		
		private function onPlayerReConnectNotify(protocol:SocketProtocol):void
		{
			var response:ProtoPlayerReconnectBroadcast;
			
			response = protocol.serverMessage as ProtoPlayerReconnectBroadcast;
			new UpdatePlayerOnlineInfoCommand(true, response.teamId).call();
		}
		
		private function sendSpeedMessage(type:int, notify:Boolean):void
		{
			var request:ProtoSpeedUpRequest;
			var response:ProtoSpeedUpResponse;
			
			//			if(selfInfo.teamId != "" && selfInfo.teamId != null)
			//			{
			//				ApplicationData.singleton.isSpeedUp = (type == 1);
			//				return ;
			//			}
			request = new ProtoSpeedUpRequest();
			response = new ProtoSpeedUpResponse();
			request.option = type;
			request.needNotifyMembers = notify;
			
			this.gameServer.sendMessage(ProtocolCmdDef.BATTLE_SPEED_UP, request, response);
		}
		
		private function onSpeedUpResponse(protocol:SocketProtocol):void
		{
			var request:ProtoSpeedUpRequest;
			var response:ProtoSpeedUpResponse;
			
			request = protocol.clientMessage as ProtoSpeedUpRequest;
			response = protocol.serverMessage as ProtoSpeedUpResponse;
			if(protocol.error != 0)
			{
				//				new ShowErrorMessageCommand(protocol.errorStr).call();
				return ;
			}
			
			new SpeedUpNotice(request.option).send();
		}
		
		private function onSpeedUpNotify(protocol:SocketProtocol):void
		{
			var response:ProtoSpeedUpNotify;
			var teamMemberData:TeamMemberData;
			
			response = protocol.serverMessage as ProtoSpeedUpNotify;
			new SpeedUpNotice(response.speedRatio - 1).send();
		}
		
		private function requestBattleTrustee():void
		{
			var request:ProtoTrusteeRequest;
			var response:ProtoTrusteeResponse;
			
			request = new ProtoTrusteeRequest();
			response = new ProtoTrusteeResponse();
			this.gameServer.sendMessage(ProtocolCmdDef.BATTLE_TRUSTEE, request, response);
		}
		
		private function giveUpBattle(command:GiveUpBattleCommand):void
		{
			var request:ProtoSurrenderRequest;
			var response:ProtoSurrenderResponse;
			
			request = new ProtoSurrenderRequest();
			response = new ProtoSurrenderResponse();
			gameServer.sendMessage(ProtocolCmdDef.BATTLE_GIVE_UP, request, response, command);
		}
		
		private function onGiveUpBattleResult(protocol:SocketProtocol):void
		{
			var command:GiveUpBattleCommand;
			
			command = protocol.clientData as GiveUpBattleCommand;
			
			if(protocol.error != 0)
			{
				command.faild();
				new ShowErrorMessageCommand(protocol.errorStr).call();
				return ;
			}
			
			command = protocol.clientData as GiveUpBattleCommand;
			command.finish();
		}
		
		private function onGiveUpBattleBroadcast(protocol:SocketProtocol):void
		{
			var notify:ProtoPlayerSurrenderBroadcast;
			
			notify = protocol.serverMessage as ProtoPlayerSurrenderBroadcast;
			
			if(UIData.singleton.isOurPlayerPos(notify.teamId))
			{
				new GiveUpBroadcastNotice().send();
			}
		}
		
		private function onBattleTrusteeResult(protocol:SocketProtocol):void
		{
			var response:ProtoTrusteeResponse;
			
			response = protocol.serverMessage as ProtoTrusteeResponse;
			if(protocol.error == 0)
			{
				new NotifyAutoFightCommand(response.trusteeState == 1).call();
			}
			else
			{
				//				new ShowErrorMessageCommand(protocol.errorStr).call();
			}
		}
		
		private function onBattleTrusteeNotify(protocol:SocketProtocol):void
		{
			var notify:ProtoTrusteeNotify;
			
			notify = protocol.serverMessage as ProtoTrusteeNotify;
			new NotifyAutoFightCommand(notify.trusteeState == 1).call();
		}
		
		private function onCloseFightTipsNotify(protocol:SocketProtocol):void
		{
			new NotifyCloseFightTipsCommand().call();
		}
		/**
		 * 
		 * @param	resLoaded 包含了要加载的场景，CustomInfo，人物，信息
		 * @param	isInsert
		 * @param	hasHasStartTips
		 */
		private function callStartBattleCmd(resLoaded:ProtoFightResToLoad, isInsert:Boolean = false, hasHasStartTips:Boolean = false, count:int = 0):void
		{
			var cmd:NotifyStartBattleCommand;
			var scriptInfo:ScriptActionInfo;
			var ninjaList:Array;
			var scriptId:int;
			var custom:CustomInfo;
			var selfResInfo:ProtoPlayerTeamPos;
			
			BoxManager.hideBoxByEnterBattle();
			new InitializeBattleCommand().call();
			
			scriptId = resLoaded.scriptId;
			custom = new CustomInfo();
			custom.sceneId = resLoaded.backgroundRes.backgroundMap;
			if(resLoaded.customBattleInfo != null)
			{
				custom.customFightId = resLoaded.customBattleInfo.customId;
				custom.sectionId = resLoaded.customBattleInfo.sectionId;
				custom.curWave = resLoaded.customBattleInfo.currentBattleWave;
				custom.totalWave = resLoaded.customBattleInfo.totalBattleWave;
			}
			if(resLoaded.hasWorldBossFaintRound)
			{
				BattleData.singleton.enervationCountDown = resLoaded.worldBossFaintRound;
			}
			
			BattleData.singleton.timeout = resLoaded.syncTimeoutSec;
			
			for each(var playerTeamPos:ProtoPlayerTeamPos in resLoaded.playerResInfo)
			{
				if(playerTeamPos.teamId == resLoaded.teamId)
				{
					selfResInfo = playerTeamPos;
					WaitLoadingData.singleton.addWaitPlayer(playerTeamPos.teamId, playerTeamPos.playerName, playerTeamPos.hasLoadedRes == 1, true);
					continue ;
				}
				
				WaitLoadingData.singleton.addWaitPlayer(playerTeamPos.teamId, playerTeamPos.playerName, playerTeamPos.hasLoadedRes == 1, false);
			}
			
			ninjaList = selfResInfo.stageInfo.ninja;
			cmd = new NotifyStartBattleCommand();
			cmd.uiData = UIInfoConverte.convertUIData(selfResInfo);
			cmd.custom = custom;
			cmd.teamId = resLoaded.teamId;
			cmd.ninjaList = BaseConverter.convertNinjaInfos(selfResInfo.teamId, 0, selfResInfo.stageInfo.ninja, PlayerNameUtil.standardlizeName(selfResInfo.player, selfResInfo.playerName));
			BaseConverter.settingExeuntStageAction(cmd.ninjaList, selfResInfo);
			cmd.contractPetId = selfResInfo.contractPetId;
			cmd.contractPetInfo = BaseConverter.convertContractPetNinjaInfo(selfResInfo.contractPetId);
			cmd.isInsert = isInsert;
			cmd.uiData.customInfo = custom;
			cmd.uiData.firsetAction = true;
			cmd.beginRoundIndex = count;
			BattleData.singleton.needShowFightTips = hasHasStartTips;
			BattleData.singleton.fightType = resLoaded.fightType;
			BattleData.singleton.subFightType = resLoaded.fightSubType;
			
			if(scriptId != 0)
			{
				scriptInfo = new ScriptActionInfo();
				scriptInfo.scriptId = scriptId;
				
				cmd.scriptInfo = scriptInfo;
			}
			cmd.call();
		}
		
		private function notifyFightingStatusChange(protoPlayerTeamPosArr:Array, isFighting:Boolean):void
		{
			var protoPlayerKey:ProtoPlayerKey;
			var type:String;  //区分是玩家还是Npc
			//这是用来在玩家头上显示战斗标志的
			for each (var playerTeamPos:Object in protoPlayerTeamPosArr)
			{
				protoPlayerKey = playerTeamPos.player as ProtoPlayerKey;
			}
		}
		
		private function callSetPlayerLocationCommand(location:Point):void
		{
			new SetSelfPlayerPosAndDirCommand(location, -1).call();
		}
		
		private function onWatchNotify(protocol:SocketProtocol):void
		{
			var notify:ProtoWatchFightNotify;
			var playerTeamPos:ProtoPlayerTeamPos;
			var cmd:NotifyStartBattleCommand;
			var custom:CustomInfo;
			
			notify = protocol.serverMessage as ProtoWatchFightNotify;
			
			logger.output("BattleData.singleton.fightState ", BattleData.singleton.fightState); 
			if(BattleData.singleton.fightState != BattleData.FIGHT_STATE_NONE)//车轮战需要手动显示一下loading条
			{
				WaitLoadingData.singleton.dispose();
				for each(playerTeamPos in notify.needLoadResPlayerList.fightPlayerList)
				{
					WaitLoadingData.singleton.addWaitPlayer(playerTeamPos.teamId, playerTeamPos.playerName, playerTeamPos.hasLoadedRes == 1, false);
				}
				
				new UpdateWatchFlagNotice(BattleData.SKILL_STATUS_WATCH_ON).send();
				new NotifyShowResLoadCommand().call();
				return ;
			}
			
			changeSelfState(UserStateDef.BASE_PVP, true);//观战暂时只能观PVP
			
			BoxManager.hideBoxByEnterBattle();
			new CloseTextBoxCommand().call();
			new InitializeBattleCommand().call();
			
			
			battleInfo.type = notify.fightStartType;
			battleInfo.battleStart();
			custom = new CustomInfo();
			custom.sceneId = notify.backgroundRes.backgroundMap;
			BattleData.singleton.timeout = notify.syncTimeoutSec;
			
			WaitLoadingData.singleton.dispose();
			for each(playerTeamPos in notify.needLoadResPlayerList.fightPlayerList)
			{
				WaitLoadingData.singleton.addWaitPlayer(playerTeamPos.teamId, playerTeamPos.playerName, playerTeamPos.hasLoadedRes == 1, false);
			}
			
			cmd = new NotifyStartBattleCommand();
			cmd.custom = custom;
			cmd.ninjaList = [];
			cmd.uiData = UIInfoConverte.creatWatchUIData(notify.side == 0);
			cmd.uiData.customInfo = custom;
			cmd.uiData.firsetAction = true;
			cmd.beginRoundIndex = notify.roundCount-1;//后台返回的是从1开始，前台是从0算起
			BattleData.singleton.fightType = battleInfo.type;
			
			cmd.call();
			
			new UpdateWatchFlagNotice(BattleData.SKILL_STATUS_WATCH_ON).send();
		}
		
		private function ackWatchRes():void
		{
			var request:EmptyMessage;
			var response:ProtoWatchFightReadyResponse;
			
			request = new EmptyMessage();
			response = new ProtoWatchFightReadyResponse();
			
			this.gameServer.sendMessage(ProtocolCmdDef.BATTLE_WATCH_READY_ACK, request, response);
		}
		
		private function onBattleWatchReayAckResult(protocol:SocketProtocol):void
		{
			var response:ProtoWatchFightReadyResponse;
			var cmd:NotifyTinyRoundsCommand;
			
			if(protocol.error != 0 && protocol.error != -8009)
			{
				new ShowErrorMessageCommand(protocol.errorStr).call();
				
				NarutoLoading.loadingView.hide();
				new DestroyBattleCommand(false).call();
				battleInfo.battleFail();
				
				return ;
			}
			
			response = protocol.serverMessage as ProtoWatchFightReadyResponse;
			
			if(response.needLoadResPlayerList == null && response.action == null){return ;}
			
			if(WaitLoadingData.singleton.isComplete == false)
			{
				if(response.needLoadResPlayerList != null)
				{
					for each(var playerTeamPos:ProtoPlayerTeamPos in response.needLoadResPlayerList.fightPlayerList)
					{
						if(playerTeamPos.hasLoadedRes == 1)
						{
							LoadAssetHelper.singleton.addCompletePlayer(playerTeamPos.teamId);
						}
					}
				}
				else
				{
					LoadAssetHelper.singleton.finishAllWaitPlayer();
				}
			}
			
			if(response.action == null)
			{
				return ;
			}
			
			cmd = new NotifyTinyRoundsCommand();
			
			cmd.isFightOver = false;
			response.action.stageAction.battleStartFlag = 1;
			cmd.actions = MessageConverter.convertMetaActionArr([response.action], 0);
			cmd.notice = MessageConverter.dumpUpdatePlayerInfoNotice();
			cmd.call();
		}
		
		private function onResLoadProcessNotify(protocol:SocketProtocol):void
		{
			var notify:ProtoFightStartNotify;
			var selfResInfo:ProtoPlayerTeamPos;
			
			notify = protocol.serverMessage as ProtoFightStartNotify;
			
			WaitLoadingData.singleton.dispose();
			for each(var playerTeamPos:ProtoPlayerTeamPos in notify.fightResToLoad.playerResInfo)
			{
				if(playerTeamPos.teamId == notify.fightResToLoad.teamId)
				{
					selfResInfo = playerTeamPos;
					WaitLoadingData.singleton.addWaitPlayer(playerTeamPos.teamId, playerTeamPos.playerName, playerTeamPos.hasLoadedRes == 1, true);
					continue ;
				}
				
				WaitLoadingData.singleton.addWaitPlayer(playerTeamPos.teamId, playerTeamPos.playerName, playerTeamPos.hasLoadedRes == 1, false);
			}
			
			new NotifyShowResLoadCommand().call();
		}
		
		private function onWatchTransformNotify(protocol:SocketProtocol):void
		{
			var cmd:NotifyWatchTransfomResAckCommand;
			var notify:ProtoFightStartNotify;
			var selfResInfo:ProtoPlayerTeamPos;
			
			notify = protocol.serverMessage as ProtoFightStartNotify;
			
			cmd = new NotifyWatchTransfomResAckCommand();
			
			UIData.singleton.firsetAction = true;
			WaitLoadingData.singleton.dispose();
			for each(var playerTeamPos:ProtoPlayerTeamPos in notify.fightResToLoad.playerResInfo)
			{
				if(playerTeamPos.teamId == notify.fightResToLoad.teamId)
				{
					selfResInfo = playerTeamPos;
					WaitLoadingData.singleton.addWaitPlayer(playerTeamPos.teamId, playerTeamPos.playerName, playerTeamPos.hasLoadedRes == 1, true);
					continue ;
				}
				
				WaitLoadingData.singleton.addWaitPlayer(playerTeamPos.teamId, playerTeamPos.playerName, playerTeamPos.hasLoadedRes == 1, false);
			}
			
			cmd.teamId = notify.fightResToLoad.teamId;
			BattleData.singleton.timeout = notify.fightResToLoad.syncTimeoutSec;
			cmd.ninjaList = BaseConverter.convertNinjaInfos(selfResInfo.teamId, 0, selfResInfo.stageInfo.ninja, PlayerNameUtil.standardlizeName(selfResInfo.player, selfResInfo.playerName));
			cmd.contractPetInfo = BaseConverter.convertContractPetNinjaInfo(selfResInfo.contractPetId);
			new UpdateWatchFlagNotice(BattleData.SKILL_STATUS_WATCH_OFF).send();
			cmd.call();
		}
		
		private function notifyFightComplete():void
		{
			var request:EmptyMessage;
			var response:ProtoBattleEndConfirmResp;
			
			request = new EmptyMessage();
			response = new ProtoBattleEndConfirmResp();
			this.gameServer.sendMessage(ProtocolCmdDef.BATTLE_OVER_CONFIRM, request, response);
		}
		
		private function onNotifyCompleteResult(protocol:SocketProtocol):void
		{
			if(protocol.error != 0)
			{
				//				new ShowErrorMessageCommand(protocol.errorStr).call();
				return ;
			}
			
		}
		
		private function onServerClose(evt:Event):void
		{
			if(battleInfo.isFighting)
			{
				new CGIReportCommand(CGIReportTypeDef.DISCONNECT,[{state:"state",value:BattleData.singleton.socketClosePharse}]).call();
			}
		}
		
		override public function autoSetNull():void
		{
			if(super.hasOwnProperty("autoSetNull"))
			{
				super["autoSetNull"]();
			}
			
			requestCmd = null;
			battleInfo = null;
		}
	}
}