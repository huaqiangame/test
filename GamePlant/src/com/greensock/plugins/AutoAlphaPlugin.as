﻿//Created by Action Script Viewer - http://www.buraks.com/asv
package com.greensock.plugins {
    import com.greensock.*;
    import flash.display.*;

    public class AutoAlphaPlugin extends TweenPlugin {

        protected var _target:Object;
        protected var _ignoreVisible:Boolean;

        public static const API:Number = 1;

        public function AutoAlphaPlugin(){
            super();
            this.propName = "autoAlpha";
            this.overwriteProps = ["alpha", "visible"];
        }
        override public function onInitTween(target:Object, value, tween:TweenLite):Boolean{
            this._target = target;
            addTween(target, "alpha", target.alpha, value, "alpha");
            return (true);
        }
        override public function killProps(lookup:Object):void{
            super.killProps(lookup);
            this._ignoreVisible = Boolean(("visible" in lookup));
        }
        override public function set changeFactor(n:Number):void{
            updateTweens(n);
            if (!(this._ignoreVisible)){
                this._target.visible = Boolean(!((this._target.alpha == 0)));
            };
        }

    }
}//package com.greensock.plugins 
