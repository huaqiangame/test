package com.tencent.morefun.naruto.plugin.ui.formation  
{

	import flash.display.MovieClip;
	import flash.display.Sprite;

	public class TroopIndicator extends Sprite
	{
		protected var _status:String;
		protected var _view:MovieClip;
		
		protected var _offsetY:uint;
		protected var _offsetX:uint;
		
		protected var _anchorX:Number;
		protected var _anchorY:Number;
		
		/**
		 * 构造函数
		 * create a [TroopIndicator] object
		 */
		public function TroopIndicator(view:MovieClip, offsetX:uint, offsetY:uint) 
		{
			_offsetX = offsetX;
			_offsetY = offsetY;
			
			addChild(_view = view);
			this.mouseChildren = false;
			this.status = IndicatorStatusDef.NORMAL;
		}
		
		/**
		 * 垃圾回收
		 */
		public function dispose():void
		{
			if (_view)
			{
				_view.stop();
				_view.parent && _view.parent.removeChild(_view);
				_view = null;
			}
		}
		
		/**
		 * 设置锚点
		 */
		public function setAnchor(x:Number, y:Number):void
		{
			_anchorX = x;
			_anchorY = y;
		}
		
		/**
		 * 阵法状态
		 */
		public function get status():String { return _status; }
		public function set status(value:String):void 
		{
			_status = value;
			_view && _view.gotoAndStop(_status);
		}
		
		/**
		 * 所在列
		 */
		public function get offsetX():uint { return _offsetX; }
		
		/**
		 * 所在行
		 */
		public function get offsetY():uint { return _offsetY; }
		
		/**
		 * 不动点
		 */
		public function get anchorX():Number { return _anchorX; }
		
		/**
		 * 不动点
		 */
		public function get anchorY():Number { return _anchorY; }
		}

}