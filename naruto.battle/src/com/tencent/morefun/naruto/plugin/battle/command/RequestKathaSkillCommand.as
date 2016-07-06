package com.tencent.morefun.naruto.plugin.battle.command
{
	import com.tencent.morefun.framework.base.Command;
	
	import def.PluginDef;

	public class RequestKathaSkillCommand extends Command
	{
		public var activePos:uint;
		public var passivePos:uint;
		public var skillIndex:int;
		public var teamPos:int;
		public var kathaChange:int;
		public var skillStates:Array;
		
		/**
		 * 
		 * @param active_pos 攻击者位置
		 * @param passive_pos 受击者位置
		 * 
		 */
		public function RequestKathaSkillCommand(active_pos:uint, passive_pos:uint, skill_index:int)
		{
			super();
			
			this.activePos = active_pos;
			this.passivePos = passive_pos;
			this.skillIndex = skill_index;
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

			skillStates = null;
		}
	}
}