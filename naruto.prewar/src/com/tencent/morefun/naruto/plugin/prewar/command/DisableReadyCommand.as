package com.tencent.morefun.naruto.plugin.prewar.command
{
	import base.NarutoCommand;
	
	import def.PluginDef;
	
	public class DisableReadyCommand extends NarutoCommand
	{
		public function DisableReadyCommand()
		{
			super();
		}
		
		override public function getPluginName():String
		{
			return PluginDef.PREWAR;
		}
	}
}