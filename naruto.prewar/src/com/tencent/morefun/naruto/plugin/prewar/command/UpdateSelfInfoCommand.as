package com.tencent.morefun.naruto.plugin.prewar.command
{
	import base.NarutoCommand;
	
	import def.PluginDef;
	
	import ninja.model.data.FormationInfo;
	import ninja.model.data.NinjaInfo;

	public class UpdateSelfInfoCommand extends NarutoCommand
	{
		public var formation:FormationInfo;
		public var pkgNinjas:Vector.<NinjaInfo>;
		
		public function UpdateSelfInfoCommand(formation:FormationInfo, pkgNinjas:Vector.<NinjaInfo>)
		{
			this.formation = formation;
			this.pkgNinjas = pkgNinjas;
		}
		
		override public function getPluginName():String
		{
			return PluginDef.PREWAR;
		}
	}
}