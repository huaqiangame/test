package com.tencent.morefun.naruto.plugin.battle.command
{
	import com.tencent.morefun.naruto.plugin.battle.data.UIData;
	import com.tencent.morefun.naruto.plugin.motion.manager.ninja.data.NinjaInfo;
	
	import base.NarutoCommand;
	import def.PluginDef;

	public class NotifyPrewarResToLoadCommand extends NarutoCommand
	{
		public var uiData:UIData;
		public var ninjaList:Array;
		public var contractPetId:int;
		public var contractPetInfo:NinjaInfo;
		
		public function NotifyPrewarResToLoadCommand()
		{
			super();
		}
		
		override public function getPluginName():String
		{
			return PluginDef.BATTLE;
		}
																
		override public function autoSetNull():void
		{
			if(super.hasOwnProperty("autoSetNull"))
			{
				super["autoSetNull"]();
			}

			uiData = null;
			ninjaList = null;
			contractPetInfo = null;
		}
	}
}