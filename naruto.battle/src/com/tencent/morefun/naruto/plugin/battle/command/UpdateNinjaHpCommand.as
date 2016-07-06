package com.tencent.morefun.naruto.plugin.battle.command
{
	import battle.command.BattleCommand;

	public class UpdateNinjaHpCommand extends BattleCommand
	{
		public var pos:int;
		public var value:int;
		
		public function UpdateNinjaHpCommand(pos:int, value:int)
		{
			super();
			
			this.pos = pos;
			this.value = value;
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