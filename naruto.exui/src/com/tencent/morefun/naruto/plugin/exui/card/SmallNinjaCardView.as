package com.tencent.morefun.naruto.plugin.exui.card
{
    import com.tencent.morefun.naruto.plugin.exui.card.small.NinjaCardAvatar;
    import com.tencent.morefun.naruto.plugin.exui.card.small.NinjaCardBg;
    import com.tencent.morefun.naruto.plugin.exui.card.small.NinjaCardFg;
    import com.tencent.morefun.naruto.plugin.exui.card.ui.SmallNinjaCardUI;
    
    import flash.display.Sprite;
    
    import bag.data.CardItemData;
    import bag.utils.BagUtils;
    
    import base.ApplicationData;

    public class SmallNinjaCardView extends Sprite
    {
        private var _ui:SmallNinjaCardUI;
        private var _fg:NinjaCardFg;
        private var _bg:NinjaCardBg;
        private var _avatar:NinjaCardAvatar;
//        private var _fragment:NinjaCardFragment;

        public function SmallNinjaCardView()
        {
            _ui = new SmallNinjaCardUI();
            this.addChild(_ui);

            _fg = new NinjaCardFg(_ui.fg);
            _bg = new NinjaCardBg(_ui.bg);
            _avatar = new NinjaCardAvatar(_ui.avatar);
//            _fragment = new NinjaCardFragment(_ui.fragment);

            _ui.fragment.visible = false;

            reset();
        }

        public function destroy():void 
        {
            _fg.destroy();
            _fg = null;

            _bg.destroy();
            _bg = null;

            _avatar.destroy();
            _avatar = null;

//            _fragment.destroy();
//            _fragment = null;

            this.removeChild(_ui);
            _ui = null;
        }

        public function reset():void
        {
            _fg.reset();
            _bg.reset();
            _avatar.reset();
//            _fragment.reset();
        }

        public function set data(value:CardItemData):void
        {
            if (value != null)
            {
                if (value.id == BagUtils.PLAYER_NINJA_ID)
                    value.ninjaType = ApplicationData.singleton.selfInfo.professions;

                _fg.data = value;
                _bg.data = value;
                _avatar.data = value;
//                _fragment.data = value;
            }
            else
            {
                reset();
            }
        }
   	}
}