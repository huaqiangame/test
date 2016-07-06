package com.tencent.morefun.naruto.plugin.battle.command
{
	import battle.command.BattleCommand;

	public class ShowGuidSkillCommand extends BattleCommand
	{
		public var type:int;
		public var skillIndex:int;
		
		public function ShowGuidSkillCommand(type:int, skillIndex:int)
		{
			super();
			
			this.type = type;
			this.skillIndex = skillIndex;
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