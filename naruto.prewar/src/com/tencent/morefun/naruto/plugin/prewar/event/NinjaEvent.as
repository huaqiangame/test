package com.tencent.morefun.naruto.plugin.prewar.event
{
	import flash.events.Event;

	/**
	 * 忍者系统内部事件
	 * @author larryhou
	 * @createTime 2013/9/24 15:44
	 */
	public class NinjaEvent extends Event 
	{
		/**
		 * 页签new标记数字变更时派发
		 */
		public static const ICON_NUM_CHANGE:String = "iconNumChange";
		
		/**
		 * 更新图标数字展示
		 */
		public static const UPDATE_ICONS_NUM:String = "updateIconsNum";
		
		/**
		 * 拖动技能
		 */
		public static const START_DRAG_SKILL:String = "startDragSkill";
		
		/**
		 * 停止拖动技能
		 */
		public static const STOP_DRAG_SKILL:String = "stopDragSkill";
		
		/**
		 * 开始拖动背包忍者
		 */
		public static const START_DRAG_NINJA:String = "startDragNinja";
		
		/**
		 * 停止拖拽背包忍者
		 */
		public static const STOP_DRAG_NINJA:String = "stopDragNinja";
		
		/**
		 * 开始拖动仓库忍者
		 */
		public static const START_DRAG_STORAGE_NINJA:String = "startDragStorageNinja";
		
		/**
		 * 停止拖动仓库忍者
		 */
		public static const STOP_DRAG_STORAGE_NINJA:String = "stopDragStorageNinja";
		
		/**
		 * 处理仓库忍者
		 */
		public static const PROCESS_STORAGE_NINJA:String = "processStorageNinja";
		
		/**
		 * 数据变更
		 */
		public static const DATA_CHANGE:String = "dataChange";		
		
		/**
		 * 事件携带数据
		 */
		public var data:*;

		/**
		 * 构造函数
		 * create a [NinjaEvent] object
		 * @param data 用户自定义数据
		 */
		public function NinjaEvent(type:String, data:* = null, bubbles:Boolean = false) 
		{
			this.data = data;
			super(type, bubbles, false);
			
		}

		/**
		 * 克隆事件
		 */
		public override function clone():Event 
		{
			return new NinjaEvent(type, data, bubbles);
		}

		/**
		 * 格式化文本输出
		 */
		public override function toString():String 
		{
			return formatToString("NinjaEvent", "type", "data", "bubbles", "cancelable", "eventPhase");
		}
	}

}