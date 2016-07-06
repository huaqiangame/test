package com.tencent.morefun.naruto.plugin.exui.uihelp 
{
	/**
	 * UI帮助显示方位
	 * @usage 可以使用或运算(|)进行组合，比如左上对齐: UIHelpDirection.LEFT | UIHelpDirection.TOP
	 * 
	 * @author larryhou
	 * @createTime 2014/10/29 15:20
	 */
	public class UIHelpDirection 
	{
		/**
		 * 左对齐
		 */
		public static const LEFT		:uint = 2/*1 << 1*/;
		
		/**
		 * 右对齐
		 */
		public static const RIGHT		:uint = 4/*1 << 2*/;
		
		/**
		 * 顶对齐
		 */
		public static const TOP			:uint = 8/*1 << 3*/;
		
		/**
		 * 底对齐
		 */
		public static const BOTTOM		:uint = 16/*1 << 4*/;
	}

}