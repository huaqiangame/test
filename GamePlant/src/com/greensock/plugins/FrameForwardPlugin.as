//Created by Action Script Viewer - http://www.buraks.com/asv
package com.greensock.plugins {
    import flash.display.*;
    import com.greensock.*;

    public class FrameForwardPlugin extends TweenPlugin {

        protected var _start:int;
        protected var _change:int;
        protected var _max:uint;
        protected var _target:MovieClip;
        protected var _backward:Boolean;

        public static const API:Number = 1;

        public function FrameForwardPlugin(){
            super();
            this.propName = "frameForward";
            this.overwriteProps = ["frame", "frameLabel", "frameForward", "frameBackward"];
            this.round = true;
        }
        override public function onInitTween(target:Object, value, tween:TweenLite):Boolean{
            if (((!((target is MovieClip))) || (isNaN(value)))){
                return (false);
            };
            this._target = (target as MovieClip);
            this._start = this._target.currentFrame;
            this._max = this._target.totalFrames;
            this._change = ((typeof(value))=="number") ? (Number(value) - this._start) : Number(value);
            if (((!(this._backward)) && ((this._change < 0)))){
                this._change = (this._change + this._max);
            } else {
                if (((this._backward) && ((this._change > 0)))){
                    this._change = (this._change - this._max);
                };
            };
            return (true);
        }
        override public function set changeFactor(n:Number):void{
            var frame:Number = ((this._start + (this._change * n)) % this._max);
            if ((((frame < 0.5)) && ((frame >= -0.5)))){
                frame = this._max;
            } else {
                if (frame < 0){
                    frame = (frame + this._max);
                };
            };
            this._target.gotoAndStop(int((frame + 0.5)));
        }

    }
}//package com.greensock.plugins 
