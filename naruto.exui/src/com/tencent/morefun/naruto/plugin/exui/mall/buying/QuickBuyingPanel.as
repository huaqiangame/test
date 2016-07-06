package com.tencent.morefun.naruto.plugin.exui.mall.buying
{
    import com.tencent.morefun.framework.base.CommandEvent;
    import com.tencent.morefun.naruto.plugin.exui.mall.MallConst;
    import com.tencent.morefun.naruto.plugin.exui.ui.QuickBuyingPanelUI;
    import com.tencent.morefun.naruto.plugin.ui.box.BaseBox;
    import com.tencent.morefun.naruto.plugin.ui.util.VipUtil;
    
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    
    import bag.data.ItemData;
    
    import cardPackage.command.BuyShopItemCommand;
    import cardPackage.command.ShopRefreshItemsDataCommand;
    import cardPackage.command.ShowChargeBoxCommand;
    import cardPackage.data.ShopItemData;
    
    import naruto.component.controls.NumericStepper_1;
    import naruto.component.core.BaseButton;
    
    public class QuickBuyingPanel extends BaseBox
    {
        public static const MIN_NUM:int         =   1;
        public static const MAX_NUM:int         =   999;

        private var _ui:QuickBuyingPanelUI;
        private var _closeButton:BaseButton;
        private var _buyButton:BaseButton;
        private var _item:QuickBuyingItemBox;
        private var _labelText:TextField;
        private var _numStepper:NumericStepper_1;
        private var _priceBar:QuickBuyingPriceBar;
        private var _data:ItemData;
        private var _shopItemData:ShopItemData;
        private var _onSuccess:Function;
        private var _onFailed:Function;

        public function QuickBuyingPanel()
        {
            _ui = new QuickBuyingPanelUI();
            super(_ui, true, true, true, 5, this.name);

            _closeButton = _ui.closeButton;
            _closeButton.addEventListener(MouseEvent.CLICK, onClose);

            _buyButton = _ui.buyButton;
            _buyButton.addEventListener(MouseEvent.CLICK, onBuy);

            _item = new QuickBuyingItemBox(_ui.item);

            _labelText = _ui.labelText;
            _labelText.mouseEnabled = false;

            _numStepper = _ui.numStepper;
            _numStepper.min = MIN_NUM;
            _numStepper.max = MAX_NUM;
            _numStepper.editable = true;
            _numStepper.addEventListener(Event.CHANGE, onNumChange);

            _priceBar = new QuickBuyingPriceBar(_ui.priceBar);

            reset();
        }

        override public function destroy():void
        {
            _closeButton.removeEventListener(MouseEvent.CLICK, onClose);
            _closeButton.dispose();
            _closeButton = null;

            _ui.background.dispose();

            _buyButton.removeEventListener(MouseEvent.CLICK, onBuy);
            _buyButton.dispose();
            _buyButton = null;

            _numStepper.removeEventListener(Event.CHANGE, onNumChange);
            _numStepper.dispose();
            _numStepper = null;

            _item.destroy();
            _item = null;

            _priceBar.dispose();
            _priceBar = null;

            super.destroy();
        }

        public function reset():void
        {
            _item.reset();
            _labelText.htmlText = "";
            _numStepper.value = _numStepper.min;
            _priceBar.reset();
            _buyButton.enabled = false;

            _data = null;
            _shopItemData = null;
        }

        override public function get name():String
        {
            return "QuickBuyingPanel";
        }

        public function set label(value:String):void
        {
            _labelText.htmlText = "<b>" + value + "</b>";
        }

        public function set onSuccess(func:Function):void
        {
            _onSuccess = func;
        }

        public function set onFailed(func:Function):void
        {
            _onFailed = func;
        }

        public function open(data:ItemData):void
        {
            if (data == null || data.id == 0)
                return;

            _data = data;

            _buyButton.enabled = true;
            _item.data = _data;

            updateNum();
            requestShopItemData(_data.id);

            show();
        }

        private function updateNum():void
        {
            if (_data == null)
                return;

            _numStepper.value = _data.num > _numStepper.min ? _data.num : _numStepper.min;
        }

        private function onNumChange(event:Event):void
        {
            if (_data == null || _shopItemData == null)
                return;

            _data.num = _numStepper.value;
            updatePrice();
        }

        private function updatePrice():void
        {
            if (_data != null && _shopItemData != null)
            {
                var discount:Boolean = VipUtil.hasDiscount();
                var yuanbaoPrice:int = discount ? _shopItemData.goodsVipPrice : _shopItemData.goodsNormalPrice;
                var dianquanPrice:int = discount ? _shopItemData.goodsVipPrice : _shopItemData.goodsCashPrice;
                var num:int = _data.num;
//TODO: 10800001
//if (_shopItemData.goodsItemId == 10800001)取消小喇叭特殊处理
//    dianquanPrice = 0;
////
                _priceBar.dianquanPrice = dianquanPrice * num;
                _priceBar.yuanbaoPrice = yuanbaoPrice * num;
            }
            else
            {
                _priceBar.reset();
            }
        }

        private function requestShopItemData(id:uint):void
        {
            var cmd:ShopRefreshItemsDataCommand = new ShopRefreshItemsDataCommand();
            cmd.addEventListener(CommandEvent.FAILD, onShopItemData);
            cmd.addEventListener(CommandEvent.FINISH, onShopItemData);
            cmd.itemId = id;

            cmd.call();
        }

        private function onShopItemData(event:CommandEvent):void
        {
            var cmd:ShopRefreshItemsDataCommand = event.currentTarget as ShopRefreshItemsDataCommand;
            cmd.removeEventListener(CommandEvent.FAILD, onShopItemData);
            cmd.removeEventListener(CommandEvent.FINISH, onShopItemData);

            _shopItemData = cmd.itemData;
            updatePrice();
        }

        private function onClose(event:MouseEvent):void
        {
            close();
        }

        private function onBuy(event:MouseEvent):void
        {
            if (_data == null || _data.id == 0 || _data.num <= 0)
                return;

            _buyButton.enabled = false;

            var data:ShopItemData = new ShopItemData();
            data.goodsItemId = _data.id;
            data.m_currentNum = _data.num;

            var cmd:BuyShopItemCommand = new BuyShopItemCommand();
            cmd.addEventListener(CommandEvent.FINISH, onBuyResult);
            cmd.addEventListener(CommandEvent.FAILD, onBuyResult);
            cmd.data = data;
            cmd.call();
        }

        private function onBuyResult(event:CommandEvent):void
        {
            var cmd:BuyShopItemCommand = event.target as BuyShopItemCommand;
            cmd.removeEventListener(CommandEvent.FINISH, onBuyResult);
            cmd.removeEventListener(CommandEvent.FAILD, onBuyResult);

            close();

            if (event.type == CommandEvent.FINISH)
            {
                if (_onSuccess != null)
                    _onSuccess();
            }
            else if (event.type == CommandEvent.FAILD)
            {
                if (_onFailed != null)
                    _onFailed(cmd.errorCode);

                if (cmd.errorCode == MallConst.ERROR_CODE_NOT_ENOUGH_YUANBAO)
                    showChargeBox();
            }
        }

        private function showChargeBox():void
        {
            var cmd:ShowChargeBoxCommand = new ShowChargeBoxCommand();
            cmd.call();
        }
    }
}