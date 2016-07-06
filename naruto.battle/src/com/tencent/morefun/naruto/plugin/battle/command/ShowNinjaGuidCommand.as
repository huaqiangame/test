package com.tencent.morefun.naruto.plugin.battle.command
{
	import battle.command.BattleCommand;

	public class ShowNinjaGuidCommand extends BattleCommand
	{
		public var pos:int;
		
		public function ShowNinjaGuidCommand(pos:int)
		{
			super();
			
			this.pos = pos;
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