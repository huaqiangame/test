package com.tencent.morefun.naruto.plugin.exui.tooltip
{

    import com.tencent.morefun.naruto.plugin.exui.item.ItemIcon;
    import com.tencent.morefun.naruto.plugin.ui.tips.BaseTipsView;
    import com.tencent.morefun.naruto.plugin.ui.tooltip.BeastRuneItemTooltipUI;
    
    import flash.text.TextFieldAutoSize;
    
    import bag.data.BeastRuneData;
    import bag.data.ItemData;
    import bag.utils.BagUtils;
    
    import def.TipsTypeDef;

    import com.tencent.morefun.naruto.i18n.I18n;
    public class BeastRuneTooltip extends BaseTipsView
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

        private var _ui:BeastRuneItemTooltipUI;
        private var _icon:ItemIcon;
        private var _lineY:int;

        public function BeastRuneTooltip(skinCls:Class=null)
        {
            _ui = new BeastRuneItemTooltipUI();
            _ui.mouseEnabled = false;
            _ui.mouseChildren = false;
            _ui.contentText.text = "";
			_ui.contentText.autoSize = TextFieldAutoSize.LEFT;

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
            if (!(value is BeastRuneData))
                return;

            var itemData:BeastRuneData = value as BeastRuneData;

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

		private static const VAL_LABELS:Array = [I18n.lang("as_exui_1451031568_1274_0"),I18n.lang("as_exui_1451031568_1274_1"),I18n.lang("as_exui_1451031568_1274_2"),I18n.lang("as_exui_1451031568_1274_3"),I18n.lang("as_exui_1451031568_1274_4")];
        private function showContent(data:BeastRuneData):void
        {
			var html:String = "";
			for(var i:int=1;i<6;i++)
			{
				if (data["val" + i] > 0)
				{
					if(html!="")
					{
						html += "\n";
					}
					html += "<font color='#E9E499'>" + VAL_LABELS[i-1] + "</font> <font color='#00FF00'>+" + data["val" + i] + "</font>";
				}
			}
			if(html!="")
			{
				html += "\n";
			}
			html += I18n.lang("as_exui_1451031568_1275") + data.exp + "/" + data.levelExp;
			_ui.contentText.htmlText = html;
        }

        private function showPrice(data:ItemData):void
        {
            if (data.price > 0)
            {
                _ui.price.sellable.priceText.htmlText = "<b>" + data.price + "</b>";
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
			_ui.price.y = _ui.contentText.y + _ui.contentText.textHeight + SPACE_Y;
            _ui.bg.width = BG_W;
            _ui.bg.height = _ui.price.y + _ui.price.height + BOTTOM_SPACE_Y;
			
			this._ui.texture_left.x = leftSpace;
			this._ui.texture_left.y = topSpage;
			this._ui.texture_right.x = this._ui.bg.width - this._ui.texture_right.width - rightSpace;
			this._ui.texture_right.y = this._ui.bg.height - this._ui.texture_right.height - downSpage;
        }
		
   	}
}