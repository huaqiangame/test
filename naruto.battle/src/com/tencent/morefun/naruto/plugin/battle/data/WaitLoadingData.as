package com.tencent.morefun.naruto.plugin.battle.data
{
	import com.tencent.morefun.framework.log.logger;
	
	import serverProto.fight.FightStartType;

	
	
	

    import com.tencent.morefun.naruto.i18n.I18n;
	public class WaitLoadingData
	{
		private static var instance:WaitLoadingData;
		
		private var _waitComplete:Boolean;
		private var waitPlayerInfoList:Array = new Array();
		public function WaitLoadingData()
		{
		}
		
		public static function get singleton():WaitLoadingData
		{
			if(!instance)
			{
				instance = new WaitLoadingData();
			}
			
			return instance;
		}
		
		public function get needShowWait():Boolean
		{
			return waitPlayerInfoList.length > 1;
		}
		
		public function get isComplete():Boolean
		{
			for each(var waitPlayerInfo:WaitPlayerInfo in waitPlayerInfoList)
			{
				if(waitPlayerInfo.complete == false)
				{
					return false;
				}
			}
			
			return true;
		}
		
		public function get waitComplete():Boolean
		{
			return _waitComplete;
		}
		
		public function set waitComplete(value:Boolean):void
		{
			_waitComplete = value;
		}
		
		public function addWaitPlayer(pos:int, name:String, isComplete:Boolean, isSelf:Boolean):void
		{
			logger.output("addWaitPlayer", pos, name, isComplete);
			
			waitPlayerInfoList.push(new WaitPlayerInfo(pos, name, isSelf, isComplete));
		}
		
		public function removeWaitPlayer(pos:int):void
		{
			var waitPlayerInfo:WaitPlayerInfo;
			
			waitPlayerInfo = getWaitPlayerInfo(pos);
			if(waitPlayerInfoList.indexOf(waitPlayerInfo) != -1)
			{
				waitPlayerInfoList.splice(waitPlayerInfoList.indexOf(waitPlayerInfo), 1);
			}
		}
		
		public function addCompletePlayer(pos:int):void
		{
			var waitPlayerInfo:WaitPlayerInfo;
			
			logger.output("addCompletePlayer", pos);
			
			waitPlayerInfo = getWaitPlayerInfo(pos);
			if(waitPlayerInfo)
			{
				waitPlayerInfo.complete = true;
			}
		}
		
		public function finishAllWaitPlayer():void
		{
			for each(var waitPlayerInfo:WaitPlayerInfo in waitPlayerInfoList)
			{
				waitPlayerInfo.complete = true;
			}
		}
		
		private function getWaitPlayerInfo(pos:int):WaitPlayerInfo
		{
			for each(var waitPlayerInfo:WaitPlayerInfo in waitPlayerInfoList)
			{
				if(waitPlayerInfo.pos == pos)
				{
					return waitPlayerInfo;
				}
			}
			
			return null;
		}
		
		public function getWaitText():String
		{
			var waitLoadingText:String = "";
			var thePlayerName:String;
			waitPlayerInfoList.sortOn(["pos"], [Array.NUMERIC]);
			
			for each(var waitPlayerInfo:WaitPlayerInfo in waitPlayerInfoList)
			{
				if(waitPlayerInfo.isSelf)
				{
					continue ;
				}
				
				if(BattleData.singleton.fightType == FightStartType.FIGHT_START_TYPE_PVP_SINGLE_ARENA_INFERIOR || BattleData.singleton.fightType == FightStartType.FIGHT_START_TYPE_BATTLE_ROYALE || BattleData.singleton.fightType == FightStartType.FIGHT_START_TYPE_WAR_WORSHIP)
				{
					thePlayerName = I18n.lang("as_battle_1451031565_272");
				}
				else
				{
					thePlayerName = waitPlayerInfo.name;
				}
				
				if(waitPlayerInfo.complete)
				{
					waitLoadingText += "[" + thePlayerName + I18n.lang("as_battle_1451031565_273");
				}
				else
				{
					waitLoadingText += "[" + thePlayerName + I18n.lang("as_battle_1451031565_274");
				}
			}
			
			return waitLoadingText;
		}
		
		public function dispose():void
		{
			waitPlayerInfoList.splice(0, waitPlayerInfoList.length);
			_waitComplete = false;
		}
																
		public function autoSetNull():void
		{

			instance = null;
			waitPlayerInfoList = null;
		}
	}
}

 class WaitPlayerInfo
 {
	 public var pos:int;
	 public var name:String;
	 public var isSelf:Boolean;
	 public var complete:Boolean;
	 
	 public function WaitPlayerInfo(pos:int, name:String, isSelf:Boolean, complete:Boolean)
	 {
		 this.pos = pos;
		 this.name = name;
		 this.isSelf = isSelf;
		 this.complete = complete;
	 }
 
	public function autoSetNull():void
	{

		name = null;
	}
}
