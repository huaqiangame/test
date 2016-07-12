//Created by Action Script Viewer - http://www.buraks.com/asv
package com.greensock.motionPaths {
    import flash.events.*;
    import flash.display.*;

    public class MotionPath extends Shape {

        protected var _redrawLine:Boolean;
        protected var _thickness:Number;
        protected var _color:uint;
        protected var _lineAlpha:Number;
        protected var _pixelHinting:Boolean;
        protected var _scaleMode:String;
        protected var _caps:String;
        protected var _joints:String;
        protected var _miterLimit:Number;
        protected var _rootFollower:PathFollower;
        protected var _progress:Number;

        protected static const _RAD2DEG:Number = 57.2957795130823;
        protected static const _DEG2RAD:Number = 0.0174532925199433;

        public function MotionPath(){
            super();
            this._progress = 0;
            this.lineStyle(1, 0x666666, 1, false, "none", null, null, 3, true);
            this.addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage, false, 0, true);
        }
        protected function onAddedToStage(event:Event):void{
            this.renderAll();
        }
        public function addFollower(target, progress:Number=0, autoRotate:Boolean=false, rotationOffset:Number=0):PathFollower{
            var f:PathFollower = this.getFollower(target);
            if (f == null){
                f = new PathFollower(target);
            };
            f.autoRotate = autoRotate;
            f.rotationOffset = rotationOffset;
            if (f.path != this){
                if (this._rootFollower){
                    this._rootFollower.cachedPrev = f;
                };
                f.cachedNext = this._rootFollower;
                this._rootFollower = f;
                f.path = this;
                f.cachedProgress = progress;
                this.renderObjectAt(f.target, progress, autoRotate, rotationOffset);
            };
            return (f);
        }
        public function removeFollower(target):void{
            var f:PathFollower = this.getFollower(target);
            if (f == null){
                return;
            };
            if (f.cachedNext){
                f.cachedNext.cachedPrev = f.cachedPrev;
            };
            if (f.cachedPrev){
                f.cachedPrev.cachedNext = f.cachedNext;
            } else {
                if (this._rootFollower == f){
                    this._rootFollower = null;
                };
            };
            f.cachedNext = (f.cachedPrev = null);
            f.path = null;
        }
        public function removeAllFollowers():void{
            var next:PathFollower;
            var f:PathFollower = this._rootFollower;
            while (f) {
                next = f.cachedNext;
                f.cachedNext = (f.cachedPrev = null);
                f.path = null;
                f = next;
            };
            this._rootFollower = null;
        }
        public function distribute(targets:Array=null, min:Number=0, max:Number=1, autoRotate:Boolean=false, rotationOffset:Number=0):void{
            var f:PathFollower;
            if (targets == null){
                targets = this.followers;
            };
            min = this._normalize(min);
            max = this._normalize(max);
            var i:int = targets.length;
            var space:Number = ((i)>1) ? ((max - min) / (i - 1)) : 1;
            while (--i > -1) {
                f = this.getFollower(targets[i]);
                if (f == null){
                    f = this.addFollower(targets[i], 0, autoRotate, rotationOffset);
                };
                f.cachedProgress = (min + (space * i));
                this.renderObjectAt(f.target, f.cachedProgress, autoRotate, rotationOffset);
            };
        }
        protected function _normalize(num:Number):Number{
            if (num > 1){
                num = (num - int(num));
            } else {
                if (num < 0){
                    num = (num - (int(num) - 1));
                };
            };
            return (num);
        }
        public function getFollower(target:Object):PathFollower{
            if ((target is PathFollower)){
                return ((target as PathFollower));
            };
            var f:PathFollower = this._rootFollower;
            while (f) {
                if (f.target == target){
                    return (f);
                };
                f = f.cachedNext;
            };
            return (null);
        }
        protected function renderAll():void{
        }
        public function renderObjectAt(target:Object, progress:Number, autoRotate:Boolean=false, rotationOffset:Number=0):void{
        }
        public function lineStyle(thickness:Number=1, color:uint=0x666666, alpha:Number=1, pixelHinting:Boolean=false, scaleMode:String="none", caps:String=null, joints:String=null, miterLimit:Number=3, skipRedraw:Boolean=false):void{
            this._thickness = thickness;
            this._color = color;
            this._lineAlpha = alpha;
            this._pixelHinting = pixelHinting;
            this._scaleMode = scaleMode;
            this._caps = caps;
            this._joints = joints;
            this._miterLimit = miterLimit;
            this._redrawLine = true;
            if (!(skipRedraw)){
                this.renderAll();
            };
        }
        override public function get rotation():Number{
            return (super.rotation);
        }
        override public function set rotation(value:Number):void{
            super.rotation = value;
            this.renderAll();
        }
        override public function get scaleX():Number{
            return (super.scaleX);
        }
        override public function set scaleX(value:Number):void{
            super.scaleX = value;
            this.renderAll();
        }
        override public function get scaleY():Number{
            return (super.scaleY);
        }
        override public function set scaleY(value:Number):void{
            super.scaleY = value;
            this.renderAll();
        }
        override public function get x():Number{
            return (super.x);
        }
        override public function set x(value:Number):void{
            super.x = value;
            this.renderAll();
        }
        override public function get y():Number{
            return (super.y);
        }
        override public function set y(value:Number):void{
            super.y = value;
            this.renderAll();
        }
        override public function get width():Number{
            return (super.width);
        }
        override public function set width(value:Number):void{
            super.width = value;
            this.renderAll();
        }
        override public function get height():Number{
            return (super.height);
        }
        override public function set height(value:Number):void{
            super.height = value;
            this.renderAll();
        }
        override public function get visible():Boolean{
            return (super.visible);
        }
        override public function set visible(value:Boolean):void{
            super.visible = value;
            this._redrawLine = true;
            this.renderAll();
        }
        public function get progress():Number{
            return (this._progress);
        }
        public function set progress(value:Number):void{
            if (value > 1){
                value = (value - int(value));
            } else {
                if (value < 0){
                    value = (value - (int(value) - 1));
                };
            };
            var dif:Number = (value - this._progress);
            var f:PathFollower = this._rootFollower;
            while (f) {
                f.cachedProgress = (f.cachedProgress + dif);
                if (f.cachedProgress > 1){
                    f.cachedProgress = (f.cachedProgress - int(f.cachedProgress));
                } else {
                    if (f.cachedProgress < 0){
                        f.cachedProgress = (f.cachedProgress - (int(f.cachedProgress) - 1));
                    };
                };
                f = f.cachedNext;
            };
            this._progress = value;
            this.renderAll();
        }
        public function get followers():Array{
            var a:Array = [];
            var cnt:uint;
            var f:PathFollower = this._rootFollower;
            while (f) {
                var _temp1 = cnt;
                cnt = (cnt + 1);
                var _local4 = _temp1;
                a[_local4] = f;
                f = f.cachedNext;
            };
            return (a);
        }
        public function get targets():Array{
            var a:Array = [];
            var cnt:uint;
            var f:PathFollower = this._rootFollower;
            while (f) {
                var _temp1 = cnt;
                cnt = (cnt + 1);
                var _local4 = _temp1;
                a[_local4] = f.target;
                f = f.cachedNext;
            };
            return (a);
        }

    }
}//package com.greensock.motionPaths 
