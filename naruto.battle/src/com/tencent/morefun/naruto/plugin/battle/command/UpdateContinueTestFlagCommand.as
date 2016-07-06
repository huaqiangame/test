package com.tencent.morefun.naruto.plugin.battle.command
{
	import battle.command.BattleCommand;

	public class UpdateContinueTestFlagCommand extends BattleCommand
	{
		public var isContinueTest:Boolean;
		
		public function UpdateContinueTestFlagCommand(isContinueTest:Boolean)
		{
			super();
			
			this.isContinueTest = isContinueTest;
		}
																
		override public function autoSetNull():void
		{
			if(super.hasOwnProperty("autoSetNull"))
			{
				super["autoSetNull"]();
			}

		}
	}
}