package com.tencent.morefun.naruto.plugin.battle.view.fightOver
{
	import com.tencent.morefun.naruto.plugin.ui.components.layouts.EasyLayout;
	import com.tencent.morefun.naruto.plugin.ui.util.DisplayUtils;
	import flash.display.Sprite;
	
    
    

    public class DamageTeamListView
    {

        private var _list:EasyLayout;

        public function DamageTeamListView(ui:Sprite)
        {
			
            _list = new EasyLayout(DamageTeamCellView, 1, 1, -6, 2);
//            _list.list.vergap = 1;
            _list.scroller.x = 433+180;
            _list.scroller.y = 7;
            _list.scroller.height = 327-37;
            DisplayUtils.replaceDisplay(ui, _list);
        }

        public function finalize():void
        {
            _list.dispose();
        }
		public function setDatas(datas:Array):void 
		{
			_list.dataProvider = datas;
			if (_list.scroller) {
				_list.scroller.value = 0;
			}
		}
		public function changeTab(curModel:int):void 
		{
			for each(var c:Object in _list.layout.items) {
				c.target.changeTab(curModel);
			}
			/*
			if (_list.scroller) {
				_list.scroller.value = 0;
			}*/
			
		}
		
    }
}
