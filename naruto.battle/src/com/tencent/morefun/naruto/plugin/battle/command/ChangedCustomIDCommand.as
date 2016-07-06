package com.tencent.morefun.naruto.plugin.battle.command
{
	import battle.command.BattleCommand;

	public class ChangedCustomIDCommand extends BattleCommand
	{
		public var sectionId:int;
		public var customFightId:int;
		public var sceneId:int;
		public var curWave:int;
		public var totalWave:int;
		
		public function ChangedCustomIDCommand(sectionId:int=0, customFightId:int=0, sceneId:int=0, curWave:int=0, totalWave:int=0)
		{
			super();
			
			this.sectionId = sectionId;
			this.customFightId = customFightId;
			this.sceneId = sceneId;
			this.curWave = curWave;
			this.totalWave = totalWave;
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