package com.tencent.morefun.naruto.plugin.battle.command
{
	import battle.command.BattleCommand;

	public class NotifyAutoFightCommand extends BattleCommand
	{
		public var isAutoFight:Boolean;
		
		public function NotifyAutoFightCommand(isAutoFight:Boolean)
		{
			super();
			
			this.isAutoFight = isAutoFight;
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