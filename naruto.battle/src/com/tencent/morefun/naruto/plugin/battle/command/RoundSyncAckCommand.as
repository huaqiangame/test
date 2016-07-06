package com.tencent.morefun.naruto.plugin.battle.command
{
	import com.tencent.morefun.framework.base.Command;
	import def.PluginDef;

	public class RoundSyncAckCommand extends Command
	{
		public var team_id:uint;
		
		/**
		 * 大回合结束时同步的应答
		 * @param team_id
		 * 
		 */
		public function RoundSyncAckCommand(team_id:uint)
		{
			super();
			
			this.team_id = team_id;
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