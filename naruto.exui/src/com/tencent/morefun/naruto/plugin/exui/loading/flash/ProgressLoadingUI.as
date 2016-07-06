package com.tencent.morefun.naruto.plugin.exui.loading.flash 
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	/**
	 * 进度条内容
	 * @author larryhou
	 * @createTime 2014/12/31 11:31
	 */
	public class ProgressLoadingUI extends MovieClip
	{
		public var indicator:MovieClip;
		
		public var anchorAnimation:MovieClip;
		public var anchor:MovieClip;
		
		public var percent:TextField;
		public var loadingMask:MovieClip;
		
		public var assetTips:TextField;
		public var errorTips:TextField;
		public var helpTips:MovieClip;
		
		public var detailInfo:TextField;
		public var countdown:TextField;
		
		/**
		 * 构造函数
		 * create a [ProgressLoadingUI] object
		 */
		public function ProgressLoadingUI() 
		{
			
		}
	}

}