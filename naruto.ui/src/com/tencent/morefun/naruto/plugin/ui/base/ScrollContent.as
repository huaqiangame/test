package com.tencent.morefun.naruto.plugin.ui.base
{
	import com.tencent.morefun.naruto.plugin.ui.base.event.ScrollContentEvent;
	import com.tencent.morefun.naruto.plugin.ui.base.interfaces.IScrollContent;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class ScrollContent extends Sprite implements IScrollContent
	{	
		protected var m_minHorScrollValue:int;
		protected var m_maxHorScrollValue:int;
		protected var m_horScrollValue:int;
		protected var m_horPageScrollValue:int;
		
		protected var m_minVerScrollValue:int;
		protected var m_maxVerScrollValue:int;
		protected var m_verScrollValue:int;
		protected var m_verPageScrollValue:int;
		
		protected var m_curMinHorScrollValue:int;
		protected var m_curMaxHorScrollValue:int;
		protected var m_curHorScollValue:int;
		protected var m_curHorPageScrollValue:int;
		
		protected var m_curMinVerScrollValue:int;
		protected var m_curMaxVerScrollValue:int;
		protected var m_curVerScrollValue:int;
		protected var m_curVerPageScrollValue:int;
		
		protected var m_enableMouseWeel:Boolean;
		protected var m_weelScrollValue:int = 30;
		
		protected var m_width:Number;
		protected var m_height:Number;
		
		protected var m_scrollRect:Rectangle;
		
		protected var m_skin:DisplayObject;
		
		protected var m_updateImmediately:Boolean = true;
		
		/**
		 *传入容器背景皮肤 与 指定是否感应鼠标滚轮事件 
		 * @param skin
		 * @param enableMouseWeel
		 * 
		 */		
		public function ScrollContent(skin:DisplayObject, width:Number, height:Number, enableMouseWeel:Boolean = true)
		{
			super();
			
			m_skin = skin;
			if(m_skin)
			{
				addChild(m_skin);
			}
			
			m_enableMouseWeel = enableMouseWeel;
			if(m_enableMouseWeel)
			{
				addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWeelEvent);
			}
			
			m_scrollRect = new Rectangle();

			this.m_width = width;
			this.m_height = height;
			updateContentScrollRect();
		}
		
		/**
		 *用完记得调用此函数来销毁
		 * 
		 */		
		public function destroy():void
		{
			if(m_skin)
			{
				removeChild(m_skin);
			}
			removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWeelEvent);
		}
		
		public function set updateImmediately(value:Boolean):void
		{
			m_updateImmediately = value;
		}
		
		public function get updateImmediately():Boolean
		{
			return m_updateImmediately;
		}
		
		
		override public function set width(value:Number):void
		{
			m_width = value;
			updateContentScrollRect();
		}
		
		override public function get width():Number
		{
			return m_width;
		}
		
		override public function set height(value:Number):void
		{
			m_height = value;
			updateContentScrollRect();
		}
		
		override public function get height():Number
		{
			return m_height;	
		}
		
		private function onMouseWeelEvent(evt:MouseEvent):void
		{
			verticalScrollValue += (evt.delta > 0)?-m_weelScrollValue:m_weelScrollValue;
		}
		
		/**
		 *设置是否感应鼠标滑轮 
		 * @param value
		 * 
		 */		
		public function set enableMouseWeel(value:Boolean):void
		{
			m_enableMouseWeel = value;
			if(m_enableMouseWeel)
			{
				addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWeelEvent);
			}
			else
			{
				removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWeelEvent)
			}
		}
		
		public function get enableMouseWeel():Boolean
		{
			return m_enableMouseWeel;
		}
		
		/**
		 *设置鼠标滚轮对应的滚动值 
		 * @param value
		 * 
		 */		
		public function set weelScrollValue(value:int):void
		{
			m_weelScrollValue = value;
		}
		
		public function get weelScrollValue():int
		{
			return m_weelScrollValue;
		}
		
		/**
		 *设置最小滚动值 
		 * @param value
		 * 
		 */		
		public function set minHorScrollValue(value:int):void
		{
			if(value == m_minHorScrollValue)
			{
				return ;
			}
			
			m_minHorScrollValue = value;
			waitUpdate();
		}
		
		public function get minHorScrollValue():int
		{
			return m_minHorScrollValue;
		}
		
		/**
		 *设置最大滚动值 
		 * @param value
		 * 
		 */		
		public function set maxHorScrollValue(value:int):void
		{
			if(value == m_maxHorScrollValue)
			{
				return ;
			}
			
			m_maxHorScrollValue = value;
			waitUpdate();
		}
		
		public function get maxHorScrollValue():int
		{
			return m_maxHorScrollValue;
		}
		
		
		/**
		 *设置横向滚动值 
		 * @param value
		 * 
		 */		
		public function set horizontalScrollValue(value:int):void
		{
			if(value < m_minHorScrollValue)
			{
				value = m_minHorScrollValue;
			}
			if(value > m_maxHorScrollValue)
			{
				value = m_maxHorScrollValue;
			}
			
			if(value == m_curHorScollValue)
			{
				return ;
			}
			
			m_horScrollValue = value;
			if(m_updateImmediately)
			{
				this.updateNow();
			}
			else
			{
				this.waitUpdate();
			}
		}
		
		public function get horizontalScrollValue():int
		{
			return m_horScrollValue;
		}
		
		/**
		 * 设置翻页时对应的横向滚动值
		 * @param value
		 * 
		 */		
		public function set horPageScrollValue(value:int):void
		{
			m_horPageScrollValue = value;
			waitUpdate();
		}
		
		public function get horPageScrollValue():int
		{
			return m_horPageScrollValue;	
		}
		
		/**
		 *设置最小竖向滚动值 
		 * @param value
		 * 
		 */		
		public function set minVerScrollValue(value:int):void
		{
			if(value == m_minVerScrollValue)
			{
				return ;
			}
			
			m_minVerScrollValue = value;
			waitUpdate();
		}
		
		public function get minVerScrollValue():int
		{
			return m_minVerScrollValue;
		}
		
		/**
		 *设置最大竖向滚动值 
		 * @param value
		 * 
		 */		
		public function set maxVerScrollValue(value:int):void
		{
			if(value == m_maxVerScrollValue)
			{
				return ;
			}
			
			m_maxVerScrollValue = value;
			waitUpdate();
		}
		
		public function get maxVerScrollValue():int
		{
			return m_maxVerScrollValue;	
		}
		
		/**
		 *设置竖向滚动值 
		 * @param value
		 * 
		 */		
		public function set verticalScrollValue(value:int):void
		{
			if(value < m_minVerScrollValue)
			{
				value = m_minVerScrollValue;
			}
			if(value > m_maxVerScrollValue)
			{
				value = m_maxVerScrollValue;
			}
			
			if(value == m_curVerScrollValue)
			{
				return ;
			}
			
			m_verScrollValue = value;
			if(m_updateImmediately)
			{
				this.updateNow();
			}
			else
			{
				this.waitUpdate();
			}
		}
		
		public function get verticalScrollValue():int
		{
			return m_verScrollValue;
		}
		
		/**
		 * 设置翻页时对应的竖向滚动值
		 * @param value
		 * 
		 */	
		public function set verPageScrollValue(value:int):void
		{
			m_verPageScrollValue = value;
			waitUpdate();
		}
		
		public function get verPageScrollValue():int
		{
			return m_verPageScrollValue;	
		}
		
		/**
		 *在下一帧时更新
		 * 
		 */		
		public function waitUpdate():void
		{
			this.addEventListener(Event.ENTER_FRAME, preUpdate);
		}
		
		public function calculateMaxScrollValue():void
		{
			this.maxHorScrollValue = m_skin.width - this.width;
			this.maxVerScrollValue = m_skin.height - this.height;
		}
		
		/**
		 *立即更新
		 * 
		 */		
		public function updateNow():void
		{
			preUpdate(new Event(Event.ENTER_FRAME));
		}
		
		private function preUpdate(evt:Event):void
		{
			this.removeEventListener(Event.ENTER_FRAME, preUpdate);
			
			checkAndDispathEvents(evt);
			update(evt);
		}
		
		/**
		 *每一个变化都会发出对应时间提醒监听者 
		 * @param evt
		 * 
		 */	
		private function checkAndDispathEvents(evt:Event):void
		{
			var event:ScrollContentEvent;
			
			//翻页对应的横向滚动值变了
			if(m_horPageScrollValue != m_curHorPageScrollValue)
			{
				event = new ScrollContentEvent(ScrollContentEvent.HOR_PAGE_SCROLL_VALUE_CHANGED);
				event.oldValue = m_curHorPageScrollValue;
				event.newValue = m_horPageScrollValue;
				
				m_curHorPageScrollValue = m_horPageScrollValue;
				
				dispatchEvent(event);
			}
			
			//最小横向滚动值变了
			if(m_minHorScrollValue != m_curMinHorScrollValue)
			{
				event = new ScrollContentEvent(ScrollContentEvent.MIN_HOR_SCROLL_VALUE_CHANGED);
				event.oldValue = m_curMinHorScrollValue;
				event.newValue = m_minHorScrollValue;
				
				m_curMinHorScrollValue = m_minHorScrollValue;
				
				dispatchEvent(event);
			}
			
			//最大横向滚动值变了
			if(m_maxHorScrollValue != m_curMaxHorScrollValue)
			{
				event = new ScrollContentEvent(ScrollContentEvent.MAX_HOR_SCROLL_VALUE_CHANGED);
				event.oldValue = m_curMaxHorScrollValue;
				event.newValue = m_maxHorScrollValue;
				
				m_curMaxHorScrollValue = m_maxHorScrollValue;
				
				dispatchEvent(event);
			}
			
			//横向滚动值变了
			if(m_horScrollValue != m_curHorScollValue)
			{
				event = new ScrollContentEvent(ScrollContentEvent.HOR_SCROLL_VALUE_CHANGED);
				event.oldValue = m_curHorScollValue;
				event.newValue = m_horScrollValue;
				
				m_curHorScollValue = m_horScrollValue;
				
				dispatchEvent(event);
			}
			
			//最小竖向滚动值变了
			if(m_minVerScrollValue != m_curMinVerScrollValue)
			{
				event = new ScrollContentEvent(ScrollContentEvent.MIN_VER_SCROLL_VALUE_CHANGED);
				event.oldValue = m_curMinVerScrollValue;
				event.newValue = m_minVerScrollValue;
				
				m_curMinVerScrollValue = m_minVerScrollValue;
				
				
				dispatchEvent(event);
			}
			
			//最大竖向滚动值变了
			if(m_maxVerScrollValue != m_curMaxVerScrollValue)
			{
				event = new ScrollContentEvent(ScrollContentEvent.MAX_VER_SCROLL_VALUE_CHANGED);
				event.oldValue = m_curMaxHorScrollValue;
				event.newValue = m_maxVerScrollValue;
				
				m_curMaxVerScrollValue = m_maxVerScrollValue;
				
				dispatchEvent(event);
			}
			
			//翻页对应的竖向滚动值变了
			if(m_verPageScrollValue != m_curVerPageScrollValue)
			{
				event = new ScrollContentEvent(ScrollContentEvent.VER_PAGE_SCROLL_VALUE_CHANGED);
				event.oldValue = m_curVerPageScrollValue;
				event.newValue = m_verPageScrollValue;
				
				m_curVerPageScrollValue = m_verPageScrollValue;
				
				dispatchEvent(event);
			}
			
			//竖向滚动值变了
			if(m_verScrollValue != m_curVerScrollValue)
			{
				event = new ScrollContentEvent(ScrollContentEvent.VER_SCROLL_VALUE_CHANGED);
				event.oldValue = m_curVerScrollValue;
				event.newValue = m_verScrollValue;
				
				m_curVerScrollValue = m_verScrollValue;
				
				dispatchEvent(event);
			}
		}
		
	
		protected function update(evt:Event):void
		{
			if(m_skin)
			{
				m_skin.y = -verticalScrollValue;
				m_skin.x = -horizontalScrollValue;
			}
		}
		
		protected function updateContentScrollRect():void
		{
			m_scrollRect.width = m_width;
			m_scrollRect.height = m_height;
			this.scrollRect = m_scrollRect;
		}
		}
}