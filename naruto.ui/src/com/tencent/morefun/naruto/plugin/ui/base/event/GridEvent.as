package com.tencent.morefun.naruto.plugin.ui.base.event
{
	import com.tencent.morefun.naruto.plugin.ui.base.ItemRenderer;
	import flash.events.Event;

	public class GridEvent extends Event
	{
		public static const ITEM_CLICK:String = "itemClick";
		public static const ITEM_MOUSE_DOWN:String = "itemMouseDown";
		public static const ITEM_MOUSE_UP:String = "itemMouseUp";
		
		public var itemRenderer:ItemRenderer;
		
		override public function clone():Event
		{
			var event:GridEvent;
			
			event = new GridEvent(type, bubbles, cancelable);
			event.itemRenderer = itemRenderer;
			return event;
		}
		
		public function GridEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		}
}