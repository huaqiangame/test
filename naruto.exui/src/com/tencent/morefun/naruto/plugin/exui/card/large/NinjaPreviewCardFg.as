package com.tencent.morefun.naruto.plugin.exui.card.large
{
    import com.tencent.morefun.naruto.plugin.exui.card.ui.LargeNinjaCardFgUI;
    
    import flash.display.DisplayObject;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.text.TextField;
    
    import bag.data.CardItemData;

    public class NinjaPreviewCardFg
    {
        private var _ui:LargeNinjaCardFgUI;
        private var _data:CardItemData;
        private var _ninjaClass:MovieClip;
        private var _ninjaType:MovieClip;
        private var _ninjaTypeStrip:MovieClip;
        private var _frame:MovieClip;
        private var _rare:MovieClip;
        private var _hasNinja:Sprite;
        private var _nameText:TextField;
        private var _showName:Boolean;
        private var _leadershipText:TextField;

        public function NinjaPreviewCardFg(ui:LargeNinjaCardFgUI)
        {
            _ui = ui;
            _ui.mouseEnabled = false;
            _ui.mouseChildren = false;

            _ninjaClass = _ui.ninjaClass;
            _ninjaType = _ui.ninjaType;
            _ninjaTypeStrip = _ui.ninjaTypeStrip;
            _frame = _ui.frame;
            _rare = _ui.rare;
            _hasNinja = _ui.hasNinja;
            _nameText = _ui.nameText;
            _leadershipText = _ui.leadershipText;

            reset();
            this.showName = true;

            // Don't display for now~
            _rare.visible = false;
        }

        public function dispose():void
        {
            reset();

            _ui = null;
            _data = null;
            _ninjaClass = null;
            _ninjaType = null;
            _ninjaTypeStrip = null;
            _frame = null;
            _rare = null;
            _hasNinja = null;
            _nameText = null;
            _leadershipText = null;
        }

        public function reset():void
        {
            _ninjaType.gotoAndStop(1);
            _ninjaTypeStrip.gotoAndStop(1);
            _frame.gotoAndStop(1);
            _rare.gotoAndStop(1);
            _hasNinja.visible = false;
            _nameText.htmlText = "";

            // Disabled
            _ninjaClass.gotoAndStop(1);
            _ninjaClass.visible = false;
            _leadershipText.htmlText = "";
            _leadershipText.visible = false;
        }

        public function set data(value:CardItemData):void
        {
            if (value != null)
            {
                _data = value;

//                _ninjaClass.gotoAndStop(_data.ninjaClass);
                _ninjaType.gotoAndStop(_data.ninjaType);
                _ninjaTypeStrip.gotoAndStop(_data.ninjaType);
                _ninjaTypeStrip.visible = _data.rare > 3;
                _frame.gotoAndStop(_data.rare);
                _rare.gotoAndStop(_data.rare);
//                _hasNinja.visible = (!_data.isFragment) && (_data.ninja != null);
//                _nameText.htmlText = getNameStr();
//                _leadershipText.htmlText = getLeadershipStr();

                refreshName();
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

        public function set hasNinja(value:Boolean):void
        {
            _hasNinja.visible = value;
        }

        public function set showName(value:Boolean):void
        {
            _showName = value;

            refreshName();
        }

        private function refreshName():void
        {
            if (_showName)
                _nameText.htmlText = getNameStr();
            else
                _nameText.htmlText = "";
        }

        private function getNameStr():String
        {
            if (_data == null)
                return "";

            var str:String = _data.name;

            if (_data.title != null)
                str += _data.title;

            return "<b>" + str + "</b>";
        }
/*
        private function getLeadershipStr():String
        {
            var str:String = StrReplacer.replace(Const.PREVIEW_LEADERSHIP_LABEL, _data.leadership);

            return "<b>" + str + "</b>";
        }
*/
    }
}