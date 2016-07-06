package com.tencent.morefun.naruto.plugin.battle.event
{
	import flash.events.Event;

	public class DeBugViewEvent extends Event
	{
		public static const SAVE_RECO:String = "saveReco";
		public static const REPLAY:String = "replay";
		static public const LOAD_AND_REPLAY:String = "loadAndReplay";
		
		public var recoData:Object;
		public function DeBugViewEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
																
		public function autoSetNull():void
		{

			recoData = null;
		}
	}
}