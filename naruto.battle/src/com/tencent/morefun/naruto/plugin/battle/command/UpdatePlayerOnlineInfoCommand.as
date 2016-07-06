package com.tencent.morefun.naruto.plugin.battle.command
{
	import battle.command.BattleCommand;

	public class UpdatePlayerOnlineInfoCommand extends BattleCommand
	{
		public var teamId:int;
		public var isOnline:Boolean;
		
		public function UpdatePlayerOnlineInfoCommand(isOnline:Boolean = false, teamId:int = 100)
		{
			super();
			
			this.teamId = teamId;
			this.isOnline = isOnline;
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