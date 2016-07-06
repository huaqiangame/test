package com.tencent.morefun.naruto.plugin.prewar.command
{
	import base.NarutoCommand;
	
	import def.PluginDef;
	
	public class UpdateSelfSkillInfoCommand extends NarutoCommand
	{
		public var special:int;
		public var normal:int;
		public var skills:Array;
		
		public function UpdateSelfSkillInfoCommand(special:int, normal:int, skills:Array)
		{
			super();
			
			this.normal = normal;
			this.special = special;
			this.skills = skills;
		}
		
		override public function getPluginName():String
		{
			return PluginDef.PREWAR;
		}
	}
}