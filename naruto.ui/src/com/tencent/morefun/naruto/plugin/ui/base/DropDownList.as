package com.tencent.morefun.naruto.plugin.ui.base
{

	import com.tencent.morefun.naruto.plugin.ui.base.def.DirectionDef;
	import com.tencent.morefun.naruto.plugin.ui.base.event.GridEvent;
	import com.tencent.morefun.naruto.plugin.ui.layer.LayerManager;
	import com.tencent.morefun.naruto.plugin.ui.layer.LayoutManager;
	import com.tencent.morefun.naruto.plugin.ui.layer.def.LayerDef;
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class DropDownList extends Sprite
	{
		protected var m_list:DirectionGrid;
		protected var m_srcollBar:ScrollBar;
		protected var m_listWindow:ScrollWindow;
		protected var m_openRendererItem:ItemRenderer;
		protected var m_isOpen:Boolean;
		protected var m_listBackground:DisplayObject;
		
		protected var m_listOffsetX:int = 0;
		protected var m_listOffsetY:int = 0;
		
		/**
		 * 
		 * @param row 显示的行数
		 * @param itemRendererCls 列表渲染逻辑类
		 * @param itemSkinCls 列表渲染皮肤类，在创建itemRendererCls时会自动传入其构造函数中
		 * @param scollUpBtn 滚动条皮肤-上按钮
		 * @param scrollDownBtn 滚动条皮肤-下按钮
		 * @param scrollThumbSkin 滚动条皮肤-滑块
		 * @param scrollAreaSkin 滚动条皮肤-滑块滑动区域
		 * @param background 列表背景
		 * @param openRendererData 列表开关按钮的Data
		 * @param autoHideScrollBar 滚动条是否常显模式
		 * 
		 */		
		public function DropDownList(row:int,
									 itemRendererCls:Class,
									 itemSkinCls:Class,
									 scollBarSkin:MovieClip,
									 background:DisplayObject = null,
									 openRendererData:Object = null,
									 autoHideScrollBar:Boolean = true,
									 scollUpBtn:BaseButton = null,
									 scrollDownBtn:BaseButton = null,
									 scrollThumbSkin:InteractiveObject = null,
									 scrollAreaSkin:DisplayObject = null,
									 openItemRenderCls:Class = null,
									 openItemSkinCls:Class = null)
		{
			super();
			
			openItemRenderCls = openItemRenderCls || itemRendererCls;
			openItemSkinCls = openItemSkinCls || itemSkinCls;
			
			m_listBackground = background;
			
			if(itemSkinCls == null)
			{
				m_openRendererItem = new openItemRenderCls(null);
			}
			else
			{
				m_openRendererItem = new openItemRenderCls(new openItemSkinCls());
			}
			m_openRendererItem.row = -1;
			m_openRendererItem.col = -1;
			m_openRendererItem.data = openRendererData;
			
			addChild(m_openRendererItem);
			
			m_list = new DirectionGrid(row, 1, itemRendererCls, itemSkinCls, null);
			m_list.verPageScrollValue = m_openRendererItem.height;
			if((scollUpBtn && scrollDownBtn && scrollThumbSkin && scrollAreaSkin) || scollBarSkin)
			{
				m_srcollBar = new ScrollBar(scollBarSkin, DirectionDef.VERTICAL, false, scollUpBtn, scrollDownBtn, scrollThumbSkin, scrollAreaSkin);
				m_listWindow = new ScrollWindow(m_list, null, m_srcollBar, autoHideScrollBar);
			}
			else
			{
				m_listWindow = new ScrollWindow(m_list, null, null, autoHideScrollBar);
			}
			
			m_list.addEventListener(GridEvent.ITEM_CLICK, onItemClick);
			m_openRendererItem.addEventListener(MouseEvent.CLICK, onOpenItemClick);
		}
		
		/**
		 *销毁函数 用完记得调用 
		 * 
		 */		
		public function destroy():void
		{			
			m_listWindow.destroy();
			
			m_list.removeEventListener(GridEvent.ITEM_CLICK, onItemClick);
			m_openRendererItem.removeEventListener(MouseEvent.CLICK, onOpenItemClick);
		}
		
		public function set listOffsetX(value:int):void
		{
			m_listOffsetX = value;
			m_list.x = m_listOffsetX;
		}
		
		public function get listOffsetX():int
		{
			return m_listOffsetX;
		}
		
		public function set listOffsetY(value:int):void
		{
			m_listOffsetY = value;
			m_list.y = m_listOffsetY;
		}
		
		public function get listOffsetY():int
		{
			return m_listOffsetY;
		}
		
		/**
		 *立即更新显示 
		 * 
		 */		
		public function updateNow():void
		{
			m_srcollBar.updateNow();
			m_list.updateNow();
			m_listWindow.updateNow();
		}
		
		/**
		 *列表开关按钮渲染单元 
		 * @return 
		 * 
		 */		
		public function get openRendererItem():ItemRenderer
		{
			return m_openRendererItem;
		}
		
		/**
		 * 列表弹出窗体部分
		 * @return 
		 * 
		 */		
		public function get listConent():ScrollWindow
		{
			return m_listWindow;
		}
		
		public function get list():DirectionGrid
		{
			return m_list;
		}
		
		/**
		 * 列表开关按钮的Data
		 * @param data
		 * 
		 */		
		public function set openRendererData(data:Object):void
		{
			m_openRendererItem.data = data;
		}
		
		public function get openRendererData():Object
		{
			return m_openRendererItem.data;
		}
		
		/**
		 *列表数据源 
		 * @param value
		 * 
		 */		
		public function set source(value:Array):void
		{
			m_list.source = value;
		}
		
		public function get source():Array
		{
			return m_list.source;
		}
		
		/**
		 *设置列表在开关按钮下方弹出 
		 */		
		protected var localPoint:Point = new Point();
		protected function onOpenItemClick(evt:MouseEvent):void
		{
			var stagePoint:Point;
			var localPoint:Point;
			
			if(m_isOpen == false)
			{	
				//stagePoint = localToGlobal(localPoint);
				
				m_list.updateNow();
				m_listWindow.updateNow();
				
				var bounds:Rectangle = m_openRendererItem.getBounds(stage);
				if(bounds.bottom + m_listBackground.height > LayoutManager.stageHeight)
				{
					m_listBackground.y = bounds.top - m_listBackground.height - 1;
				}
				else
				{
					m_listBackground.y = bounds.bottom + 1;
				}
				
				m_listBackground.x = bounds.left + (bounds.width - m_listBackground.width) / 2;
				m_listWindow.x = m_listBackground.x + (m_listBackground.width - m_listWindow.width) / 2;
				m_listWindow.y = m_listBackground.y + (m_listBackground.height - m_listWindow.height) / 2;
				
				stagePoint = new Point(m_listBackground.x, m_listBackground.y);
				localPoint = LayerManager.singleton.findLayerByName(LayerDef.DROP_DOWN_LIST).globalToLocal(stagePoint);
				m_listBackground.x = localPoint.x;
				m_listBackground.y = localPoint.y;
				
				stagePoint = new Point(m_listWindow.x, m_listWindow.y);
				localPoint = LayerManager.singleton.findLayerByName(LayerDef.DROP_DOWN_LIST).globalToLocal(stagePoint);
				m_listWindow.x = localPoint.x;
				m_listWindow.y = localPoint.y;
				
				LayerManager.singleton.addItemToLayer(m_listBackground, LayerDef.DROP_DOWN_LIST);
				LayerManager.singleton.addItemToLayer(m_listWindow, LayerDef.DROP_DOWN_LIST);
				stage.addEventListener(MouseEvent.CLICK, onStageMouseClick);
			}
			else
			{
				LayerManager.singleton.removeItemToLayer(m_listBackground);
				LayerManager.singleton.removeItemToLayer(m_listWindow);
				stage.removeEventListener(MouseEvent.CLICK, onStageMouseClick);
			}
			
			m_isOpen = !m_isOpen;
		}
		
		private function test():void
		{
			
		}
		
		/**
		 *自动隐藏检查 
		 * @param evt
		 * 
		 */		
		protected function onStageMouseClick(evt:MouseEvent):void
		{
			var target:DisplayObject;
			
			target = evt.target as DisplayObject;
			if(target != this && !this.contains(target) && target != m_listWindow && !m_listWindow.contains(target) && m_listWindow.stage)
			{
				m_listWindow.stage.removeEventListener(MouseEvent.CLICK, onStageMouseClick);
				LayerManager.singleton.removeItemToLayer(m_listBackground);
				LayerManager.singleton.removeItemToLayer(m_listWindow);
				m_isOpen = !m_isOpen;
				this.dispatchEvent(new Event("DropDownList_m_listWindow_reomve"));
			}
		}
		
		/**
		 *渲染单元点击事件 
		 * @param evt
		 * 
		 */		
		protected function onItemClick(evt:GridEvent):void
		{
			this.dispatchEvent(evt);
			
			LayerManager.singleton.removeItemToLayer(m_listBackground);
			LayerManager.singleton.removeItemToLayer(m_listWindow);
			stage.removeEventListener(MouseEvent.CLICK, onStageMouseClick);
			m_isOpen = !m_isOpen;
		}
		}
}