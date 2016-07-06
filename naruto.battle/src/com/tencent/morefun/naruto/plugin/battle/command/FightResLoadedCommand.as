package com.tencent.morefun.naruto.plugin.battle.command
{
	import com.tencent.morefun.framework.base.Command;
	import def.PluginDef;

	public class FightResLoadedCommand extends Command
	{
		public var isInsert:Boolean;
		public function FightResLoadedCommand(isInsert:Boolean)
		{
			super();
			
			this.isInsert = isInsert;
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

		}
	}
}