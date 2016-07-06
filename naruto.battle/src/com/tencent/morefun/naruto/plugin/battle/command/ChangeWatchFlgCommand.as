package com.tencent.morefun.naruto.plugin.battle.command
{
	import battle.command.BattleCommand;

	public class ChangeWatchFlgCommand extends BattleCommand
	{
		public var watchFlg:int;
		
		public function ChangeWatchFlgCommand(watchFlg:int)
		{
			super();
			
			this.watchFlg = watchFlg;
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