package com.tencent.morefun.naruto.plugin.prewar.view.formation
{
	import com.tencent.morefun.naruto.plugin.prewar.data.PrewarModel;
	import com.tencent.morefun.naruto.plugin.prewar.data.PrewarPlayerInfo;
	import com.tencent.morefun.naruto.plugin.prewar.def.StatusDef;
	
	import flash.display.MovieClip;
	
	import user.data.UserInfo;

	public class TroopView
	{
		private var _data:PrewarModel;
		
		private var _view:MovieClip;
		private var _ninjaTroopViewList:Vector.<NinjaTroopView> = new Vector.<NinjaTroopView>();
		
		public function TroopView(view:MovieClip, selfInfo:UserInfo)
		{
			super();
			_view = view;
			initUI(selfInfo);
		}
		
		public function initUI(selfInfo:UserInfo):void
		{
			var troopNinjaView:NinjaTroopView;
			
			for(var i:int = 0;i < 6; i++)
			{
				troopNinjaView = new NinjaTroopView(_view["team" + i]);
				troopNinjaView.teamPos = i;
				troopNinjaView.selfUserInfo = selfInfo;
				_ninjaTroopViewList.push(troopNinjaView);
				
				troopNinjaView.data = null;
			}
		}
		
		public function updateReady():void
		{
			var selfPrewarPlayer:PrewarPlayerInfo;
			
			for each(selfPrewarPlayer in data.prewarPlayers)
			{
				if(selfPrewarPlayer.isSelf)
				{
					break;
				}
			}
			
			for each(var troopNinjaView:NinjaTroopView in _ninjaTroopViewList)
			{
				troopNinjaView.isReady = selfPrewarPlayer.status == StatusDef.READY;
			}
		}
		
		public function getMainTroopView():NinjaTroopView
		{
			for each(var troopNinjaView:NinjaTroopView in _ninjaTroopViewList)
			{
				if(troopNinjaView.data && troopNinjaView.data.isSelf)
				{
					return troopNinjaView;
				}
			}
			
			return troopNinjaView;
		}
		
		public function setPrewarPlayer(teamPos:int, prewarPlayerInfo:PrewarPlayerInfo):void
		{
			var troopNinjaView:NinjaTroopView;
			
			troopNinjaView = getTroopNinjaView(teamPos);
			troopNinjaView.data = prewarPlayerInfo;
		}
		
		private function getTroopNinjaView(teamPos:int):NinjaTroopView
		{
			for each(var troopNinjaView:NinjaTroopView in _ninjaTroopViewList)
			{
				if(troopNinjaView.teamPos == teamPos)
				{
					return troopNinjaView;
				}
			}
			
			return null;
		}
		
		public function addMouseEventListener():void
		{
			for each(var troopNinjaView:NinjaTroopView in _ninjaTroopViewList)
			{
				troopNinjaView.addMouseListener();
			}
		}
		
		public function removeMouseEventListener():void
		{
			for each(var troopNinjaView:NinjaTroopView in _ninjaTroopViewList)
			{
				troopNinjaView.removeMouseListener();
			}
		}
		
		public function set data(value:PrewarModel):void
		{
			_data = value;
			
			for each(var troopNinjaView:NinjaTroopView in _ninjaTroopViewList)
			{
				troopNinjaView.data = _data.getPrewarPlayeByPos(troopNinjaView.teamPos);
			}
		}
		
		public function get data():PrewarModel
		{
			return _data;
		}
		
		public function destroy():void
		{
			for each(var troopNinjaView:NinjaTroopView in _ninjaTroopViewList)
			{
				troopNinjaView.destroy();
			}
		}
	}
}