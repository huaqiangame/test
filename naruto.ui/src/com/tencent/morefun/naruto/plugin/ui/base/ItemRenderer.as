package com.tencent.morefun.naruto.plugin.ui.base
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	public class ItemRenderer extends Sprite
	{
		protected var m_skin:DisplayObject;
		protected var m_selected:Boolean;
		protected var m_status:Object;
		protected var m_data:Object;
		protected var m_index:int;
		protected var m_row:int;
		protected var m_col:int;
		
		/**
		 *
		 * @param skin 皮肤实列，在组件构造函数传入其Class,组件创建该Renderer
		 * 时会自动创建skin并传入
		 * 
		 */		
		public function ItemRenderer(skin:DisplayObject = null)
		{
			super();
			
			m_skin = skin;
			if(m_skin != null)
			{
				addChild(m_skin);
			}
		}
		
		/**
		 *行数 
		 * @param value
		 * 
		 */		
		public function set row(value:int):void
		{
			m_row = value;
		}
		
		public function get row():int
		{
			return m_row;
		}
		
		/**
		 *列数 
		 * @param value
		 * 
		 */		
		public function set col(value:int):void
		{
			m_col = value;
		}
		
		public function get col():int
		{
			return m_col;
		}
		
		/**
		 * 下标，只会某些组件下有设置，比如DirectionGrid
		 * @param value
		 * 
		 */		
		public function set index(value:int):void
		{
			m_index = value;
		}
		
		public function get index():int
		{
			return m_index;
		}
		
		/**
		 *单元数据 子类中实现具体处理逻辑
		 * @param value
		 * 
		 */		
		public function set data(value:Object):void
		{
			if(m_data == value){return ;}
			
			m_data = value;
		}
		
		public function get data():Object
		{
			return m_data;
		}
		
		public function get skin():DisplayObject
		{
			return m_skin;
		}
		
		public function set selected(value:Boolean):void
		{
			m_selected = value;
		}
		
		public function get selected():Boolean
		{
			return m_selected;
		}
		
		public function set status(value:Object):void
		{
			m_status = value;
		}
		
		public function get status():Object
		{
			return m_status;
		}
		
		/**
		 *销毁函数 子类中实现具体销毁逻辑 
		 * 
		 */		
		public function destroy():void
		{
			removeChildren();
			m_skin = null;
			m_status = null;
			m_data = null;
		}
		}
}