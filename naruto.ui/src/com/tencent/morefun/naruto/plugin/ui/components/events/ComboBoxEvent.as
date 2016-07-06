package com.tencent.morefun.naruto.plugin.ui.components.events 
{
	import flash.events.Event;

	/**
	 * 下拉列表时间
	 * @author larryhou
	 * @createTime 2014/10/9 16:20
	 */
	public class ComboBoxEvent extends Event 
	{
		/**
		 * 展开下拉列表
		 */
		public static const EXPAND_SIGNAL:String = "expandSignal";
		
		/**
		 * 收起下拉列表
		 */
		public static const COLLAPSE_SIGNAL:String = "collapseSignal";
		
		/**
		 * 选择发生变更时派发
		 */
		public static const SELECT_CHANGE:String = "selectChange";
		
		/**
		 * 打开列表
		 */
		public static const OPEN:String = "open";
		
		/**
		 * 事件携带数据
		 */
		public var data:*;

		/**
		 * 构造函数
		 * create a [ComboBoxEvent] object
		 * @param data 用户自定义数据
		 */
		public function ComboBoxEvent(type:String, data:* = null, bubbles:Boolean = false) 
		{
			this.data = data;
			super(type, bubbles, false);
			
		}

		/**
		 * 克隆事件
		 */
		public override function clone():Event 
		{
			return new ComboBoxEvent(type, data, bubbles);
		}

		/**
		 * 格式化文本输出
		 */
		public override function toString():String 
		{
			return formatToString("DropDownEvent", "type", "data", "bubbles", "cancelable", "eventPhase");
		}
	}

}