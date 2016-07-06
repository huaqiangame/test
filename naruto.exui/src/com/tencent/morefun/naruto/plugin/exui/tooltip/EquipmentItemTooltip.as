package com.tencent.morefun.naruto.plugin.exui.tooltip
{

    import com.tencent.morefun.naruto.plugin.exui.item.ItemIcon;
    import com.tencent.morefun.naruto.plugin.ui.tips.BaseTipsView;
    import com.tencent.morefun.naruto.plugin.ui.tooltip.EquipmentItemTooltipUI;
    import com.tencent.morefun.naruto.plugin.ui.tooltip.QualityBg_Down_1;
    import com.tencent.morefun.naruto.plugin.ui.tooltip.QualityBg_Down_2;
    import com.tencent.morefun.naruto.plugin.ui.tooltip.QualityBg_Down_3;
    import com.tencent.morefun.naruto.plugin.ui.tooltip.QualityBg_Down_4;
    import com.tencent.morefun.naruto.plugin.ui.tooltip.QualityBg_Down_5;
    import com.tencent.morefun.naruto.plugin.ui.tooltip.QualityBg_Up_1;
    import com.tencent.morefun.naruto.plugin.ui.tooltip.QualityBg_Up_2;
    import com.tencent.morefun.naruto.plugin.ui.tooltip.QualityBg_Up_3;
    import com.tencent.morefun.naruto.plugin.ui.tooltip.QualityBg_Up_4;
    import com.tencent.morefun.naruto.plugin.ui.tooltip.QualityBg_Up_5;
    import com.tencent.morefun.naruto.util.ScaleUtil;
    import com.tencent.morefun.naruto.util.StrReplacer;
    import flash.display.Bitmap;
    import flash.display.Sprite;
    import flash.text.TextField;
    import bag.data.EquipmentItemData;
    import bag.data.GemItemData;
    import bag.utils.BagUtils;
    import base.ApplicationData;
    import def.TipsTypeDef;
    import equipment.utils.EquipmentUtils;

    import com.tencent.morefun.naruto.i18n.I18n;
    public class EquipmentItemTooltip extends BaseTipsView
    {
        private static const VALUE_NUM:int                  =   5;
        private static const FORGE_VALUE_NUM:int            =   5;
        private static const GEM_NUM:int                    =   5;
        private static const SPACE_Y:int                    =   15;
        private static const BOTTOM_SPACE_Y:int             =   35;
        private static const GEMS_BOTTOM_SPACE_Y:int        =   30;
        private static const LABEL_VAL_SPACE_Y:int          =   5;
        private static const BEGIN_Y:int                    =   120;
        private static const GEM_ICON_W:int                 =   28;
        private static const GEM_ICON_H:int                 =   28;
        private static const GEM_ICON_X:int                 =   2;
        private static const GEM_ICON_Y:int                 =   2;

		private static const leftSpace:int = 10;
		private static const rightSpace:int = 12;
		private static const topSpage:int = 14;
		private static const downSpage:int = 13;
		
        private var _ui:EquipmentItemTooltipUI;
        private var _lineY:int;
        private var _hasForgeValue:Boolean;
		private var _icon:ItemIcon;
		private var gemIconList:Vector.<ItemIcon>;
		private var qualityBgDown:Bitmap;
		private var qualityBgUp:Bitmap;
		
        public function EquipmentItemTooltip(skinCls:Class=null)
        {
            _ui = new EquipmentItemTooltipUI();
            _ui.mouseEnabled = false;
            _ui.mouseChildren = false;
            addChild(_ui);

            _icon = new ItemIcon();
            _ui.icon.addChild(_icon);
        }

        override public function destroy():void
        {
			_icon.destroy();
			_icon = null;

            if (this.gemIconList != null)
            {
                for each (var icon:ItemIcon in this.gemIconList)
                    icon.destroy();

                this.gemIconList.length = 0;
            }

			if (this.qualityBgDown)
			{
				this.qualityBgDown.bitmapData.dispose();
				this.qualityBgDown.bitmapData = null;
				this.qualityBgDown = null;
			}
			if (this.qualityBgUp)
			{
				this.qualityBgUp.bitmapData.dispose();
				this.qualityBgUp.bitmapData = null;
				this.qualityBgUp = null;
			}

            super.destroy();
        }

        override public function set data(value:Object):void
        {
            if (!(value is EquipmentItemData))
                return;

            _data = value;

            var itemData:EquipmentItemData = value as EquipmentItemData;
			showIconAndQualityBg(itemData);
            showName(itemData);
            showValues(itemData);
            showForgeValues(itemData);
            showGems(itemData);

            resize();
        }
		
		private function showIconAndQualityBg(data:EquipmentItemData):void
		{
			if (data == null)
			{
				return;
			}
			_icon.loadIcon(data.id, data, TipsTypeDef.BAG_ITEM);
			
			// 品质背景
			switch (data.quality)
			{
				case 1:
					this.qualityBgDown = new Bitmap(new QualityBg_Down_1());
					this.qualityBgUp = new Bitmap(new QualityBg_Up_1());
					break;
				case 2:
                case 3:
					this.qualityBgDown = new Bitmap(new QualityBg_Down_2());
					this.qualityBgUp = new Bitmap(new QualityBg_Up_2());
					break;
				case 4:
                case 5:
					this.qualityBgDown = new Bitmap(new QualityBg_Down_3());
					this.qualityBgUp = new Bitmap(new QualityBg_Up_3());
					break;
				case 6:
                case 7:
					this.qualityBgDown = new Bitmap(new QualityBg_Down_4());
					this.qualityBgUp = new Bitmap(new QualityBg_Up_4());
					break;
				case 8:
                case 9:
					this.qualityBgDown = new Bitmap(new QualityBg_Down_5());
					this.qualityBgUp = new Bitmap(new QualityBg_Up_5());
					break;
			}
			if (this.qualityBgDown)
			{
				this.qualityBgDown.smoothing = true;
				_ui.addChildAt(this.qualityBgDown, _ui.getChildIndex(_ui.bg) + 1);
			}
			if (this.qualityBgUp)
			{
				this.qualityBgUp.smoothing = true;
				_ui.addChildAt(this.qualityBgUp, _ui.getChildIndex(_ui.bg) + 1);
			}
		}

        private function showName(data:EquipmentItemData):void
        {
            _ui.nameText.htmlText = "<b>" + BagUtils.getColoredItemName(data.id) + "</b>";

            var levelStr:String = StrReplacer.replace(TooltipConst.EQUIPMENT_LEVEL_TEXT, data.level);
            _ui.levelText.htmlText = levelStr;

            var forgeStr:String = StrReplacer.replace(TooltipConst.EQUIPMENT_FORGE_TEXT, data.forgeLevel);
            forgeStr = ApplicationData.singleton.selfInfo.level < EquipmentUtils.FORGE_PROP_OPEN_LEVEL ? "" : forgeStr;
            _ui.forgeText.htmlText = forgeStr;

            _lineY = BEGIN_Y;
        }

        private function showValues(data:EquipmentItemData):void
        {
			var htmlText:String = "";
            for (var i:int = 1; i <= VALUE_NUM; ++i)
            {
				var value:int = data["val"+i];
				if (value > 0)
				{
					htmlText += "<font color='#FFFFFF'>" + EquipmentUtils.VAL_LABELS[i - 1] + " +"+value+"</font>";
					var upgradeVal:int = data["upgradeVal"+i];
					if (upgradeVal > 0)
					{
						htmlText += I18n.lang("as_exui_1451031568_1338") + upgradeVal + "）</font>";
					}
					htmlText += "\n";
				}
            }
			_ui.valuesText.htmlText = htmlText;
//			_ui.valuesText.width = _ui.valuesText.textWidth + 4;
			_ui.valuesText.height = _ui.valuesText.textHeight + 4;
			_lineY = _ui.valuesText.y + _ui.valuesText.height + SPACE_Y;
        }
		
		private function getGemBuffTips(data:GemItemData):String
		{
			switch (true)
			{
				case data.val1 > 0:
				{
					return EquipmentUtils.VAL_LABELS[0] + " <font color='#00CE30'>+"+data.val1+"</font>";
				}
				case data.val2 > 0:
				{
					return EquipmentUtils.VAL_LABELS[1] + " <font color='#00CE30'>+"+data.val2+"</font>";
				}
				case data.val3 > 0:
				{
					return EquipmentUtils.VAL_LABELS[2] + " <font color='#00CE30'>+"+data.val3+"</font>";
				}
				case data.val4 > 0:
				{
					return EquipmentUtils.VAL_LABELS[3] + " <font color='#00CE30'>+"+data.val4+"</font>";
				}
				case data.val5 > 0:
				{
					return EquipmentUtils.VAL_LABELS[4] + " <font color='#00CE30'>+"+data.val5+"</font>";
				}
			}
			return "";
		}

        private function showForgeValues(data:EquipmentItemData):void
        {
            _ui.hLine.y = _lineY;
            _ui.forgeLabelText.y = _ui.hLine.y + _ui.hLine.height + SPACE_Y;
            _ui.forgeValuesText.y = _ui.forgeLabelText.y + _ui.forgeLabelText.height + LABEL_VAL_SPACE_Y;

            _hasForgeValue = hasForgeValue(data);

            if (_hasForgeValue)
            {
                var str:String = "";
                var propName:String;
                var propVal:int;
                var qualityColor:String;
                var qualityPercent:int;
                var qualityVal:int;

                for (var i:int=1; i<=FORGE_VALUE_NUM; ++i)
                {
                    propName = EquipmentUtils.FORGE_VAL_LABELS[i - 1];
                    propVal = data["forgePropVal" + i];
                    qualityPercent = data["forgeQualityPercent" + i];
                    qualityVal = data["forgeQualityVal" + i];
                    qualityColor = EquipmentUtils.getForgeQualityColor(qualityPercent).toString(16);

                    str += StrReplacer.replace(TooltipConst.EQUIPMENT_FORGE_PROP_TEXT, [propName, propVal]);

                    if (qualityVal > 0)
                        str += StrReplacer.replace(TooltipConst.EQUIPMENT_FORGE_QUALITY_TEXT, [qualityColor, qualityVal]);

                    str += "\n";
                }

                _ui.hLine.visible = true;
                _ui.forgeLabelText.visible = true;
                _ui.forgeValuesText.htmlText = str;
            }
            else
            {
                _ui.hLine.visible = false;
                _ui.forgeLabelText.visible = false;
                _ui.forgeValuesText.htmlText = "";
            }
        }

        private function hasForgeValue(data:EquipmentItemData):Boolean
        {
            if (data == null)
                return false;

            for (var i:int=1; i<=FORGE_VALUE_NUM; ++i)
            {
                if (data["forgePropVal" + i] > 0)
                    return true;
            }

            return false;
        }

        private function showGems(data:EquipmentItemData):void
        {
            var numGems:int = calcEquippedGemsNum(data);

            if (numGems > 0)
            {
                this.gemIconList = new Vector.<ItemIcon>();

                var gemsText:TextField;
                var gemsIcon:Sprite;
                var gemsList:Vector.<GemItemData> =  data.gems ? data.gems.concat() : null;
                var gemData:GemItemData;

                gemsList.sort(this.sortGemsList);

                for (var i:int=0; i<GEM_NUM; ++i)
                {
                    gemsText = _ui.gems["gems_text_" + i];
                    gemsIcon = _ui.gems["gems_icon_" + i];
                    gemData = gemsList[i];

                    if (gemsList != null && numGems > i && gemData.id > 0)
                    {
                        gemsText.htmlText = BagUtils.getColoredItemName(gemData.id) + "\n" + this.getGemBuffTips(gemData);
                        gemsText.visible = true;
                        gemsIcon.visible = true;

                        var ico:ItemIcon = new ItemIcon(GEM_ICON_W, GEM_ICON_H);
                        ico.x = GEM_ICON_X;
                        ico.y = GEM_ICON_Y;
                        this.gemIconList.push(ico);
                        ico.loadIconByData(gemData, true);
                        gemsIcon.addChild(ico);
                    }
                    else
                    {
                        gemsText.htmlText = "";
                        gemsText.visible = false;
                        gemsIcon.visible = false;
                        if (gemsIcon.parent)
                        {
                            gemsIcon.parent.removeChild(gemsIcon);
                        }
                        if (gemsText.parent)
                        {
                            gemsText.parent.removeChild(gemsText);
                        }
                    }
                }
            }
            else
            {
                if (_ui.gems.parent != null)
                    _ui.removeChild(_ui.gems);

                if (_ui.gemsBg.parent != null)
                    _ui.removeChild(_ui.gemsBg);
            }
        }
		
		private function sortGemsList(a:GemItemData, b:GemItemData):int
		{
			if (a.id > b.id)
			{
				return -1;
			}
			return 1;
		}

        private function calcEquippedGemsNum(data:EquipmentItemData):int
        {
            if (data == null || data.gems == null)
                return 0;

            var len:int = data.gems.length;
            var num:int = 0;

            for (var i:int=0; i<len; ++i)
            {
                if (data.gems[i] != null && data.gems[i].id > 0)
                    num++;
            }

            return num;
        }

        override protected function resize():void
        {
            if (_hasForgeValue)
                _ui.bg.height = _ui.forgeValuesText.y + _ui.forgeValuesText.textHeight + BOTTOM_SPACE_Y;
            else
                _ui.bg.height = _ui.valuesText.y + _ui.valuesText.textHeight + BOTTOM_SPACE_Y;

            _ui.gemsBg.height = _ui.gems.y + _ui.gems.height + GEMS_BOTTOM_SPACE_Y;

			if (this.qualityBgDown)
			{
				ScaleUtil.scaleInBox(this.qualityBgDown, _ui.bg.width - leftSpace - rightSpace, int.MAX_VALUE);
				this.qualityBgDown.x = _ui.bg.width - this.qualityBgDown.width - rightSpace;
				this.qualityBgDown.y = _ui.bg.height - this.qualityBgDown.height - downSpage;
			}
			if (this.qualityBgUp)
			{
				ScaleUtil.scaleInBox(this.qualityBgUp, _ui.bg.width - leftSpace - rightSpace, int.MAX_VALUE);
				this.qualityBgUp.x = leftSpace;
				this.qualityBgUp.y = topSpage;
			}
			
			_ui.texture_left.x = leftSpace;
			_ui.texture_left.y = topSpage;
			_ui.texture_right.x = _ui.bg.width - _ui.texture_right.width - rightSpace;
			_ui.texture_right.y = _ui.bg.height - _ui.texture_right.height - downSpage;
        }

        override public function get height():Number
        {
            var numGems:int = calcEquippedGemsNum(_data as EquipmentItemData);

            if (numGems > 0)
                return _ui.bg.height > _ui.gemsBg.height ? _ui.bg.height : _ui.gemsBg.height;
            else
                return _ui.bg.height;
        }
   	}
}