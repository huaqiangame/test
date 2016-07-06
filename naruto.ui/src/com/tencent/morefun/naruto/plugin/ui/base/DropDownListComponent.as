package com.tencent.morefun.naruto.plugin.ui.base
{
	import com.tencent.morefun.naruto.plugin.ui.base.event.GridEvent;
	import com.tencent.morefun.naruto.plugin.ui.layer.LayerManager;
	import com.tencent.morefun.naruto.plugin.ui.layer.def.LayerDef;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class DropDownListComponent extends Sprite
	{
		private var m_list:DirectionGrid;
		private var m_openBtn:InteractiveObject;
		
		public function DropDownListComponent(openBtn:InteractiveObject, list:DirectionGrid, scrollBar:ScrollBar)
		{
			super();
			
			m_list = list;
			m_openBtn = openBtn;
			
			m_list.addEventListener(GridEvent.ITEM_CLICK, onListItemClick);
			openBtn.addEventListener(MouseEvent.CLICK, onOpenBtnClick);
			
			m_list.x = 0;
			m_list.y = 0;
//			scrollBar.x = m_list.width - 
			scrollBar.y = 0;
			
			addChild(m_list);
			addChild(scrollBar);
		}
		
		public function destroy():void
		{
			m_openBtn.addEventListener(MouseEvent.CLICK, openList);
		}
		
		public function set row(value:int):void
		{
			m_list.row = value;
		}
		
		public function get row():int
		{
			return m_list.row;
		}
		
		public function set source(value:Array):void
		{
			m_list.source = value;
		}
		
		public function get source():Array
		{
			return m_list.source;
		}
		
		public function openList():void
		{
			var openBtnGlobePoint:Point;
			
			m_openBtn.localToGlobal(new Point(0, 0));
			m_list.y = m_openBtn.x;
			m_list.x = m_openBtn.y + m_openBtn.height;
			
			LayerManager.singleton.addItemToLayer(this, LayerDef.MENU);
			LayerManager.singleton.stage.addEventListener(MouseEvent.MOUSE_DOWN, onStageMouseDown);
		}
		
		public function closeList():void
		{
			LayerManager.singleton.removeItemToLayer(this);
			LayerManager.singleton.stage.removeEventListener(MouseEvent.MOUSE_DOWN, onStageMouseDown);
		}
		
		private function onStageMouseDown(evt:MouseEvent):void
		{
			var targetDispay:DisplayObject;
			
			targetDispay = evt.target as DisplayObject;
			if(contains(targetDispay) == true)
			{
				return ;
			}
			
			closeList();
		}
		
		private function onListItemClick(evt:MouseEvent):void
		{
			closeList();
			dispatchEvent(evt.clone());
		}
		
		private function onOpenBtnClick(evt:MouseEvent):void
		{
			openList();
		}
		}
}