package com.tencent.morefun.naruto.plugin.ui.base
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	public class ScalableBitmap extends Bitmap
	{
		private var _grid:Rectangle;
		
		private var _height:uint;
		private var _width:uint;
		
		private var _scaleX:Number;
		private var _scaleY:Number;
		
		private var _data:BitmapData;
		private var _smoothing:Boolean;
		
		/**
		 * 构造函数
		 * create a [ScalableBitmap] object
		 */
		public function ScalableBitmap(bitmapData:BitmapData = null, snapping:String = "auto", smoothing:Boolean = true)
		{
			_scaleX = _scaleY = 1;
			
			super(null, snapping, _smoothing = smoothing);
			this.bitmapData = bitmapData;
		}
		
		/**
		 * 渲染显示
		 */
		private function render():void
		{
			if (!_data) return;
			if ((_scaleX == 1 && _scaleY == 1) || !_grid)
			{
				super.bitmapData = _data;
				super.smoothing = _smoothing;
				return;
			}
			
			var width:uint = _scaleX * _width + 0.5 >> 0;
			var height:uint = _scaleY * _height + 0.5 >> 0;
			
			var width1:uint = _grid.x + (_width - _grid.right);
			var height1:uint = _grid.y + (_height - _grid.bottom);
			
			var result:BitmapData = new BitmapData(width, height, true, 0);
			var edges:Dictionary = new Dictionary(true);
			
			var scaleX:Number, scaleY:Number;
			edges["scaleX"] = scaleX = width1 > width? (width / width1) : 1;
			edges["scaleY"] = scaleY = height1 > height? (height / height1) : 1
			
			var rect:Rectangle;
			var offsetX:int, offsetY:int;
			
			// top-left
			rect = new Rectangle(0, 0, _grid.x, _grid.y);
			edges["tl"] = copyPixels(result, _data, rect, scaleX, scaleY, 0, 0);
			
			// bottom-left
			rect = new Rectangle(0, _grid.bottom, _grid.x, _height - _grid.bottom);
			edges["bl"] = copyPixels(result, _data, rect, scaleX, scaleY, 0, height - rect.height * scaleY);
			
			// top-right
			rect = new Rectangle(_grid.right, 0, _width - _grid.right, _grid.y);
			edges["tr"] = copyPixels(result, _data, rect, scaleX, scaleY, width - rect.width * scaleX, 0);
			
			// bottom-right
			rect = new Rectangle(_grid.right, _grid.bottom, _width - _grid.right, _height - _grid.bottom);
			edges["br"] = copyPixels(result, _data, rect, scaleX, scaleY, width - rect.width * scaleX, height - rect.height * scaleY);
			
			scaleX = (edges["tr"].x - edges["tl"].right) / _grid.width;
			scaleY = (edges["bl"].y - edges["tl"].bottom) / _grid.height;
			
			// top
			rect = new Rectangle(_grid.x, 0, _grid.width, _grid.y);
			copyPixels(result, _data, rect, scaleX, edges["scaleY"], edges["tl"].right, 0);
			
			// bottom
			rect = new Rectangle(_grid.x, _grid.bottom, _grid.width, _height - _grid.bottom);
			copyPixels(result, _data, rect, scaleX, edges["scaleY"], edges["bl"].right, edges["bl"].top);
			
			// left
			rect = new Rectangle(0, _grid.y, _grid.x, _grid.height);
			copyPixels(result, _data, rect, edges["scaleX"], scaleY, 0, edges["tl"].bottom);
			
			// right
			rect = new Rectangle(_grid.right, _grid.y, _width - _grid.right, _grid.height);
			copyPixels(result, _data, rect, edges["scaleX"], scaleY, edges["tr"].left, edges["tr"].bottom);
			
			// center
			rect = new Rectangle(_grid.x, _grid.y, _grid.width, _grid.height);
			copyPixels(result, _data, rect, scaleX, scaleY, edges["tl"].right, edges["tl"].bottom);
			
			if (super.bitmapData && super.bitmapData != _data)
			{
				super.bitmapData.dispose();
			}
			
			super.bitmapData = result;
			super.smoothing = _smoothing;
		}
		
		/**
		 * 缩放并拷贝像素到目标点
		 */
		private function copyPixels(canvas:BitmapData, source:BitmapData, rect:Rectangle, scaleX:Number, scaleY:Number, offsetX:int, offsetY:int):Rectangle
		{
			var pixels:BitmapData = new BitmapData(rect.width, rect.height, true, 0);
			pixels.copyPixels(source, rect, new Point(0, 0));
			
			var matrix:Matrix = new Matrix();
			matrix.scale(scaleX, scaleY);
			matrix.translate(offsetX, offsetY);
			
			canvas.draw(pixels, matrix, null, null, null, true);
			pixels.dispose();
			
			rect = new Rectangle(offsetX, offsetY, rect.width * scaleX, rect.height * scaleY);
			return rect;
		}
		
		/**
		 * 缩放图片
		 * @usage	仅对九宫格缩放有效：若scale9Grid为空，则该方法无效
		 */
		public function scale(scaleX:Number, scaleY:Number):void
		{
			_scaleX = (!isNaN(scaleX) && scaleX > 0)? scaleX : _scaleX;
			_scaleY = (!isNaN(scaleY) && scaleY > 0)? scaleY : _scaleY;
			
			_grid && render();
		}
		
		/**
		 * 设置宽高
		 * @usage	仅对九宫格缩放有效：若scale9Grid为空，则该方法无效
		 * @usage	调用该方法前需要先设置bitmapData属性
		 */
		public function resize(width:uint, height:uint):void
		{
			scale((_width > 0)? (width / _width) : _scaleX, (_height > 0)? (height / _height) : _scaleY);
		}
		
		/**
		 * 九宫格
		 */
		override public function get scale9Grid():flash.geom.Rectangle { return _grid; }
		override public function set scale9Grid(value:flash.geom.Rectangle):void 
		{
			_grid = value;
			if (_grid)
			{
				if (_grid.height < 0) 
				{
					_grid.height = Math.abs(_grid.height);
					_grid.y -= _grid.height;
				}
				
				if (_grid.width < 0)
				{
					_grid.width = Math.abs(_grid.width);
					_grid.x -= _grid.width;
				}
				
				_grid.x = Math.max(0, _grid.x) >> 0;
				_grid.y = Math.max(0, _grid.y) >> 0;
				_grid.height >>= 0;
				_grid.width >>= 0;
				
				if (!_grid.x || !_grid.y || !_grid.width || !_grid.height || (_width - _grid.right) <= 0 || (_height - _grid.bottom) <= 0)
				{
					_grid = null; return;
				}
				
				render();
			}
		}
		
		/**
		 * 设置位图数据
		 */
		override public function get bitmapData():flash.display.BitmapData { return super.bitmapData; }
		override public function set bitmapData(value:flash.display.BitmapData):void 
		{
			_data = value;
			if (_data)
			{
				_width = _data.width;
				_height = _data.height;
				
				this.scale9Grid = _grid;
				render();
			}
			else
			{
				_width = _height = 0;
				
				super.bitmapData = null;
			}
		}
		
		/**
		 * 记录像素平滑开关
		 */
		override public function get smoothing():Boolean { return _smoothing; }
		override public function set smoothing(value:Boolean):void 
		{
			super.smoothing = _smoothing = value;
		}
		}

}