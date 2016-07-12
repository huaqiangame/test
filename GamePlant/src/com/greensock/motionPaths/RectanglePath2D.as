//Created by Action Script Viewer - http://www.buraks.com/asv
package com.greensock.motionPaths {
    import flash.display.*;
    import flash.geom.*;

    public class RectanglePath2D extends MotionPath {

        protected var _rawWidth:Number;
        protected var _rawHeight:Number;
        protected var _centerOrigin:Boolean;

        public function RectanglePath2D(x:Number, y:Number, rawWidth:Number, rawHeight:Number, centerOrigin:Boolean=false){
            super();
            this._rawWidth = rawWidth;
            this._rawHeight = rawHeight;
            this._centerOrigin = centerOrigin;
            super.x = x;
            super.y = y;
        }
        override protected function renderAll():void{
            var length:Number;
            var px:Number;
            var py:Number;
            var xFactor:Number;
            var yFactor:Number;
            var g:Graphics;
            var xOffset:Number = (this._centerOrigin) ? (this._rawWidth / -2) : 0;
            var yOffset:Number = (this._centerOrigin) ? (this._rawHeight / -2) : 0;
            var m:Matrix = this.transform.matrix;
            var a:Number = m.a;
            var b:Number = m.b;
            var c:Number = m.c;
            var d:Number = m.d;
            var tx:Number = m.tx;
            var ty:Number = m.ty;
            var f:PathFollower = _rootFollower;
            while (f) {
                px = xOffset;
                py = yOffset;
                if (f.cachedProgress < 0.5){
                    length = ((f.cachedProgress * (this._rawWidth + this._rawHeight)) * 2);
                    if (length > this._rawWidth){
                        px = (px + this._rawWidth);
                        py = (py + (length - this._rawWidth));
                        xFactor = 0;
                        yFactor = this._rawHeight;
                    } else {
                        px = (px + length);
                        xFactor = this._rawWidth;
                        yFactor = 0;
                    };
                } else {
                    length = (((f.cachedProgress - 0.5) / 0.5) * (this._rawWidth + this._rawHeight));
                    if (length <= this._rawWidth){
                        px = (px + (this._rawWidth - length));
                        py = (py + this._rawHeight);
                        xFactor = -(this._rawWidth);
                        yFactor = 0;
                    } else {
                        py = (py + (this._rawHeight - (length - this._rawWidth)));
                        xFactor = 0;
                        yFactor = -(this._rawHeight);
                    };
                };
                f.target.x = (((px * a) + (py * c)) + tx);
                f.target.y = (((px * b) + (py * d)) + ty);
                if (f.autoRotate){
                    f.target.rotation = ((Math.atan2(((xFactor * b) + (yFactor * d)), ((xFactor * a) + (yFactor * c))) * _RAD2DEG) + f.rotationOffset);
                };
                f = f.cachedNext;
            };
            if (((((_redrawLine) && (this.visible))) && (this.parent))){
                g = this.graphics;
                g.clear();
                g.lineStyle(_thickness, _color, _lineAlpha, _pixelHinting, _scaleMode, _caps, _joints, _miterLimit);
                g.drawRect(xOffset, yOffset, this._rawWidth, this._rawHeight);
                _redrawLine = false;
            };
        }
        override public function renderObjectAt(target:Object, progress:Number, autoRotate:Boolean=false, rotationOffset:Number=0):void{
            var length:Number;
            var xFactor:Number;
            var yFactor:Number;
            if (progress > 1){
                progress = (progress - int(progress));
            } else {
                if (progress < 0){
                    progress = (progress - (int(progress) - 1));
                };
            };
            var px:Number = (this._centerOrigin) ? (this._rawWidth / -2) : 0;
            var py:Number = (this._centerOrigin) ? (this._rawHeight / -2) : 0;
            if (progress < 0.5){
                length = ((progress * (this._rawWidth + this._rawHeight)) * 2);
                if (length > this._rawWidth){
                    px = (px + this._rawWidth);
                    py = (py + (length - this._rawWidth));
                    xFactor = 0;
                    yFactor = this._rawHeight;
                } else {
                    px = (px + length);
                    xFactor = this._rawWidth;
                    yFactor = 0;
                };
            } else {
                length = (((progress - 0.5) / 0.5) * (this._rawWidth + this._rawHeight));
                if (length <= this._rawWidth){
                    px = (px + (this._rawWidth - length));
                    py = (py + this._rawHeight);
                    xFactor = -(this._rawWidth);
                    yFactor = 0;
                } else {
                    py = (py + (this._rawHeight - (length - this._rawWidth)));
                    xFactor = 0;
                    yFactor = -(this._rawHeight);
                };
            };
            var m:Matrix = this.transform.matrix;
            target.x = (((px * m.a) + (py * m.c)) + m.tx);
            target.y = (((px * m.b) + (py * m.d)) + m.ty);
            if (autoRotate){
                target.rotation = ((Math.atan2(((xFactor * m.b) + (yFactor * m.d)), ((xFactor * m.a) + (yFactor * m.c))) * _RAD2DEG) + rotationOffset);
            };
        }
        public function get rawWidth():Number{
            return (this._rawWidth);
        }
        public function set rawWidth(value:Number):void{
            this._rawWidth = value;
            _redrawLine = true;
            this.renderAll();
        }
        public function get rawHeight():Number{
            return (this._rawHeight);
        }
        public function set rawHeight(value:Number):void{
            this._rawHeight = value;
            _redrawLine = true;
            this.renderAll();
        }
        public function get centerOrigin():Boolean{
            return (this._centerOrigin);
        }
        public function set centerOrigin(value:Boolean):void{
            this._centerOrigin;
            _redrawLine = true;
            this.renderAll();
        }

    }
}//package com.greensock.motionPaths 
