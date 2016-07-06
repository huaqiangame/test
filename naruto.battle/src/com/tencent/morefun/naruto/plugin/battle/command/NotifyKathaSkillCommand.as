package com.tencent.morefun.naruto.plugin.battle.command
{
	
	import battle.command.BattleCommand;

	public class NotifyKathaSkillCommand extends BattleCommand
	{
		public var playerTeamId:int;
		public var mp:int;
		public var ninjaPos:int;
		public var skillId:int;
		public var skillIndex:int;
		public var useSpecialSkill:Boolean;
		public var skillState:Array;
		public var dontDelay:Boolean = false;
		
		public function NotifyKathaSkillCommand()
		{
			super();
		}
																
		override public function autoSetNull():void
		{
			if(super.hasOwnProperty("autoSetNull"))
			{
				super["autoSetNull"]();
			}

			skillState = null;
		}
	}
}