package com.tencent.morefun.naruto.plugin.battle.command
{
	import battle.command.BattleCommand;

	public class UpdatePlayerInfoCommand extends BattleCommand
	{
		public var teamId:uint;
		public var teamType:uint;//0自己  1玩家  4NPC 5通灵兽
		public var hp:int;
		public var maxHp:int;
		public var mp:uint;
		public var uin:uint;
		public var name:String;
		public var contractPetId:uint;
		public var type:int;
		public var offlineFlg:Boolean;
		public var level:int = -1;
		public var battlePower:int = -1;
		public var head:int = -1;
		public var stageNinjaList:Array;
		public var hasMp:Boolean;
		
		public function UpdatePlayerInfoCommand()
		{
			super();
		}
		
		
																
		override public function autoSetNull():void
		{
			if(super.hasOwnProperty("autoSetNull"))
			{
				super["autoSetNull"]();
			}

			name = null;
			stageNinjaList = null;
		}
	}
}