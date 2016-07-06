package com.tencent.morefun.naruto.plugin.exui.tooltip
{

 import com.tencent.morefun.naruto.plugin.exui.item.ItemIcon;
 import com.tencent.morefun.naruto.plugin.ui.tips.BaseTipsView;
 import com.tencent.morefun.naruto.plugin.ui.tooltip.StrengthenInfoItemTooltipUI;
 
 import flash.text.TextFormatAlign;

    import com.tencent.morefun.naruto.i18n.I18n;
    public class StrengthenInfoItemTooltip extends BaseTipsView
    {
        private static const SPACE_X:int                    =   35;
        private static const SPACE_Y:int                    =   15;
        private static const LINE_SPACE_Y:int               =   5;
        private static const EXPIRE_SPACE_Y:int             =   15;
        private static const DESCRIPTION_SPACE_Y:int        =   15;
        private static const BOTTOM_SPACE_Y:int             =   25;
        private static const ICON_W:int                     =   64;
        private static const ICON_H:int                     =   64;
        private static const ICON_X:int                     =   1;
        private static const ICON_Y:int                     =   1;
		
		private static const leftSpace:int = 8;
		private static const rightSpace:int = 10;
		private static const topSpage:int = 11;
		private static const downSpage:int = 11;

        private var _ui:StrengthenInfoItemTooltipUI;
        private var _icon:ItemIcon;
        private var _lineY:int;

        public function StrengthenInfoItemTooltip(skinCls:Class=null)
        {
            _ui = new StrengthenInfoItemTooltipUI();
            _ui.mouseEnabled = false;
            _ui.mouseChildren = false;
            _ui.descriptionText.autoSize = TextFormatAlign.LEFT;

            _icon = new ItemIcon(ICON_W, ICON_H);
            _icon.x = ICON_X;
            _icon.y = ICON_Y;
            _ui.icon.addChild(_icon);

            addChild(_ui);
        }

        override public function destroy():void
        {
            _icon.destroy();
        }

        override public function set data(obj:Object):void
        {
			//name:String,level:String,des:String,currentBuff:String,nextBuff:String,needItem:String
			_ui.nameText.text = obj.name;
			_ui.descriptionText.text = obj.des;
			_ui.currentBuffText.text = obj.currentBuff;
			_ui.nextBuffText.text = obj.nextBuff;
			_ui.needItemInfo.value = obj.needItem+I18n.lang("as_exui_1451031568_1388");
            showIcon(obj.iconid);
        }

        private function showIcon(num:int):void
        {
            _ui.icon.gotoAndStop(num);
        }

   	}
}