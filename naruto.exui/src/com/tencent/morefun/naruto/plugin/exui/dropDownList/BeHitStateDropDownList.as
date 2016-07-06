package com.tencent.morefun.naruto.plugin.exui.dropDownList
{
	import com.tencent.morefun.naruto.plugin.exui.dropDownList.data.BeHitStateData;
	import com.tencent.morefun.naruto.plugin.exui.render.BeHitStateDownItemRender;
	import com.tencent.morefun.naruto.plugin.ui.core.CoreDropDownList;
	import ui.exui.dropDownList.StartLeveRightUI;

	public class BeHitStateDropDownList extends CoreDropDownList
	{
		private var _sources:Array;
		
		public function BeHitStateDropDownList()
		{
			_sources = [];
			_sources.push(newData(-1,0));
			_sources.push(newData(2,0));
			_sources.push(newData(3,0));
			_sources.push(newData(1,0));
			_sources.push(newData(7,0));
			_sources.push(newData(10,2));
			_sources.push(newData(10,1));
			_sources.push(newData(10,6));
			_sources.push(newData(10,4));
			_sources.push(newData(9,0));
			_sources.push(newData(10,8));
			_sources.push(newData(4,-1));
			
			super(5, BeHitStateDownItemRender, StartLeveRightUI, null, null, _sources[0]);
			updateCellWidthInfo(85);
			
			BeHitStateDownItemRender(openRendererItem).isLabel = true;
			openRendererItem.data = openRendererItem.data;
			openRendererItem.skin["bg"]["bg"].width = 90;
			this.source = _sources;
		}
		
		private function newData(state:int, param:int):BeHitStateData 
		{
			return new BeHitStateData(state, param);
		}
	}
}
