package com.tencent.morefun.naruto.plugin.exui.card
{
    
	import bag.data.BeastFragmentData;
	import bag.data.ItemData;
	import com.tencent.morefun.naruto.plugin.exui.BeastCardUI;
	import com.tencent.morefun.naruto.plugin.exui.item.ItemIcon;
	import flash.display.Sprite;
    public class BeastCardView extends Sprite
    {
        public static const IMG_WIDTH:int                   =   300;
        public static const IMG_HEIGHT:int                  =   410;
        private var _ui:BeastCardUI;
        private var _img:ItemIcon;

        public function BeastCardView()
        {
			
            _img = new ItemIcon(IMG_WIDTH, IMG_HEIGHT);
            _img.x = 0;
            _img.y = 0;
			
            _ui = new BeastCardUI();
			_ui.stop();
            this.addChild(_ui);
            _ui.imageUI.addChild(_img);
        }

        public function dispose():void 
        {

            if (_img.parent) {
				_img.parent.removeChild(_img);
			}
            _img.destroy();
            _img = null;
			
            this.removeChild(_ui);
            _ui = null;
        }
        public function set data(value:ItemData):void
        {
            if (value != null)
            {
                 var url:String = "assets/cardPackage/beastImage/" + BeastFragmentData(value).beastId + ".png";

                _img.load(url);
				_ui.nameTf.visible = true;
				_ui.nameTf.text = value.name;
				_ui.gotoAndStop(value.type);
            }
        }
		public function hideName():void {
			_ui.nameTf.visible = false;
		}

    }
}