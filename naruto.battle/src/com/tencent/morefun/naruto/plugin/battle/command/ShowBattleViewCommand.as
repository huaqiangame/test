package com.tencent.morefun.naruto.plugin.battle.command
{
	import battle.command.BattleCommand;
	import com.tencent.morefun.naruto.plugin.battle.data.UIData;

	public class ShowBattleViewCommand extends BattleCommand
	{
		public var uiData:UIData;
		
		public function ShowBattleViewCommand(uiData:UIData)
		{
			super();
			this.uiData = uiData;
		}
																
		override public function autoSetNull():void
		{
			if(super.hasOwnProperty("autoSetNull"))
			{
				super["autoSetNull"]();
			}

			uiData = null;
		}
	}
}