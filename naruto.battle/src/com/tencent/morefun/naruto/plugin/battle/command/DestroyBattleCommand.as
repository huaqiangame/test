package com.tencent.morefun.naruto.plugin.battle.command
{
	import battle.command.BattleCommand;

	public class DestroyBattleCommand extends BattleCommand
	{
		public var isNotifyEnd:Boolean;
		public function DestroyBattleCommand(isNotifyEnd:Boolean = true)
		{
			super();
			
			this.isNotifyEnd = isNotifyEnd;
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