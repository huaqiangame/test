package com.tencent.morefun.naruto.plugin.exui.avatar
{
    import com.tencent.morefun.naruto.plugin.exui.base.Image;
    import com.tencent.morefun.naruto.plugin.ui.tips.TipsManager;
    
    import flash.display.Sprite;
    
    import def.TipsTypeDef;
    
    import throughTheBeast.data.BeastData;

    public class BeastAvatar extends Sprite
    {
        private var _img:Image;

        public function BeastAvatar(width:int=75, height:int=75)
        {
            _img = new Image(width, height, true);

            this.addChild(_img);
        }

        public function destroy():void
        {
            reset();

            _img = null;
        }

        public function reset():void
        {
            _img.dispose();
            TipsManager.singleton.unbinding(_img);
        }

        public function loadByData(data:BeastData, showTooltip:Boolean=false):void
        {
            if (data != null)
            {
                var url:String = "assets/bag/item/" + data.id + ".png";
                _img.load(url);

                if (showTooltip)
                    TipsManager.singleton.binding(_img, data, TipsTypeDef.BEAST);
            }
            else
            {
                reset();
            }
        }
    }
}