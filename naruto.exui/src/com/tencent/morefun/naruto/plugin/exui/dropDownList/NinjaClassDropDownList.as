package com.tencent.morefun.naruto.plugin.exui.dropDownList
{
	import com.tencent.morefun.naruto.plugin.exui.dropDownList.data.NinjaPropertyData;
	import com.tencent.morefun.naruto.plugin.exui.render.NinjaClassDropDownItemRender;
	import com.tencent.morefun.naruto.plugin.ui.core.CoreDropDownList;
	
	import ninja.conf.NinjaDefConfig;
	
	import ui.exui.dropDownList.NinjaClassDropDownItemUI;

	public class NinjaClassDropDownList extends CoreDropDownList
	{
		
		private var _sources:Array;
		
		public function NinjaClassDropDownList()
		{
//			_sources = [-1, 1, 2, 3, 4, 5];
			_sources = new Array();
			_sources.push(new NinjaPropertyData("", -1));
			_sources.push(new NinjaPropertyData(NinjaDefConfig.CATEGORY, 1));
			_sources.push(new NinjaPropertyData(NinjaDefConfig.CATEGORY, 2));
			_sources.push(new NinjaPropertyData(NinjaDefConfig.CATEGORY, 3));
			_sources.push(new NinjaPropertyData(NinjaDefConfig.CATEGORY, 4));
			_sources.push(new NinjaPropertyData(NinjaDefConfig.CATEGORY, 5));
			_sources.push(new NinjaPropertyData(NinjaDefConfig.PROPERTY, 1));
			_sources.push(new NinjaPropertyData(NinjaDefConfig.PROPERTY, 11));
			_sources.push(new NinjaPropertyData(NinjaDefConfig.PROPERTY, 15));
			_sources.push(new NinjaPropertyData(NinjaDefConfig.PROPERTY, 49));
			
			super(6, NinjaClassDropDownItemRender, NinjaClassDropDownItemUI, null, null, _sources[0]);
			NinjaClassDropDownItemRender(openRendererItem).isLabel = true;
			openRendererItem.data = openRendererItem.data;
			this.source = _sources;
		}
		
		public function reset():void
		{
			this.openRendererData = _sources[0];
		}
	}
}