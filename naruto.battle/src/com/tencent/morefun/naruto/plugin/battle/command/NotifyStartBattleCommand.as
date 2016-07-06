package com.tencent.morefun.naruto.plugin.battle.command
{

	
	import com.tencent.morefun.naruto.plugin.battle.data.CustomInfo;
	import com.tencent.morefun.naruto.plugin.battle.data.UIData;
	import com.tencent.morefun.naruto.plugin.motion.data.ScriptActionInfo;
	import com.tencent.morefun.naruto.plugin.motion.manager.ninja.data.NinjaInfo;
	
	import battle.command.BattleCommand;

	public class NotifyStartBattleCommand extends BattleCommand
	{
		public var custom:CustomInfo;
		public var isInsert:Boolean;
		public var uiData:UIData;
		public var scriptInfo:ScriptActionInfo;
		public var ninjaList:Array;
		public var contractPetId:int;
		public var contractPetInfo:NinjaInfo;
		public var needShowFightTips:Boolean;
		public var fightType:int;
		public var subFightType:int;
		public var teamId:int;
		public var beginRoundIndex:int;
		
		public function NotifyStartBattleCommand()
		{
			super();
		}
																
		override public function autoSetNull():void
		{
			if(super.hasOwnProperty("autoSetNull"))
			{
				super["autoSetNull"]();
			}

			custom = null;
			uiData = null;
			scriptInfo = null;
			ninjaList = null;
			contractPetInfo = null;
		}
	}
}