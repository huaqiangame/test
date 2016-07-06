package com.tencent.morefun.naruto.plugin.ui.base.event
{
	import flash.events.Event;

	public class PageContentEvent extends Event
	{
		public static const PAGE_VALUE_CHANGED:String = "pageValueChanged";
		public static const MAX_PAGE_CHANGED:String = "maxPageChanged";
		
		public var oldValue:int;
		public var newValue:int;
		public function PageContentEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		}
}