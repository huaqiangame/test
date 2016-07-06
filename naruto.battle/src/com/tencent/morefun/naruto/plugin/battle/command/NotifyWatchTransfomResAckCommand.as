package com.tencent.morefun.naruto.plugin.battle.command
{
	import com.tencent.morefun.naruto.plugin.motion.manager.ninja.data.NinjaInfo;
	
	import battle.command.BattleCommand;

	public class NotifyWatchTransfomResAckCommand extends BattleCommand
	{
		public var sceneId:int;
		public var ninjaList:Array = [];
		public var contractPetInfo:NinjaInfo;
		public var teamId:int;
		
		public function NotifyWatchTransfomResAckCommand()
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