package com.tencent.morefun.naruto.plugin.ui.base.interfaces
{
	public interface IVerticalListGroupData
	{
		function get id():int;
		function set id(value:int):void;
		
		function get open():Boolean;
		function set open(value:Boolean):void;
		
		function get isGroup():Boolean;
		function set isGroup(value:Boolean):void;
		
		function get items():Array;
		function set items(value:Array):void;
		
		function get text():String;
		function set text(value:String):void;
	}
}