package com.tencent.morefun.naruto.plugin.player.utils
{
	import flash.geom.Point;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	

	public class PlayerUtil
	{
		public function PlayerUtil()
		{
		}
		
		public static function shorten(ps:Array,length:Number):Array
		{
			var len:int = ps.length;
			if(len<2)
			{
				return [];
			}
			
			var bp:Point = ps[len-1];
			for(var i:int=len-2;i>=0;i--)
			{
				var cp:Point = ps[i];
				
				var dist:Number = Point.distance(bp,cp);
				
				if(dist >= length)
				{
					var f:Number = length/dist;
					var endPoint:Point = Point.interpolate(cp,bp,f);
					
					
					var rs:Array = [];
					for(var j:int=0;j<=i;j++)
					{
						rs.push(ps[j]);
					}
					rs.push(endPoint);
					return rs;
					break;
				}
				bp = cp;
				length -= dist;
			}
			return [];
		}
		
		public static var effectMap:Dictionary;
		public static const EFFECT_TYP_HP:String = "hp";
		public static const EFFECT_TYP_MP:String = "mp";
		public static const EFFECT_TYP_PK:String = "pk";
//		public static const EFFECT_TYP_RUN:String = "run";
        public static const EFFECT_TYP_LEVEL_UP:String = "levelUp";
        public static const EFFECT_TYP_STRENGTH:String = "strength";
		
		public static function getEffectAppDomain(type:String):ApplicationDomain
		{
			return effectMap[type] as ApplicationDomain;
		}
	}
}