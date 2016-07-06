package com.tencent.morefun.naruto.plugin.ui.base.interfaces
{
	import flash.events.IEventDispatcher;

	public interface IScrollContent extends IEventDispatcher
	{
		function get minHorScrollValue():int;
		function set minHorScrollValue(value:int):void;
		
		function get maxHorScrollValue():int;
		function set maxHorScrollValue(value:int):void;
		
		function get horPageScrollValue():int;
		function set horPageScrollValue(value:int):void;
		
		function get verticalScrollValue():int;
		function set verticalScrollValue(value:int):void;
		
		function get minVerScrollValue():int;
		function set minVerScrollValue(value:int):void;
		
		function get maxVerScrollValue():int;
		function set maxVerScrollValue(value:int):void;
		
		function get verPageScrollValue():int;
		function set verPageScrollValue(value:int):void;
		
		function get horizontalScrollValue():int;
		function set horizontalScrollValue(value:int):void;
		
		function get width():Number;
		function set width(value:Number):void;
		
		function get height():Number;
		function set height(value:Number):void;
		
		function updateNow():void;
		function destroy():void;
	}
}