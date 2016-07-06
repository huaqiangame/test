package com.tencent.morefun.naruto.plugin.exui.card.large
{
    import com.tencent.morefun.naruto.plugin.exui.item.ItemIcon;
    
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.filters.BitmapFilterQuality;
    import flash.filters.GlowFilter;
    
    import bag.data.CardItemData;
    import bag.utils.BagUtils;

    public class NinjaPreviewCardAvatar
    {
        public static const IMG_WIDTH:int                   =   300;
        public static const IMG_HEIGHT:int                  =   410;
        public static const IMG_X:int                       =   0;
        public static const IMG_Y:int                       =   0;

        private var _ui:Sprite;
        private var _img:ItemIcon;

        public function NinjaPreviewCardAvatar(ui:Sprite)
        {
            _ui = ui;
            _ui.mouseEnabled = false;
            _ui.mouseChildren = false;

            _img = new ItemIcon(IMG_WIDTH, IMG_HEIGHT);
            _img.x = IMG_X;
            _img.y = IMG_Y;
            _ui.addChild(_img);
        }

        public function dispose():void
        {
            reset();

            _ui.removeChild(_img);
            _img.destroy();
            _img = null;

            _ui = null;
        }

        public function reset():void
        {
            _img.filters = [];
            _img.unload();
        }

        public function set data(value:CardItemData):void
        {
            if (value != null)
            {
                var ninjaId:uint = (value.id != BagUtils.PLAYER_NINJA_ID) ? value.ninjaId : BagUtils.getPlayerPreviewResId();
                var url:String = BagUtils.getNinjaPreviewResUrl(ninjaId);

                _img.filters = getNinjaFilter(value);
                _img.load(url);
            }
            else
            {
                reset();
            }
        }

        public function get ui():DisplayObject
        {
            return _ui;
        }

        private function getNinjaFilter(value:CardItemData):Array
        {
            var color:Number = getNinjaFilterColor(value.ninjaType);
            var alpha:Number = 1;
            var blurX:Number = 25;
            var blurY:Number = 25;
            var strength:Number = 0.7;
            var inner:Boolean = false;
            var knockout:Boolean = false;
            var quality:Number = BitmapFilterQuality.LOW;

            return [new GlowFilter(color, alpha, blurX, blurY, strength, quality, inner, knockout)];
        }

        private function getNinjaFilterColor(ninjaType:int):uint
        {
            var arr:Array = [0x990000, 0x8AD4CC, 0x0099FF, 0x49C56F, 0xFFCC00];

            return arr[ninjaType - 1];
        }
    }
}