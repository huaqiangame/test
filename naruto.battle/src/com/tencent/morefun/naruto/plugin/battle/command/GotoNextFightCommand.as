package com.tencent.morefun.naruto.plugin.battle.command
{
	import battle.command.BattleCommand;

	public class GotoNextFightCommand extends BattleCommand
	{
		public var battleID:uint;
		
		public function GotoNextFightCommand(battleID:uint)
		{
			super();
			
			this.battleID = battleID;
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