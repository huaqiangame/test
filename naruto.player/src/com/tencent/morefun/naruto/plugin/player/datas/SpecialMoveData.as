package com.tencent.morefun.naruto.plugin.player.datas
{
	import flash.geom.Point;

	public class SpecialMoveData
	{
		public static const FLASH:int = 1;
		public static const JUMP:int = 2;
		
		public var type:int;
		public var beginPoint:Point;
		public var endPoint:Point;
		public var doneFun:Function;
		
		public function SpecialMoveData(beginPoint:Point, endPoint:Point, type:int, doneFun:Function=null)
		{
			this.beginPoint = beginPoint;
			this.endPoint = endPoint;
			this.type = type;
			this.doneFun = doneFun;
		}
		
		
		public function destroy():void
		{
			this.beginPoint = null;
			this.endPoint = null;
			this.doneFun = null;
		}
	}
}