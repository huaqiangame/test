//Created by Action Script Viewer - http://www.buraks.com/asv
package com.greensock.plugins {
    import com.greensock.*;
    import flash.display.*;
    import com.greensock.motionPaths.*;
    import flash.geom.*;

    public class CirclePath2DPlugin extends TweenPlugin {

        protected var _target:Object;
        protected var _autoRemove:Boolean;
        protected var _start:Number;
        protected var _change:Number;
        protected var _circle:CirclePath2D;
        protected var _autoRotate:Boolean;
        protected var _rotationOffset:Number;

        public static const API:Number = 1;
        private static const _2PI:Number = 6.28318530717959;
        private static const _RAD2DEG:Number = 57.2957795130823;

        public function CirclePath2DPlugin(){
            super();
            this.propName = "circlePath2D";
            this.overwriteProps = ["x", "y"];
        }
        override public function onInitTween(target:Object, value, tween:TweenLite):Boolean{
            if (((!(("path" in value))) || (!((value.path is CirclePath2D))))){
                trace("CirclePath2DPlugin error: invalid 'path' property. Please define a CirclePath2D instance.");
                return (false);
            };
            this._target = target;
            this._circle = (value.path as CirclePath2D);
            this._autoRotate = Boolean((value.autoRotate == true));
            this._rotationOffset = ((value.rotationOffset) || (0));
            var f:PathFollower = this._circle.getFollower(target);
            if (((!((f == null))) && (!(("startAngle" in value))))){
                this._start = f.progress;
            } else {
                this._start = this._circle.angleToProgress(((value.startAngle) || (0)), value.useRadians);
                this._circle.renderObjectAt(this._target, this._start);
            };
            this._change = Number(this._circle.anglesToProgressChange(this._circle.progressToAngle(this._start), ((value.endAngle) || (0)), ((value.direction) || ("clockwise")), ((value.extraRevolutions) || (0)), Boolean(value.useRadians)));
            return (true);
        }
        override public function killProps(lookup:Object):void{
            super.killProps(lookup);
            if (((("x" in lookup)) || (("y" in lookup)))){
                this.overwriteProps = [];
            };
        }
        override public function set changeFactor(n:Number):void{
            var angle:Number = ((this._start + (this._change * n)) * _2PI);
            var radius:Number = this._circle.radius;
            var m:Matrix = this._circle.transform.matrix;
            var px:Number = (Math.cos(angle) * radius);
            var py:Number = (Math.sin(angle) * radius);
            this._target.x = (((px * m.a) + (py * m.c)) + m.tx);
            this._target.y = (((px * m.b) + (py * m.d)) + m.ty);
            if (this._autoRotate){
                angle = (angle + (Math.PI / 2));
                px = (Math.cos(angle) * this._circle.radius);
                py = (Math.sin(angle) * this._circle.radius);
                this._target.rotation = ((Math.atan2(((px * m.b) + (py * m.d)), ((px * m.a) + (py * m.c))) * _RAD2DEG) + this._rotationOffset);
            };
        }

    }
}//package com.greensock.plugins 
