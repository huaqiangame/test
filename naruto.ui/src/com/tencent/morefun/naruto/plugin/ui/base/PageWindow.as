package com.tencent.morefun.naruto.plugin.ui.base
{
	import flash.display.Sprite;
	import com.tencent.morefun.naruto.plugin.ui.base.event.NumberStepperEvent;
	import com.tencent.morefun.naruto.plugin.ui.base.event.PageContentEvent;

	public class PageWindow extends Sprite
	{
		private var m_pageConent:PageContent;
		private var m_pageNums:NumberStepper;
		
		/**
		 *传入滚动容器 和 翻页控制组件 在该组件中对其进行逻辑绑定 
		 * @param content 翻页滚动容器
		 * @param pageNums 翻页控制组件
		 * 
		 */		
		public function PageWindow(content:PageContent, pageNums:NumberStepper)
		{
			super();
			
			m_pageNums = pageNums;
			m_pageConent = content;
			
			m_pageConent.enableMouseWeel = false;
			
			addChild(m_pageConent);
			addChild(m_pageNums);
			
			m_pageNums.addEventListener(NumberStepperEvent.NUMBER_STEPPER_VALUE_CHANGED, onNumberPageChanged);
			m_pageConent.addEventListener(PageContentEvent.PAGE_VALUE_CHANGED, onContentPageChaged);
			m_pageConent.addEventListener(PageContentEvent.MAX_PAGE_CHANGED, onContentMaxPageChanged);
		}
		
		/**
		 *销毁函数 用完记得调用 
		 * 
		 */		
		public function destroy():void
		{
			removeChild(m_pageConent);
			removeChild(m_pageNums);
			
			m_pageNums.removeEventListener(NumberStepperEvent.NUMBER_STEPPER_VALUE_CHANGED, onNumberPageChanged);
			m_pageConent.removeEventListener(PageContentEvent.PAGE_VALUE_CHANGED, onContentPageChaged);
			m_pageConent.removeEventListener(PageContentEvent.MAX_PAGE_CHANGED, onContentMaxPageChanged);
		}
		
		/**
		 *翻页容器 
		 * @return 
		 * 
		 */		
		public function get pageConent():PageContent
		{
			return m_pageConent;
		}
		
		public function get pageNumStepper():NumberStepper
		{
			return m_pageNums;
		}
		
		/**
		 *响应翻页控制组件事件 
		 * @param evt
		 * 
		 */		
		private function onNumberPageChanged(evt:NumberStepperEvent):void
		{
			m_pageConent.page = m_pageNums.value;
		}
		
		/**
		 *响应翻页容器事件 
		 * @param evt
		 * 
		 */		
		private function onContentPageChaged(evt:PageContentEvent):void
		{
			m_pageNums.value = m_pageConent.page;
		}
		
		/**
		 *当翻页容器的最大页码增加时，控制组件的可翻页码上限增加 
		 * @param evt
		 * 
		 */		
		private function onContentMaxPageChanged(evt:PageContentEvent):void
		{
			m_pageNums.max = m_pageConent.maxPage;
		}
		}
}