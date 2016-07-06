package com.tencent.morefun.naruto.plugin.battle.executer
{
	import com.tencent.morefun.framework.base.Command;
	import com.tencent.morefun.framework.base.CommandEvent;
	import com.tencent.morefun.framework.log.logger;
	import com.tencent.morefun.naruto.plugin.battle.command.HidePerwarCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.NotifyPrewarResToLoadCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.PrewarResCompleteCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.ShowPrewarChooseCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.StartPrewarOptionNotifyCommand;
	import com.tencent.morefun.naruto.plugin.battle.data.UIData;
	import com.tencent.morefun.naruto.plugin.battle.messageConverter.BaseConverter;
	import com.tencent.morefun.naruto.plugin.motion.manager.scene.SceneConfig;
	import com.tencent.morefun.naruto.plugin.motion.manager.scene.data.SceneInfo;
	import utils.PlayerNameUtil;
	
	import avmplus.getQualifiedClassName;
	
	import base.NarutoExecuter;
	
	import battle.command.PrewarReadyAckCommand;
	import battle.util.NinjaBattleProtoExecuter;
	
	import def.ExecuterDef;
	import def.ModelDef;
	import def.PluginDef;
	import def.ProtocolCmdDef;
	
	import ninja.data.TeamForamtionInfo;
	import ninja.model.data.FormationInfo;
	import ninja.model.data.NinjaArrangeInfo;
	import ninja.model.data.NinjaInfo;
	
	import prewar.command.OpenPrewarCommand;
	import prewar.command.PrewarInsertPlayerNoticeCommand;
	import prewar.command.PrewarReadyBroadcastCommand;
	
	import server.SocketProtocol;
	
	import serverProto.fight.ProtoChangeFormationAck;
	import serverProto.fight.ProtoChangeFormationBroadcast;
	import serverProto.fight.ProtoChangeFormationResReadyAck;
	import serverProto.fight.ProtoChangeFormationResponse;
	import serverProto.fight.ProtoInsertPreFightBroadcast;
	import serverProto.fight.ProtoInsertPreFightNotify;
	import serverProto.fight.ProtoIsPreFightAck;
	import serverProto.fight.ProtoIsPreFightNotify;
	import serverProto.fight.ProtoNinja;
	import serverProto.fight.ProtoPlayerTeamPos;
	import serverProto.fight.ProtoPreFightResNotify;
	import serverProto.formationBase.ProtoTeamFormationInfo;
	
	import team.model.TeamModel;
	
	import ui.command.ShowErrorMessageCommand;

	public class PerwarServerExecuter extends NarutoExecuter
	{
		private var ninjaProtoDeco:NinjaBattleProtoExecuter;
		
		public function PerwarServerExecuter()
		{
			super(PluginDef.BATTLE, ExecuterDef.BATTLE_PREWAR_SERVER);
			
			//弹出站前准备选择界面通知
			this.gameServer.registerMessage(ProtocolCmdDef.PREWAR_NOTICE, ProtoIsPreFightNotify);
			this.gameServer.addProtocolListener(ProtocolCmdDef.PREWAR_NOTICE, onPrewarNotice);
			
			//下发战前准备所需资源通知
			this.gameServer.registerMessage(ProtocolCmdDef.PREWAR_FIGHT_RES_NOTICE, ProtoPreFightResNotify);
			this.gameServer.addProtocolListener(ProtocolCmdDef.PREWAR_FIGHT_RES_NOTICE, onPrewarResNotice);
			
			//玩家插入广播
			this.gameServer.registerMessage(ProtocolCmdDef.PREWAR_INSERT_BROADCAST, ProtoInsertPreFightBroadcast);
			this.gameServer.addProtocolListener(ProtocolCmdDef.PREWAR_INSERT_BROADCAST, onPrewarInsertBroadcast);
			
			//通知插入玩家加载资源
			this.gameServer.registerMessage(ProtocolCmdDef.PREWAR_INSERT_RES_NOTICE, ProtoInsertPreFightNotify);
			this.gameServer.addProtocolListener(ProtocolCmdDef.PREWAR_INSERT_RES_NOTICE, onInsertPrewarResNotice);
			
			//玩家准备通知
			this.gameServer.registerMessage(ProtocolCmdDef.PREWAR_READY_BROADCAST, ProtoChangeFormationBroadcast);
			this.gameServer.addProtocolListener(ProtocolCmdDef.PREWAR_READY_BROADCAST, onPrewarReadyBrocast);
			
			//玩家准备应答
			this.gameServer.addProtocolListener(ProtocolCmdDef.PREWAR_READY_ACK, onPrewarReadyAckResult);
			
			this.gameServer.registerBusy(ProtocolCmdDef.PREWAR_READY_ACK, true);
			this.gameServer.registerBusy(ProtocolCmdDef.PREWAR_FIGHT_OPTION_ACK, true);
			
			ninjaProtoDeco = new NinjaBattleProtoExecuter();
		}
		
		/**
		 *上报准备完毕 
		 * @param command
		 * 
		 */		
		override public function doCommand(command:Command):void
		{
			switch(getQualifiedClassName(command))
			{
				case getQualifiedClassName(PrewarReadyAckCommand):
					prewarReadyAck(command as PrewarReadyAckCommand);
					break;
				case getQualifiedClassName(PrewarResCompleteCommand):
					onResLoadComplete();
					break;
			}
		}
		
		/**
		 *上报准备完毕 
		 * @param command
		 * 
		 */		
		private function prewarReadyAck(command:PrewarReadyAckCommand):void
		{
			var teamPos:int;
			var request:ProtoChangeFormationAck;
			var response:ProtoChangeFormationResponse;
			
			if(selfInfo.teamId == null)
			{
				teamPos = 0;
			}
			else
			{
				teamPos = indexTransformPos((this.plugin.retrieveModel(ModelDef.TEAM) as TeamModel).getMember(selfInfo.uin, selfInfo.role, selfInfo.svrId).index);
			}
			
			request = new ProtoChangeFormationAck();
			request.teamId = teamPos;
			response = new ProtoChangeFormationResponse();
			this.gameServer.sendMessage(ProtocolCmdDef.PREWAR_READY_ACK, request, response, command);
		}
		
		private function onPrewarReadyAckResult(protocol:SocketProtocol):void
		{
			var uiData:UIData;
			var ninjaList:Array;
			var command:PrewarReadyAckCommand;
			var resLoadCommand:NotifyPrewarResToLoadCommand;
			var response:ProtoChangeFormationResponse;
			
			command = protocol.clientData as PrewarReadyAckCommand;
			if(protocol.error != 0)
			{
				command.faild(Command.SERVER_ERROR);
				new ShowErrorMessageCommand(protocol.errorStr).call();
				return ;
			}
			
			command.finish();
			response = protocol.serverMessage as ProtoChangeFormationResponse;
			resLoadCommand = new NotifyPrewarResToLoadCommand();
			ninjaList = response.playerTeam.stageInfo.ninja;
			
			uiData = UIData.singleton;
			
			resLoadCommand.contractPetId = uiData.customInfo.customFightId;
			resLoadCommand.contractPetInfo = BaseConverter.convertContractPetNinjaInfo(uiData.customInfo.customFightId);
			resLoadCommand.ninjaList = BaseConverter.convertNinjaInfos(response.playerTeam.teamId, response.playerTeam.arenaLevel, ninjaList, PlayerNameUtil.standardlizeName(response.playerTeam.player, response.playerTeam.playerName));
			BaseConverter.settingExeuntStageAction(resLoadCommand.ninjaList, response.playerTeam);
			resLoadCommand.uiData = uiData;
			
			resLoadCommand.call();
		}
		
		/**
		 *上报资源加载完毕 
		 * @param evt
		 * 
		 */		
		private function onResLoadComplete():void
		{
			var command:NotifyPrewarResToLoadCommand;
			var request:ProtoChangeFormationResReadyAck;
			
			request = new ProtoChangeFormationResReadyAck();
			gameServer.sendMessage(ProtocolCmdDef.PREWAR_RES_READY_ACK, request);
		}
		
		private var backgroundURL:String;
		private var showPrewarChooseCommand:ShowPrewarChooseCommand;
		/**
		 *战前准备选择面板通知 
		 * @param protocol
		 * 
		 */		
		private var isControlPlayer:Boolean;
		//资源加载完毕上报后才会下发
		private function onPrewarNotice(protocol:SocketProtocol):void
		{
			var sceneInfo:SceneInfo;
			var response:ProtoIsPreFightNotify;
			var canControl:Boolean;
			
			response = protocol.serverMessage as ProtoIsPreFightNotify;
			
			sceneInfo = SceneConfig.getSceneInfo(response.backgroundRes.backgroundMap);
			backgroundURL = sceneInfo.res;
			
			isControlPlayer = response.playerKey.uin == selfInfo.uin && response.playerKey.svrId == selfInfo.svrId && response.playerKey.roleId == selfInfo.role;
			showPrewarChooseCommand = new ShowPrewarChooseCommand();
			showPrewarChooseCommand.isControl = isControlPlayer;
			showPrewarChooseCommand.enableChoose = response.option == 1;
			showPrewarChooseCommand.enableClick = isControlPlayer;
			showPrewarChooseCommand.addEventListener(CommandEvent.FINISH, onChooseShowPrewar);
			showPrewarChooseCommand.call();
		}
		
		/**
		 *上报战前显示选择结果
		 * @param evt
		 * 
		 */		
		private function onChooseShowPrewar(evt:CommandEvent):void
		{
			var request:ProtoIsPreFightAck;
			
			showPrewarChooseCommand.removeEventListener(CommandEvent.FINISH, onChooseShowPrewar);
			request = new ProtoIsPreFightAck();
			request.option = showPrewarChooseCommand.choose;
			gameServer.sendMessage(ProtocolCmdDef.PREWAR_FIGHT_OPTION_ACK, request, null, null, false);
		}
		
		/**
		 *下发战前准备显示资源 
		 * @param protocol
		 * 
		 */		
		private function onPrewarResNotice(protocol:SocketProtocol):void
		{
			var teamForamtionInfo:TeamForamtionInfo;
			var response:ProtoPreFightResNotify;
			
			var talentPage:int;
			var selfTeamPos:int;
			var npcTeamFormationList:Vector.<TeamForamtionInfo>;
			var playerTeamForamtionList:Vector.<TeamForamtionInfo>;
			var pkgNinjas:Vector.<NinjaInfo> = new Vector.<NinjaInfo>();
			var openPrewarCommand:OpenPrewarCommand;
			
			response = protocol.serverMessage as ProtoPreFightResNotify;
			
			if(selfInfo.teamId != null && !selfInfo.isCaptain)
			{
				logger.output("[prewarDebugTrace]", "HidePerwarCommand");
				new HidePerwarCommand().call();
			}
			
			new StartPrewarOptionNotifyCommand().call();
			logger.output("[prewarDebugTrace]", "StartPrewarOptionNotifyCommand");
			
			talentPage = response.currentTalentPage;
			selfTeamPos = response.teamPos;
			
			logger.output("[prewarDebugTrace]", "decoPlayerTeamPos");
			npcTeamFormationList = decoPlayerTeamPos(response.npcTeam);
			playerTeamForamtionList = new Vector.<TeamForamtionInfo>();
			for each(var protoformationInfo:ProtoTeamFormationInfo in response.playerTeam)
			{
				logger.output("[prewarDebugTrace]", "protoformationInfo", protoformationInfo.teamPos);
				teamForamtionInfo = new TeamForamtionInfo();
				teamForamtionInfo.teamPos = protoformationInfo.teamPos;
				logger.output("[prewarDebugTrace]", "getFormationInfo");
				teamForamtionInfo.formationInfo = ninjaProtoDeco.getFormationInfo(protoformationInfo.formation);
				if(teamForamtionInfo.teamPos == selfTeamPos)
				{
					logger.output("[prewarDebugTrace]", "getPkgNinjas");
					teamForamtionInfo.formationInfo.maxFormationNum = protoformationInfo.formation.formationNinjaUlimit;
					pkgNinjas = ninjaProtoDeco.getPkgNinjas(response.ninjaPackage.ninjaInfo, teamForamtionInfo.formationInfo);
				}
				playerTeamForamtionList.push(teamForamtionInfo);
			}
			
			logger.output("[prewarDebugTrace]", "OpenPrewarCommand");
			new OpenPrewarCommand(UIData.singleton.self.mp, backgroundURL, talentPage, selfTeamPos, [], pkgNinjas, npcTeamFormationList, playerTeamForamtionList, isControlPlayer, 0, response.canStandPos).call();
		}
		
		/**
		 * PlayerTeamPos 转化成 TeamForamtionInfo
		 * @param list
		 * @return 
		 * 
		 */		
		private function decoPlayerTeamPos(list:Array):Vector.<TeamForamtionInfo>
		{
			var result:Vector.<TeamForamtionInfo>;
			var teamForamtionInfo:TeamForamtionInfo;
			var formationInfo:FormationInfo;
			
			result = new Vector.<TeamForamtionInfo>();
			for each(var protoPlayerTeamPos:ProtoPlayerTeamPos in list)
			{
				logger.output("[prewarDebugTrace]", "protoPlayerTeamPos", protoPlayerTeamPos.teamId);
				
				formationInfo = new FormationInfo();
				teamForamtionInfo = new TeamForamtionInfo();
				teamForamtionInfo.teamPos = protoPlayerTeamPos.teamId;
				formationInfo.arranges = getNinjaArrange(protoPlayerTeamPos.stageInfo.ninja);
				teamForamtionInfo.formationInfo = formationInfo;
				result.push(teamForamtionInfo);
			}
			
			return result;
		}
		
		/**
		 * ProtoNinja 转化成 NinjaArrangeInfo
		 * @param list
		 * @return 
		 * 
		 */		
		private function getNinjaArrange(list:Array):Vector.<NinjaArrangeInfo>
		{
			var result:Vector.<NinjaArrangeInfo>;
			var ninjaArrangeInfo:NinjaArrangeInfo;
			
			result = new Vector.<NinjaArrangeInfo>();
			for each(var protoNinja:ProtoNinja in list)
			{
				ninjaArrangeInfo = new NinjaArrangeInfo();
				ninjaArrangeInfo.ninjaId = protoNinja.id;
				ninjaArrangeInfo.location = protoNinja.pos % 100 % 27;
				ninjaArrangeInfo.life = protoNinja.hp;
				ninjaArrangeInfo.lifeMax = protoNinja.maxHp;
				result.push(ninjaArrangeInfo);
			}
			
			return result;
		}
		
		/**
		 * 玩家插入通知
		 * @param protocol
		 * 
		 */		
		private function onPrewarInsertBroadcast(protocol:SocketProtocol):void
		{
			var insertPrewarPlayerCommand:PrewarInsertPlayerNoticeCommand;
			var teamFormationInfo:TeamForamtionInfo;
			var response:ProtoInsertPreFightBroadcast;
			
			response = protocol.serverMessage as ProtoInsertPreFightBroadcast;
			
			teamFormationInfo = new TeamForamtionInfo();
			teamFormationInfo.teamPos = response.playerTeam.teamPos;
			teamFormationInfo.formationInfo = ninjaProtoDeco.getFormationInfo(response.playerTeam.formation);
			
			insertPrewarPlayerCommand = new PrewarInsertPlayerNoticeCommand(response.canStandPos, teamFormationInfo);
			insertPrewarPlayerCommand.call();
		}
		
		/**
		 *通知插入玩家加载战前显示资源 
		 * @param protocol
		 * 
		 */		
		private function onInsertPrewarResNotice(protocol:SocketProtocol):void
		{
			var teamForamtionInfo:TeamForamtionInfo;
			var response:ProtoInsertPreFightNotify;
			
			var talentPage:int;
			var selfTeamPos:int;
			var pkgNinjas:Vector.<NinjaInfo>;
			var npcTeamFormationList:Vector.<TeamForamtionInfo>;
			var playerTeamForamtionList:Vector.<TeamForamtionInfo>;
			var openPrewarCommand:OpenPrewarCommand;
			
			response = protocol.serverMessage as ProtoInsertPreFightNotify;
			
			new StartPrewarOptionNotifyCommand().call();
			
			talentPage = response.currentTalentPage;
			selfTeamPos = response.teamPos;
			npcTeamFormationList = decoPlayerTeamPos(response.npcTeam);
			playerTeamForamtionList = new Vector.<TeamForamtionInfo>();
			for each(var protoformationInfo:ProtoTeamFormationInfo in response.playerTeam)
			{
				teamForamtionInfo = new TeamForamtionInfo();
				teamForamtionInfo.teamPos = protoformationInfo.teamPos;
				teamForamtionInfo.formationInfo = ninjaProtoDeco.getFormationInfo(protoformationInfo.formation);
				if(teamForamtionInfo.teamPos == selfTeamPos)
				{
					teamForamtionInfo.formationInfo.maxFormationNum = protoformationInfo.formation.formationNinjaUlimit;
					pkgNinjas = ninjaProtoDeco.getPkgNinjas(response.ninjaPackage.ninjaInfo, teamForamtionInfo.formationInfo);
				}
				playerTeamForamtionList.push(teamForamtionInfo);
			}
			
			new OpenPrewarCommand(UIData.singleton.self.mp, backgroundURL, talentPage, selfTeamPos, response.readyPlayerTeam, pkgNinjas, npcTeamFormationList, playerTeamForamtionList, isControlPlayer, response.elapseTime, response.canStandPos).call();
		}
		
		/**
		 *其他玩家准备通知 
		 * @param protocol
		 * 
		 */		
		private function onPrewarReadyBrocast(protocol:SocketProtocol):void
		{
			var command:PrewarReadyBroadcastCommand;
			var response:ProtoChangeFormationBroadcast;
			
			response = protocol.serverMessage as ProtoChangeFormationBroadcast;
			new PrewarReadyBroadcastCommand(response.teamId).call();
		}
		
		private function indexTransformPos(index:int):int
		{
			switch(index)
			{
				case 0:
					return 0;
					break;
				case 1:
					return 2;
					break;
				case 2:
					return 4;
					break;
			}
			
			return 0;
		}
																
		override public function autoSetNull():void
		{
			if(super.hasOwnProperty("autoSetNull"))
			{
				super["autoSetNull"]();
			}

			ninjaProtoDeco = null;
			backgroundURL = null;
			showPrewarChooseCommand = null;
		}
	}
}