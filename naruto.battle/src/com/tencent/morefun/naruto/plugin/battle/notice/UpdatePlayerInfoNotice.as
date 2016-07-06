package com.tencent.morefun.naruto.plugin.battle.notice
{
	import com.tencent.morefun.naruto.plugin.motion.notice.base.BaseNotice;
	

	public class UpdatePlayerInfoNotice extends BaseNotice
	{
		public var teamId:uint;
		public var teamType:uint;
		public var hp:int;
		public var maxHp:int;
		public var mp:uint;
		public var uin:uint;
		public var roleId:uint;
		public var svrId:uint;
		public var name:String;
		public var contractPetId:uint;
		public var type:int;
		public var offlineFlg:Boolean;
		public var level:int = -1;
		public var battlePower:int = -1;
		public var head:int = -1;
		public var stageNinjaList:Array;
		public var hasMp:Boolean;
		public var isSelf:Boolean;
		
		public function UpdatePlayerInfoNotice()
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