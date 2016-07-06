package com.tencent.morefun.naruto.plugin.exui.card.small
{
    import com.tencent.morefun.naruto.plugin.exui.item.ItemIcon;
    
    import flash.display.Sprite;
    
    import bag.data.CardItemData;
    import bag.utils.BagUtils;

    public class NinjaCardAvatar extends Sprite
    {
        private static const IMG_W:int                      =   72;
        private static const IMG_H:int                      =   98;
        private static const IMG_X:int                      =   0;
        private static const IMG_Y:int                      =   0;

        private var _ui:Sprite;
        private var _img:ItemIcon;

        public function NinjaCardAvatar(ui:Sprite)
        {
            _ui = ui;

            _img = new ItemIcon(IMG_W, IMG_H);
            _img.x = IMG_X;
            _img.y = IMG_Y;
            _ui.addChild(_img);
        }

        public function destroy():void
        {
            _ui.removeChild(_img);
            _img.filters = [];
            _img.destroy();
            _img = null;

            _ui.filters = [];
            _ui = null;
        }

        public function reset():void
        {
            _ui.filters = [];

            _img.filters = [];
            _img.unload();
        }

        public function set data(value:CardItemData):void
        {
            if (value != null)
            {
                var url:String;

                if (value.isFragment)
                {
                    url = BagUtils.getNinjaCardResUrl(value.cardId);
//                    _ui.filters = GrayUtils.getGrayFilter();
                }
                else
                {
                    url = BagUtils.getNinjaCardResUrl(value.id);
//                    _ui.filters = [];
                }

                _img.load(url);
            }
            else
            {
                reset();
            }
        }
  	}
}