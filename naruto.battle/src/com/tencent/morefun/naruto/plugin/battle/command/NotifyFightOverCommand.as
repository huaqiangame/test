package com.tencent.morefun.naruto.plugin.battle.command
{
	import com.tencent.morefun.naruto.plugin.battle.view.fightOver.damage.DamageInfo;
	
	import battle.command.BattleCommand;

	public class NotifyFightOverCommand extends BattleCommand
	{
		public var isWin:Boolean;
		public var showResult:Boolean;
		public var damageInfo:DamageInfo;
		
		public function NotifyFightOverCommand()
		{
			super();
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