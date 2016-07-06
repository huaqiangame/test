package com.tencent.morefun.naruto.plugin.exui.loading 
{
	
	/**
	 * loading接口
	 * @author larryhou
	 * create a [ILoadingMask] interface
	 */
	public interface ILoadingMask 
	{
		/**
		 * 背景颜色
		 */
		function get bgColor():uint;
		
		/**
		 * 背景透明度
		 */
		function get bgAlpha():Number;
	}
}