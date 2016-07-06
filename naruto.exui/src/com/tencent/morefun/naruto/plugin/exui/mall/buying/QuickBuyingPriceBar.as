package com.tencent.morefun.naruto.plugin.exui.mall.buying
{
    import com.tencent.morefun.naruto.plugin.exui.mall.MallConst;
    import com.tencent.morefun.naruto.plugin.exui.ui.QuickBuyingPriceBarUI;
    import com.tencent.morefun.naruto.plugin.ui.tips.TipsManager;
    
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;

    public class QuickBuyingPriceBar
    {
        private static const DIANQUAN_TEXT_OFFSET_X:int             =   36;
        private static const OR_TEXT_OFFSET_X:int                   =   10;
        private static const YUANBAO_TEXT_OFFSET_X:int              =   26;

        private var _ui:QuickBuyingPriceBarUI;
        private var _dianquanIcon:Sprite;
        private var _dianquanPriceText:TextField;
        private var _yuanbaoIcon:Sprite;
        private var _yuanbaoPriceText:TextField;
        private var _orText:TextField;
        private var _dianquanPrice:int;
        private var _yuanbaoPrice:int;

        public function QuickBuyingPriceBar(ui:QuickBuyingPriceBarUI)
        {
            _ui = ui;

            _dianquanIcon = _ui.dianquanIcon;

            _dianquanPriceText = _ui.dianquanPriceText;
            _dianquanPriceText.mouseEnabled = false;
            _dianquanPriceText.autoSize = TextFieldAutoSize.LEFT;

            _yuanbaoIcon = _ui.yuanbaoIcon;

            _yuanbaoPriceText = _ui.yuanbaoPriceText;
            _yuanbaoPriceText.mouseEnabled = false;
            _yuanbaoPriceText.autoSize = TextFieldAutoSize.LEFT;

            _orText = _ui.orText;
            _orText.mouseEnabled = false;

            TipsManager.singleton.binding(_dianquanIcon, MallConst.DIANQUAN);
            TipsManager.singleton.binding(_yuanbaoIcon, MallConst.YUANBAO);
        }

        public function dispose():void
        {
            TipsManager.singleton.unbinding(_dianquanIcon);
            TipsManager.singleton.unbinding(_yuanbaoIcon);
        }

        public function reset():void
        {
            _dianquanPrice = 0;
            _yuanbaoPrice = 0;

            _dianquanPriceText.htmlText = "<b>--</b>";
            _yuanbaoPriceText.htmlText = "<b>--</b>";
        }

        public function set dianquanPrice(value:int):void
        {
            _dianquanPrice = value;
            _dianquanPriceText.htmlText = "<b>" + value + "</b>";

            updatePos();
        }

        public function set yuanbaoPrice(value:int):void
        {
            _yuanbaoPrice = value;
            _yuanbaoPriceText.htmlText = "<b>" + value + "</b>";

            updatePos();
        }

        private function updatePos():void
        {
            if (_dianquanPrice > 0)
            {
                _dianquanIcon.x = 0;
                _dianquanPriceText.x = DIANQUAN_TEXT_OFFSET_X;
                _orText.x = _dianquanPriceText.x + _dianquanPriceText.textWidth + OR_TEXT_OFFSET_X;
                _yuanbaoIcon.x = _orText.x + _orText.textWidth + OR_TEXT_OFFSET_X;
                _yuanbaoPriceText.x = _yuanbaoIcon.x + YUANBAO_TEXT_OFFSET_X;

                _dianquanIcon.visible = true;
                _dianquanPriceText.visible = true;
                _orText.visible = true;
                _yuanbaoIcon.visible = true;
                _yuanbaoPriceText.visible = true;
            }
            else
            {
                _dianquanIcon.x = 0;
                _dianquanPriceText.x = 0;
                _orText.x = 0;
                _yuanbaoIcon.x = 0;
                _yuanbaoPriceText.x = _yuanbaoIcon.x + YUANBAO_TEXT_OFFSET_X;

                _dianquanIcon.visible = false;
                _dianquanPriceText.visible = false;
                _orText.visible = false;
                _yuanbaoIcon.visible = true;
                _yuanbaoPriceText.visible = true;
            }
        }
    }
}