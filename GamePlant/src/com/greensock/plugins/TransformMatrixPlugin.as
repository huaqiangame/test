//Created by Action Script Viewer - http://www.buraks.com/asv
package com.greensock.plugins {
    import com.greensock.*;
    import flash.display.*;
    import flash.geom.*;

    public class TransformMatrixPlugin extends TweenPlugin {

        protected var _transform:Transform;
        protected var _matrix:Matrix;
        protected var _txStart:Number;
        protected var _txChange:Number;
        protected var _tyStart:Number;
        protected var _tyChange:Number;
        protected var _aStart:Number;
        protected var _aChange:Number;
        protected var _bStart:Number;
        protected var _bChange:Number;
        protected var _cStart:Number;
        protected var _cChange:Number;
        protected var _dStart:Number;
        protected var _dChange:Number;
        protected var _angleChange:Number;// = 0

        public static const API:Number = 1;
        private static const _DEG2RAD:Number = 0.0174532925199433;
        private static const _RAD2DEG:Number = 57.2957795130823;

        public function TransformMatrixPlugin(){
            super();
            this.propName = "transformMatrix";
            this.overwriteProps = ["x", "y", "scaleX", "scaleY", "rotation", "transformMatrix", "transformAroundPoint", "transformAroundCenter"];
        }
        override public function onInitTween(target:Object, value, tween:TweenLite):Boolean{
            var ratioX:Number;
            var ratioY:Number;
            var scaleX:Number;
            var scaleY:Number;
            var angle:Number;
            var skewX:Number;
            var finalAngle:Number;
            var finalSkewX:Number;
            var skewY:Number;
            this._transform = (target.transform as Transform);
            this._matrix = this._transform.matrix;
            var matrix:Matrix = this._matrix.clone();
            this._txStart = matrix.tx;
            this._tyStart = matrix.ty;
            this._aStart = matrix.a;
            this._bStart = matrix.b;
            this._cStart = matrix.c;
            this._dStart = matrix.d;
            if (("x" in value)){
                this._txChange = ((typeof(value.x))=="number") ? (value.x - this._txStart) : Number(value.x);
            } else {
                if (("tx" in value)){
                    this._txChange = (value.tx - this._txStart);
                } else {
                    this._txChange = 0;
                };
            };
            if (("y" in value)){
                this._tyChange = ((typeof(value.y))=="number") ? (value.y - this._tyStart) : Number(value.y);
            } else {
                if (("ty" in value)){
                    this._tyChange = (value.ty - this._tyStart);
                } else {
                    this._tyChange = 0;
                };
            };
            this._aChange = (("a" in value)) ? (value.a - this._aStart) : 0;
            this._bChange = (("b" in value)) ? (value.b - this._bStart) : 0;
            this._cChange = (("c" in value)) ? (value.c - this._cStart) : 0;
            this._dChange = (("d" in value)) ? (value.d - this._dStart) : 0;
            if (((((((((((((((("rotation" in value)) || (("scale" in value)))) || (("scaleX" in value)))) || (("scaleY" in value)))) || (("skewX" in value)))) || (("skewY" in value)))) || (("skewX2" in value)))) || (("skewY2" in value)))){
                scaleX = Math.sqrt(((matrix.a * matrix.a) + (matrix.b * matrix.b)));
                if ((((matrix.a < 0)) && ((matrix.d > 0)))){
                    scaleX = -(scaleX);
                };
                scaleY = Math.sqrt(((matrix.c * matrix.c) + (matrix.d * matrix.d)));
                if ((((matrix.d < 0)) && ((matrix.a > 0)))){
                    scaleY = -(scaleY);
                };
                angle = Math.atan2(matrix.b, matrix.a);
                if ((((matrix.a < 0)) && ((matrix.d >= 0)))){
                    angle = (angle + ((angle)<=0) ? Math.PI : -(Math.PI));
                };
                skewX = (Math.atan2(-(this._matrix.c), this._matrix.d) - angle);
                finalAngle = (("rotation" in value)) ? ((typeof(value.rotation))=="number") ? (value.rotation * _DEG2RAD) : ((Number(value.rotation) * _DEG2RAD) + angle) : angle;
                finalSkewX = (("skewX" in value)) ? ((typeof(value.skewX))=="number") ? (Number(value.skewX) * _DEG2RAD) : ((Number(value.skewX) * _DEG2RAD) + skewX) : 0;
                if (("skewY" in value)){
                    skewY = ((typeof(value.skewY))=="number") ? (value.skewY * _DEG2RAD) : ((Number(value.skewY) * _DEG2RAD) - skewX);
                    finalAngle = (finalAngle + (skewY + skewX));
                    finalSkewX = (finalSkewX - skewY);
                };
                if (finalAngle != angle){
                    if (("rotation" in value)){
                        this._angleChange = (finalAngle - angle);
                        finalAngle = angle;
                    } else {
                        matrix.rotate((finalAngle - angle));
                    };
                };
                if (("scale" in value)){
                    ratioX = (Number(value.scale) / scaleX);
                    ratioY = (Number(value.scale) / scaleY);
                    if (typeof(value.scale) != "number"){
                        ratioX = (ratioX + 1);
                        ratioY = (ratioY + 1);
                    };
                } else {
                    if (("scaleX" in value)){
                        ratioX = (Number(value.scaleX) / scaleX);
                        if (typeof(value.scaleX) != "number"){
                            ratioX = (ratioX + 1);
                        };
                    };
                    if (("scaleY" in value)){
                        ratioY = (Number(value.scaleY) / scaleY);
                        if (typeof(value.scaleY) != "number"){
                            ratioY = (ratioY + 1);
                        };
                    };
                };
                if (finalSkewX != skewX){
                    matrix.c = (-(scaleY) * Math.sin((finalSkewX + finalAngle)));
                    matrix.d = (scaleY * Math.cos((finalSkewX + finalAngle)));
                };
                if (("skewX2" in value)){
                    if (typeof(value.skewX2) == "number"){
                        matrix.c = Math.tan((0 - (value.skewX2 * _DEG2RAD)));
                    } else {
                        matrix.c = (matrix.c + Math.tan((0 - (Number(value.skewX2) * _DEG2RAD))));
                    };
                };
                if (("skewY2" in value)){
                    if (typeof(value.skewY2) == "number"){
                        matrix.b = Math.tan((value.skewY2 * _DEG2RAD));
                    } else {
                        matrix.b = (matrix.b + Math.tan((Number(value.skewY2) * _DEG2RAD)));
                    };
                };
                if (ratioX){
                    matrix.a = (matrix.a * ratioX);
                    matrix.b = (matrix.b * ratioX);
                };
                if (ratioY){
                    matrix.c = (matrix.c * ratioY);
                    matrix.d = (matrix.d * ratioY);
                };
                this._aChange = (matrix.a - this._aStart);
                this._bChange = (matrix.b - this._bStart);
                this._cChange = (matrix.c - this._cStart);
                this._dChange = (matrix.d - this._dStart);
            };
            return (true);
        }
        override public function set changeFactor(n:Number):void{
            this._matrix.a = (this._aStart + (n * this._aChange));
            this._matrix.b = (this._bStart + (n * this._bChange));
            this._matrix.c = (this._cStart + (n * this._cChange));
            this._matrix.d = (this._dStart + (n * this._dChange));
            if (this._angleChange){
                this._matrix.rotate((this._angleChange * n));
            };
            this._matrix.tx = (this._txStart + (n * this._txChange));
            this._matrix.ty = (this._tyStart + (n * this._tyChange));
            this._transform.matrix = this._matrix;
        }

    }
}//package com.greensock.plugins 
