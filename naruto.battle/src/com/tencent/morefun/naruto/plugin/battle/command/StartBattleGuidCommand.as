package com.tencent.morefun.naruto.plugin.battle.command
{
	import battle.command.BattleCommand;

	public class StartBattleGuidCommand extends BattleCommand
	{
		public function StartBattleGuidCommand()
		{
			super();
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