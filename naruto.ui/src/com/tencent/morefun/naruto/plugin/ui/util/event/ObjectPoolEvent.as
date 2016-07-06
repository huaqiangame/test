package com.tencent.morefun.naruto.plugin.ui.util.event
{
	import flash.events.Event;

	public class ObjectPoolEvent extends Event
	{
		public static const RELEASE:String = "release";
		
		public function ObjectPoolEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		}
}