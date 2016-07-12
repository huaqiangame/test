//Created by Action Script Viewer - http://www.buraks.com/asv
package com.greensock.plugins {
    import com.greensock.*;
    import flash.media.*;

    public class SoundTransformPlugin extends TweenPlugin {

        protected var _target:Object;
        protected var _st:SoundTransform;

        public static const API:Number = 1;

        public function SoundTransformPlugin(){
            super();
            this.propName = "soundTransform";
            this.overwriteProps = ["soundTransform", "volume"];
        }
        override public function onInitTween(target:Object, value, tween:TweenLite):Boolean{
            var p:String;
            if (!(target.hasOwnProperty("soundTransform"))){
                return (false);
            };
            this._target = target;
            this._st = this._target.soundTransform;
            for (p in value) {
                addTween(this._st, p, this._st[p], value[p], p);
            };
            return (true);
        }
        override public function set changeFactor(n:Number):void{
            updateTweens(n);
            this._target.soundTransform = this._st;
        }

    }
}//package com.greensock.plugins 
