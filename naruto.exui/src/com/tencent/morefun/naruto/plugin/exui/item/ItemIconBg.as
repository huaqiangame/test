package com.tencent.morefun.naruto.plugin.exui.item
{
    import com.tencent.morefun.naruto.plugin.exui.ui.ItemIconBgUI;
    
    import flash.display.Sprite;

    public class ItemIconBg extends Sprite
    {
        private var _ui:ItemIconBgUI;

        public function ItemIconBg()
        {
            this.mouseEnabled = true;
            this.mouseChildren = false;

            _ui = new ItemIconBgUI();
            addChild(_ui);
        }

        public function destroy():void
        {
            removeChild(_ui);
            _ui = null;
        }
   	}
}