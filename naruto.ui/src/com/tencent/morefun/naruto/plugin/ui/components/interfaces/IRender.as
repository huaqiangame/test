package com.tencent.morefun.naruto.plugin.ui.components.interfaces 
{
	
	/**
	 * 列表渲染器基类
	 * @author larryhou
	 */
	public interface IRender
	{
		function get data():Object;
		function set data(value:Object):void;
		function dispose():void;
	}
	
}