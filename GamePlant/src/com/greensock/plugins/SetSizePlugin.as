//Created by Action Script Viewer - http://www.buraks.com/asv
package com.greensock.plugins {
    import flash.display.*;
    import com.greensock.*;

    public class SetSizePlugin extends TweenPlugin {

        public var width:Number;
        public var height:Number;
        protected var _target:Object;
        protected var _setWidth:Boolean;
        protected var _setHeight:Boolean;
        protected var _hasSetSize:Boolean;

        public static const API:Number = 1;

        public function SetSizePlugin(){
            super();
            this.propName = "setSize";
            this.overwriteProps = ["setSize", "setActualSize", "width", "height", "scaleX", "scaleY"];
            this.round = true;
        }
        override public function onInitTween(target:Object, value, tween:TweenLite):Boolean{
            this._target = target;
            this._hasSetSize = Boolean(("setSize" in this._target));
            if (((("width" in value)) && (!((this._target.width == value.width))))){
                addTween((this._hasSetSize) ? this : this._target, "width", this._target.width, value.width, "width");
                this._setWidth = this._hasSetSize;
            };
            if (((("height" in value)) && (!((this._target.height == value.height))))){
                addTween((this._hasSetSize) ? this : this._target, "height", this._target.height, value.height, "height");
                this._setHeight = this._hasSetSize;
            };
            if (_tweens.length == 0){
                this._hasSetSize = false;
            };
            return (true);
        }
        override public function killProps(lookup:Object):void{
            super.killProps(lookup);
            if ((((_tweens.length == 0)) || (("setSize" in lookup)))){
                this.overwriteProps = [];
            };
        }
        override public function set changeFactor(n:Number):void{
            updateTweens(n);
            if (this._hasSetSize){
                this._target.setSize((this._setWidth) ? this.width : this._target.width, (this._setHeight) ? this.height : this._target.height);
            };
        }

    }
}//package com.greensock.plugins 
