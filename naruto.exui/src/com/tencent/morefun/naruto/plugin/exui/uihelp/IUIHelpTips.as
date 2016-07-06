package com.tencent.morefun.naruto.plugin.exui.uihelp 
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * 用户界面帮助接口
	 * @author larryhou
	 * create a [IUIHelpTips] interface
	 */
	public interface IUIHelpTips 
	{
		/**
		 * 帮助唯一id
		 */
		function get id():String;
		
		/**
		 * TIPS内容
		 */
		function get view():DisplayObject;
		
		/**
		 * TIPS显示方位
		 * @see com.tencent.morefun.naruto.plugin.exui.uihelp.UIHelpDirection
		 */
		function get direction():uint;
		
		/**
		 * 帮助内容相关的界面元素
		 * @usage 充当坐标空间角色
		 */
		function get relatedObject():DisplayObject;
		
		/**
		 * UI界面的边界大小
		 * @usage 使用relatedObject容器坐标空间
		 */
		function get relatedBounds():Rectangle;
		
		/**
		 * 当前TIPS是否需要显示
		 */
		function get enabled():Boolean;
		
		/**
		 * 是否显示边框
		 */
		function get borderEnabled():Boolean;
		
		/**
		 * 箭头坐标偏移
		 */
		function get offset():Point;
		
		/**
		 * 垃圾回收
		 */
		function dispose():void;
	}
}