package com.tencent.morefun.naruto.plugin.ui.base
{
	import com.tencent.morefun.naruto.plugin.ui.base.event.ScrollBarEvent;
	import com.tencent.morefun.naruto.plugin.ui.base.event.ScrollContentEvent;
	import com.tencent.morefun.naruto.plugin.ui.base.interfaces.IScrollContent;
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	public class ScrollWindow extends Sprite
	{
		private var m_scrollContent:IScrollContent;
		private var m_horScrollBar:ScrollBar;
		private var m_verScrollBar:ScrollBar;
		private var m_autoHideScrollBar:Boolean;
		
		/**
		 * 
		 * @param content 滚动容器
		 * @param horScrollBar 横向滚动条
		 * @param verScrollBar 纵向滚动条
		 * @param autoHideScrollBar 是滚动条否常显
		 * 
		 */		
		public function ScrollWindow(content:IScrollContent, horScrollBar:ScrollBar = null, verScrollBar:ScrollBar = null, autoHideScrollBar:Boolean = false)
		{
			super();
			
			m_scrollContent = content;
			m_horScrollBar = horScrollBar;
			m_verScrollBar = verScrollBar;
			m_autoHideScrollBar = autoHideScrollBar;
			
			if(m_horScrollBar != null)
			{
				content.addEventListener(ScrollContentEvent.HOR_PAGE_SCROLL_VALUE_CHANGED, onHorPageScrollValueChanged);
				content.addEventListener(ScrollContentEvent.HOR_SCROLL_VALUE_CHANGED, onHorScrollValueChanged);
				content.addEventListener(ScrollContentEvent.MIN_HOR_SCROLL_VALUE_CHANGED, onMinHorScrollValueChanged);
				content.addEventListener(ScrollContentEvent.MAX_HOR_SCROLL_VALUE_CHANGED, onMaxHorScrollValueChanged);
			}
			if(m_verScrollBar != null)
			{
				content.addEventListener(ScrollContentEvent.VER_PAGE_SCROLL_VALUE_CHANGED, onVerPageScrollValueChanged);
				content.addEventListener(ScrollContentEvent.VER_SCROLL_VALUE_CHANGED, onVerScrollValueChanged);
				content.addEventListener(ScrollContentEvent.MIN_VER_SCROLL_VALUE_CHANGED, onMinVerScrollValueChanged);
				content.addEventListener(ScrollContentEvent.MAX_VER_SCROLL_VALUE_CHANGED, onMaxVerScrollValueChanged);
			}
			addChild(content as DisplayObject);
			
			if(m_horScrollBar)
			{
				if(autoHideScrollBar)
				{
					m_horScrollBar.visible = false;
				}
				
				m_horScrollBar.minScrollValue = content.minHorScrollValue;
				m_horScrollBar.maxScrollValue = content.maxHorScrollValue;
				m_horScrollBar.pageScrollValue = content.horPageScrollValue;
				m_horScrollBar.scrollValue = content.horizontalScrollValue;
				m_horScrollBar.addEventListener(ScrollBarEvent.SCROLL_VALUE_CHANGED, onScrollBarHorScrollValueChanged);
				
				addChild(horScrollBar);
			}
			
			if(m_verScrollBar)
			{
				if(autoHideScrollBar)
				{
					m_verScrollBar.visible = false;
				}
				
				m_verScrollBar.minScrollValue = content.minVerScrollValue;
				m_verScrollBar.maxScrollValue = content.maxVerScrollValue;
				m_verScrollBar.pageScrollValue = content.verPageScrollValue;
				m_verScrollBar.scrollValue = content.verticalScrollValue;
				m_verScrollBar.addEventListener(ScrollBarEvent.SCROLL_VALUE_CHANGED, onScrollBarVerScrollValueChanged);
				
				addChild(m_verScrollBar);
			}
		}
		
		override public function get height():Number
		{
			return m_scrollContent.height;
		}
		
		override public function get width():Number
		{
			return m_scrollContent.width;
		}
		
		public function updateNow():void
		{
			m_scrollContent.updateNow();
			if(m_horScrollBar)
			{
				m_horScrollBar.updateNow();
			}
			if(m_verScrollBar)
			{
				m_verScrollBar.updateNow();
			}
		}
		
		
		override public function set height(value:Number):void
		{
			super.height = value;
		}
		
		/**
		 *销毁函数 用完记得调用 
		 * 
		 */		
		public function destroy():void
		{	
			if(m_horScrollBar)
			{
				m_horScrollBar.removeEventListener(ScrollBarEvent.SCROLL_VALUE_CHANGED, onScrollBarHorScrollValueChanged);
				
				m_horScrollBar.destroy();
			}
			if(m_verScrollBar)
			{
				m_verScrollBar.removeEventListener(ScrollBarEvent.SCROLL_VALUE_CHANGED, onScrollBarVerScrollValueChanged);
				m_verScrollBar.destroy();
			}
			
			if(m_horScrollBar && m_horScrollBar.parent)
			{
				m_horScrollBar.parent.removeChild(m_horScrollBar);
			}
			
			if(m_verScrollBar && m_verScrollBar.parent)
			{
				m_verScrollBar.parent.removeChild(m_verScrollBar);
			}
			
			m_scrollContent.removeEventListener(ScrollContentEvent.HOR_PAGE_SCROLL_VALUE_CHANGED, onHorPageScrollValueChanged);
			m_scrollContent.removeEventListener(ScrollContentEvent.HOR_SCROLL_VALUE_CHANGED, onHorScrollValueChanged);
			m_scrollContent.removeEventListener(ScrollContentEvent.MIN_HOR_SCROLL_VALUE_CHANGED, onMinHorScrollValueChanged);
			m_scrollContent.removeEventListener(ScrollContentEvent.MAX_HOR_SCROLL_VALUE_CHANGED, onMaxHorScrollValueChanged);
			m_scrollContent.removeEventListener(ScrollContentEvent.VER_PAGE_SCROLL_VALUE_CHANGED, onVerPageScrollValueChanged);
			m_scrollContent.removeEventListener(ScrollContentEvent.VER_SCROLL_VALUE_CHANGED, onVerScrollValueChanged);
			m_scrollContent.removeEventListener(ScrollContentEvent.MIN_VER_SCROLL_VALUE_CHANGED, onMinVerScrollValueChanged);
			m_scrollContent.removeEventListener(ScrollContentEvent.MAX_VER_SCROLL_VALUE_CHANGED, onMaxVerScrollValueChanged);
			if(contains(m_scrollContent as DisplayObject)){removeChild(m_scrollContent as DisplayObject);}
			m_scrollContent.destroy();
		}
		
		/**
		 *横向滚动条 
		 * @return 
		 * 
		 */		
		public function get horScrollBar():ScrollBar
		{
			return m_horScrollBar;
		}
		
		/**
		 *纵向滚动条 
		 * @return 
		 * 
		 */		
		public function get verScrollBar():ScrollBar
		{
			return m_verScrollBar;
		}
		
		/**
		 *滚动容器 
		 * @return 
		 * 
		 */		
		public function get scrollContent():IScrollContent
		{
			return m_scrollContent;
		}
		
		/**
		 *横向滚动值改变响应 
		 * @param evt
		 * 
		 */		
		private function onScrollBarHorScrollValueChanged(evt:ScrollBarEvent):void
		{
			m_scrollContent.horizontalScrollValue = evt.newValue;
		}
		
		/**
		 *纵向滚动值改变响应 
		 * @param evt
		 * 
		 */		
		private function onScrollBarVerScrollValueChanged(evt:ScrollBarEvent):void
		{
			m_scrollContent.verticalScrollValue = evt.newValue;
		}
		
		/**
		 *横向每屏所占滚动值该表响应 
		 * @param evt
		 * 
		 */		
		private function onHorPageScrollValueChanged(evt:ScrollContentEvent):void
		{
			m_horScrollBar.pageScrollValue = evt.newValue;
		}
		
		/**
		 *横向滚动值改变响应
		 * @param evt
		 * 
		 */	
		private function onHorScrollValueChanged(evt:ScrollContentEvent):void
		{
			m_horScrollBar.scrollValue = evt.newValue;
		}
		
		/**
		 *横向最小滚动值改变响应 
		 * @param evt
		 * 
		 */		
		private function onMinHorScrollValueChanged(evt:ScrollContentEvent):void
		{
			m_horScrollBar.minScrollValue = evt.newValue;
		}
		
		/**
		 *横向最大滚动值改变响应 
		 * @param evt
		 * 
		 */		
		private function onMaxHorScrollValueChanged(evt:ScrollContentEvent):void
		{
			m_horScrollBar.maxScrollValue = evt.newValue;
			if(m_autoHideScrollBar == true)
			{
				if(m_horScrollBar.maxScrollValue <= 0)
				{
					m_horScrollBar.visible = false;
				}
				else
				{
					m_horScrollBar.visible = true;
				}
			}
		}
		
		/**
		 *纵向每屏所占滚动值该表响应 
		 * @param evt
		 * 
		 */	
		private function onVerPageScrollValueChanged(evt:ScrollContentEvent):void
		{
			m_verScrollBar.pageScrollValue = evt.newValue;
		}
		
		/**
		 *纵向滚动值改变响应
		 * @param evt
		 * 
		 */	
		private function onVerScrollValueChanged(evt:ScrollContentEvent):void
		{
			m_verScrollBar.scrollValue = evt.newValue;
		}
		
		/**
		 *纵向最小滚动值改变响应 
		 * @param evt
		 * 
		 */	
		private function onMinVerScrollValueChanged(evt:ScrollContentEvent):void
		{
			m_verScrollBar.minScrollValue = evt.newValue;
		}
		
		/**
		 *纵向最大滚动值改变响应 
		 * @param evt
		 * 
		 */	
		private function onMaxVerScrollValueChanged(evt:ScrollContentEvent):void
		{
			m_verScrollBar.maxScrollValue = evt.newValue;
			if(m_autoHideScrollBar == true)
			{
				if(m_verScrollBar.maxScrollValue <= 0)
				{
					m_verScrollBar.visible = false;
				}
				else
				{
					m_verScrollBar.visible = true;
				}
			}
		}
		}
}