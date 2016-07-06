package com.tencent.morefun.naruto.plugin.exui.card.small
{
    import flash.display.MovieClip;
    import flash.display.Sprite;
    
    import bag.data.CardItemData;

    public class NinjaCardBg extends Sprite
    {
        private var _ui:MovieClip;

        public function NinjaCardBg(ui:MovieClip)
        {
            _ui = ui;
            _ui.mouseEnabled = false;
            _ui.mouseChildren = false;
        }

        public function destroy():void
        {
            reset();

            _ui = null;
        }

        public function reset():void
        {
            _ui.filters = [];
            _ui.gotoAndStop(1);
        }

        public function set data(value:CardItemData):void
        {
            if (value == null)
                return;

//            if (value.isFragment)
//                _ui.filters = GrayUtils.getGrayFilter();
//            else
//                _ui.filters = [];

            _ui.gotoAndStop(value.ninjaType);
        }
   	}
}