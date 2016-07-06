package com.tencent.morefun.naruto.plugin.battle.command
{
	
	import base.NarutoCommand;
	import def.PluginDef;

	public class CancelSkillActionCommand extends NarutoCommand
	{
		public var ninjaPos:Array;
		
		public function CancelSkillActionCommand(ninjaPos:Array=null)
		{
			super();
			
			this.ninjaPos = ninjaPos;
		}
		
		override public function getPluginName():String
		{
			return PluginDef.BATTLE;
		}
																
		override public function autoSetNull():void
		{
			if(super.hasOwnProperty("autoSetNull"))
			{
				super["autoSetNull"]();
			}

			ninjaPos = null;
		}
	}
}