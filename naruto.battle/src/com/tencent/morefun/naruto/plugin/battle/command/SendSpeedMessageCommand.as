package com.tencent.morefun.naruto.plugin.battle.command
{
	import battle.command.BattleCommand;

	public class SendSpeedMessageCommand extends BattleCommand
	{
		public var type:int;	
		public var notify:Boolean;
		public function SendSpeedMessageCommand(type:int, notify:Boolean = true)
		{
			super();
			
			this.type = type;
			this.notify = notify;
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