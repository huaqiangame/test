package com.tencent.morefun.naruto.plugin.exui.card.large
{
    import com.tencent.morefun.naruto.plugin.exui.card.ui.LargeNinjaCardBgUI;
    
    import flash.display.DisplayObject;
    
    import bag.data.CardItemData;

    public class NinjaPreviewCardBg
    {
        private var _ui:LargeNinjaCardBgUI;

        public function NinjaPreviewCardBg(ui:LargeNinjaCardBgUI)
        {
            _ui = ui;
            _ui.mouseEnabled = false;
            _ui.mouseChildren = false;
            _ui.gotoAndStop(1);
        }

        public function dispose():void
        {
            _ui = null;
        }

        public function reset():void
        {
        }

        public function set data(value:CardItemData):void
        {
            if (value == null)
                return;

            _ui.gotoAndStop(value.ninjaType);
        }

        public function get ui():DisplayObject
        {
            return _ui;
        }
    }
}