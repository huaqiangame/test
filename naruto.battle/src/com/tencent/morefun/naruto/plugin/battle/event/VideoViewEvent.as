package com.tencent.morefun.naruto.plugin.battle.event
{
	import flash.events.Event;

	public class VideoViewEvent extends Event
	{
		public static const VIDEO_COMPLETE:String = "videoComplete";
		
		public function VideoViewEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
																
		public function autoSetNull():void
		{

		}
	}
}