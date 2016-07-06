package com.tencent.morefun.naruto.plugin.battle.command
{
	
	import battle.command.BattleCommand;

	public class UpdateSkillStateCommand extends BattleCommand
	{
		public var skillStates:Array;
		
		public function UpdateSkillStateCommand(skillStates:Array=null)
		{
			super();
			
			this.skillStates = skillStates;
		}
																
		override public function autoSetNull():void
		{
			if(super.hasOwnProperty("autoSetNull"))
			{
				super["autoSetNull"]();
			}

			skillStates = null;
		}
	}
}