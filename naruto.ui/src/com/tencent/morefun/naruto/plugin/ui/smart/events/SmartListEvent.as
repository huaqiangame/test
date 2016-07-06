package com.tencent.morefun.naruto.plugin.ui.smart.events
{
	import com.tencent.morefun.naruto.plugin.ui.smart.SmartListItemRenderer;
	import flash.events.Event;

	public class SmartListEvent extends Event
	{
		public static const ITEM_CLICK:String = "itemClick";
		
		public var item:SmartListItemRenderer;
		
		public function SmartListEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		}
}