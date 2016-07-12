//Created by Action Script Viewer - http://www.buraks.com/asv
package com.greensock.motionPaths {
    import flash.display.*;
    import flash.geom.*;

    public class CirclePath2D extends MotionPath {

        protected var _radius:Number;

        public function CirclePath2D(x:Number, y:Number, radius:Number){
            super();
            this._radius = radius;
            super.x = x;
            super.y = y;
        }
        override protected function renderAll():void{
            var angle:Number;
            var px:Number;
            var py:Number;
            var g:Graphics;
            var m:Matrix = this.transform.matrix;
            var a:Number = m.a;
            var b:Number = m.b;
            var c:Number = m.c;
            var d:Number = m.d;
            var tx:Number = m.tx;
            var ty:Number = m.ty;
            var f:PathFollower = _rootFollower;
            while (f) {
                angle = ((f.cachedProgress * Math.PI) * 2);
                px = (Math.cos(angle) * this._radius);
                py = (Math.sin(angle) * this._radius);
                f.target.x = (((px * a) + (py * c)) + tx);
                f.target.y = (((px * b) + (py * d)) + ty);
                if (f.autoRotate){
                    angle = (angle + (Math.PI / 2));
                    px = (Math.cos(angle) * this._radius);
                    py = (Math.sin(angle) * this._radius);
                    f.target.rotation = ((Math.atan2(((px * m.b) + (py * m.d)), ((px * m.a) + (py * m.c))) * _RAD2DEG) + f.rotationOffset);
                };
                f = f.cachedNext;
            };
            if (((((_redrawLine) && (this.visible))) && (this.parent))){
                g = this.graphics;
                g.clear();
                g.lineStyle(_thickness, _color, _lineAlpha, _pixelHinting, _scaleMode, _caps, _joints, _miterLimit);
                g.drawCircle(0, 0, this._radius);
                _redrawLine = false;
            };
        }
        override public function renderObjectAt(target:Object, progress:Number, autoRotate:Boolean=false, rotationOffset:Number=0):void{
            var angle:Number = ((progress * Math.PI) * 2);
            var m:Matrix = this.transform.matrix;
            var px:Number = (Math.cos(angle) * this._radius);
            var py:Number = (Math.sin(angle) * this._radius);
            target.x = (((px * m.a) + (py * m.c)) + m.tx);
            target.y = (((px * m.b) + (py * m.d)) + m.ty);
            if (autoRotate){
                angle = (angle + (Math.PI / 2));
                px = (Math.cos(angle) * this._radius);
                py = (Math.sin(angle) * this._radius);
                target.rotation = ((Math.atan2(((px * m.b) + (py * m.d)), ((px * m.a) + (py * m.c))) * _RAD2DEG) + rotationOffset);
            };
        }
        public function angleToProgress(angle:Number, useRadians:Boolean=false):Number{
            var revolution:Number = (useRadians) ? (Math.PI * 2) : 360;
            if (angle < 0){
                angle = (angle + ((int((-(angle) / revolution)) + 1) * revolution));
            } else {
                if (angle > revolution){
                    angle = (angle - (int((angle / revolution)) * revolution));
                };
            };
            return ((angle / revolution));
        }
        public function progressToAngle(progress:Number, useRadians:Boolean=false):Number{
            var revolution:Number = (useRadians) ? (Math.PI * 2) : 360;
            return ((progress * revolution));
        }
        public function followerTween(follower, endAngle:Number, direction:String="clockwise", extraRevolutions:uint=0, useRadians:Boolean=false):String{
            var revolution:Number = (useRadians) ? (Math.PI * 2) : 360;
            return (String(this.anglesToProgressChange((getFollower(follower).progress * revolution), endAngle, direction, extraRevolutions, useRadians)));
        }
        public function anglesToProgressChange(startAngle:Number, endAngle:Number, direction:String="clockwise", extraRevolutions:uint=0, useRadians:Boolean=false):Number{
            var revolution:Number = (useRadians) ? (Math.PI * 2) : 360;
            var dif:Number = (endAngle - startAngle);
            if ((((dif < 0)) && ((direction == "clockwise")))){
                dif = (dif + ((int((-(dif) / revolution)) + 1) * revolution));
            } else {
                if ((((dif > 0)) && ((direction == "counterClockwise")))){
                    dif = (dif - ((int((dif / revolution)) + 1) * revolution));
                } else {
                    if (direction == "shortest"){
                        dif = (dif % revolution);
                        if (dif != (dif % (revolution * 0.5))){
                            dif = ((dif)<0) ? (dif + revolution) : (dif - revolution);
                        };
                    };
                };
            };
            if (dif < 0){
                dif = (dif - (extraRevolutions * revolution));
            } else {
                dif = (dif + (extraRevolutions * revolution));
            };
            return ((dif / revolution));
        }
        public function get radius():Number{
            return (this._radius);
        }
        public function set radius(value:Number):void{
            this._radius = value;
            _redrawLine = true;
            this.renderAll();
        }

    }
}//package com.greensock.motionPaths 
