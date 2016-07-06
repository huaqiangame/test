package com.tencent.morefun.naruto.plugin.player.events
{
	import flash.events.Event;
	import flash.geom.Point;
	
	public class WalkablePlayerEvent extends Event
	{
		public static const MOVE_START:String = "moveStart";
		public static const MOVE_STOP:String = "moveStop";
		public static const MOVE_FINISH:String = "moveFinish";
		public var moveToPixcels:Array;
		
		public static const SPECIAL_MOVE:String = "specialMove";
		public var beginPoint:Point;
		public var endPoint:Point;
		public var specialMoveType:int;
		
		public function WalkablePlayerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}