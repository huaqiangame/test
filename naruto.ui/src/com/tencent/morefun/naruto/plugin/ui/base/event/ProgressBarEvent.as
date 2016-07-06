package com.tencent.morefun.naruto.plugin.ui.base.event
{
	import flash.events.Event;

	public class ProgressBarEvent extends Event
	{
		public static const PROGRESS_BAR_VALUE_CHANGED:String = "progressBarValueChanged";
		public static const PROGRESS_BAR_PROGRESS_COMPLETE:String = "progressBarProgressComplete";
		
		public var oldValue:int;
		public var newValue:int;
		public function ProgressBarEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		}
}