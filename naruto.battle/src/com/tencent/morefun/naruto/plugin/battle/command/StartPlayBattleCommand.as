package com.tencent.morefun.naruto.plugin.battle.command
{
	import battle.command.BattleCommand;

	public class StartPlayBattleCommand extends BattleCommand
	{
		public var isReplay:Boolean;
		public function StartPlayBattleCommand(isReplay:Boolean = false)
		{
			super();
			
			this.isReplay = isReplay;
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