package com.tencent.morefun.naruto.plugin.prewar.command
{
	import base.NarutoCommand;
	
	import def.PluginDef;
	
	import ninja.model.data.NinjaInfo;
	
	public class UpdateSelfNinjaListCommand extends NarutoCommand
	{
		public var pkgNinjas:Vector.<NinjaInfo>;
		
		public function UpdateSelfNinjaListCommand(pkgNinjas:Vector.<NinjaInfo>)
		{
			super();
			
			this.pkgNinjas = pkgNinjas;
		}
		
		override public function getPluginName():String
		{
			return PluginDef.PREWAR;
		}
	}
}