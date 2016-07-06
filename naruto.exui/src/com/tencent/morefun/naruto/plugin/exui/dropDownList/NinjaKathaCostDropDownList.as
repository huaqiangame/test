package com.tencent.morefun.naruto.plugin.exui.dropDownList
{
	import com.tencent.morefun.naruto.plugin.exui.render.KathaCostDropDownItemRender;
	import com.tencent.morefun.naruto.plugin.ui.core.CoreDropDownList;
	
	import ui.exui.dropDownList.DropDownListBackground;
	import ui.exui.dropDownList.StartLeveRightUI;

	public class NinjaKathaCostDropDownList extends CoreDropDownList
	{
		private var dropDownListBg:DropDownListBackground;
		private var _sources:Array = [-1,0,20,40,60,80,100];
		
		public function NinjaKathaCostDropDownList()
		{
			super(6, KathaCostDropDownItemRender, StartLeveRightUI, null, null, _sources[0]);
			updateCellWidthInfo(70);
			
			KathaCostDropDownItemRender(openRendererItem).isLabel = true;
			openRendererItem.data = openRendererItem.data;
			openRendererItem.skin["bg"]["bg"].width = 70;
			this.source = _sources;
		}
		
		public function reset():void
		{
			this.openRendererData = _sources[0];
		}
	}
}