package com.tencent.morefun.naruto.plugin.ui.base.event
{
	import flash.events.Event;

	public class ScrollContentEvent extends Event
	{
		public static const VER_PAGE_SCROLL_VALUE_CHANGED:String = "verPageScrollValueChanged";
		public static const VER_SCROLL_VALUE_CHANGED:String = "verScrollValueChanged";
		public static const MAX_VER_SCROLL_VALUE_CHANGED:String = "maxVerScrollValueChanged";
		public static const MIN_VER_SCROLL_VALUE_CHANGED:String = "minVerScrollValueChanged";
		public static const HOR_PAGE_SCROLL_VALUE_CHANGED:String = "horPageScrollValueChanged";
		public static const HOR_SCROLL_VALUE_CHANGED:String = "horScrollValueChanged";
		public static const MAX_HOR_SCROLL_VALUE_CHANGED:String = "maxHorScrollValueChanged";
		public static const MIN_HOR_SCROLL_VALUE_CHANGED:String = "minHorScrollValueChanged";
		
		public var oldValue:int
		public var newValue:int;
		public function ScrollContentEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		}
}