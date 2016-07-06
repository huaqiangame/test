package com.tencent.morefun.naruto.plugin.ui.components.wrappers 
{
	import com.tencent.morefun.naruto.plugin.ui.components.events.ScrollEvent;
	import com.tencent.morefun.naruto.plugin.ui.components.interfaces.IComponent;
	import com.tencent.morefun.naruto.plugin.ui.components.interfaces.IScroller;
	import com.tencent.morefun.naruto.plugin.ui.components.layouts.ScrollLayout;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	

	/**
	 * 滚动布局类
	 * @author larryhou
	 */
    import com.tencent.morefun.naruto.i18n.I18n;
	public class LayoutWrapper extends EventDispatcher implements IComponent
	{
		private var _scroller:IScroller = null;
		
		private var _layout:ScrollLayout = null;
		
		private var _enabled:Boolean = false;
		
		private var _position:Number = 0;
		
		/**
		 * 构造函数
		 * create a [LayoutWrapper] object
		 */
		public function LayoutWrapper(layout:ScrollLayout, scroller:IScroller)
		{
			_layout = layout;
			_scroller = scroller;
			
			if (!_layout)
			{
				throw new ArgumentError(I18n.lang("as_ui_1451031579_6172"));
			}
			
			if (!_scroller)
			{
				throw new ArgumentError(I18n.lang("as_ui_1451031579_6173"));
			}
		}
		
		//------------------------------------------
		// Public APIs
		//------------------------------------------
		
		public function scrollTo(dataIndex:int):void
		{
			_layout.scrollTo(dataIndex);
			
			_scroller.value = _layout.value;
			_position = _layout.value;
		}
		
		//------------------------------------------
		// Private APIs
		//------------------------------------------
		/**
		 * 添加事件侦听
		 */
		private function listen():void
		{
			_layout.addEventListener(Event.CHANGE, layoutChangeHandler);
			
			_scroller.addEventListener(Event.CHANGE, scrollerChangeHandler);
			_scroller.addEventListener(ScrollEvent.STOP_SCROLLING, stopScrollHandler);
			_scroller.addEventListener(ScrollEvent.START_SCROLLING, startScrollHandler);
		}
		
		/**
		 * 移除事件侦听
		 */
		private function unlisten():void
		{
			_layout.removeEventListener(Event.CHANGE, layoutChangeHandler);
			
			_scroller.removeEventListener(Event.CHANGE, scrollerChangeHandler);
			_scroller.removeEventListener(ScrollEvent.STOP_SCROLLING, stopScrollHandler);
			_scroller.removeEventListener(ScrollEvent.START_SCROLLING, startScrollHandler);
		}
		
		/**
		 * 滑块滚动处理
		 * @param	e
		 */
		private function scrollerChangeHandler(e:Event):void 
		{
			e.stopPropagation();
			
			_layout.value = _scroller.value;
			_position = _scroller.value;
		}
		
		/**
		 * 滑块开始滚动处理
		 * @param	e
		 */
		private function startScrollHandler(e:ScrollEvent):void
		{
			e.stopPropagation();
			
			_layout.scrolling = true;
		}
		
		/**
		 * 滑块开始滚动处理
		 * @param	e
		 */
		private function stopScrollHandler(e:ScrollEvent):void 
		{
			e.stopPropagation();
			
			_layout.scrolling = false;
		}
		
		/**
		 * 列表滚动处理
		 * @param	e
		 */
		private function layoutChangeHandler(e:Event):void
		{
			e.stopPropagation();
			
			_scroller.value = _layout.value;
			_position = _layout.value;
		}
		
		//------------------------------------------
		// Getters & Setters
		//------------------------------------------
		/**
		 * 是否激活控件
		 */
		public function get enabled():Boolean { return _enabled; }
		public function set enabled(value:Boolean):void 
		{
			_enabled = value;
			
			_layout.enabled = _enabled;
			_scroller.enabled = _enabled;
			
			_enabled ? listen() : unlisten();
		}
		
		/**
		 * 传入列表数据
		 */
		public function get dataProvider():Array { return _layout.dataProvider; }
		public function set dataProvider(value:Array):void 
		{
			_layout.dataProvider = value;
			_scroller.lineCount = _layout.lineCount;
			
			this.position = _position;
		}
		
		/**
		 * 列表以及滑块的数值
		 */
		public function get position():Number { return _position; }
		public function set position(value:Number):void
		{
			_position = value;
			_layout.value = value;
			_scroller.value = value;
		}
		
		/**
		 * 布局类
		 */
		public function get layout():ScrollLayout { return _layout; }
		
		/**
		 * 滚动控制器
		 */
		public function get scroller():IScroller { return _scroller; }
	}

}