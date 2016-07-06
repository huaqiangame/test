package com.tencent.morefun.naruto.plugin.ui.base
{
 import com.greensock.TweenLite;

    public class AnyTextIntAnim
    {
        protected static const TEXT_ANIM_TIME:Number        =   0.5;

        protected var _txt:Object;
        protected var _onChange:Function;
        protected var _onComplete:Function;
        protected var _value:int;
        protected var _desValue:int;

        public function AnyTextIntAnim(txt:Object, onChange:Function=null, onComplete:Function=null)
        {
            _txt = txt;
            _onChange = onChange;
            _onComplete = onComplete;
            _value = 0;
            _desValue = 0;
        }

        public function destroy():void
        {
            TweenLite.killTweensOf(this);
        }

        public function reset():void
        {
            TweenLite.killTweensOf(this);
            _txt.text = "";
        }

        public function start(from:int, to:int):void
        {
            _value = from;
            _desValue = to;

            _txt.text = from;

            TweenLite.killTweensOf(this);
            TweenLite.to(this, TEXT_ANIM_TIME, {value:_desValue} );
        }

        public function get value():int
        {
            return _value;
        }

        public function set value(val:int):void
        {
            _value = val;
            _txt.text = String(value);

            if (_onChange != null)
                _onChange(_value);

            if (_value == _desValue)
            {
                TweenLite.killTweensOf(this);

                if (_onComplete != null)
                    _onComplete(_desValue);
            }
        }
    	}
}