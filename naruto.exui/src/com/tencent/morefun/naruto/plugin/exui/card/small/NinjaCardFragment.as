package com.tencent.morefun.naruto.plugin.exui.card.small
{
    import flash.display.MovieClip;
    import flash.display.Sprite;
    
    import bag.data.CardItemData;

    public class NinjaCardFragment extends Sprite
    {
        private var _ui:MovieClip;

        public function NinjaCardFragment(ui:MovieClip)
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
            _ui.visible = false;
        }

        public function set data(value:CardItemData):void
        {
            if (value == null)
                return;

            _ui.visible = value.isFragment;
        }
   	}
}