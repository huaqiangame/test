package com.tencent.morefun.naruto.plugin.battle.event
{
	import flash.events.Event;

	public class ValueBarEvent extends Event
	{
		public static const UPDATE:String = "update";
		public static const COMPLETE:String = "complete";
		
		public static const COMPOUND_VALUE_BAR_COMPLETE:String = "compoundValueBarComplete";
		public static const COMPOUND_DELAY_VALUE_BAR_COMPLETE:String = "compoundDelayValueBarComplete";
		
		public static const COMPOUND_VALUE_BAR_UPDATE:String = "compoundValueBarUpdate";
		public static const COMPOUND_DELAY_VALUE_BAR_UPDATE:String = "compoundDelayValueBarUpdate";
		
		public function ValueBarEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
																
		public function autoSetNull():void
		{

		}
	}
}