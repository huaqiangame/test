//Created by Action Script Viewer - http://www.buraks.com/asv
package com.greensock.plugins {
    import flash.display.*;
    import com.greensock.*;

    public class CacheAsBitmapPlugin extends TweenPlugin {

        protected var _target:DisplayObject;
        protected var _tween:TweenLite;
        protected var _cacheAsBitmap:Boolean;
        protected var _initVal:Boolean;

        public static const API:Number = 1;

        public function CacheAsBitmapPlugin(){
            super();
            this.propName = "cacheAsBitmap";
            this.overwriteProps = ["cacheAsBitmap"];
        }
        override public function onInitTween(target:Object, value, tween:TweenLite):Boolean{
            this._target = (target as DisplayObject);
            this._tween = tween;
            this._initVal = this._target.cacheAsBitmap;
            this._cacheAsBitmap = Boolean(value);
            return (true);
        }
        override public function set changeFactor(n:Number):void{
            if ((((this._tween.cachedDuration == this._tween.cachedTime)) || ((this._tween.cachedTime == 0)))){
                this._target.cacheAsBitmap = this._initVal;
            } else {
                if (this._target.cacheAsBitmap != this._cacheAsBitmap){
                    this._target.cacheAsBitmap = this._cacheAsBitmap;
                };
            };
        }

    }
}//package com.greensock.plugins 
