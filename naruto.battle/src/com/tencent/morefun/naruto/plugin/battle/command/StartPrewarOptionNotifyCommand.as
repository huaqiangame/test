package com.tencent.morefun.naruto.plugin.battle.command
{
	import battle.command.BattleCommand;

	public class StartPrewarOptionNotifyCommand extends BattleCommand
	{
		public function StartPrewarOptionNotifyCommand()
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