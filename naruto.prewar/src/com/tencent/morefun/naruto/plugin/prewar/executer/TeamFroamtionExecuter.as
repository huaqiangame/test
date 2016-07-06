package com.tencent.morefun.naruto.plugin.prewar.executer
{
	import com.tencent.morefun.naruto.plugin.prewar.data.PrewarModel;
	import com.tencent.morefun.naruto.plugin.prewar.data.PrewarPlayerInfo;
	
	import base.NarutoExecuter;
	
	import def.ExecuterDef;
	import def.ModelDef;
	import def.PluginDef;
	import def.ProtocolCmdDef;
	
	import ninja.executer.NinjaProtoTool;
	import ninja.model.data.FormationInfo;
	
	import server.SocketProtocol;
	
	import serverProto.formation.ProtoOperationFormationNinjaBroadcast;
	import serverProto.formation.ProtoTeamFormationPostionChangeNotify;
	
	import team.data.TeamMemberData;
	import team.def.MemberIndexDef;
	import team.model.TeamModel;
	
	public class TeamFroamtionExecuter extends NarutoExecuter
	{
		private var teamModel:TeamModel;
		private var prewarModel:PrewarModel;
		
		public function TeamFroamtionExecuter()
		{
			super(PluginDef.PREWAR, ExecuterDef.PREWAR_FORMATION);
			
			teamModel = this.plugin.retrieveModel(ModelDef.TEAM) as TeamModel;
			
			gameServer.registerMessage(ProtocolCmdDef.NINJA_OPERATE_FORMATION_BROADCAST, ProtoOperationFormationNinjaBroadcast);
			gameServer.addProtocolListener(ProtocolCmdDef.NINJA_OPERATE_FORMATION_BROADCAST, onOperateFormationBroadcast);
			
			gameServer.registerMessage(ProtocolCmdDef.TEAM_MEMBER_POS_UPDATE_BROADCAST, ProtoTeamFormationPostionChangeNotify);
			gameServer.addProtocolListener(ProtocolCmdDef.TEAM_MEMBER_POS_UPDATE_BROADCAST, onTeamFormationPosUpdateBroadcast);
			
			prewarModel = plugin.retrieveModel(ModelDef.PREWAR) as PrewarModel;
		}
		
		private function onOperateFormationBroadcast(protocol:SocketProtocol):void
		{
			var tmd:TeamMemberData;
			var tmds:Vector.<TeamMemberData>;
			var formationInfo:FormationInfo;
			var response:ProtoOperationFormationNinjaBroadcast;
			var prewarPlayerInfo:PrewarPlayerInfo;
			
			response = protocol.serverMessage as ProtoOperationFormationNinjaBroadcast;
			
			prewarPlayerInfo = prewarModel.getPrewarPlayeByPos(response.formationInfo.teamPos);
			if(prewarPlayerInfo){prewarPlayerInfo.formationInfo = NinjaProtoTool.tool.decodeFormationInfo(response.formationInfo.formation)};
		}
		
		private function onTeamFormationPosUpdateBroadcast(protocol:SocketProtocol):void
		{
			var prewarPlayerInfoA:PrewarPlayerInfo;
			var prewarPlayerInfoB:PrewarPlayerInfo;
			var notify:ProtoTeamFormationPostionChangeNotify;
			
			notify = protocol.serverMessage as ProtoTeamFormationPostionChangeNotify;
			prewarPlayerInfoA = prewarModel.getPrewarPlayeByPos(indexTransformPos(notify.postionA));
			prewarPlayerInfoB = prewarModel.getPrewarPlayeByPos(indexTransformPos(notify.postionB));
			
			if(prewarPlayerInfoA)
			{
				prewarModel.removePrewarPlayer(prewarPlayerInfoA);
			}
			
			if(prewarPlayerInfoB)
			{
				prewarModel.removePrewarPlayer(prewarPlayerInfoB);
			}
			
			if(prewarPlayerInfoA)
			{
				prewarPlayerInfoA.teamPos = indexTransformPos(notify.postionB);
				prewarModel.addPrewarPlayer(prewarPlayerInfoA);
			}
			
			if(prewarPlayerInfoB)
			{
				prewarPlayerInfoB.teamPos = indexTransformPos(notify.postionA);
				prewarModel.addPrewarPlayer(prewarPlayerInfoB);
			}
		}
		
		private function indexTransformPos(index:int):int
		{
			switch(index)
			{
				case MemberIndexDef.CENTER:
					return 0;
					break;
				case MemberIndexDef.BOTTOM:
					return 2;
					break;
				case MemberIndexDef.TOP:
					return 4;
					break;
			}
			
			return 0;
		}
	}
}