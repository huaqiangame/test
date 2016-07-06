package com.tencent.morefun.naruto.plugin.player.datas
{
	import flash.geom.Point;
	
	import player.datas.PlayerData;

	public class PlayerGroupData
	{
		public var captain:PlayerData;
		public var members:Vector.<PlayerData> = new Vector.<PlayerData>;
//		public var playerDatas:Vector.<PlayerData>;
		
		public var teamId:String;
		public var pos:Point;
		public var isFighting:Boolean;
		
		public function PlayerGroupData()
		{
		}
		
	}
}