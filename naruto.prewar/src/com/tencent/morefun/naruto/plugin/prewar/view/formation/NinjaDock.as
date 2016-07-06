package com.tencent.morefun.naruto.plugin.prewar.view.formation
{
	import com.tencent.morefun.naruto.plugin.prewar.DockShape;
	import com.tencent.morefun.naruto.plugin.prewar.def.NinjaDockStateDef;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * 忍者基座
	 * @author larryhou
	 * @createTime 2013/9/27 14:46
	 */
	public class NinjaDock
	{
		private static const DOCK_SHAPE:BitmapData = createImageData();
		private static function createImageData():BitmapData
		{
			var source:BitmapData = new DockShape();
			var data:BitmapData = new BitmapData(source.width, source.height, true, 0xFFFFFFFF);
			data.copyChannel(source, source.rect, new Point(), BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);
			return data;
		}
		
		private var _view:MovieClip;
		private var _id:uint;
		
		private var _state:String;
		private var _target:TroopNinja;
		
		/**
		 * 构造函数
		 * create a [NinjaDock] object
		 */
		public function NinjaDock(view:MovieClip, id:uint) 
		{
			_id = id;
			_view = view;
			super();
			
			_view.stop();
			_view.visible = false;
			
			_view.mouseChildren = false;
		}
		
		/**
		 * 创建白色轮廓
		 */
		public function createImage():Bitmap
		{
			var image:Bitmap = new Bitmap(DOCK_SHAPE);
			image.filters = [new GlowFilter(0xFFDA96, 1, 3, 3, 4)];
			return image;
		}
		
		/**
		 * 效果重置
		 */
		public function reset():void
		{
			this.target = null;
			this.state = NinjaDockStateDef.NONE;
		}
		
		/**
		 * 基座id
		 */
		public function get id():uint { return _id; }
		
		/**
		 * 忍者基座狀態
		 */
		public function get state():String { return _state; }
		public function set state(value:String):void 
		{
			_state = value; 
			if (!_state || _state == NinjaDockStateDef.NONE)
			{
				if (!_target)
				{
					_view.visible = false;
				}
				else
				{
					_view.visible = true;
					_view.gotoAndStop(NinjaDockStateDef.NORMAL);
				}
			}
			else
			{
				_view.visible = true;
				_view.gotoAndStop(_state);
			}
		}
		
		public function get x():int
		{
			return _view.x;
		}
		
		public function get y():int
		{
			return _view.y;
		}
		
		public function get scaleX():Number
		{
			return _view.scaleX;
		}
		
		public function get scaleY():Number
		{
			return _view.scaleY;
		}
		
		public function getBounds(targetCoordinateSpace:DisplayObject):Rectangle
		{
			return _view.getBounds(targetCoordinateSpace);
		}
		
		/**
		 * 对应忍者对象
		 */
		public function get target():TroopNinja { return _target; }
		public function set target(value:TroopNinja):void 
		{
			_target = value;
		}
	}

}