package com.tencent.morefun.naruto.plugin.exui.card
{
    import com.tencent.morefun.naruto.plugin.exui.card.large.NinjaPreviewCardAvatar;
    import com.tencent.morefun.naruto.plugin.exui.card.large.NinjaPreviewCardBg;
    import com.tencent.morefun.naruto.plugin.exui.card.large.NinjaPreviewCardFg;
    import com.tencent.morefun.naruto.plugin.exui.card.ui.LargeNinjaCardUI;
    
    import flash.display.Sprite;
    
    import bag.data.CardItemData;
    import bag.utils.BagUtils;
    
    import base.ApplicationData;

    public class LargeNinjaCardView extends Sprite
    {
        private var _ui:LargeNinjaCardUI;
        private var _fg:NinjaPreviewCardFg;
        private var _bg:NinjaPreviewCardBg;
        private var _avatar:NinjaPreviewCardAvatar;
//        private var _fragment:Sprite;

        public function LargeNinjaCardView()
        {
            _ui = new LargeNinjaCardUI();
            this.addChild(_ui);

            _fg = new NinjaPreviewCardFg(_ui.fg);
            _bg = new NinjaPreviewCardBg(_ui.bg);
            _avatar = new NinjaPreviewCardAvatar(_ui.avatar);

//            _fragment = _ui.fragment;
//            _fragment.mouseEnabled = false;

            // Don't display for now~
            _ui.fragment.visible = false;
        }

        public function dispose():void 
        {
			if (_fg)
			{
				_fg.dispose();
				_fg = null;
			}
			
			if (_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			
			if (_avatar)
			{
				_avatar.dispose();
				_avatar = null;
			}

//            _fragment = null;

            this.removeChild(_ui);
            _ui = null;
        }

        public function reset():void
        {
            _fg.reset();
            _bg.reset();
            _avatar.reset();

            _fg.ui.filters = [];
            _bg.ui.filters = [];
            _avatar.ui.filters = [];
//            _fragment.visible = false;
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
/*
                if (value.card.isFragment)
                {
                    _fg.ui.filters = GrayUtils.getGrayFilter();
                    _bg.ui.filters = GrayUtils.getGrayFilter();
                    _avatar.ui.filters = GrayUtils.getGrayFilter();
                    _fragment.visible = true;
                }
                else
                {
                    _fg.ui.filters = [];
                    _bg.ui.filters = [];
                    _avatar.ui.filters = [];
                    _fragment.visible = false;
                }
*/
            }
            else
            {
                reset();
            }
        }

        public function set hasNinja(value:Boolean):void
        {
            _fg.hasNinja = value;
        }

        public function set showName(value:Boolean):void
        {
            _fg.showName = value;
        }
    }
}