package com.tencent.morefun.naruto.plugin.prewar.component
{
	import flash.display.BitmapData;
	
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	/**
	 * 位图填充图像
	 * @author larryhou
	 * @createTime 2013/9/11 16:05
	 */
	public class BitmapSprite extends Sprite
	{
		/**
		 * 构造函数
		 * create a [BitmapSprite] object
		 */
		public function BitmapSprite() 
		{
		}
		
		/**
		 * 设置数据
		 * @param	data		填充数据
		 * @param	offsetX		横向偏移
		 * @param	offsetY		竖向偏移
		 */
		public function fill(data:BitmapData, offsetX:int, offsetY:int, repeat:Boolean = false, smoothing:Boolean = true):void
		{
			graphics.clear();
			if (data)
			{
				graphics.beginBitmapFill(data, new Matrix(1, 0, 0, 1, offsetX, offsetY), repeat, smoothing);
				graphics.drawRect(offsetX, offsetY, data.width, data.height);
				graphics.endFill();
			}
		}
		
		/**
		 * 垃圾回收
		 */
		public function dispose():void
		{
			graphics.clear();
		}
		
	}

}