package com.tencent.morefun.naruto.plugin.ui.base.event
{
	import flash.events.Event;

	public class ScrollBarEvent extends Event
	{
		public static const SCROLL_VALUE_CHANGED:String = "scrollValueChanged";
		
		public var oldValue:int;
		public var newValue:int;
		public function ScrollBarEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		}
}