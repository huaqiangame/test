package com.tencent.morefun.naruto.plugin.battle.command
{
	
	
	import battle.command.BattleCommand;

	public class NotifyRoundSyncCommand extends BattleCommand
	{
		/**
		 * ArrayElementType("com.tencent.morefun.naruto.plugin.motion.manager.buff.data.BuffInfo")
		 * @see BuffInfo
		 */
		[ArrayElementType("com.tencent.morefun.naruto.plugin.motion.manager.buff.data.BuffInfo")]
		public var buffInfos:Array;
		
		public var shieldInfos:Array;
		
		[ArrayElementType("com.tencent.morefun.naruto.plugin.motion.manager.buff.data.StageActionInfo")]
		public var actionList:Array;
		public var teamInfos:Array;
		public var skillStates:Array;
		public var ninjaList:Array;
		public var isFightOver:Boolean;
		public var roundIndex:int;
		public var customEndRound:Boolean;
		
		public function NotifyRoundSyncCommand()
		{
		}
																
		override public function autoSetNull():void
		{
			if(super.hasOwnProperty("autoSetNull"))
			{
				super["autoSetNull"]();
			}

			buffInfos = null;
			shieldInfos = null;
			actionList = null;
			teamInfos = null;
			skillStates = null;
			ninjaList = null;
		}
	}
}