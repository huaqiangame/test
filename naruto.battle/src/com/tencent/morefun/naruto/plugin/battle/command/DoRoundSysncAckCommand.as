package com.tencent.morefun.naruto.plugin.battle.command
{
	import battle.command.BattleCommand;

	public class DoRoundSysncAckCommand extends BattleCommand
	{
		public function DoRoundSysncAckCommand()
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