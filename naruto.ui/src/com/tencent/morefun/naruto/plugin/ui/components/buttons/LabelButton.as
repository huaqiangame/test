package com.tencent.morefun.naruto.plugin.ui.components.buttons {
    import flash.display.DisplayObject;
    import flash.text.TextFormat;
    
    /**
     * 带有自定义标签的按钮 label
     * @author:Georgehu
     * @since:2014-01-20
     */
    import com.tencent.morefun.naruto.i18n.I18n;
    public class LabelButton extends Button {
        private var _label:String = "";
        private var _format:TextFormat = null;
        
        /**
         * 构造函数
         * create a [LabelButton] object
         */
        public function LabelButton(buttonView:DisplayObject, useWrapper:Boolean = false) {
            super(buttonView, useWrapper);
            
            _label = _buttonView["label"];
            
            if(!_label) {
                throw new ArgumentError(this + I18n.lang("as_ui_1451031579_6153"));
            }
        }
        
        override protected function setButtonState(state:String):void {
            super.setButtonState(state);
            
            this.label = (_label ||= "");
        }
        
        /**
         * 标签文字
         */
        public function get label():String {
            return _label;
        }
        
        public function set label(value:String):void {
            _label = value;
            _buttonView["label"].htmlText = _label;
        }
    
    }

}
