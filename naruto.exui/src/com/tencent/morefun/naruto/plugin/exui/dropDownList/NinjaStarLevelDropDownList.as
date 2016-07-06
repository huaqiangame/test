package com.tencent.morefun.naruto.plugin.exui.dropDownList
{
	import com.tencent.morefun.naruto.plugin.exui.render.StarLevelDropDownItemRender;
	import com.tencent.morefun.naruto.plugin.ui.core.CoreDropDownList;
	
	import flash.events.MouseEvent;
	
	import ui.exui.dropDownList.DropDownListBackground;
	import ui.exui.dropDownList.StartLeveRightUI;

	public class NinjaStarLevelDropDownList extends CoreDropDownList
	{
		private var dropDownListBg:DropDownListBackground;
		private var _sources:Array = [-1,0,1,2,3,4];
		
		public function NinjaStarLevelDropDownList()
		{
			super(6, StarLevelDropDownItemRender, StartLeveRightUI, null, null, _sources[0]);
			updateCellWidthInfo(52);
			
			StarLevelDropDownItemRender(openRendererItem).isLabel = true;
			openRendererItem.data = openRendererItem.data;
			openRendererItem.skin["bg"]["bg"].width = 52;
			this.source = _sources;
			
			listOffsetX = -8;
		}
		
		public function reset():void
		{
			this.openRendererData = _sources[0];
		}
		
		override protected function onOpenItemClick(evt:MouseEvent):void
		{
			super.onOpenItemClick(evt);
			m_listBackground.x -= 8;
		}
	}
}