package com.tencent.morefun.naruto.plugin.battle.command
{
	
	import battle.command.BattleCommand;

	public class NinjaEnterCommand extends BattleCommand
	{
		public var ninjaInfoList:Array;
		
		public function NinjaEnterCommand(ninjaInfoList:Array)
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