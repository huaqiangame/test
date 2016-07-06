package com.tencent.morefun.naruto.plugin.exui.base
{
	import com.tencent.morefun.naruto.mmefile.render.MmeAssetRender;
	import flash.display.Loader;

	public class MMEImage extends Image
	{
		public var startFrame:int;
		
		public function MMEImage(width:int = 0, height:int = 0, resizeToFit:Boolean = false)
		{
			super(width, height, resizeToFit);
		}
		
		override protected function processImage(image:Loader, url:String):void 
		{
			if (String(url.split("?").shift().match(/[^\.]+$/)).toLowerCase() == "swf")
			{
				super.processImage(image, url);
			}
			else
			{
				addChild(_content = new MmeAssetRender());
				MmeAssetRender(_content).load(image.contentLoaderInfo.applicationDomain);
				MmeAssetRender(_content).play(MmeAssetRender(_content).getMmeData().actionDatas[0].name, startFrame, true);
			}
		}
		
		/**
		 * 垃圾回收
		 */
		override public function dispose(gc:Boolean = false):void 
		{
			if(_content is MmeAssetRender)
			{
				(_content as MmeAssetRender).unload();
			}
			
			super.dispose(gc);
		}
	}
}