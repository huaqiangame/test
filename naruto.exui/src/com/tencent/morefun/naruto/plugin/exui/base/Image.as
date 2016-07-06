package com.tencent.morefun.naruto.plugin.exui.base
{

	import com.tencent.morefun.framework.net.LoadManager;
	import com.tencent.morefun.framework.net.def.LoaderDef;
	import flash.display.BitmapData;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import ui.naruto.LoadingUI;

	/**
	 * 图片加载完成时派发
	 */
	[Event(name = "complete", type = "flash.events.Event")]
	
	public class Image extends Sprite
	{
		// static members
		//*************************************************
		public static const _loader:LoadManager = LoadManager.getManager(LoaderDef.IMAGE);
		
		// instance members
		//*************************************************
		protected var _content:DisplayObject;
		protected var _url:String;
		
		protected var _width:int;
		protected var _height:int;
		
		protected var _resizeToFit:Boolean;
		protected var _centerAlign:Boolean;
		
		protected var _enableLoadingMovie:Boolean;
		
		protected var _indicator:LoadingUI;
        protected var _indicatorX:int;
        protected var _indicatorY:int;
		protected var _loading:Boolean;
		
		protected var _autoTrim:Boolean;
		protected var _smoothing:Boolean;
		
		/**
		 * 构造函数
		 * @param	width			图片容器宽度
		 * @param	height			图片容器高度
		 * @param	resizeToFit		图片是否自动缩放适应宽高
		 * @param	centerAlign		加载图片是否居中显示
		 * @param	loadingEnabled	是否显示loading动画
		 * @param	loadingX		loading动画X坐标
		 * @param	loadingY		loading动画Y坐标
		 */
		public function Image(width:int = 0, height:int = 0, resizeToFit:Boolean = false, centerAlign:Boolean = false, enableLoadingMovie:Boolean = false)
		{
			_resizeToFit = resizeToFit;
			_centerAlign = centerAlign;
			_smoothing = true;
			
			_width = width;
			_height = height;
			
			_enableLoadingMovie = enableLoadingMovie;
		}
		
		/**
		 * 重置图片宽高限制
		 */
		public function setImageRect(width:int, height:uint):void
		{
			_width = width;	_height = height;
		}
		
		/**
		 * 移动loading坐标
		 * @param	x	loading动画显示横坐标
		 * @param	y	loading动画显示竖坐标
		 */
		public function moveLoadingMovie(x:Number, y:Number):void
		{
            _indicatorX = x;
            _indicatorY = y;
		}
		
		/**
		 * 加载图片
		 */
		public function load(url:String):void
		{
			if (_url == url || !url) return;
			
			_content && dispose(false);
			_url = url;
			
			if (_enableLoadingMovie)
			{
                if (_indicator == null)
                {
                    _indicator = new LoadingUI();
                    _indicator.x = _indicatorX;
                    _indicator.y = _indicatorY;
                }

                _indicator.gotoAndPlay(2);
				!_indicator.parent && addChild(_indicator);
			}
			
			_loading = true;
			_loader.loadTask(_url, processImage, null);
		}
		
		/**
		 * 显示图片
		 */
		protected function processImage(image:Loader, url:String):void 
		{
			if (url != _url) return;
			
			_loading = false;
			if (!image)
			{
				trace("[image][error]" + url);
				if (_indicator)
				{
					_indicator.parent && _indicator.parent.removeChild(_indicator);
                    _indicator.gotoAndStop(1);
					_indicator = null;
				}
				dispatchEvent(new Event("LoadError"));
				return;
			}
			
			var bitmap:Bitmap = new Bitmap();
			bitmap.bitmapData = (image.contentLoaderInfo.content as Bitmap).bitmapData;
			bitmap.smoothing = _smoothing;
			
			var bounds:Rectangle;
			if (_autoTrim)
			{
				try
				{
					bounds = bitmap.bitmapData.getColorBoundsRect(0xFF000000, 0x000000, false);
				}
				catch (e:Error) 
				{ 
					bounds = null;
				}
			}
			
			if (!bounds || !bounds.width || !bounds.height)
			{
				bounds = bitmap.getBounds(bitmap);
			}
			
			bitmap.scrollRect = bounds;
			addChild(_content = bitmap);
			
			if (_resizeToFit && _width && _height)
			{
				_content.scaleX = _content.scaleY = Math.min(_width / bounds.width, _height / bounds.height);
			}
			
			if (_indicator)
			{
				_indicator.parent && _indicator.parent.removeChild(_indicator);
                _indicator.gotoAndStop(1);
				_indicator = null;
			}
			
			this.centerAlign = _centerAlign;
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 * 垃圾回收
		 */
		public function dispose(gc:Boolean = false):void
		{
			if (_url)
			{
				_loader.killCompleteCallback(_url, processImage);
				_loader.releaseAsset(_url);
				_url = null;
			}
			
			if (_content)
			{
				if (_content is Bitmap)
				{
					(_content as Bitmap).bitmapData = null;
				}
				
				_content.parent && _content.parent.removeChild(_content);
				_content = null;
			}
		}
		
		/**
		 * 是否居中对齐
		 */
		public function get centerAlign():Boolean { return _centerAlign; }
		public function set centerAlign(value:Boolean):void 
		{
			_centerAlign = value;
			if (_content && _centerAlign)
			{
				var bounds:Rectangle = _content.getBounds(_content);
				bounds.height = _content.scrollRect.height;
				bounds.width = _content.scrollRect.width;
				
				_content.x = (_width - bounds.width * _content.scaleX) / 2 - bounds.x * _content.scaleX >> 0;
				_content.y = (_height - bounds.height * _content.scaleY) / 2 - bounds.y * _content.scaleY >> 0;
			}
		}
		
		/**
		 * 图片链接
		 */
		public function get url():String { return _url; }
		
		/**
		 * 是否在加载的时候显示loading动画
		 */
		public function get enableLoadingMovie():Boolean { return _enableLoadingMovie; }
		public function set enableLoadingMovie(value:Boolean):void 
		{
			_enableLoadingMovie = value;
		}
		
		public function get content():DisplayObject
		{
			return this._content;
		}
		
		/**
		 * 自动检测透明边缘
		 */
		public function get autoTrim():Boolean { return _autoTrim; }
		public function set autoTrim(value:Boolean):void 
		{
			_autoTrim = value;
		}
		
		/**
		 * 是否平滑处理图片
		 */
		public function get smoothing():Boolean { return _smoothing; }
		public function set smoothing(value:Boolean):void 
		{
			_smoothing = value;
			if (_content && _content is Bitmap)
			{
				(_content as Bitmap).smoothing = _smoothing;
			}
		}
	}
}