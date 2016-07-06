package com.tencent.morefun.naruto.plugin.battle.cfg
{
	import com.tencent.morefun.naruto.sound.data.BgMusicInfo;

	public class CustomBattleCfg
	{
		public var id:int;
		public var sectionId:int;
		public var leftHead:int;
		public var rightHead:int;
		public var background:int;
		public var guidType:int;
		public var guidArgs:int;
		public var endTipsModel:int;
		public var endCondition:String;
		public var enableExit:Boolean;
		
		public var music:BgMusicInfo;
		
		public function CustomBattleCfg()
		{
		}
		
		public function setXML(xml:XML):void
		{
			id = xml.@id;
			sectionId = xml.@sectionId;
			leftHead = xml.@leftHead;
			rightHead = xml.@rightHead;
			background = xml.@background;
			guidType = xml.@guidType;
			guidArgs = xml.@guidArgs;
			endTipsModel = xml.@showEndTips;
			endCondition = xml.@endCondition;
			enableExit = String(xml.@enableExit) != "0";
		}
																
		public function autoSetNull():void
		{

			endCondition = null;
			music = null;
		}
	}
}