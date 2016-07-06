package com.tencent.morefun.naruto.plugin.exui.mall.selling
{
    import com.tencent.morefun.naruto.plugin.exui.item.ItemIcon;
    import com.tencent.morefun.naruto.plugin.exui.ui.QuickSellingItemCellUI;
    import com.tencent.morefun.naruto.plugin.ui.tips.TipsManager;

    import flash.display.Sprite;
    import flash.text.TextField;

    import bag.data.CommonItemData;
    import bag.data.ItemData;
    import bag.utils.BagUtils;

    import def.TipsTypeDef;

    public class QuickSellingItemCell
    {
        private static const FRAME_X:int            =   -2;
        private static const FRAME_Y:int            =   -2;
        private static const FRAME_W:int            =   82;
        private static const FRAME_H:int            =   96;
        private static const EXPIRE_ALPHA:Number    =   0.5;

        private var _ui:QuickSellingItemCellUI;
        private var _data:ItemData;
        private var _img:ItemIcon;
        private var _numText:TextField;
        private var _nameText:TextField;
        private var _expire:Sprite;

        public function QuickSellingItemCell(ui:QuickSellingItemCellUI)
        {
            _ui = ui;

            _img = new ItemIcon(this.imageWidth, this.imageHeight);
            _img.x = this.imageX;
            _img.y = this.imageY;
            _ui.img.mouseEnabled = false;
            _ui.img.mouseChildren = false;
            _ui.img.addChild(_img);

            _numText = _ui.numText;
            _numText.mouseEnabled = false;
            _numText.htmlText = "";

            _nameText = _ui.nameText;
            _nameText.mouseEnabled = false;
            _nameText.htmlText = "";

            _expire = _ui.expire;
            _expire.mouseEnabled = false;
            _expire.mouseChildren = false;
            _expire.visible = false;
        }

        public function dispose():void
        {
            TipsManager.singleton.unbinding(_ui);

            _ui.img.removeChild(_img);
            _img.destroy();
            _img = null;

            _numText = null;
            _nameText = null;
            _expire = null;

            _ui = null;
            _data = null;
        }

        public function reset():void
        {
            TipsManager.singleton.unbinding(_ui);

            _img.unload();
            _img.alpha = 1;

            _expire.alpha = 1;
            _expire.visible = false;

            _numText.htmlText = "";
            _nameText.htmlText = "";

            _data = null;
        }

        public function get data():Object
        {
            return _data;
        }

        public function set data(value:Object):void
        {
            if (value is ItemData && value.id != 0)
            {
                _data = value as ItemData;

                _img.loadIconByData(_data);
//                _numText.htmlText = _data.num > 0 ? String(_data.num) : "";

                TipsManager.singleton.binding(_ui, _data, TipsTypeDef.BAG_ITEM);

                if (_data is CommonItemData)
                {
                    var commonItemData:CommonItemData = _data as CommonItemData;
                    var expireable:Boolean = commonItemData.expireTime != null && commonItemData.expireTime.time > 0;
                    var expired:Boolean = expireable && commonItemData.expireSeconds <= 0;

                    _img.alpha = expired ? EXPIRE_ALPHA : 1;
                    _expire.alpha = expired ? EXPIRE_ALPHA : 1;
                    _expire.visible = expireable;
                }
                else
                {
                    _img.alpha = 1;
                    _expire.alpha = 1;
                    _expire.visible = false;
                }

                var nameStr:String = BagUtils.getColoredItemName(_data.id);
                _nameText.htmlText = (nameStr != null ? nameStr : "--");
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