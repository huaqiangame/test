package com.tencent.morefun.naruto.plugin.ui 
{
	import com.tencent.morefun.naruto.plugin.ui.core.FrameUI;
	import com.tencent.morefun.naruto.plugin.ui.smiley.Smiley1;

	public class UiAssets 
	{		
		/**
		 * 构造函数
		 * create a [UiAssets] object
		 */
		public function UiAssets() 
		{
			register(com.tencent.morefun.naruto.plugin.ui.core.FrameUI);
			Smiley1;
		}
		
		private function register(cls:Class):void { }
		}

}