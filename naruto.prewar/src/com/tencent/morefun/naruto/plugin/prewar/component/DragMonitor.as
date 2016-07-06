package com.tencent.morefun.naruto.plugin.prewar.component
{
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * 拖拽完成
	 */
	[Event(name = "complete", type = "flash.events.Event")]
	
	/**
	 * 开始拖拽
	 */
	[Event(name = "init", type = "flash.events.Event")]
	
	/**
	 * 拖拽插件
	 * @author larryhou
	 * @createTime 2013/9/29 20:46
	 */
	public class DragMonitor extends EventDispatcher
	{
		private var _tolerance:uint;
		private var _target:InteractiveObject;
		
		private var _dragging:Boolean;
		private var _origin:Point;
		
		/**
		 * 构造函数
		 * create a [DragMonitor] object
		 */
		public function DragMonitor(target:InteractiveObject) 
		{
			_target = target;
			_tolerance = 5;
			
			_target.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
		}
		
		/**
		 * 鼠标按下
		 */
		private function downHandler(e:MouseEvent):void 
		{
			_origin = new Point(_target.mouseX, _target.mouseY);
			_target.stage.addEventListener(MouseEvent.MOUSE_UP, upHandler);
			_target.stage.addEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
		}
		
		/**
		 * 鼠标移动
		 */
		private function moveHandler(e:MouseEvent):void 
		{
			if (Point.distance(_origin, new Point(_target.mouseX, _target.mouseY)) >= _tolerance)
			{
				e.currentTarget.removeEventListener(e.type, arguments.callee);
				
				_dragging = true;
				dispatchEvent(new Event(Event.INIT));
			}
		}
		
		/**
		 * 鼠标弹起
		 */
		private function upHandler(e:MouseEvent):void 
		{
			e.currentTarget.removeEventListener(e.type, arguments.callee);
			_target.stage.removeEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
			
			if (_dragging)
			{
				_dragging = false;
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		/**
		 * 垃圾回收
		 */
		public function dispose():void
		{
			if(!_target)
			{
				return ;
			}
			
			_target.removeEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			
			if (_target.stage)
			{
				_target.stage.removeEventListener(MouseEvent.MOUSE_UP, upHandler);
				_target.stage.removeEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
			}
			
			_target = null;
		}
		
		/**
		 * 鼠标移动距离超过这个像素值即被认为激活拖拽
		 * @default 5
		 */
		public function get tolerance():uint { return _tolerance; }
		public function set tolerance(value:uint):void 
		{
			_tolerance = value;
		}
		
		/**
		 * 是否正拖拽
		 */
		public function get dragging():Boolean { return _dragging; }
		
	}

}