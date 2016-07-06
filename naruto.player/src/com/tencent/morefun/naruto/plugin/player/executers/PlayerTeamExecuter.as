package com.tencent.morefun.naruto.plugin.player.executers
{
	import com.tencent.morefun.framework.apf.core.facade.Facade;
	import com.tencent.morefun.framework.base.PluginEvent;
	import com.tencent.morefun.naruto.model.event.ModelEvent;
	import com.tencent.morefun.naruto.plugin.player.models.PlayerModel;
	
	import base.NarutoExecuter;
	
	import def.ExecuterDef;
	import def.ModelDef;
	import def.PluginDef;
	
	import player.commands.CleanPlayerCommand;
	import player.commands.RequestGetPlayerViewListCommand;
	
	import team.model.TeamModel;
	
	public class PlayerTeamExecuter extends NarutoExecuter
	{
		public function PlayerTeamExecuter()
		{
			super(PluginDef.PLAYER, ExecuterDef.PLAYER_TEAM);
			
			Facade.getInstance().addEventListener(PluginEvent.PLUGIN_REGISTER, pluginCompleteHandler);
		}
		
		private function pluginCompleteHandler(e:PluginEvent):void 
		{
			if(e.pluginInfo.interfaceName == PluginDef.TEAM)
			{
				e.currentTarget.removeEventListener(e.type, arguments.callee);
				
				teamModel.addEventListener(ModelEvent.UPDATE, onTeamModel);
			}
		}
		
		protected function onTeamModel(event:ModelEvent):void
		{
			switch(event.key)
			{
				case TeamModel.KEY_JOIN:
					if(teamModel.destinationId == appData.globelInfo.sceneToId
						|| teamModel.destinationId == appData.globelInfo.sceneId
					)
					{
						new CleanPlayerCommand().call();
						new RequestGetPlayerViewListCommand(true).call();
					}else
					{
						//如果在不同场景，那会在组队的加入队伍的时候请求切换场景，不需要在这里多请求一次玩家视野
					}
					break;
				case TeamModel.KEY_UPDATE:
				case TeamModel.KEY_EXIT:
					new CleanPlayerCommand().call();
					new RequestGetPlayerViewListCommand(true).call();
					break;
			}
		}
		
		private var _playerModel:PlayerModel;
		private function get playerModel():PlayerModel
		{
			this._playerModel = this._playerModel || plugin.retrieveModel(PlayerModel.NAME) as PlayerModel;
			return this._playerModel;
		}
		
		private function get teamModel():TeamModel
		{
			return plugin.retrieveModel(ModelDef.TEAM) as TeamModel;
		}
	}
}