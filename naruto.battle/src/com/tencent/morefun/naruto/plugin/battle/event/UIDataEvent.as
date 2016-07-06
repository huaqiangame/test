package com.tencent.morefun.naruto.plugin.battle.event
{
	import com.tencent.morefun.naruto.plugin.battle.data.UIPlayerData;
	import flash.events.Event;

	public class UIDataEvent extends Event
	{
		public static const UPDATE_ALL:String = "updateAll";
		public static const BASE_INFO_UPDATE:String = "baseInfoUpdate";
		public static const MAIN_NINJA_UPDATE:String = "mianNinjaUpdate";
		public static const ONLINE_INFO_UPDATE:String = "onlineInfoUpdate";
		
		public static const ADD_NINJA:String = "addNinja";
		public static const REMOVE_NINJA:String = "removeNinja";
		
		public static const ADD_PLAYER:String = "addPlayer";
		public static const REMOVE_PLAYER:String = "removePlayer";
		
		public static const PLAYER_UPDATE:String = "playerUpdate";
		
		public static const UPDATE_SELF:String = "updateSelf";
		
		public var ninjaPos:int;
		public var playerPos:int;
		public var isOurs:Boolean;
		
		public var oldSelf:UIPlayerData;
		public var newSelf:UIPlayerData;
		
		override public function clone():Event
		{
			var evt:UIDataEvent;
			
			evt = new UIDataEvent(type);
			evt.ninjaPos = ninjaPos;
			evt.playerPos = playerPos;
			evt.isOurs = isOurs;
			
			return evt;
		}
		
		public function UIDataEvent(type:String)
		{
			super(type);
		}
		
																
		public function autoSetNull():void
		{

			oldSelf = null;
			newSelf = null;
		}
	}
}