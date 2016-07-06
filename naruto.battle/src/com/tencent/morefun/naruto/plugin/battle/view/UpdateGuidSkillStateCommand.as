package com.tencent.morefun.naruto.plugin.battle.view
{
	import battle.command.BattleCommand;

	public class UpdateGuidSkillStateCommand extends BattleCommand
	{
		public var skillIdList:Array;
		public var skillEnableList:Array;
		
		public function UpdateGuidSkillStateCommand(skillEnableList:Array, skillIdList:Array)
		{
			super();
			
			this.skillIdList = skillIdList;
			this.skillEnableList = skillEnableList;
		}
																
		override public function autoSetNull():void
		{
			if(super.hasOwnProperty("autoSetNull"))
			{
				super["autoSetNull"]();
			}

			skillEnableList = null;
		}
	}
}