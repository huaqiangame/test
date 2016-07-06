package com.tencent.morefun.naruto.plugin.battle.command
{
	
	
	import battle.command.BattleCommand;

	public class NotifyTinyRoundsCommand extends BattleCommand
	{
		public var actions:Array;
		public var notice:Array;
		public var isFightOver:Boolean;
		public var roundId:int;
		
		public function NotifyTinyRoundsCommand()
		{
			super();
		}
																
		override public function autoSetNull():void
		{
			if(super.hasOwnProperty("autoSetNull"))
			{
				super["autoSetNull"]();
			}

			actions = null;
		}
	}
}