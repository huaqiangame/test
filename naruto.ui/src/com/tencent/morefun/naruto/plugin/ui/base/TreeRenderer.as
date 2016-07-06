package com.tencent.morefun.naruto.plugin.ui.base
{
	import flash.display.MovieClip;
	import com.tencent.morefun.naruto.plugin.ui.base.event.TreeEvent;

	public class TreeRenderer extends ItemRenderer
	{
		private var m_open:Boolean;
		private var m_id:String;
		
		/**
		 * 
		 * @param skin 渲染单元皮肤实例，在树组件构造函数中传入其Class,组件在创建
		 * 当前TreeRenderer时会创建皮肤实列并传入 
		 * 
		 */		
		public function TreeRenderer(skin:MovieClip)
		{
			super(skin);
		}
		
		/**
		 *展开设置 
		 * @param value
		 * 
		 */		
		public function set open(value:Boolean):void
		{
			var event:TreeEvent;
			if(m_open == value)
			{
				return ;
			}
			
			m_open = value;
			if(m_open == true)
			{
				event = new TreeEvent(TreeEvent.NODE_OPEN, true);
				event.nodeId = this.id;
				event.nodedata = this.data;
			}
			else
			{
				event = new TreeEvent(TreeEvent.NODE_CLOSE, true);
				event.nodeId = this.id;
				event.nodedata = this.data;
			}
			this.dispatchEvent(event);
		}
		
		/**
		 *获取展开状态 
		 * @return 
		 * 
		 */		
		public function get open():Boolean
		{
			return m_open;
		}
		
		/**
		 *该渲染单元ID 
		 * @param value
		 * 
		 */		
		public function set id(value:String):void
		{
			m_id = value;
		}
		
		public function get id():String
		{
			return m_id;
		}
		}
}