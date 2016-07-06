package com.tencent.morefun.naruto.plugin.ui.core
{
	import com.tencent.morefun.naruto.plugin.ui.DropDownListScrollBar_1_Skin;
	import com.tencent.morefun.naruto.plugin.ui.base.DropDownList;
	
	import flash.display.MovieClip;
	
	import naruto.component.controls.Background_10;

	public class CoreDropDownList extends DropDownList
	{
		private static const DEFAULT_CONTENT_OFFSET_X:int = 7;
		private static const DEFAULT_CONTENT_OFFSET_Y:int = 7;
		

		
		private var itemSkinCls:Class;
		private var scrollBarSkinCls:Class;
		private var backgroundSkinCls:Class;

		private var row:int;
		
		private var cellHeight:int;
		private var cellWidth:int;
		private var cellRenderSkin:MovieClip;
		private var backgroundSkin:MovieClip;
		private var scrollBarSkin:MovieClip;
		public function CoreDropDownList(row:int, itemRendererCls:Class, itemSkinCls:Class, openItemRenderCls:Class=null, openItemSkinCls:Class=null, openRendererData:Object=null, scrollBarSkinCls:Class = null, backgroundSkinCls:Class = null, autoHideScrollBar:Boolean=true)
		{
			this.row = row;
			this.itemSkinCls = itemSkinCls;
			this.backgroundSkinCls = backgroundSkinCls || Background_10;
			this.scrollBarSkinCls = scrollBarSkinCls || DropDownListScrollBar_1_Skin;
			
			updateSkinPosition();
			
			super(row, itemRendererCls, itemSkinCls, scrollBarSkin, backgroundSkin, openRendererData, autoHideScrollBar, null, null, null, null, openItemRenderCls, openItemSkinCls);
		}
		
		public function updateCellWidthInfo(value:int):void
		{
			cellWidth = value;
			
			backgroundSkin.width = cellWidth + DEFAULT_CONTENT_OFFSET_X * 2;
			m_listWindow.x = DEFAULT_CONTENT_OFFSET_X;
			m_listWindow.verScrollBar.x = m_listWindow.width - m_listWindow.verScrollBar.width;
		}
		
		private function updateSkinPosition():void
		{
			scrollBarSkin = new scrollBarSkinCls();
			
			cellRenderSkin = new itemSkinCls();
			cellWidth = cellRenderSkin.width;
			cellHeight = cellRenderSkin.height;
			
			backgroundSkin = new backgroundSkinCls();
			backgroundSkin.width = cellWidth + DEFAULT_CONTENT_OFFSET_X * 2;
			backgroundSkin.height = cellHeight * row + DEFAULT_CONTENT_OFFSET_Y * 2;
			
			scrollBarSkin.x = cellWidth - scrollBarSkin.width;
			
			updateScrollBarHeight(cellHeight * row);
		}
		
		private function updateScrollBarHeight(value:int):void
		{
			scrollBarSkin["down"].y = value - scrollBarSkin["down"].height;
			scrollBarSkin["scrollArea"].height = value - scrollBarSkin["up"].height - scrollBarSkin["down"].height;
		}
		}
}