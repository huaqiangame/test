package com.tencent.morefun.naruto.plugin.exui.tooltip
{
    import com.tencent.morefun.naruto.plugin.exui.item.ItemIcon;
    import com.tencent.morefun.naruto.plugin.ui.tips.BaseTipsView;
    import com.tencent.morefun.naruto.plugin.ui.tooltip.CommonItemTooltipUI;
    import com.tencent.morefun.naruto.util.StrReplacer;

    import flash.text.TextFormatAlign;

    import bag.data.CommonItemData;
    import bag.data.ItemData;
    import bag.utils.BagUtils;

    import base.ApplicationData;

    import def.TipsTypeDef;

    public class CommonItemTooltip extends BaseTipsView
    {
        private static const SPACE_X:int                    =   30;
        private static const SPACE_Y:int                    =   15;
        private static const LINE_SPACE_Y:int               =   5;
        private static const EXPIRE_SPACE_Y:int             =   15;
        private static const DESCRIPTION_SPACE_Y:int        =   15;
        private static const BOTTOM_SPACE_Y:int             =   25;
		
		private static const leftSpace:int = 8;
		private static const rightSpace:int = 10;
		private static const topSpage:int = 11;
		private static const downSpage:int = 11;

        private var _ui:CommonItemTooltipUI;
        private var _icon:ItemIcon;
        private var _lineY:int;

        public function CommonItemTooltip(skinCls:Class=null)
        {
            _ui = new CommonItemTooltipUI();
            _ui.mouseEnabled = false;
            _ui.mouseChildren = false;
            _ui.descriptionText.autoSize = TextFormatAlign.LEFT;

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
            if (!(value is ItemData))
                return;

            var itemData:ItemData = value as ItemData;
            var commonItemData:CommonItemData = value as CommonItemData;

            showName(itemData);
            showUselevel(commonItemData);
            showExpireTime(commonItemData);
            showDescription(itemData);
            showExtraDescription(commonItemData);
            showPrice(itemData);
            showIcon(itemData);

            resize();
        }

        private function showName(data:ItemData):void
        {
            _ui.nameText.htmlText = "<b>" + BagUtils.getColoredItemName(data.id) + "</b>";
        }

        private function showUselevel(data:CommonItemData):void
        {
            if (data != null && data.useLevel > 0)
            {
                _ui.useLevel.useLevelText.htmlText = getUserLevelText(data);
                _ui.useLevel.visible = true;
                _ui.useLevel.x = SPACE_X;
            }
            else
            {
                _ui.useLevel.visible = false;
            }
        }

        private function getUserLevelText(data:CommonItemData):String
        {
            var str:String = "";

            if (ApplicationData.singleton.selfInfo.level < data.useLevel)
                str = "<font color='#" + TooltipConst.COLOR_RED.toString(16) + "'>" + data.useLevel + "</font>";
            else
                str = "<font color='#" + TooltipConst.COLOR_WHITE.toString(16) + "'>" + data.useLevel + "</font>";

            return str;
        }

        private function showExpireTime(data:CommonItemData):void
        {
            if (data != null)
            {
                var str:String = "";
                var timeStr:String = "";

                if (data.usableTime != null && data.usableTime.time > 0)
                {
                    timeStr = getTimeStr(data.usableTime);
                    str += StrReplacer.replace(TooltipConst.COMMON_USABLE_TIME, timeStr);
                }

                if (data.expireTime != null && data.expireTime.time > 0)
                {
                    timeStr = getTimeStr(data.expireTime);
                    str += (str != "" ? "\n" : "") + StrReplacer.replace(TooltipConst.COMMON_EXPIRE_TIME, timeStr);
                }
                else if (data.expireSeconds != 0)
                {
                    timeStr = getTimeStrBySeconds(data.expireSeconds);
                    str += (str != "" ? "\n" : "") + StrReplacer.replace(TooltipConst.COMMON_EXPIRE_TIME, timeStr);
                }

                _ui.expireText.htmlText = str;
                _lineY = str != "" ? _ui.expireText.y + _ui.expireText.textHeight + EXPIRE_SPACE_Y : _ui.expireText.y;
            }
            else
            {
                _ui.expireText.htmlText = "";
                _lineY = _ui.expireText.y;
            }
        }

        private function showDescription(data:ItemData):void
        {
            var description:String = data != null && data.description != null ? data.description : TooltipConst.UNKNOWN;

            _ui.descriptionText.htmlText = description;
            _ui.descriptionText.x = SPACE_X;
            _ui.descriptionText.y = _lineY;

            _lineY = _ui.descriptionText.y + _ui.descriptionText.height + DESCRIPTION_SPACE_Y;
        }

        private function showExtraDescription(data:CommonItemData):void
        {
            _ui.extraDescriptionText.y = _ui.descriptionText.y + _ui.descriptionText.height + LINE_SPACE_Y;

            if (data != null && data.extraDescription != null && data.extraDescription != "" && ApplicationData.singleton.selfInfo.level < data.extraDescriptionLevel)
            {
                _ui.extraDescriptionText.htmlText = data.extraDescription;
                _ui.extraDescriptionText.x = SPACE_X;
                _ui.extraDescriptionText.y = _ui.descriptionText.y + _ui.descriptionText.height + LINE_SPACE_Y;

                _lineY = _ui.extraDescriptionText.y + _ui.extraDescriptionText.height + DESCRIPTION_SPACE_Y;
            }
            else
            {
                _ui.extraDescriptionText.htmlText = "";
                _lineY = _ui.descriptionText.y + _ui.descriptionText.height + DESCRIPTION_SPACE_Y;
            }
        }

        private function showPrice(data:ItemData):void
        {
            _ui.price.x = SPACE_X;
            _ui.price.y = _ui.extraDescriptionText.y + _ui.extraDescriptionText.height + LINE_SPACE_Y;

            if (data.price > 0)
            {
                _ui.price.sellable.priceText.htmlText = "<b>" + data.price + "</b>";
                _ui.price.sellable.visible = true;
                _ui.price.priceless.visible = false;
            }
            else
            {
                _ui.price.sellable.priceText.htmlText = "";
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
            var maxWidth:int = _ui.nameText.x + _ui.nameText.textWidth;
            maxWidth = maxWidth > _ui.expireText.x + _ui.expireText.textWidth ? maxWidth : _ui.expireText.x + _ui.expireText.textWidth;
            maxWidth = maxWidth > _ui.descriptionText.x + _ui.descriptionText.textWidth ? maxWidth : _ui.descriptionText.x + _ui.descriptionText.textWidth;
            maxWidth = maxWidth > _ui.extraDescriptionText.x + _ui.extraDescriptionText.textWidth ? maxWidth : _ui.extraDescriptionText.x + _ui.extraDescriptionText.textWidth;

            _ui.bg.width = maxWidth + SPACE_X;
            _ui.bg.height = _ui.price.y + _ui.price.height + BOTTOM_SPACE_Y;
			
			this._ui.texture_left.x = leftSpace;
			this._ui.texture_left.y = topSpage;
			this._ui.texture_right.x = this._ui.bg.width - this._ui.texture_right.width - rightSpace;
			this._ui.texture_right.y = this._ui.bg.height - this._ui.texture_right.height - downSpage;
        }

        private function getTimeStr(date:Date):String
        {
            if (date == null || date.time == 0)
                return "";

            var hours:String = date.hours < 10 ? "0" + date.hours : date.hours.toString();
            var minutes:String = date.minutes < 10 ? "0" + date.minutes : date.minutes.toString();
            var seconds:String = date.seconds < 10 ? "0" + date.seconds : date.seconds.toString();
            var str:String = StrReplacer.replace(TooltipConst.COMMON_EXPIRE_TIME_FORMAT, [date.fullYear, date.month + 1, date.date, hours, minutes, seconds]);

            return str;
        }

        private function getTimeStrBySeconds(totalSeconds:int):String
        {
            var date:Date = new Date(totalSeconds * 1000);

            return getTimeStr(date);
        }
   	}
}