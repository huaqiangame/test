package com.tencent.morefun.naruto.plugin.exui.tooltip
{
    import com.tencent.morefun.naruto.plugin.exui.item.ItemIcon;
    import com.tencent.morefun.naruto.plugin.ui.tips.BaseTipsView;
    import com.tencent.morefun.naruto.plugin.ui.tooltip.GemItemTooltipUI;

    import bag.data.GemItemData;
    import bag.data.ItemData;
    import bag.utils.BagUtils;

    import def.TipsTypeDef;

    public class GemItemTooltip extends BaseTipsView
    {
        private static const SPACE_X:int                    =   30;
        private static const SPACE_Y:int                    =   15;
        private static const NAME_SPACE_Y:int               =   15;
        private static const CONTENT_SPACE_Y:int            =   15;
        private static const BOTTOM_SPACE_Y:int             =   25;
        private static const BG_W:int                       =   260;
		
		private static const leftSpace:int = 8;
		private static const rightSpace:int = 10;
		private static const topSpage:int = 11;
		private static const downSpage:int = 11;

        private var _ui:GemItemTooltipUI;
        private var _icon:ItemIcon;
        private var _lineY:int;

        public function GemItemTooltip(skinCls:Class=null)
        {
            _ui = new GemItemTooltipUI();
            _ui.mouseEnabled = false;
            _ui.mouseChildren = false;
            _ui.content.props.gotoAndStop(1);

            _icon = new ItemIcon();
            _ui.icon.addChild(_icon);

            addChild(_ui);
        }

        override public function destroy():void
        {
            _icon.destroy();
            _icon = null;

            super.destroy();
        }

        override public function set data(value:Object):void
        {
            if (!(value is GemItemData))
                return;

            var itemData:GemItemData = value as GemItemData;

            showName(itemData);
            showContent(itemData);
            showPrice(itemData);
            showIcon(itemData);

            resize();
        }

        private function showName(data:ItemData):void
        {
            _ui.nameText.htmlText = "<b>" + BagUtils.getColoredItemName(data.id) + "</b>";
        }

        private function showContent(data:GemItemData):void
        {
            var propFrame:int = 0;
            var propValue:int = 0;

            for (var i:int=1; i<6; ++i)
            {
                if (data["val" + i] > 0)
                {
                    propFrame = i;
                    propValue = data["val" + i];
                    break;
                }
            }

            _ui.content.props.gotoAndStop(propFrame);
            _ui.content.propValueText.text = "+" + propValue;
            _ui.content.expText.text = data.exp + "/" + data.levelExp;

//            _lineY = _ui.content.y + _ui.content.height + CONTENT_SPACE_Y;
        }

        private function showPrice(data:ItemData):void
        {
//            _ui.price.x = SPACE_X;
//            _ui.price.y = _lineY;

            if (data.price > 0)
            {
                _ui.price.sellable.priceText.text = String(data.price);
                _ui.price.sellable.visible = true;
                _ui.price.priceless.visible = false;
            }
            else
            {
                _ui.price.sellable.priceText.text = "";
                _ui.price.sellable.visible = false;
                _ui.price.priceless.visible = true;
            }
        }

        private function showIcon(data:ItemData):void
        {
            if (data == null)
                return;

            _icon.loadIcon(data.id, data, TipsTypeDef.BAG_ITEM);
        }

		override protected function resize():void
		{
//            var maxWidth:int = _ui.nameText.textWidth;
//            maxWidth = maxWidth > _ui.content.expText.x + _ui.content.expText.textWidth ? maxWidth : _ui.content.expText.x + _ui.content.expText.textWidth;

            _ui.bg.width = BG_W;
            _ui.bg.height = _ui.price.y + _ui.price.height + BOTTOM_SPACE_Y;
			
			this._ui.texture_left.x = leftSpace;
			this._ui.texture_left.y = topSpage;
			this._ui.texture_right.x = this._ui.bg.width - this._ui.texture_right.width - rightSpace;
			this._ui.texture_right.y = this._ui.bg.height - this._ui.texture_right.height - downSpage;
        }
		
   	}
}