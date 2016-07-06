package com.tencent.morefun.naruto.plugin.ui.base
{

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;

	public class VBox extends Sprite
	{
		private var m_vergap:int = 5;
		
		public function VBox()
		{
			
		}
		
		public function set vergap(value:int):void
		{
			if(value == m_vergap)
			{
				return ;
			}
			
			waitUpdate();
			m_vergap = value;
		}
		
		public function get vergap():int
		{
			return m_vergap;
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			waitUpdate();
			return super.addChild(child);
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			waitUpdate();
			return super.removeChild(child);
		}
		
		public function waitUpdate():void
		{
			this.addEventListener(Event.ENTER_FRAME, update);
		}
		
		public function updateNow():void
		{
			update(new Event(Event.ENTER_FRAME));
		}
		
		public function update(evt:Event):void
		{
			var child:DisplayObject;
			
			for(var i:int = 0;i < this.numChildren;i ++)
			{
				child = this.getChildAt(i);
				child.y = i * m_vergap;
			}
		}
		}
}