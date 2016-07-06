package com.tencent.morefun.naruto.plugin.ui.components 
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
		
		private var _digitWidth:Number;
		private var _length:uint;
		
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
			
			while (list.length < _length) list.unshift(0);
			
			var item:MovieClip;
			while (_items.length > list.length)
			{
				item = _items.pop();
				item.parent && item.parent.removeChild(item);
				item.stop();
			}
			
			while (_items.length < list.length)
			{
				_items.unshift(addChild(new _digitClass()));
				_items[0].stop();
			}
			
			var deltaWidth:Number = _digitWidth? _digitWidth : _items[0].width;
			
			var position:uint = 0;
			for (var i:int = 0; i < _items.length; i++)
			{
				item = _items[i];
				item.x = position + (deltaWidth - item.width) / 2;
				item.gotoAndStop(list[i] + 1);
				position += deltaWidth + _gap;
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
		
		/**
		 * 数字宽度
		 */
		public function get digitWidth():Number { return _digitWidth; }
		public function set digitWidth(value:Number):void 
		{
			_digitWidth = value;
		}
		
		/**
		 * 设定数字固定长度
		 * @usage 不足前面补零
		 */
		public function get length():uint { return _length; }
		public function set length(value:uint):void 
		{
			_length = value;
		}
		
		public function dispose():void
		{
			var tmpItem:MovieClip;
			while (_items.length > 0)
			{
				tmpItem = _items.pop() as MovieClip;
				(tmpItem.parent) && (tmpItem.parent.removeChild(tmpItem));
			}
			
			_items = null;
			tmpItem = null;
			_digitClass = null;
		}
	}

}