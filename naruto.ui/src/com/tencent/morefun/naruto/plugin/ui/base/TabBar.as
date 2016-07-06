package com.tencent.morefun.naruto.plugin.ui.base
{
	import com.tencent.morefun.naruto.plugin.ui.base.event.TabBarEvent;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class TabBar extends Sprite
	{
		protected var tabItems:Array;
		
		protected var m_selectedIndex:int = -1;
		/**
		 * 
		 * @param TabItems
		 * 参数为BaseButton实例
		 *  
		 */
		public function TabBar(...TabItems)
		{
			super();
			
			
			var item:BaseButton;
			
			tabItems = TabItems;
			for(var i:int = 0;i < tabItems.length;i ++)
			{
				item = tabItems[i];
				item.selectable = true;
				item.radioGroup = name;
				
				item.addEventListener(MouseEvent.CLICK, onItemClick);
				addChild(item);
			}
		}
		
		/**
		 *立即更新显示内容 
		 * 
		 */		
		public function updateNow():void
		{
			var item:BaseButton;
			
			for(var i:int = 0;i < tabItems.length;i ++)
			{
				item = tabItems[i] as BaseButton;
				item.updateNow();
			}
		}
		
		/**
		 *销毁函数 用完记得调用 
		 * 
		 */		
		public function destroy():void
		{
			var item:BaseButton;
			
			for(var i:int = 0;i < tabItems.length;i ++)
			{
				item = tabItems[i];
				item.destroy();
				
				item.removeEventListener(MouseEvent.CLICK, onItemClick);
				removeChild(item);
			}
		}
		
		/**
		 *设置第几个页签为选中 
		 * @param value
		 * 
		 */		
		public function set selectedIndex(value:int):void
		{
			var item:BaseButton;
			var event:TabBarEvent;
			
			if(m_selectedIndex == value)
			{
				return ;
			}
			
			m_selectedIndex = value;
			
			item = tabItems[value];
			if (item)
			{
				if(item.selected == false)
				{
					item.selected = true;
				}
			}
			else
			{
				for each (item in tabItems)
				{
					item.selected = false;
					item.mouseEnabled = true;
				}
			}
			
			event = new TabBarEvent(TabBarEvent.TAB_SELECTED_INDEX_CHANGED);
			event.selectedIndex = value;
			this.dispatchEvent(event);
		}
		
		/**
		 *根据索引获取对应按钮 
		 * @param value
		 * @return 
		 * 
		 */		
		public function getTabItemByIndex(value:int):BaseButton
		{
			return tabItems[value];
		}
		
		/**
		 * 当前选中页签下标
		 * @return 
		 * 
		 */		
		public function get selectedIndex():int
		{
			return m_selectedIndex;
		}
		
		/**
		 *页签点击响应 
		 * @param evt
		 * 
		 */		
		protected function onItemClick(evt:MouseEvent):void
		{
			var item:BaseButton;
			
			item = evt.currentTarget as BaseButton;
			selectedIndex = tabItems.indexOf(item);
			item.selected = true;
		}
		}
}