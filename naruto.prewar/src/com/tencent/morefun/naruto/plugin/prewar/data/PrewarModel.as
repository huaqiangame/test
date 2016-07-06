package com.tencent.morefun.naruto.plugin.prewar.data
{
	import com.tencent.morefun.naruto.model.BaseModel;
	import com.tencent.morefun.naruto.model.event.ModelEvent;
	
	import def.ModelDef;
	
	import ninja.model.data.NinjaInfo;
	
	import prewar.def.PrewarModelKeyDef;
	
	import team.model.TeamModel;
	
	import user.data.UserInfo;
	
	public class PrewarModel extends BaseModel
	{
		private var selfInfo:UserInfo;
		private var teamModel:TeamModel;
		
		private var _mp:int;
		private var _prewarPlayers:Vector.<PrewarPlayerInfo> = new Vector.<PrewarPlayerInfo>();
		private var _pkgNinjaInfos:Vector.<NinjaInfo>;
		private var _backgroundURL:String;
		private var _canStandList:Array = [];
		
		private var _majorSpecialSkill:int;
		
		public function PrewarModel()
		{
			super(ModelDef.PREWAR);
		}

		public function get canStandList():Array
		{
			return _canStandList;
		}

		public function set canStandList(value:Array):void
		{
			_canStandList = value;
			
			this.dispModelEvent(ModelEvent.UPDATE, PrewarModelKeyDef.CAN_STAND_LIST_UPDATE, _canStandList);
		}

		public function get backgroundURL():String
		{
			return _backgroundURL;
		}

		public function set backgroundURL(value:String):void
		{
			_backgroundURL = value;
		}

		public function get majorSpecialSkill():int
		{
			return _majorSpecialSkill;
		}

		public function set majorSpecialSkill(value:int):void
		{
			_majorSpecialSkill = value;
		}

		public function get mp():int
		{
			return _mp;
		}

		public function set mp(value:int):void
		{
			_mp = value;
		}

		public function get prewarPlayers():Vector.<PrewarPlayerInfo>
		{
			return _prewarPlayers;
		}

		public function set prewarPlayers(value:Vector.<PrewarPlayerInfo>):void
		{
			_prewarPlayers = value;
		}
		
		public function set pkgNinjaInfos(value:Vector.<NinjaInfo>):void
		{
			_pkgNinjaInfos = value;
		}
		
		public function get pkgNinjaInfos():Vector.<NinjaInfo>
		{
			return _pkgNinjaInfos;
		}

		public function addPrewarPlayer(prewarPlayerInfo:PrewarPlayerInfo):void
		{
			prewarPlayers.push(prewarPlayerInfo);
			
			this.dispModelEvent(ModelEvent.UPDATE, PrewarModelKeyDef.ADD_PREWAR_PLAYER, prewarPlayerInfo);
		}
		
		public function removePrewarPlayer(prewarPlayerInfo:PrewarPlayerInfo):void
		{
			prewarPlayers.splice(prewarPlayers.indexOf(prewarPlayerInfo), 1);
			
			this.dispModelEvent(ModelEvent.UPDATE, PrewarModelKeyDef.REMOVE_PREWAR_PLAYER, prewarPlayerInfo);
		}
		
		public function removeAllPlayer():void
		{
			prewarPlayers.splice(0, prewarPlayers.length);
		}
		
		public function getPrewarPlayeByPos(teamPos:int):PrewarPlayerInfo
		{
			for each(var prewarPlayerInfo:PrewarPlayerInfo in prewarPlayers)
			{
				if(prewarPlayerInfo.teamPos == teamPos)
				{
					return prewarPlayerInfo;
				}
			}
			
			return null;
		}
		
	}
}