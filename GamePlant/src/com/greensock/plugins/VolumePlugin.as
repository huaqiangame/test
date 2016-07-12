//Created by Action Script Viewer - http://www.buraks.com/asv
package com.greensock.plugins {
    import flash.display.*;
    import com.greensock.*;
    import flash.media.*;

    public class VolumePlugin extends TweenPlugin {

        protected var _target:Object;
        protected var _st:SoundTransform;

        public static const API:Number = 1;

        public function VolumePlugin(){
            super();
            this.propName = "volume";
            this.overwriteProps = ["volume"];
        }
        override public function onInitTween(target:Object, value, tween:TweenLite):Boolean{
            if (((isNaN(value)) || (!(target.hasOwnProperty("soundTransform"))))){
                return (false);
            };
            this._target = target;
            this._st = this._target.soundTransform;
            addTween(this._st, "volume", this._st.volume, value, "volume");
            return (true);
        }
        override public function set changeFactor(n:Number):void{
            updateTweens(n);
            this._target.soundTransform = this._st;
        }

    }
}//package com.greensock.plugins 
