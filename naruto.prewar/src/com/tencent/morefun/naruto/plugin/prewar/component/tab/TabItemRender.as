package com.tencent.morefun.naruto.plugin.prewar.component.tab
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * 选项卡被点击时派发
	 */
	[Event(name = "select", type = "flash.events.Event")]
	
	/**
	 * 页签项目渲染器
	 * @author larryhou
	 * @createTime 2013/9/26 19:03
	 */
	public class TabItemRender extends Sprite
	{
		protected var _selected:Boolean;
		
		/**
		 * 构造函数
		 * create a [TabItemRender] object
		 */
		public function TabItemRender() 
		{
			addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		private function clickHandler(e:MouseEvent):void 
		{
			dispatchEvent(new Event(Event.SELECT, true));
		}
		
		/**
		 * 垃圾回收
		 */
		public function dispose():void
		{
			removeEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		/**
		 * 选项卡渲染数据
		 */
		public function get data():Object { return null; }
		public function set data(value:Object):void 
		{
			
		}
		
		/**
		 * 选项卡是否被选中
		 */
		public function get selected():Boolean { return _selected; }
		public function set selected(value:Boolean):void 
		{
			_selected = value;
			if (_selected)
			{
				mouseChildren = mouseEnabled = false;
			}
			else
			{
				mouseChildren = mouseEnabled = true;
			}
		}
	}

}