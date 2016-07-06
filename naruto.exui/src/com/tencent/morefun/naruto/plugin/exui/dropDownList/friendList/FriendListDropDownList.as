package com.tencent.morefun.naruto.plugin.exui.dropDownList.friendList
{
	import com.tencent.morefun.naruto.plugin.ui.DropDownListScrollBar_1_Skin;
	import com.tencent.morefun.naruto.plugin.ui.base.DropDownList;
	import com.tencent.morefun.naruto.plugin.ui.layer.LayerManager;
	import com.tencent.morefun.naruto.plugin.ui.layer.LayoutManager;
	import com.tencent.morefun.naruto.plugin.ui.layer.def.LayerDef;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import ui.exui.dropDownList.DropDownListBackground;
	import ui.exui.dropDownList.FriendInfoRenderUI;

	public class FriendListDropDownList extends DropDownList
	{
		protected var dropDownListBg:DropDownListBackground;
		
		public function FriendListDropDownList(row:int = 7,
											   itemRendererCls:Class = null,
											   itemSkinCls:Class = null)
		{
			var tmpRender:DisplayObject;
			
			(!itemRendererCls) && (itemRendererCls = FriendInfoRender);
			(!itemSkinCls) && (itemSkinCls = FriendInfoRenderUI);
			
			tmpRender = new itemRendererCls(new itemSkinCls());
			
			dropDownListBg = new DropDownListBackground();
			dropDownListBg.width = tmpRender.width;
			dropDownListBg.height = 173;
			
			super(row, itemRendererCls, itemSkinCls, new DropDownListScrollBar_1_Skin(), dropDownListBg);
			this.m_srcollBar.height = 163;
			this.m_srcollBar.x = dropDownListBg.width - this.m_srcollBar.width;
			(openRendererItem as FriendInfoRender).switchToOpenRenderMode();
			
			(tmpRender.hasOwnProperty("destory")) && (tmpRender["destory"]());
			tmpRender = null;
		}
		
		public function showList():void
		{
			var bounds:Rectangle = m_openRendererItem.getBounds(stage);
			if(bounds.bottom + m_listBackground.height > LayoutManager.stageHeight)
			{
				m_listBackground.y = bounds.top - m_listBackground.height - 1;
			}
			else
			{
				m_listBackground.y = bounds.bottom + 1;
			}
			
			m_listBackground.x = bounds.left;
			m_listWindow.x = m_listBackground.x + (m_listBackground.width - m_listWindow.width) / 2;
			m_listWindow.y = m_listBackground.y + (m_listBackground.height - m_listWindow.height) / 2;
			
			LayerManager.singleton.addItemToLayer(m_listBackground, LayerDef.DROP_DOWN_LIST);
			LayerManager.singleton.addItemToLayer(m_listWindow, LayerDef.DROP_DOWN_LIST);
			stage.addEventListener(MouseEvent.CLICK, onStageMouseClick);
			
			m_isOpen = true;
		}
		
		public function hideList():void
		{
			LayerManager.singleton.removeItemToLayer(m_listBackground);
			LayerManager.singleton.removeItemToLayer(m_listWindow);
			stage.removeEventListener(MouseEvent.CLICK, onStageMouseClick);
			
			m_isOpen = false;
			
		}
		
		override protected function onOpenItemClick(evt:MouseEvent):void
		{
		}
		
		override public function set source(value:Array):void
		{
			m_list.source = value;
			m_listWindow.updateNow(); //不加这句首次点开的时候位置会不对；
		}
		
		override public function destroy():void
		{
			(dropDownListBg.parent) && (dropDownListBg.parent.removeChild(dropDownListBg));
			dropDownListBg = null;
			
			super.destroy();
		}
	}
}