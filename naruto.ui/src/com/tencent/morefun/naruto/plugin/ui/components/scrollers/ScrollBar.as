package com.tencent.morefun.naruto.plugin.ui.components.scrollers 
{
	import com.tencent.morefun.naruto.i18n.I18n;
	import com.tencent.morefun.naruto.plugin.ui.components.events.MoveEvent;
	import com.tencent.morefun.naruto.plugin.ui.components.events.ScrollEvent;
	import com.tencent.morefun.naruto.plugin.ui.components.interfaces.IScroller;
	import com.tencent.morefun.naruto.plugin.ui.components.scrollers.bar.SimpleBar;
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * 用户交互引起value值发生变化时派发
	 */
	[Event(name = "change", type = "flash.events.Event")]
	
	/**
	 * 滚动条停止滚动时派发
	 */
	[Event(name = "stopScrolling", type = "com.tencent.morefun.naruto.plugin.ui.components.events.ScrollEvent")]
	
	/**
	 * 滚动条开始滚动时派发
	 */
	[Event(name = "startScrolling", type = "com.tencent.morefun.naruto.plugin.ui.components.events.ScrollEvent")]
	
	/**
	 * 通用滚动条控件
	 * 该控件不兼容EasyScrollBar的素材，但是包含其所有功能，并扩展控件的表现形式
	 * @notice 不能被旧控件ScrollVeiw支持
	 * @author larryhou
	 * @createTime	2010/2/28 23:12
	 */
    import com.tencent.morefun.naruto.i18n.I18n;
	public class ScrollBar extends EventDispatcher implements IScroller
	{
		private var _view:MovieClip;
		
		private var _bar:SimpleBar;
		private var _track:MovieClip;
		private var _upBtn:MovieClip;
		private var _downBtn:MovieClip;
		
		private var _speed:Number = 4;
		private var _direction:int = 1;
		private var _wheelSpeed:Number = 1;
		
		private var _pageCount:int;
		private var _lineCount:int;
		
		private var _isOnTrack:Boolean = false;
		private var _wheelArea:InteractiveObject;
		
		private var _value:Number;
		private var _enabled:Boolean;
		
		/**
		 * 构造函数
		 * create a [EasyScrollBar] object
		 */
		public function ScrollBar(view:MovieClip, pageCount:int)
		{
			_view = view;
			
			_pageCount = pageCount;
			
			_upBtn = _view["upBtn"];
			_upBtn.buttonMode = true;
			_upBtn.gotoAndStop(1);
			
			_downBtn = _view["downBtn"];
			_downBtn.buttonMode = true;
			_downBtn.gotoAndStop(1);
			
			_track = _view["track"];
			_bar = new SimpleBar(_view["bar"]);
			
			if (!_track || !_bar)
			{
				throw new ArgumentError(I18n.lang("as_ui_1451031579_6165") + _track + ", bar=" + _bar);
			}
			
			this.wheelArea = _view;
		}
		
		/**
		 * 添加时间真挺
		 */
		protected function listen():void 
		{
			_track.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			
			_upBtn && _upBtn.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			_downBtn && _downBtn.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			
			_bar.addEventListener(Event.CHANGE, notify);
			_bar.addEventListener(MoveEvent.STOP_MOVE, stopScrolling);
			_bar.addEventListener(MoveEvent.START_MOVE, startScrolling);
			
			if (_wheelArea)
			{
				_wheelArea.addEventListener(MouseEvent.MOUSE_WHEEL, wheelHandler);
			}
		}
		
		/**
		 * 移除事件侦听
		 */
		protected function unlisten():void 
		{
			_track.removeEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			
			_upBtn && _upBtn.removeEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			_downBtn && _downBtn.removeEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			
			_bar.removeEventListener(Event.CHANGE, notify);
			_bar.removeEventListener(MoveEvent.STOP_MOVE, stopScrolling);
			_bar.removeEventListener(MoveEvent.START_MOVE, startScrolling);
			
			if (_view.stage)
			{
				_view.stage.removeEventListener(MouseEvent.MOUSE_UP, upHandler);
			}
			
			_view.removeEventListener(Event.ENTER_FRAME, frameHandler);
			if (_wheelArea)
			{
				_wheelArea.removeEventListener(MouseEvent.MOUSE_WHEEL, wheelHandler);
			}
		}
		
		/**
		 * 滚动区域
		 * @param	e
		 */
		private function wheelHandler(e:MouseEvent):void 
		{
			_direction = -e.delta / Math.abs(e.delta);
			frameHandler(e);
		}
		
		/**
		 * 实时拖动处理
		 * @param	e
		 */
		private function notify(e:Event = null):void 
		{
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**
		 * 停止移动处理
		 * @param	e
		 */
		private function stopScrolling(e:MoveEvent = null):void 
		{
			dispatchEvent(new ScrollEvent(ScrollEvent.STOP_SCROLLING));
		}
		
		/**
		 * 开始移动处理
		 * @param	e
		 */
		private function startScrolling(e:MoveEvent = null):void 
		{
			dispatchEvent(new ScrollEvent(ScrollEvent.START_SCROLLING));
		}
		
		/**
		 * 鼠标按下
		 * @param	e
		 */
		private function downHandler(e:MouseEvent):void 
		{
			_view.stage.addEventListener(MouseEvent.MOUSE_UP, upHandler);
			
			var target:DisplayObject = e.target as DisplayObject;
			
			if(target != _track)
			{
				if (target == _downBtn)
				{
					_direction = 1;
				}
				else
				{
					_direction = -1;
				}
			}
			else
			{
				if (_view.mouseY > _bar.y)
				{
					_direction = 1;
				}
				else
				{
					_direction = -1;
				}
				
				_isOnTrack = true;
			}
			
			startScrolling();
			
			_view.addEventListener(Event.ENTER_FRAME, frameHandler);
		}
		
		/**
		 * 帧频渲染
		 * @param	e
		 */
		private function frameHandler(e:Event):void 
		{
			var targetY:Number = _bar.y + _speed * _direction;
			
			if (_isOnTrack)
			{
				if (_direction == 1)
				{
					if (targetY + _bar.height > _view.mouseY)
					{
						targetY = _view.mouseY - _bar.height;
					}
				}
				else
				{
					if (targetY < _view.mouseY)
					{
						targetY = _view.mouseY;
					}
				}
			}
			else
			{
				if (_direction == 1)
				{
					if (targetY > _bar.dragRect.bottom) 
					{
						targetY = _bar.dragRect.bottom;
					}
				}
				else
				{
					if (targetY < _bar.dragRect.top)
					{
						targetY = _bar.dragRect.top;
					}
				}
			}
			
			if (_bar.y != targetY)
			{
				_bar.y = targetY;
				notify();
			}
		}
		
		/**
		 * 鼠标弹起
		 * @param	e
		 */
		private function upHandler(e:MouseEvent):void 
		{
			e.currentTarget.removeEventListener(e.type,arguments.callee);
			
			_view.removeEventListener(Event.ENTER_FRAME, frameHandler);
			
			_isOnTrack = false;
			
			stopScrolling();
		}
		
		// getter & setter
		//*************************************************
		/**
		 * 行数
		 */
		public function get lineCount():int { return _lineCount; }
		public function set lineCount(value:int):void
		{
			_lineCount = value;
			
			if (_lineCount <= _pageCount)
			{
				_view.visible = this.enabled = false; return;
			}
			
			_view.visible = this.enabled = true;
			
			var dragRange:Rectangle = _bar.dragRect;
			
			dragRange.width = 0;
			dragRange.x = _bar.x;
			
			var upRect:Rectangle = _upBtn? _upBtn.getBounds(_view) : new Rectangle();
			var downRect:Rectangle = _downBtn? _downBtn.getBounds(_view) : new Rectangle();
			
			dragRange.y = upRect.bottom >> 0;
			dragRange.height = downRect.top - upRect.bottom;
			
			var minValue:Number = _bar.minHeight;
			var maxValue:Number = _bar.dragRect.height;
			
			var ratio:Number = (_lineCount - _pageCount) / (_pageCount * 5);
			_bar.height = maxValue * (1 - ratio) + ratio * minValue >> 0;
			dragRange.height = dragRange.height - _bar.height + 1.0 >> 0;
			
			_bar.y = _bar.dragRect.y;
		}
		
		/**
		 * 滑块高度
		 */
		public function get height():Number { return _view.height; }
		public function set height(value:Number):void 
		{
			var upRect:Rectangle = _upBtn? _upBtn.getBounds(_view) : new Rectangle();
			var downRect:Rectangle = _downBtn? _downBtn.getBounds(_view) : new Rectangle();
			
			_track.height = value - upRect.height - downRect.height;
			_downBtn.y = _track.y + _track.height;
			
			this.lineCount = _lineCount;
		}
		
		/**
		 * 横坐标
		 */
		public function get x():Number { return _view.x; }
		public function set x(value:Number):void 
		{
			_view.x = value;
		}
		
		/**
		 * 竖坐标
		 */
		public function get y():Number { return _view.y; }
		public function set y(value:Number):void 
		{
			_view.y = value;
		}
		
		/**
		 * 是否可见
		 */
		public function get visible():Boolean { return _view.visible; }
		public function set visible(value:Boolean):void
		{
			_view.visible = value;
		}
		
		/**
		 * 滑块对象
		 */
		public function get bar():SimpleBar { return _bar; }
		
		/**
		 * 滚动速度
		 */
		public function get speed():Number { return _speed; }
		public function set speed(value:Number):void 
		{
			_speed = value;
		}
		
		/**
		 * 是否激活控件
		 */
		public function get enabled():Boolean { return _enabled; }
		public function set enabled(value:Boolean):void 
		{
			_enabled = value;
			_bar.enabled = _enabled;
			_enabled? listen() : unlisten();
		}
		
		/**
		 * 滑块宽度
		 */
		public function get width():Number { return _view.width; }
		public function set width(value:Number):void { }
		
		/**
		 * 滑块值
		 */
		public function get value():Number 
		{ 
			_value = 100 * (_bar.y - _bar.dragRect.y) / _bar.dragRect.height;
			return _value = Math.max(Math.min(_value, 100), 0);
		}
		
		public function set value(value:Number):void 
		{
			_value = isNaN(value)? 0 : value;
			_bar.y = _value * _bar.dragRect.height / 100 + _bar.dragRect.y;
		}
		
		/**
		 * 滚轮感应区
		 */
		public function get wheelArea():InteractiveObject { return _wheelArea; }
		public function set wheelArea(value:InteractiveObject):void 
		{
			_wheelArea = value;
		}
		
		/**
		 * 滚动条素材
		 */
		public function get view():MovieClip { return _view; }

		
		/**
		 * 每页显示的长度
		 */
		public function get pageCount():int
		{
			return _pageCount;
		}

		/**
		 * 每页显示的长度
		 */
		public function set pageCount(value:int):void
		{
			_pageCount = value;
		}

		
	}
	
}