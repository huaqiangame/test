package com.tencent.morefun.naruto.plugin.battle.command
{
	
	import battle.command.BattleCommand;

	public class NinjaExeuntCommand extends BattleCommand
	{
		public var ninjaInfoList:Array;
		
		public function NinjaExeuntCommand(ninjaInfoList:Array)
		{
			super();
			
			this.ninjaInfoList = ninjaInfoList;
		}
																
		override public function autoSetNull():void
		{
			if(super.hasOwnProperty("autoSetNull"))
			{
				super["autoSetNull"]();
			}

			ninjaInfoList = null;
		}
	}
}