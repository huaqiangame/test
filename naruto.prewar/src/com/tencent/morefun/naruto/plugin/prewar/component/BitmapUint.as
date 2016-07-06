package com.tencent.morefun.naruto.plugin.prewar.component
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	/**
	 * 位图美术字渲染器
	 * @author larryhou
	 * @createTime 2013/10/1 16:31
	 */
	public class BitmapUint extends Sprite
	{
		private var _value:uint;
		private var _digitClass:Class;
		
		private var _items:Vector.<MovieClip>;
		private var _gap:int;
		
		/**
		 * 构造函数
		 * create a [BitmapUint] object
		 */
		public function BitmapUint(digitViewClass:Class, gap:int = 0) 
		{
			_digitClass = digitViewClass;
			_gap = gap;
			
			_items = new Vector.<MovieClip>();
		}
		
		/**
		 * 渲染数字展示
		 */
		private function render():void
		{
			var list:Vector.<uint> = new Vector.<uint>;
			var num:uint = _value;
			if (num)
			{
				while (num)
				{
					list.unshift(num % 10);
					num = num / 10 >> 0;
				}
			}
			else
			{
				list.push(0);
			}
			
			var item:MovieClip;
			while (_items.length > list.length)
			{
				item = _items.pop();
				item.parent && item.parent.removeChild(item);
			}
			
			while (_items.length < list.length)
			{
				_items.push(addChild(new _digitClass()));
			}
			
			var position:uint = 0;
			for (var i:int = 0; i < _items.length; i++)
			{
				item = _items[i];
				item.x = position;
				item.gotoAndStop(list[i] + 1);
				position += item.width + _gap;
			}
		}
		
		/**
		 * 对应数值
		 */
		public function get value():uint { return _value; }
		public function set value(value:uint):void 
		{
			_value = value; render();
		}
	}

}