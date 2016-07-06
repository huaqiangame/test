package com.tencent.morefun.naruto.plugin.player.executers
{
	import com.tencent.morefun.naruto.base.def.GlobelModelKeyDef;
	import com.tencent.morefun.naruto.model.event.ModelEvent;
	import com.tencent.morefun.naruto.plugin.player.models.PlayerModel;
	import com.tencent.morefun.naruto.plugin.player.views.PlayerView;
	
	import flash.events.Event;
	
	import base.NarutoExecuter;
	
	import def.ExecuterDef;
	import def.ModelDef;
	import def.PluginDef;
	
	import knowledgeTest.model.ScoreRankModel;
	
	import player.datas.PlayerData;
	
	import serverProto.rank.ProtoKnowledgeTestRank;
	
	import world.SceneConfig;
	
	public class PlayerKnowledgeExecuter extends NarutoExecuter
	{
		public function PlayerKnowledgeExecuter()
		{
			super(PluginDef.PLAYER, ExecuterDef.PLAYER_KNOWLEDGE);
			
			appData.globelInfo.addEventListener(ModelEvent.UPDATE, onGlobelInfo);
		}
		
		protected function onGlobelInfo(event:ModelEvent):void
		{
			switch(event.key)
			{
				case GlobelModelKeyDef.SCENE_ID:
					var sceneId:int = appData.globelInfo.sceneToId || appData.globelInfo.sceneId;
					selfInfo.knowledgeScore = 0;
					if(SceneConfig.isKnowledge(sceneId))
					{
						scoreRankModel.addEventListener(ScoreRankModel.RANK_CHANGE_EVENT, onScreRankModel);
						playerModel.addEventListener(Event.ADDED,onAddedPlayer);
						updateScoreRank();
					}else
					{
						scoreRankModel.removeEventListener(ScoreRankModel.RANK_CHANGE_EVENT, onScreRankModel);
						playerModel.removeEventListener(Event.ADDED,onAddedPlayer);
					}
					break;
			}
		}
		
		protected function onAddedPlayer(event:Event):void
		{
			updateScoreRank();
		}
		
		protected function onScreRankModel(event:Event):void
		{
			updateScoreRank();
		}
		
		private function updateScoreRank():void
		{
			selfInfo.knowledgeScore = scoreRankModel.userScore;
			for each(var pv:PlayerView in playerModel.players)
			{
				updateScoreRankPlayer(pv.getData());
			}
		}
		
		private function updateScoreRankPlayer(playerData:PlayerData):void
		{
			for each(var pktr:ProtoKnowledgeTestRank in scoreRankModel.rank)
			{
				if(playerData.equal3(pktr.playerId))
				{
					playerData.knowledgeScore = pktr.score;
					return;
				}
			}
			playerData.knowledgeScore = 0;
		}
		
		private function get scoreRankModel():ScoreRankModel
		{
			return plugin.retrieveModel(ModelDef.KNOWLEDGE_TEST_SCORERANK) as ScoreRankModel;
		}
		
		private function get playerModel():PlayerModel
		{
			return plugin.retrieveModel(PlayerModel.NAME) as PlayerModel;
		}
	}
}