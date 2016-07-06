package com.tencent.morefun.naruto.plugin.player.managers
{
	import base.ApplicationData;
	
	import com.tencent.morefun.naruto.plugin.player.defs.AssetDef;
	import com.tencent.morefun.naruto.plugin.player.views.PlayerView;
	
	import def.NinjaAssetDef;
	
	import flash.utils.Dictionary;
	
	import majorRole.def.MajorNinjaDef;
	
	import world.SceneConfig;

	public class PlayerViewManager
	{
//		private static const MAX:int = 100;
		private static var _instance:PlayerViewManager;
		public static function get instance():PlayerViewManager
		{
			return _instance||=new PlayerViewManager();
		}
		
		private var dict:Dictionary = new Dictionary();
		public function PlayerViewManager()
		{
		}
		
		public function createPlayerView(ninjaId:uint, showNinjaId:int, fashionNinjaId:int):PlayerView
		{
			var sceneId:int = ApplicationData.singleton.globelInfo.sceneToId || ApplicationData.singleton.globelInfo.sceneId;
			if(showNinjaId==0 || MajorNinjaDef.isMajorNinjaId(showNinjaId) || SceneConfig.isPvpBattleField(sceneId))
			{
				return createPlayerView2(fashionNinjaId || ninjaId);
			}else
			{
				return createPlayerView2(showNinjaId);
			}
		}
		
		private function createPlayerView2(ninjaId:int):PlayerView
		{
			if(NinjaAssetDef.isMajor(ninjaId) == false)
			{
				return new PlayerView(AssetDef.MME_ASSET);
			}
			var list:Vector.<PlayerView> = dict[ninjaId];
			if(list==null)
			{
				dict[ninjaId] = list = new Vector.<PlayerView>;
			}
			var playerView:PlayerView;
			if(list.length>0)
			{
				playerView = list.pop();
				playerView.resurrect();
			}else
			{
				playerView = new PlayerView(AssetDef.MME_ASSET);
			}
			return playerView;
		}
		
		public function disposePlayerView(ninjaId:uint, playerView:PlayerView):void
		{
			if(NinjaAssetDef.isMajor(ninjaId) == false)
			{
				playerView.destroy();
				return;
			}
			playerView.dispose();
			var list:Vector.<PlayerView> = dict[ninjaId];
			if(list==null)
			{
				dict[ninjaId] = list = new Vector.<PlayerView>;
			}
			list.push(playerView);
		}

	}
}