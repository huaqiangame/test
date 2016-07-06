package com.tencent.morefun.naruto.plugin.exui.card.small
{
    import flash.display.MovieClip;
    import flash.display.Sprite;
    
    import bag.data.CardItemData;

    public class NinjaCardFg extends Sprite
    {
        private var _ui:MovieClip;
        private var _data:CardItemData;
        private var _frame:MovieClip;
        private var _ninjaType:MovieClip;
        private var _ninjaTypeStrip:MovieClip;
        private var _rare:MovieClip;

        public function NinjaCardFg(ui:MovieClip)
        {
            _ui = ui;
            _ui.mouseEnabled = false;
            _ui.mouseChildren = false;

            _ninjaType = _ui.ninjaType;
            _ninjaTypeStrip = _ui.ninjaTypeStrip;
            _frame = _ui.frame;
            _rare = _ui.rare;

            reset();

            // Don't show these~
            _ninjaType.visible = false;
            _ninjaTypeStrip.visible = false;
            _rare.visible = false;
        }

        public function destroy():void
        {
            reset();

            _ui = null;
            _data = null;
            _frame = null;
            _ninjaType = null;
            _ninjaTypeStrip = null;
            _rare = null;
        }

        public function reset():void
        {
            _ninjaType.gotoAndStop(1);
            _ninjaTypeStrip.gotoAndStop(1);
            _frame.gotoAndStop(1);
            _rare.gotoAndStop(1);
            _ui.filters = [];
        }

        public function set data(value:CardItemData):void
        {
            _data = value;

//            _ninjaType.gotoAndStop(_data.ninjaType);
//            _ninjaTypeStrip.gotoAndStop(_data.ninjaType);
//            _ninjaTypeStrip.visible = _data.rare > 3;
//            _rare.gotoAndStop(_data.rare);

            _frame.gotoAndStop(_data.rare);

//            if (value.isFragment)
//                _ui.filters = GrayUtils.getGrayFilter();
//            else
//                _ui.filters = [];
        }
  	}
}