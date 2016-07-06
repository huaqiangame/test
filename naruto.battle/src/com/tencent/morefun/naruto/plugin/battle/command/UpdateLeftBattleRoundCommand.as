package com.tencent.morefun.naruto.plugin.battle.command
{
	import battle.command.BattleCommand;
	
	public class UpdateLeftBattleRoundCommand extends BattleCommand
	{
		public var round:int;
		public function UpdateLeftBattleRoundCommand(round:int=0)
		{
			super();
			
			this.round = round;
		}
	}
}