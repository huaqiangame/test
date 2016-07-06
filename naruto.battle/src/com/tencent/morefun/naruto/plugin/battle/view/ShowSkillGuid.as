package com.tencent.morefun.naruto.plugin.battle.view
{
	import battle.command.BattleCommand;

	public class ShowSkillGuid extends BattleCommand
	{
		public function ShowSkillGuid()
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