package com.tencent.morefun.naruto.plugin.map.views
{
	import flash.display.Shape;
	
	public class Line extends Shape
	{
		private var xs:Array;
		private var ys:Array;
		private var len:int;
		
		public function Line(length:int)
		{
			super();
			xs = [];
			ys = [];
			len = length;
		}
		
		public function add(x:Number,y:Number):void
		{
			xs.push(x);
			ys.push(y);
			
			while(xs.length > len)
			{
				xs.shift();
			}
			while(ys.length > len)
			{
				ys.shift();
			}
			
			update();
		}
		
		private function update():void
		{
			graphics.clear();
			
			graphics.lineStyle(2,0xFF0000);
			
			for(var i:int=0;i<xs.length;i++)
			{
				graphics.moveTo(i,xs[i]);
				graphics.lineTo(i,xs[i]+1);
			}
			graphics.lineStyle(2,0x0000FF);
			for(i=0;i<ys.length;i++)
			{
				graphics.moveTo(i,ys[i]);
				graphics.lineTo(i,ys[i]+1);
			}
		}
		
	}
}