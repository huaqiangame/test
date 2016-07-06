package com.tencent.morefun.naruto.plugin.prewar.event
{
	import flash.events.Event;
	
	public class PrewarPlayerInfoEvent extends Event
	{
		public static const INDEX_UPDATE:String = "indexUpdate";
		public static const STATUS_UPDATE:String = "statusUpdate";
		public static const FORMATION_NINJA_UPDATE:String = "formationNinjaUpdate";
		
		public function PrewarPlayerInfoEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}