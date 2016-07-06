package com.tencent.morefun.naruto.plugin.player.executers
{
	import com.tencent.morefun.framework.base.CommandEvent;
	
	import flash.geom.Point;
	
	import base.ApplicationData;
	import base.NarutoExecuter;
	
	import def.ExecuterDef;
	import def.ModelDef;
	import def.PluginDef;
	import def.ProtocolCmdDef;
	
	import player.commands.StopSelfMoveCommand;
	
	import pvpBattlefield.command.GetPvpBattlefieldStartInfoCommand;
	
	import server.SocketProtocol;
	
	import serverProto.inc.ProtoLocationInfo;
	import serverProto.player.ProtoPlayerToDoNotify;
	import serverProto.player.ProtoPlayerToDoType;
	
	import team.cmd.ShowTeamSyncCommand;
	import team.model.TeamModel;
	
	import world.SceneConfig;
	import world.command.ChangeSceneCommand;
	import world.data.SceneType;
	import world.def.ChangeSceneReasonDef;
	
    import com.tencent.morefun.naruto.i18n.I18n;
	public class PlayerTodoNotifyExectuer extends NarutoExecuter
	{
		public function PlayerTodoNotifyExectuer()
		{
			super(PluginDef.PLAYER, ExecuterDef.PLAYER_TODO);
			
			this.gameServer.registerMessage(ProtocolCmdDef.PLAYER_TODO_NOTIFY, ProtoPlayerToDoNotify);
			this.gameServer.addProtocolListener(ProtocolCmdDef.PLAYER_TODO_NOTIFY, notifyPlayerTodo);
		}
		
		private function notifyPlayerTodo(protocol:SocketProtocol):void
		{
			var ntf:ProtoPlayerToDoNotify = protocol.serverMessage as ProtoPlayerToDoNotify;
			switch(ntf.type)
			{
				case ProtoPlayerToDoType.PROTO_PLAYER_TO_DO_TYPE_CHANGE_SCENE:
					todoChangeScene(ntf.location);
					break;
			}
		}	
		
		private function todoChangeScene(location:ProtoLocationInfo):void
		{
			if(teamModel.isJoined)
			{
				//如果自己是队长 ，那就要显示组队的同步情况
				if(teamModel.getCaptain().equal(selfInfo.uin,selfInfo.role,selfInfo.svrId))
				{
					new ShowTeamSyncCommand(null,null,null,null).call();
				}else
				{
					throw new Error(I18n.lang("as_player_1451031577_5307"));
					return;
				}
			}
			
			if(SceneConfig.isPvpBattleField(location.scene) && !SceneConfig.isPvpBattleField(ApplicationData.singleton.globelInfo.sceneId))
			{
				var getPvpBattlefieldStartInfoCommand:GetPvpBattlefieldStartInfoCommand;
				getPvpBattlefieldStartInfoCommand = new GetPvpBattlefieldStartInfoCommand();
				getPvpBattlefieldStartInfoCommand.location = location;
				getPvpBattlefieldStartInfoCommand.addEventListener(CommandEvent.FINISH, onPvpBattlefieldCommandFinish);
				getPvpBattlefieldStartInfoCommand.addEventListener(CommandEvent.FAILD, onPvpBattlefieldCommandFinish);
				getPvpBattlefieldStartInfoCommand.call();
			}
			else
			{
				new StopSelfMoveCommand(false, false).call();
				new ChangeSceneCommand(
					location.scene,
					new Point(location.x, location.y),
					location.face,
					ChangeSceneReasonDef.PLAYER_TODO_NOTIFY
				).call();
			}
		}
		
		private function onPvpBattlefieldCommandFinish(evt:CommandEvent):void
		{
			var location:ProtoLocationInfo;
			var getPvpBattlefieldStartInfoCommand:GetPvpBattlefieldStartInfoCommand;
			
			getPvpBattlefieldStartInfoCommand = evt.currentTarget as GetPvpBattlefieldStartInfoCommand;
			getPvpBattlefieldStartInfoCommand.removeEventListener(CommandEvent.FINISH, onPvpBattlefieldCommandFinish);
			getPvpBattlefieldStartInfoCommand.removeEventListener(CommandEvent.FAILD, onPvpBattlefieldCommandFinish);
			location = getPvpBattlefieldStartInfoCommand.location;
			new StopSelfMoveCommand(false, false).call();
			new ChangeSceneCommand(
				location.scene,
				new Point(location.x, location.y),
				location.face,
				ChangeSceneReasonDef.PLAYER_TODO_NOTIFY
			).call();
		}
		
		private function get teamModel():TeamModel
		{
			return plugin.retrieveModel(ModelDef.TEAM) as TeamModel;
		}
		
	}
}