package com.tencent.morefun.naruto.plugin.exui.event
{
	import flash.events.Event;

	public class PopupListItemClickedEvent extends Event
	{
		public static const ITEM_CLICKED:String = "itemClicked";
		public var label:String;
		
		public function PopupListItemClickedEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}