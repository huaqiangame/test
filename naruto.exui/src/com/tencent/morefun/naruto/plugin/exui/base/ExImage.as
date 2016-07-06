package com.tencent.morefun.naruto.plugin.exui.base
{
	import flash.display.DisplayObject;
	import flash.display.Loader;

	public class ExImage extends Image
	{
		private var _defaultIcon:DisplayObject;
		
		public function ExImage(width:int = 0, height:int = 0, resizeToFit:Boolean = false , defaultIcon:DisplayObject = null)
		{
			super(width, height, resizeToFit);
			
			_defaultIcon = defaultIcon;
			if (_defaultIcon && this.numChildren == 0)
			{
				addChild(_defaultIcon);
			}
		}
		
		override protected function processImage(image:Loader, url:String):void 
		{
			super.processImage(image, url);
			
			if (_defaultIcon && _defaultIcon.parent)
			{
				if (_content) _defaultIcon.parent.removeChild(_defaultIcon);
			}
		}
		
		override public function load(url:String):void
		{
			if(_defaultIcon && this.numChildren == 0)
			{
				addChild(_defaultIcon);
			}
			
			super.load(url);
		}
	}
}