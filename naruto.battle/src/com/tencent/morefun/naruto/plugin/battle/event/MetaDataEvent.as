package com.tencent.morefun.naruto.plugin.battle.event 
{
	import flash.events.Event;

	public class MetaDataEvent extends Event 
	{
		static public const METADATA:String = "metadata";
		
		public var metaType:String;
		public var args:Array;
		public function MetaDataEvent() 
		{ 
			super(METADATA);
		} 
		
																
		public function autoSetNull():void
		{

			metaType = null;
			args = null;
		}
	}
	
}