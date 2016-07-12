//Created by Action Script Viewer - http://www.buraks.com/asv
package com.greensock.plugins {
    import flash.display.*;
    import com.greensock.*;

    public class FramePlugin extends TweenPlugin {

        public var frame:int;
        protected var _target:MovieClip;

        public static const API:Number = 1;

        public function FramePlugin(){
            super();
            this.propName = "frame";
            this.overwriteProps = ["frame", "frameLabel"];
            this.round = true;
        }
        override public function onInitTween(target:Object, value, tween:TweenLite):Boolean{
            if (((!((target is MovieClip))) || (isNaN(value)))){
                return (false);
            };
            this._target = (target as MovieClip);
            this.frame = this._target.currentFrame;
            addTween(this, "frame", this.frame, value, "frame");
            return (true);
        }
        override public function set changeFactor(n:Number):void{
            updateTweens(n);
            this._target.gotoAndStop(this.frame);
        }

    }
}//package com.greensock.plugins 
