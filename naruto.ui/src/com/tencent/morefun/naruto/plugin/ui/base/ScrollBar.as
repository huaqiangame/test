package com.tencent.morefun.naruto.plugin.ui.base
{

	import com.tencent.morefun.naruto.plugin.ui.base.def.DirectionDef;
	import com.tencent.morefun.naruto.plugin.ui.base.event.ScrollBarEvent;
	import com.tencent.morefun.naruto.plugin.ui.util.TimerProvider;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class ScrollBar extends Sprite
	{
		protected var _skin:MovieClip;
		protected var _skinUp:InteractiveObject;
		protected var _skinDown:InteractiveObject;
		protected var _bg:Sprite;
		protected var m_up:InteractiveObject;
		protected var m_down:InteractiveObject;
		protected var m_thumb:InteractiveObject;
		private var m_scrollArea:DisplayObject;
		private var m_fixThumbHeight:Boolean;
		
		private var m_direction:String;
		private var m_scrolAreaRec:Rectangle;
		
		private var m_scrollValue:int;
		private var m_minScrollValue:int;
		private var m_maxScrollValue:int;
		private var m_pageScrollValue:int = 1;
		
		private var m_curScrollValue:int;
		private var m_curMinScrollValue:int;
		private var m_curMaxScrollValue:int;
		
		private var m_pixelToScrollValue:Number = 0;
		
		private var m_thumbHeight:int;
		private var m_thumbWidth:int;
		private var m_minThumSize:int = 10;
		
		private var m_mouseUpDowning:Boolean;
		private var m_mouseDownDowning:Boolean;
		
		private var m_curTimeStep:int;
		private var m_timerDefaultTimeStep:int= 300;
		private var m_fastTimeStep:int = 50;
		private var m_updateImmdiately:Boolean = true;
		
		
		/**
		 * 
		 * @param up 建议为BaseButton
		 * @param down 建议为BaseButton
		 * @param thumb 滑块
		 * @param srcollArea 滑块滚动区域
		 * @param direction 方向 DirectionDef的枚举内容
		 * @param fixThumbHeight 是否根据 max min pageScrollValue 这3个信息自动设置滑块的高度比例
		 * 
		 */		
		public function ScrollBar(skin:MovieClip,
								  direction:String = "vertical",
								  fixThumbHeight:Boolean = false,
								  up:InteractiveObject = null,
								  down:InteractiveObject = null,
								  thumb:InteractiveObject = null,
								  srcollArea:DisplayObject = null
		)
		{
			super();
			
			_skin = skin;
			_skinUp = up || _skin["up"];
			_skinDown = down || _skin["down"];
			
			m_up = up || new BaseButton(skin["up"]);
			m_down = down || new BaseButton(skin["down"]);
			m_thumb = thumb || skin["thumb"];
			
			if(skin["background"])
			{
				_bg = skin["background"];
				addChild(_bg);
			}
			
			m_direction = direction;
			m_fixThumbHeight = fixThumbHeight;
			
			if(!srcollArea)
			{
				srcollArea = skin["scrollArea"];
			}
			m_scrolAreaRec = new Rectangle(srcollArea.x, srcollArea.y, srcollArea.width, srcollArea.height);
			
			addChild(srcollArea);
			if(m_up)
			{
				addChild(m_up);
				
			}
			if(m_down)
			{
				addChild(m_down);
			}
			addChild(m_thumb);
			
			m_scrollArea = srcollArea;
			
			m_thumbHeight = m_thumb.height;
			m_thumbWidth = m_thumb.width;
			
			m_thumb.addEventListener(MouseEvent.MOUSE_DOWN, onThumbMouseDown);
			
			if(m_up is BaseButton && m_down is BaseButton)
			{
				BaseButton(m_up).repeart = true;
				BaseButton(m_down).repeart = true;
				m_up.addEventListener(MouseEvent.CLICK, onUpBtnClick);
				m_down.addEventListener(MouseEvent.CLICK, onDownBtnClick);
			}
			else
			{
				if(m_up)
				{
					m_up.addEventListener(MouseEvent.MOUSE_DOWN, onUpBtnMouseDown);
					m_up.addEventListener(MouseEvent.MOUSE_UP, onUpBtnMouseUp);
					m_up.addEventListener(MouseEvent.CLICK, onUpBtnClick);
				}
				
				if(m_down)
				{
					m_down.addEventListener(MouseEvent.MOUSE_DOWN, onDownBtnMouseDown);
					m_down.addEventListener(MouseEvent.MOUSE_UP, onDownBtnMouseUp);
					m_down.addEventListener(MouseEvent.CLICK, onDownBtnClick);
				}
			}
			
			this.x = _skin.x;
			this.y = _skin.y;
			
			this.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}
		
		public function updateBaseInfo():void
		{
			m_thumbHeight = m_thumb.height;
			m_thumbWidth = m_thumb.width;
			
			m_scrolAreaRec = new Rectangle(m_scrollArea.x, m_scrollArea.y, m_scrollArea.width, m_scrollArea.height);
			updateThumbInfo();
		}
		
		/**
		 *销毁函数 用完记得调用 
		 * 
		 */		
		public function destroy():void
		{
			m_thumb.removeEventListener(MouseEvent.MOUSE_DOWN, onThumbMouseDown);
			
			if(m_up is BaseButton && m_down is BaseButton)
			{
				BaseButton(m_up).destroy();
				BaseButton(m_down).destroy();
				m_up.removeEventListener(MouseEvent.CLICK, onUpBtnClick);
				m_down.removeEventListener(MouseEvent.CLICK, onDownBtnClick);
			}
			else
			{
				if(m_up)
				{
					m_up.removeEventListener(MouseEvent.MOUSE_DOWN, onUpBtnMouseDown);
					m_up.removeEventListener(MouseEvent.MOUSE_UP, onUpBtnMouseUp);
					m_up.removeEventListener(MouseEvent.CLICK, onUpBtnClick);
				}
				
				if(m_down)
				{
					m_down.removeEventListener(MouseEvent.MOUSE_DOWN, onDownBtnMouseDown);
					m_down.removeEventListener(MouseEvent.MOUSE_UP, onDownBtnMouseUp);
					m_down.removeEventListener(MouseEvent.CLICK, onDownBtnClick);
				}
				
				TimerProvider.removeTimeTask(m_curTimeStep, onMouseDownTimer);
			}
			
			if(contains(m_up)){removeChild(m_up);}
			if(contains(m_down)){removeChild(m_down);}
			if(contains(m_thumb)){removeChild(m_thumb);}
		}
		
		public function set updateImmdiately(value:Boolean):void
		{
			m_updateImmdiately = value;
		}
		
		public function get updateImmdiately():Boolean
		{
			return m_updateImmdiately;
		}
		
		/**
		 *上滚按钮点击响应 
		 * @param evt
		 * 
		 */		
		private function onUpBtnClick(evt:MouseEvent):void
		{
			scrollValue -= m_pageScrollValue;
		}
		
		/**
		 *下滚按钮点击响应 
		 * @param evt
		 * 
		 */		
		private function onDownBtnClick(evt:MouseEvent):void
		{
			scrollValue += m_pageScrollValue;
		}
		
		/**
		 *上滚按钮长按响应 
		 * @param evt
		 * 
		 */		
		private function onUpBtnMouseDown(evt:MouseEvent):void
		{
			m_mouseUpDowning = true;
			
			m_curTimeStep = m_timerDefaultTimeStep;
			TimerProvider.addTimeTask(m_curTimeStep, onMouseDownTimer);
			
			m_up.removeEventListener(MouseEvent.CLICK, onUpBtnClick);
		}
		
		private function onUpBtnMouseUp(evt:MouseEvent):void
		{
			m_mouseUpDowning = false;
			
			m_up.addEventListener(MouseEvent.CLICK, onUpBtnClick);
			TimerProvider.removeTimeTask(m_curTimeStep, onMouseDownTimer);
		}
		
		/**
		 *下滚按钮长按响应 
		 * @param evt
		 * 
		 */		
		private function onDownBtnMouseDown(evt:MouseEvent):void
		{
			m_mouseDownDowning = true;
			
			m_curTimeStep = m_timerDefaultTimeStep;
			TimerProvider.addTimeTask(m_curTimeStep, onMouseDownTimer);
			
			m_down.removeEventListener(MouseEvent.CLICK, onDownBtnClick);
		}
		
		private function onDownBtnMouseUp(evt:MouseEvent):void
		{
			m_mouseDownDowning = false;
			
			m_down.addEventListener(MouseEvent.CLICK, onDownBtnClick);
			TimerProvider.removeTimeTask(m_curTimeStep, onMouseDownTimer);
		}
		
		/**
		 *滚动按钮长按时所启动定时器，定时派发点击滚动事件
		 * 
		 */		
		private function onMouseDownTimer():void
		{
			
			if(m_mouseUpDowning)
			{
				scrollValue -= m_pageScrollValue;
			}
			
			if(m_mouseDownDowning)
			{
				scrollValue += m_pageScrollValue;
			}
			
			if(m_curTimeStep == m_timerDefaultTimeStep)
			{
				TimerProvider.removeTimeTask(m_curTimeStep, onMouseDownTimer);
				m_curTimeStep = m_fastTimeStep;
				TimerProvider.addTimeTask(m_curTimeStep, onMouseDownTimer);
			}
			
		}
		
		private var m_mouseDownX:int;
		private var m_mouseDownY:int;
		private var m_stage:Stage;
		private var m_isDragThumb:Boolean;
		private var m_stageMousePoint:Point = new Point();
		/**
		 * 滑块按住响应
		 * @param evt
		 * 
		 */		
		private function onThumbMouseDown(evt:MouseEvent):void
		{
			m_isDragThumb = true;
			
			m_mouseDownX = evt.localX * m_thumb.scaleX;
			m_mouseDownY = evt.localY * m_thumb.scaleY;
			
			m_stage = stage;
			
			m_stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			m_stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		/**
		 *滑块拖动响应 
		 * @param evt
		 * 
		 */		
		private function onMouseMove(evt:MouseEvent):void
		{
			var localPoint:Point;
			var destX:int;
			var destY:int;
			
			m_stageMousePoint.x = m_stage.mouseX;
			m_stageMousePoint.y = m_stage.mouseY;
			
			localPoint = globalToLocal(m_stageMousePoint);
			
			
			if(m_direction == DirectionDef.VERTICAL)
			{
				destY =  localPoint.y - m_mouseDownY;
				
				if(destY < m_scrolAreaRec.y)
				{
					destY = m_scrolAreaRec.y;
				}
				else if(destY > m_scrolAreaRec.y + m_scrolAreaRec.height - m_thumbHeight)
				{
					destY = m_scrolAreaRec.y + m_scrolAreaRec.height - m_thumbHeight;
				}
				
				scrollValue = getVerticalScrollValue(destY);
				m_thumb.y = destY;
				this.updateNow();
			}
			else
			{
				destX =  localPoint.x - m_mouseDownX;
				
				if(destX < m_scrolAreaRec.x)
				{
					destX = m_scrolAreaRec.x;
				}
				else if(destX > m_scrolAreaRec.x + m_scrolAreaRec.width - m_thumbWidth)
				{
					destX = m_scrolAreaRec.x + m_scrolAreaRec.width - m_thumbWidth;
				}
				
				scrollValue = getHorticalScrollValue(destX);
				m_thumb.x = destX;
				this.updateNow();
			}
			
			if(m_updateImmdiately == false)
			{
				evt.updateAfterEvent();
			}
		}
		
		/**
		 *根据滑块位置获取对应的纵向滚动值 
		 * @param destY
		 * @return 
		 * 
		 */		
		private function getVerticalScrollValue(destY:int):int
		{
			if(destY == m_scrolAreaRec.y)
			{
				return m_minScrollValue;
			}
			if(destY == (m_scrolAreaRec.y + m_scrolAreaRec.height - m_thumbHeight))
			{
				return m_maxScrollValue;
			}
			
			return Math.round((destY - m_scrolAreaRec.y) * m_pixelToScrollValue) + m_minScrollValue;
		}
		
		/**
		 * 根据滑块位置获取对应的横向滚动值 
		 * @param destX
		 * @return 
		 * 
		 */		
		private function getHorticalScrollValue(destX:int):int
		{
			if(destX == m_scrolAreaRec.x)
			{
				return m_minScrollValue;
			}
			if(destX == m_scrolAreaRec.x + m_scrolAreaRec.width - m_thumbWidth)
			{
				return m_maxScrollValue;
			}
			
			return (destX - m_scrolAreaRec.x) * m_pixelToScrollValue;
		}
		
		/**
		 * 鼠标左键松开响应
		 * @param evt
		 * 
		 */		
		private function onMouseUp(evt:MouseEvent):void
		{
			m_isDragThumb = false;
			
			m_stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			m_stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		/**
		 *滑块高度自适应设置 
		 * @return 
		 * 
		 */		
		public function get fixThumbHeight():Boolean
		{
			return m_fixThumbHeight;
		}
		
		/**
		 *当前滚动值
		 * @param value
		 * 
		 */		
		public function set scrollValue(value:int):void
		{
			m_scrollValue = fixValue(value);
			waitUpdate();
		}
		
		public function get scrollValue():int
		{
			return m_scrollValue;
		}
		
		/**
		 *限制滚动值在最小值与最大值之间 
		 * @param value
		 * @return 
		 * 
		 */		
		private function fixValue(value:int):int
		{
			if(value > m_maxScrollValue)
			{
				return m_maxScrollValue ;
			}
			if(value < m_minScrollValue)
			{
				return m_minScrollValue;
			}
			
			return value;
		}
		
		/**
		 *最小滚动值 
		 * @param value
		 * 
		 */		
		public function set minScrollValue(value:int):void
		{
			m_minScrollValue = value;
			scrollValue = scrollValue;
			updateThumbInfo();
			waitUpdate();
		}
		
		public function get minScrollValue():int
		{
			return m_minScrollValue;	
		}
		
		/**
		 *最大滚动值 
		 * @param value
		 * 
		 */		
		public function set maxScrollValue(value:int):void
		{
			m_maxScrollValue = value;
			scrollValue = scrollValue;
			updateThumbInfo();
			waitUpdate();
		}
		
		public function get maxScrollValue():int
		{
			return m_maxScrollValue;
		}
		
		/**
		 *滑块高度所对应的滚动值 
		 * @param value
		 * 
		 */		
		public function set pageScrollValue(value:int):void
		{
			m_pageScrollValue = value;
			updateThumbInfo();
			waitUpdate();
		}
		
		public function get pageScrollValue():int
		{
			return m_pageScrollValue;	
		}
		
		/**
		 *当滑块高度为自适应时设置滑块高度
		 *更新每个像素对应多少滚动值
		 * 
		 */		
		private function updateThumbInfo():void
		{	
			if(m_direction == DirectionDef.VERTICAL)
			{
				if(m_fixThumbHeight){m_thumbHeight = (m_pageScrollValue / (m_maxScrollValue - m_minScrollValue + m_pageScrollValue)  ) * m_scrolAreaRec.height;}
				if(m_thumbHeight <= 0)
				{
					m_thumbHeight = m_minThumSize;
				}
				else if(m_thumbHeight < m_minThumSize)
				{
					m_thumbHeight = m_minThumSize;
				}
				m_pixelToScrollValue = (m_maxScrollValue - m_minScrollValue) / (m_scrolAreaRec.height - m_thumbHeight);
			}
			else
			{
				if(m_fixThumbHeight){m_thumbWidth = (m_pageScrollValue / (m_maxScrollValue - m_minScrollValue + m_pageScrollValue)) * m_scrolAreaRec.width;}
				if(m_thumbWidth <= 0)
				{
					m_thumbWidth = m_minThumSize;
				}
				else if(m_thumbWidth < m_minThumSize)
				{
					m_thumbWidth = m_minThumSize;
				}
				m_pixelToScrollValue = (m_maxScrollValue - m_minScrollValue) / (m_scrolAreaRec.width - m_thumbWidth);
			}
			
			if(isNaN(m_pixelToScrollValue))
			{
				m_pixelToScrollValue = 0;
			}
		}
		
		/**
		 *延迟显示内容 
		 * 
		 */		
		public function waitUpdate():void
		{
			this.addEventListener(Event.ENTER_FRAME, update);
		}
		
		/**
		 *立即显示内容 
		 * 
		 */		
		public function updateNow():void
		{
			update(new Event(Event.ENTER_FRAME));
		}
		
		/**
		 *更新显示内容 
		 * @param evt
		 * 
		 */		
		private function update(evt:Event):void
		{
			var event:ScrollBarEvent;
			
			this.removeEventListener(Event.ENTER_FRAME, update);
			
			if(m_maxScrollValue != m_curMaxScrollValue)
			{
				this.updateThumbInfo();
				if(m_direction == DirectionDef.VERTICAL && m_isDragThumb == false)
				{
					m_thumb.y = (m_curScrollValue - m_minScrollValue) / m_pixelToScrollValue + m_scrolAreaRec.y;
					m_thumb.y = Math.max(m_scrolAreaRec.y, m_thumb.y);
				}
				else if(m_isDragThumb == false)
				{
					m_thumb.x = (m_curScrollValue - m_minScrollValue)  / m_pixelToScrollValue + m_scrolAreaRec.x;
					m_thumb.x = Math.max(m_scrolAreaRec.x, m_thumb.x);
				}
			}
			
			if(m_scrollValue != m_curScrollValue)
			{
				event = new ScrollBarEvent(ScrollBarEvent.SCROLL_VALUE_CHANGED);
				event.oldValue = m_curScrollValue;
				event.newValue = m_scrollValue;
				
				m_curScrollValue = m_scrollValue;
				
				if(m_direction == DirectionDef.VERTICAL && m_isDragThumb == false)
				{
					m_thumb.y = (m_scrollValue - m_minScrollValue) / m_pixelToScrollValue + m_scrolAreaRec.y;
					m_thumb.y = Math.max(m_scrolAreaRec.y, m_thumb.y);
				}
				else if(m_isDragThumb == false)
				{
					m_thumb.x = (m_scrollValue - m_minScrollValue)  / m_pixelToScrollValue + m_scrolAreaRec.x;
					m_thumb.x = Math.max(m_scrolAreaRec.x, m_thumb.x);
				}
				
				this.dispatchEvent(event);
			}
			
			if(m_thumb.width != m_thumbWidth)
			{
				m_thumb.width = m_thumbWidth;
			}
			
			if(m_thumb.height != m_thumbHeight)
			{
				m_thumb.height = m_thumbHeight;
			}
		}
		
		private function onMouseWheel(evt:MouseEvent):void
		{
			scrollValue += (evt.delta > 0)?-pageScrollValue:pageScrollValue
		}
		
		override public function set height(value:Number):void
		{
			if (value <= 0)
				return;
			
			if (m_direction == DirectionDef.VERTICAL)
			{
				var space:int = _skinDown.y - m_scrollArea.y - m_scrollArea.height;
				var minValue:int = _skinUp.y + _skinUp.height + _skinDown.height + (space >> 1);
				var scrollValue:int = value > minValue ? value - minValue : minValue;
				
				m_scrollArea.height = scrollValue;
				m_thumb.height = scrollValue >> 1;
				_skinDown.y = m_scrollArea.y + m_scrollArea.height + space;
				
				if (_bg != null)
					_bg.height = scrollValue;
			}
			
			updateBaseInfo();
		}
		}
}