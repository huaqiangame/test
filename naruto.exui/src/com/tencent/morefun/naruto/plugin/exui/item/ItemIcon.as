package com.tencent.morefun.naruto.plugin.exui.item
{
    import com.tencent.morefun.naruto.plugin.exui.avatar.Avatar;
    import com.tencent.morefun.naruto.plugin.exui.ui.EquipmentForgeMaxEffectUI;
    import com.tencent.morefun.naruto.plugin.ui.tips.TipsManager;
    
    import flash.display.DisplayObjectContainer;
    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.filters.GlowFilter;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;
    
    import bag.data.EquipmentItemData;
    import bag.data.ItemData;
    import bag.utils.BagUtils;
    
    import crew.data.NinjaPropsInfo;
    
    import def.TipsTypeDef;

    public class ItemIcon extends Avatar
    {
        private static const DEFAULT_ITEM_ICON_WIDTH:int            =   64;
        private static const DEFAULT_ITEM_ICON_HEIGHT:int           =   64;
        private static const FORGE_MAX_EFFECT_X:int                 =   25;
        private static const FORGE_MAX_EFFECT_Y:int                 =   -1;

        public var _equipmentForgeMaxEffect:MovieClip;
        private var _bg:ItemIconBg;
        private var _numText:TextField;

        public function ItemIcon(width:int=DEFAULT_ITEM_ICON_WIDTH, height:int=DEFAULT_ITEM_ICON_HEIGHT, centerAlign:Boolean=false)
        {
            super(width, height, centerAlign);

            this.mouseEnabled = false;
            _container.mouseEnabled = false;
            _container.mouseChildren = false;

            initBg();
            initNumText();
            initForgeMaxEffect();
        }

        override public function destroy():void
        {
            this.removeChild(_bg);
            _bg.destroy();
            _bg = null;

            this.removeChild(_numText);
            _numText = null;

            _equipmentForgeMaxEffect.gotoAndStop(1);
            _equipmentForgeMaxEffect = null;

            super.destroy();
        }

        override public function unload():void
        {
            hideForgeMaxEffect();

            if (_bg != null)
            {
                _bg.alpha = 0;
                TipsManager.singleton.unbinding(_bg);
            }

            if (_numText != null)
                _numText.htmlText = "";

            super.unload();
        }

        public function loadIcon(id:uint, tooltip:Object=null, tooltipType:String=TipsTypeDef.DEFAULT):void
        {
            if (id != 0)
            {
                var url:String = BagUtils.getItemResUrl(id);

                if (url != null && url != _url)
                    _bg.alpha = 1;

                _numText.htmlText = "";

                load(url);

                if (tooltip != null && tooltip != "")
                {
					if (BagUtils.isNinjaPropsItem(id))
					{
						TipsManager.singleton.binding(_bg, (tooltip && tooltip is NinjaPropsInfo)? tooltip : id, TipsTypeDef.NINJA_PROPS);
					}
					else
					{
						TipsManager.singleton.binding(_bg, tooltip, tooltipType);
					}
                }

                playEquipmentForgeMaxEffect(tooltip as EquipmentItemData);
            }
            else
            {
                unload();
            }
        }
		
		public function loadIconWithNum(data:ItemData, showTooltip:Boolean, num:uint):void
		{
			loadIconByData(data, showTooltip, false);
			
			_numText.htmlText = num > 0 ? String(num) : "";
            _numText.visible = true;
		}
		
        public function loadIconByData(data:ItemData, showTooltip:Boolean=false, showNum:Boolean=false):void
        {
            if (data != null && data.id != 0)
            {
                var url:String = BagUtils.getItemResUrl(data.id);

                if (url != null && url != _url)
                    _bg.alpha = 1;

                _numText.htmlText = data.num > 0 ? String(data.num) : "";
                _numText.visible = showNum;

                load(url);

                if (showTooltip)
                {
					if (BagUtils.isNinjaPropsItem(data.id))
					{
						TipsManager.singleton.binding(_bg, data.id, TipsTypeDef.NINJA_PROPS);
					}
					else
					{
						TipsManager.singleton.binding(_bg, data, TipsTypeDef.BAG_ITEM);
					}
                }

                playEquipmentForgeMaxEffect(data as EquipmentItemData);
            }
            else
            {
                unload();
            }
        }

        public function get bg():DisplayObjectContainer
        {
            return _bg;
        }

        override public function get width():Number
        {
            if (_width > 0)
                return _width;
            else
                return super.width;
        }

        override public function get height():Number
        {
            if (_height > 0)
                return _height;
            else
                return super.height;
        }

        override protected function onLoaded(event:Event):void
        {
            super.onLoaded(event);

            _bg.alpha = 0;
            _bg.width = _container.width;
            _bg.height = _container.height;
            _bg.x = _container.x;
            _bg.y = _container.y;

            _numText.width = _container.width - 2;
            _numText.x = _container.x;
            _numText.y = _container.y + _container.height - _numText.height;
        }

        private function initBg():void
        {
            _bg = new ItemIconBg();
            _bg.alpha = 0;

            if (_width > 0 && _height > 0)
            {
                _bg.width = width;
                _bg.height = height;
            }

            this.addChildAt(_bg, this.getChildIndex(_container));
        }

        private function initNumText():void
        {
            var tf:TextFormat = new TextFormat();
            tf.size = 12;
            tf.align = TextFormatAlign.RIGHT;
            tf.font = "SimSun";

            _numText = new TextField();
            _numText.selectable = false;
            _numText.multiline = false;
            _numText.mouseEnabled = false;
            _numText.textColor = 0xFFFFFF;
            _numText.filters = [new GlowFilter(0x000000, 1, 2, 2, 10)];
            _numText.defaultTextFormat = tf;
            _numText.htmlText = "";
            _numText.visible = false;
            _numText.width = _bg.width - 2;
            _numText.height = 18;
            _numText.x = _bg.x;
            _numText.y = _bg.y + _bg.height - _numText.height;

            this.addChild(_numText);
        }

        private function playEquipmentForgeMaxEffect(data:EquipmentItemData):void
        {
            if (data != null && (data.forgeLevelMax > 0 && data.forgeLevel == data.forgeLevelMax))
                showForgeMaxEffect();
            else
                hideForgeMaxEffect();
        }

        private function initForgeMaxEffect():void
        {
            _equipmentForgeMaxEffect = new EquipmentForgeMaxEffectUI();
            _equipmentForgeMaxEffect.mouseEnabled = false;
            _equipmentForgeMaxEffect.mouseChildren = false;
            _equipmentForgeMaxEffect.x = FORGE_MAX_EFFECT_X;
            _equipmentForgeMaxEffect.y = FORGE_MAX_EFFECT_Y;
            _equipmentForgeMaxEffect.gotoAndStop(1);
        }

        private function showForgeMaxEffect():void
        {
            if (_equipmentForgeMaxEffect == null)
                return;

            if (!this.contains(_equipmentForgeMaxEffect))
                this.addChild(_equipmentForgeMaxEffect);

            _equipmentForgeMaxEffect.gotoAndPlay(2);
        }

        private function hideForgeMaxEffect():void
        {
            if (_equipmentForgeMaxEffect == null)
                return;

            if (this.contains(_equipmentForgeMaxEffect))
                this.removeChild(_equipmentForgeMaxEffect);

            _equipmentForgeMaxEffect.gotoAndStop(1);
        }
    }
}