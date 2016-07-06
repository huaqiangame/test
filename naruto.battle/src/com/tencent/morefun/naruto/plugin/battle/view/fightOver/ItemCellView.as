package com.tencent.morefun.naruto.plugin.battle.view.fightOver
{
	import bag.data.ItemData;
	import bag.utils.BagUtils;
	import com.tencent.morefun.naruto.plugin.exui.item.ItemIcon;
	import com.tencent.morefun.naruto.plugin.ui.tips.TipsManager;
	import def.TipsTypeDef;
	import flash.display.MovieClip;
	import flash.text.TextField;

    public class ItemCellView 
    {
        private var _ui:MovieClip;
        private var _data:ItemData;
        private var _img:ItemIcon;
        private var _numText:TextField;
        private var _nameText:TextField;

        public function ItemCellView(ui:MovieClip)
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

			_ui.mouseChildren = false;
        }

        public function dispose():void
        {
            _ui.img.removeChild(_img);
            _img.destroy();
            _img = null;

            _ui = null;
        }

        public function reset():void
        {
            _img.unload();
            _img.alpha = 1;

            _numText.htmlText = "";
            _nameText.htmlText = "";

            _data = null;
			TipsManager.singleton.unbinding(_ui);
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
                _numText.htmlText = _data.num > 0 ? String(_data.num) : "";


                var nameStr:String = BagUtils.getColoredItemName(value.id);
                _nameText.htmlText = nameStr != null ? nameStr : "";
				
				TipsManager.singleton.binding(_ui, _data, TipsTypeDef.BAG_ITEM);
            }
            else
            {
                reset();
            }

        }

         public function get width():Number
        {
            return 79;
        }

         public function get height():Number
        {
            return 93;
        }

        protected function get imageX():int
        {
            return 6;
        }

        protected function get imageY():int
        {
            return 5;
        }

        protected function get imageWidth():int
        {
            return 64;
        }

        protected function get imageHeight():int
        {
            return 64;
        }															
		public function autoSetNull():void
		{

			_ui = null;
			_data = null;
			_img = null;
			_numText = null;
			_nameText = null;
		}
	}
}