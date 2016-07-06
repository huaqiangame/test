package com.tencent.morefun.naruto.plugin.ui.base.event
{
	import flash.events.Event;

	public class TabBarEvent extends Event
	{
		public static const TAB_SELECTED_INDEX_CHANGED:String = "tabSelectedIndexChanged";
		public static const TAB_CLICKED:String = "tabClicked";
		
		public var selectedIndex:int;
		public function TabBarEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		}
}