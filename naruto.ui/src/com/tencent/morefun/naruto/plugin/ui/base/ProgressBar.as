package com.tencent.morefun.naruto.plugin.ui.base
{

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import com.tencent.morefun.naruto.plugin.ui.base.event.ProgressBarEvent;

	public class ProgressBar extends Sprite
	{
		private var m_thumb:MovieClip;
		private var m_background:MovieClip;
		private var m_txt:TextField;
		
		private var m_min:int;
		private var m_max:int;
		private var m_value:int;
		
		private var m_step:int = 1;
		
		private var m_destValue:int;
		private var m_curValue:int;
		
		private var m_smoothing:Boolean;
		
		/**
		 * 
		 * @param thumb 变长的滚动皮肤
		 * @param backGround 底图
		 * @param txt 进度文字显示
		 * @param smoothing 是否平滑更新进度
		 * 
		 */		
		public function ProgressBar(skin:MovieClip, smoothing:Boolean = true, thumb:MovieClip = null, backGround:MovieClip = null, txt:TextField = null)
		{
			super();
			
			m_txt = txt || skin["txt"];
			m_thumb = thumb || skin["thumb"];
			m_background = backGround || skin["backGround"];
			m_smoothing = smoothing;
			
			if(m_txt)
			{
				addChild(m_txt);
			}
			
			addChild(m_background);
			addChild(m_thumb);
			addChild(m_txt);
			
		}
		
		/**
		 *销毁函数 用完记得调用 
		 * 
		 */		
		public function destroy():void
		{
			if(m_txt)
			{
				removeChild(m_txt);
			}
			
			removeChild(m_thumb);
			removeChild(m_background);
		}
		
		public function set smoothing(value:Boolean):void
		{
			this.m_smoothing = value;
		}
		
		public function get smoothing():Boolean
		{
			return m_smoothing;
		}
		
		/**
		 *最小值 
		 * @param value
		 * 
		 */		
		public function set min(value:int):void
		{
			m_min = value;
		}
		
		public function get min():int
		{
			return m_min;
		}
		
		/**
		 *最大值 
		 * @param value
		 * 
		 */		
		public function set max(value:int):void
		{
			m_max = value;
		}
		
		public function get max():int
		{
			return m_max;
		}
		
		/**
		 *当为平滑更新进度时，每次更新的最大值
		 * @param value
		 * 
		 */		
		public function set step(value:int):void
		{
			m_step = value;
		}
		
		public function get step():int
		{
			return m_step;
		}
		
		/**
		 *设置当前进度 
		 * @param value
		 * 
		 */		
		public function set value(value:int):void
		{
			m_value = value;
			m_destValue = value;
			
			waitUpdate();
		}
		
		public function get value():int
		{
			return m_value;
		}
		
		/**
		 * 延迟更新显示
		 * 
		 */		
		public function waitUpdate():void
		{
			this.addEventListener(Event.ENTER_FRAME, update);
		}
		
		/**
		 * 立即更新显示
		 * 
		 */		
		public function updateNow():void
		{
			update(new Event(Event.ENTER_FRAME));
		}
		
		/**
		 *更新显示 
		 * @param evt
		 * 
		 */		
		public function update(evt:Event):void
		{
			var event:ProgressBarEvent;
			var tempValue:int;
			var valueChanged:Boolean;
			
			if((m_smoothing && m_curValue == m_destValue) || m_smoothing == false)
			{
				this.removeEventListener(Event.ENTER_FRAME, update);
			}
			
			valueChanged = (m_smoothing)?(m_curValue != m_destValue):(m_value != m_curValue); 
			tempValue = (m_smoothing && m_curValue < m_value)?(m_curValue + m_step):m_value;
			
			if(valueChanged)
			{
				event = new ProgressBarEvent(ProgressBarEvent.PROGRESS_BAR_VALUE_CHANGED);
				event.oldValue = m_curValue;
				event.newValue = tempValue;
				
				if(m_txt)
				{
					m_txt.text = tempValue + "/" + m_max;
				}
				
				m_thumb.width = m_background.width * ((tempValue - m_min) / (m_max - m_min));
				
				m_curValue = tempValue;
				
				this.dispatchEvent(event);
			}
			
			if(tempValue == m_max)
			{
				event = new ProgressBarEvent(ProgressBarEvent.PROGRESS_BAR_PROGRESS_COMPLETE);
				event.oldValue = m_max;
				event.newValue = m_max;
				this.dispatchEvent(event);
			}
		}
		
		}
}