package com.tencent.morefun.naruto.plugin.ui.base
{
	import com.tencent.morefun.naruto.plugin.ui.base.def.DirectionDef;
	import com.tencent.morefun.naruto.plugin.ui.base.event.PageContentEvent;
	import flash.display.DisplayObject;
	import flash.events.Event;
	

	public class PageContent extends ScrollContent
	{
		protected var m_page:int;
		protected var m_maxPage:int;
		protected var m_curPage:int;
		
		protected var m_defaultPageScrollValue:int;
		protected var m_direction:String;
		
		private var m_lastMaxVerScrollValue:int;
		private var m_lastMaxHorScrolValue:int;
		
		/**
		 * 翻页滚动容器
		 * @param defaultPageScrollValue 每页的滚动值
		 * @param skin 容器背景
		 * @param enableMouseWeel 是否感应鼠标滑轮事件
		 * @param direction 滚动方向
		 * 
		 */		
		public function PageContent(defaultPageScrollValue:int, skin:DisplayObject, width:Number, height:Number, enableMouseWeel:Boolean=true, direction:String = "vertical")
		{
			super(skin, width, height, enableMouseWeel);
			
			m_direction = direction;
			m_defaultPageScrollValue = defaultPageScrollValue;
		}
		
		/**
		 *最大页码 
		 * @return 
		 * 
		 */		
		public function get maxPage():int
		{
			return m_maxPage;
		}
		
		/**
		 *设置当前页 
		 * @param value
		 * 
		 */		
		public function set page(value:int):void
		{
			if(m_page == value)
			{
				return ;
			}
			if(value > m_maxPage)
			{
				value = m_maxPage;
			}
			if(value < 0)
			{
				value = 0;
			}
			
			m_page = value;
			waitUpdate();
		}
		
		public function get page():int
		{
			return m_page;
		}
		
		/**
		 *每页的滚动值是多少 
		 * @return 
		 * 
		 */		
		public function get defaultPageScrollValue():int
		{
			return m_defaultPageScrollValue;
		}
		
		/**
		 *更新显示内容 
		 * @param evt
		 * 
		 */		
		override protected function update(evt:Event):void
		{
			var tempMaxPageValue:int;
			var event:PageContentEvent;
			var pageScrollValue:int;
			
			super.update(evt);
			
			if(m_page != m_curPage)
			{	
				event = new PageContentEvent(PageContentEvent.PAGE_VALUE_CHANGED);
				event.oldValue = m_curPage;
				event.newValue = m_page;
				
				if(m_direction == DirectionDef.VERTICAL)
				{
					m_verScrollValue = m_page * m_defaultPageScrollValue;
				}
				else
				{
					m_horScrollValue = m_page * m_defaultPageScrollValue;
				}
				m_curPage = m_page;
				
				this.dispatchEvent(event);
			}
			
			
			if(m_direction == DirectionDef.VERTICAL)
			{
				if(m_lastMaxVerScrollValue != m_curMaxVerScrollValue)
				{	
					tempMaxPageValue = Math.max(Math.ceil(maxVerScrollValue / m_defaultPageScrollValue), 0);
					
					event = new PageContentEvent(PageContentEvent.MAX_PAGE_CHANGED);
					event.oldValue = m_maxPage;
					event.newValue = tempMaxPageValue;
					
					m_maxPage = tempMaxPageValue;
					
					this.dispatchEvent(event);
				}
			}
			m_lastMaxVerScrollValue = m_curMaxVerScrollValue;
			
			
			if(m_direction == DirectionDef.HORIZONTAL)
			{
				if(m_lastMaxHorScrolValue != m_curMaxHorScrollValue)
				{
					tempMaxPageValue = Math.max(Math.ceil(maxHorScrollValue / m_defaultPageScrollValue), 0);
					
					event = new PageContentEvent(PageContentEvent.MAX_PAGE_CHANGED);
					event.oldValue = m_maxPage;
					event.newValue = tempMaxPageValue;
					
					m_maxPage = tempMaxPageValue;
					
					this.dispatchEvent(event);
				}
			}
			m_lastMaxHorScrolValue = m_curMaxHorScrollValue;
		}
		}
}