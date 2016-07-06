package com.tencent.morefun.naruto.plugin.exui.mall.buying
{
    import com.tencent.morefun.naruto.plugin.exui.item.ItemIcon;
    import com.tencent.morefun.naruto.plugin.exui.ui.QuickBuyingItemBoxUI;
    
    import flash.text.TextField;
    
    import bag.data.ItemData;
    import bag.utils.BagUtils;
    
    import def.TipsTypeDef;

    public class QuickBuyingItemBox
    {
        private var _data:ItemData;
        private var _ui:QuickBuyingItemBoxUI;
        private var _img:ItemIcon;
        private var _nameText:TextField;

        public function QuickBuyingItemBox(ui:QuickBuyingItemBoxUI, imageWidth:int=0, imageHeight:int=0, imageX:int=0, imageY:int=0)
        {
            _ui = ui;

            _img = new ItemIcon(this.imageWidth, this.imageHeight);
            _img.x = this.imageX;
            _img.y = this.imageY;
            _ui.addChild(_img);

            _nameText = _ui.nameText;
            if (_nameText != null)
                _nameText.htmlText = "";
        }

        public function destroy():void
        {
            _ui.removeChild(_img);
            _img.destroy();
        }

        public function reset():void
        {
            _img.unload();

            if (_nameText != null)
                _nameText.htmlText = "";

            _data = null;
        }

        public function get data():ItemData
        {
            return _data;
        }

        public function set data(value:ItemData):void
        {
            if (value != null && value.id > 0)
            {
                _data = value;
                _img.loadIcon(value.id, value, TipsTypeDef.BAG_ITEM);

                if (_nameText != null)
                {
                    var nameStr:String = BagUtils.getColoredItemName(_data.id);
                    _nameText.htmlText = (nameStr != null ? nameStr : "--");
                }
            }
            else
            {
                reset();
            }
        }

        private function get imageX():int
        {
            return 6;
        }

        private function get imageY():int
        {
            return 5;
        }

        private function get imageWidth():int
        {
            return 64;
        }

        private function get imageHeight():int
        {
            return 64;
        }
    }
}