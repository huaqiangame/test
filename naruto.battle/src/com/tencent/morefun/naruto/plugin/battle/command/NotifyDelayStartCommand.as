package com.tencent.morefun.naruto.plugin.battle.command
{
	import battle.command.BattleCommand;

	public class NotifyDelayStartCommand extends BattleCommand
	{
		private var scriptId:int;
		
		public function NotifyDelayStartCommand(scriptId:int)
		{
			super();
			
			this.scriptId = scriptId;
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