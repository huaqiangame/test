package com.tencent.morefun.naruto.plugin.exui.mall.selling
{

 import com.tencent.morefun.naruto.plugin.exui.mall.MallConst;
 import com.tencent.morefun.naruto.plugin.exui.ui.QuickSellingPanelUI;
 import com.tencent.morefun.naruto.plugin.ui.base.event.NumberStepperEvent;
 import com.tencent.morefun.naruto.plugin.ui.box.BaseBox;
 import com.tencent.morefun.naruto.util.StrReplacer;
 
 import flash.events.Event;
 import flash.events.MouseEvent;
 import flash.text.TextField;
 
 import bag.command.SellItemCommand;
 import bag.data.ItemData;
 
 import naruto.component.controls.ButtonClose;
 import naruto.component.controls.ButtonNormalBlue;
 import naruto.component.controls.NumericStepper_1;
 
 import sound.commands.PlayUISoundCommand;
 import sound.def.UISoundDef;

    public class QuickSellingPanel extends BaseBox
    {
        private static const MIN_NUM:int        =   1;
        private static const MAX_NUM:int        =   999;
        private static const ITEM_X:int         =   70;
        private static const ITEM_Y:int         =   65;

        private var _ui:QuickSellingPanelUI;
        private var _priceText:TextField;
        private var _closeButton:ButtonClose;
        private var _okButton:ButtonNormalBlue;
        private var _cancelButton:ButtonNormalBlue;
        private var _data:ItemData;
        private var _numStepper:NumericStepper_1;
        private var _item:QuickSellingItemCell;
        private var _labelText:TextField;

        public function QuickSellingPanel()
        {
            _ui = new QuickSellingPanelUI();
            super(_ui, true, true, true, 5, this.name);

            _ui.closeButton.addEventListener(MouseEvent.CLICK, onClose);

            _okButton = _ui.okButton;
            _okButton.addEventListener(MouseEvent.CLICK, onOk);

            _cancelButton = _ui.cancelButton;
            _cancelButton.addEventListener(MouseEvent.CLICK, onCancel);

            _priceText = _ui.priceText;

            _numStepper = _ui.numStepper;
            _numStepper.min = MIN_NUM;
            _numStepper.max = MAX_NUM;
            _numStepper.editable = true;
            _numStepper.addEventListener(Event.CHANGE, onNumberChanged);

            _item = new QuickSellingItemCell(_ui.item);

            _labelText = _ui.labelText;
            _labelText.mouseEnabled = false;
            _labelText.htmlText = "";
        }

        override public function destroy():void 
        {
            _ui.closeButton.removeEventListener(MouseEvent.CLICK, onClose);
            _ui.closeButton.dispose();

            _ui.background.dispose();
            _ui.header.dispose();

            _okButton.removeEventListener(MouseEvent.CLICK, onOk);
            _okButton.dispose();
            _okButton = null;

            _cancelButton.removeEventListener(MouseEvent.CLICK, onCancel);
            _cancelButton.dispose();
            _cancelButton = null;

            _numStepper.removeEventListener(NumberStepperEvent.NUMBER_STEPPER_VALUE_CHANGED, onNumberChanged);
            _numStepper.dispose();
            _numStepper = null;

            _item.dispose();
            _item = null;

            _labelText = null;

            super.destroy();
        }

        override public function get name():String
        {
            return "QuickSellingPanel";
        }

        public function open(data:ItemData):void
        {
            if (data == null || data.id == 0)
                return;

            _data = data;
            _numStepper.max = _data.num > _numStepper.min ? _data.num : _numStepper.min;
            _numStepper.value = _numStepper.min;
            _item.data = _data;
            _labelText.htmlText = getSellingLabel(_data.num);

            updatePrice(_data.price, _numStepper.value);

            show();
        }

        override public function close():void
        {
            _item.data = null;
            super.close();
        }

        private function onClose(event:MouseEvent):void
        {
            close();
        }

        private function onOk(event:MouseEvent):void
        {
            if (_data == null)
                return;

            new PlayUISoundCommand(UISoundDef.BUTTON_CLICK).call();
            close();

            var cmd:SellItemCommand = new SellItemCommand(_data, _numStepper.value);
            cmd.call();
        }

        private function onCancel(event:MouseEvent):void
        {
            new PlayUISoundCommand(UISoundDef.CANCEL_OR_CLOSE_BUTTON_CLICK).call();
            close();
        }

        private function onNumberChanged(event:Event):void
        {
            if (_data == null)
                return;

            updatePrice(_data.price, _numStepper.value);
        }

        private function updatePrice(price:int, num:int):void
        {
            _priceText.htmlText = "<b>" + (price * num) + "</b>";
        }

        private function getSellingLabel(num:int):String
        {
            var str:String = StrReplacer.replace(MallConst.QUICK_SELLING_LABEL, num);
            return str;
        }	
		
	}
}