package com.tencent.morefun.naruto.plugin.ui.base
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class BitmapText extends Sprite
	{
		private var _map:Array;
		private var _chars:String = "0123456789+-.";
		private var _bitmapData:BitmapData;
		private var _height:Number;
		private var _width:Number;
		private var _blank:Boolean;
		private var _gap:Number;
		private var _shape:Shape;
		private var _sourceBitmapHeight:int;
		public function BitmapText(bitmapData:BitmapData,width:Number,height:Number,gap:Number,blank:Boolean=false,chars:String="0123456789+-.")
		{
			super();
			mouseChildren = false;
			_shape = new Shape();
			addChild(_shape);
			_bitmapData = bitmapData.clone();
			_width = width;
			_height = height;
			_blank = blank;
			_gap = gap;
			_map = [];
			if(chars)_chars = chars;
			for(var i:uint=0;i<_chars.length;i++)
			{
				var bit:BitmapData = new BitmapData(width,height,true,0);
				bit.copyPixels(_bitmapData,new Rectangle(i*width,0,width,height),new Point(0,0));
				var rect:Rectangle = bit.getColorBoundsRect(0xFF000000,0x00000000,false);
				rect.x = rect.x + i*width;
				_map[_chars.charAt(i)] = rect;
				bit.dispose();
			}
			
			_sourceBitmapHeight = bitmapData.height;
		}
		private var _text:String;
		public function get text():String
		{
			return _text;
		}
		public function set text(value:String):void
		{
			_text = value;
			_draw();
		}
		
		public function get chars():String
		{
			return _chars;
		}
		
		private function _draw():void
		{
			_shape.graphics.clear();
			var x:Number = 0;
			for(var i:uint=0;i<text.length;i++)
			{
				var char:String = text.charAt(i);
				var index:int = _chars.indexOf(char);
				var rect:Rectangle = _map[char];
				if(!_blank)x+=rect.x%_width;
				x += _gap;
				_shape.graphics.beginBitmapFill(_bitmapData,new Matrix(1,0,0,1,x-rect.x,0),false);
				_shape.graphics.drawRect(x,rect.y,rect.width,rect.height);
				x+=rect.width;
				if(!_blank)x = (i+1)*_width + (i+1)*_gap;
			}
			_shape.graphics.endFill();
			
			switch(align)
			{
				case "center":
					_shape.x = -_shape.width/2;
					break;
				case "right":
					_shape.x = -_shape.width;
					break;
				default:
					_shape.x = 0;
					break;
			}
		}
		
		public function get sourceBitmapHeight():int
		{
			return _sourceBitmapHeight;
		}
		
		private var _align:String = "left";
		public function get align():String
		{
			return _align;
		}
		public function set align(value:String):void
		{
			_align = value;
		}
		
		public function destroy():void
		{
			graphics.clear();
			_map = [];
			
			if(_bitmapData)
			{
				_bitmapData.dispose();
				_bitmapData = null;
			}
		}
		public function dispose():void{
			destroy();
		}
		}
}