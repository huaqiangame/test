package com.tencent.morefun.naruto.plugin.ui.base
{
	import com.tencent.morefun.naruto.plugin.ui.base.event.ScrollBarEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;

	public class TextArea extends Sprite
	{
		private var m_textFeild:TextField;
		private var m_verScrollBar:ScrollBar;
		private var m_horScrollBar:ScrollBar;
		
		public function TextArea(textFeild:TextField)
		{
			super();
			
			m_textFeild = textFeild;
			m_textFeild.addEventListener(Event.CHANGE, onTextChanged);
			m_textFeild.addEventListener(Event.SCROLL, onTextScrollValueChanged);
			addChild(m_textFeild);
		}
		
		public function set text(value:String):void
		{
			m_textFeild.text = value;
			updateScrollValueByText();
		}
		
		public function get text():String
		{
			return m_textFeild.text;
		}
		
		public function set htmlText(value:String):void
		{
			m_textFeild.htmlText = value;
			updateScrollValueByText();
		}
		
		public function get htmlText():String
		{
			return m_textFeild.htmlText;
		}
		
		public function set verScrollBar(value:ScrollBar):void
		{
			m_verScrollBar = value;
			
			m_verScrollBar.addEventListener(ScrollBarEvent.SCROLL_VALUE_CHANGED, onVerScrollBarValueChanged);
		}
		
		public function get verScrollBar():ScrollBar
		{
			return m_horScrollBar;
		}
		
		public function set horScrollBar(value:ScrollBar):void
		{
			m_horScrollBar = value;
			
			m_horScrollBar.addEventListener(ScrollBarEvent.SCROLL_VALUE_CHANGED, onHorScrollBarValueChanged);
		}
		
		public function get horScrollBar():ScrollBar
		{
			return m_horScrollBar;
		}
		
		private function onTextScrollValueChanged(evt:Event):void
		{
			updateScrollValueByText();
		}
		
		private function onTextChanged(evt:Event):void
		{
			updateScrollValueByText();
		}
		
		private function updateScrollValueByText():void
		{
			if(m_verScrollBar)
			{
				m_verScrollBar.minScrollValue = 1;
				m_verScrollBar.maxScrollValue = m_textFeild.maxScrollV;
				m_verScrollBar.scrollValue = m_textFeild.scrollV;
			}
			
			if(m_horScrollBar)
			{
				m_horScrollBar.maxScrollValue = m_textFeild.maxScrollH;
				m_horScrollBar.scrollValue = m_textFeild.scrollH;
			}
		}
		
		private function onVerScrollBarValueChanged(evt:ScrollBarEvent):void
		{
			m_textFeild.removeEventListener(Event.SCROLL, onTextScrollValueChanged);
			m_textFeild.scrollV = evt.newValue;
			m_textFeild.addEventListener(Event.SCROLL, onTextScrollValueChanged);
		}
		
		private function onHorScrollBarValueChanged(evt:ScrollBarEvent):void
		{
			m_textFeild.removeEventListener(Event.SCROLL, onTextScrollValueChanged);
			m_textFeild.scrollH = evt.newValue;
			m_textFeild.addEventListener(Event.SCROLL, onTextScrollValueChanged);
		}
		
		public function destroy():void
		{
			removeChildren();
			
			if(m_verScrollBar)
			{
				m_verScrollBar.removeEventListener(ScrollBarEvent.SCROLL_VALUE_CHANGED, onVerScrollBarValueChanged);
			}
			
			if(m_horScrollBar)
			{
				m_horScrollBar.removeEventListener(ScrollBarEvent.SCROLL_VALUE_CHANGED, onHorScrollBarValueChanged);
			}
			
			m_textFeild.removeEventListener(Event.CHANGE, onTextChanged);
			m_textFeild.removeEventListener(Event.SCROLL, onTextScrollValueChanged);
		}
		}
}