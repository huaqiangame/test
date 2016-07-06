package com.tencent.morefun.naruto.plugin.prewar.command
{
	import base.NarutoCommand;
	
	import def.PluginDef;
	
	import ninja.model.data.FormationInfo;

	public class UpdateSelfFormationCommand extends NarutoCommand
	{
		public var formation:FormationInfo;
		
		public function UpdateSelfFormationCommand(formation:FormationInfo)
		{
			this.formation = formation;
		}
		
		override public function getPluginName():String
		{
			return PluginDef.PREWAR;
		}
	}
}