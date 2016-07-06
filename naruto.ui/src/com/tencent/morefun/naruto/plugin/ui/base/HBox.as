package com.tencent.morefun.naruto.plugin.ui.base
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;

	public class HBox extends Sprite
	{
		private var m_horgap:int;
		
		public function HBox()
		{
			
		}
		
		public function set horgap(value:int):void
		{
			if(value == m_horgap)
			{
				return ;
			}
			
			m_horgap = value;
		}
		
		public function get horgap():int
		{
			return m_horgap;	
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
				child.x = i * m_horgap;
			}
		}
		}
}