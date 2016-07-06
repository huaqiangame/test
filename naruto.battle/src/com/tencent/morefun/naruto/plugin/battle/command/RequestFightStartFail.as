package com.tencent.morefun.naruto.plugin.battle.command
{
	import battle.command.BattleCommand;

	public class RequestFightStartFail extends BattleCommand
	{
		public function RequestFightStartFail()
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