package com.tencent.morefun.naruto.plugin.battle.view
{
	import battle.command.BattleCommand;

	public class ShowPrewarGuidCommand extends BattleCommand
	{
		public function ShowPrewarGuidCommand()
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