//Created by Action Script Viewer - http://www.buraks.com/asv
package com.greensock {
    import flash.utils.*;
    import flash.display.*;
    import flash.events.*;

    public class TweenNano {

        public var duration:Number;
        public var vars:Object;
        public var startTime:Number;
        public var target:Object;
        public var active:Boolean;
        public var gc:Boolean;
        public var useFrames:Boolean;
        public var ratio:Number;// = 0
        protected var _ease:Function;
        protected var _initted:Boolean;
        protected var _propTweens:Array;

        protected static var _time:Number;
        protected static var _frame:uint;
        protected static var _masterList:Dictionary = new Dictionary(false);
        protected static var _shape:Shape = new Shape();
        protected static var _tnInitted:Boolean;
        protected static var _reservedProps:Object = {ease:1, delay:1, useFrames:1, overwrite:1, onComplete:1, onCompleteParams:1, runBackwards:1, immediateRender:1, onUpdate:1, onUpdateParams:1};

        public function TweenNano(target:Object, duration:Number, vars:Object){
            super();
            if (!(_tnInitted)){
                _time = (getTimer() * 0.001);
                _frame = 0;
                _shape.addEventListener(Event.ENTER_FRAME, updateAll, false, 0, true);
                _tnInitted = true;
            };
            this.vars = vars;
            this.duration = duration;
            this.active = Boolean((((((duration == 0)) && ((this.vars.delay == 0)))) && (!((this.vars.immediateRender == false)))));
            this.target = target;
            if (typeof(this.vars.ease) != "function"){
                this._ease = _slot1.easeOut;
            } else {
                this._ease = this.vars.ease;
            };
            this._propTweens = [];
            this.useFrames = Boolean((vars.useFrames == true));
            var delay:Number = (("delay" in this.vars)) ? Number(this.vars.delay) : 0;
            this.startTime = (this.useFrames) ? (_frame + delay) : (_time + delay);
            var a:Array = _masterList[target];
            if ((((((a == null)) || ((int(this.vars.overwrite) == 1)))) || ((this.vars.overwrite == null)))){
                _masterList[target] = [this];
            } else {
                a[a.length] = this;
            };
            if ((((this.vars.immediateRender == true)) || (this.active))){
                this.renderTime(0);
            };
        }
        public function init():void{
            var p:String;
            var pt:Array;
            var i:int;
            for (p in this.vars) {
                if (!((p in _reservedProps))){
                    this._propTweens[this._propTweens.length] = [p, this.target[p], ((typeof(this.vars[p]))=="number") ? (this.vars[p] - this.target[p]) : Number(this.vars[p])];
                };
            };
            if (this.vars.runBackwards){
                i = this._propTweens.length;
                while (--i > -1) {
                    pt = this._propTweens[i];
                    pt[1] = (pt[1] + pt[2]);
                    pt[2] = -(pt[2]);
                };
            };
            this._initted = true;
        }
        public function renderTime(time:Number):void{
            var pt:Array;
            if (!(this._initted)){
                this.init();
            };
            var i:int = this._propTweens.length;
            if (time >= this.duration){
                time = this.duration;
                this.ratio = 1;
            } else {
                if (time <= 0){
                    this.ratio = 0;
                } else {
                    this.ratio = this._ease(time, 0, 1, this.duration);
                };
            };
            while (--i > -1) {
                pt = this._propTweens[i];
                this.target[pt[0]] = (pt[1] + (this.ratio * pt[2]));
            };
            if (this.vars.onUpdate){
                this.vars.onUpdate.apply(null, this.vars.onUpdateParams);
            };
            if (time == this.duration){
                this.complete(true);
            };
        }
        public function complete(skipRender:Boolean=false):void{
            if (!(skipRender)){
                this.renderTime(this.duration);
                return;
            };
            this.kill();
            if (this.vars.onComplete){
                this.vars.onComplete.apply(null, this.vars.onCompleteParams);
            };
        }
        public function kill():void{
            this.gc = true;
            this.active = false;
        }

        public static function to(target:Object, duration:Number, vars:Object):TweenNano{
            return (new TweenNano(target, duration, vars));
        }
        public static function from(target:Object, duration:Number, vars:Object):TweenNano{
            vars.runBackwards = true;
            if (!(("immediateRender" in vars))){
                vars.immediateRender = true;
            };
            return (new TweenNano(target, duration, vars));
        }
        public static function delayedCall(delay:Number, onComplete:Function, onCompleteParams:Array=null, useFrames:Boolean=false):TweenNano{
            return (new TweenNano(onComplete, 0, {delay:delay, onComplete:onComplete, onCompleteParams:onCompleteParams, useFrames:useFrames, overwrite:0}));
        }
        public static function updateAll(e:Event=null):void{
            var a:Array;
            var tgt:Object;
            var i:int;
            var t:Number;
            var tween:TweenNano;
            _frame++;
            _time = (getTimer() * 0.001);
            var ml:Dictionary = _masterList;
            for (tgt in ml) {
                a = ml[tgt];
                i = a.length;
                while (--i > -1) {
                    tween = a[i];
                    t = (tween.useFrames) ? _frame : _time;
                    if (((tween.active) || (((!(tween.gc)) && ((t >= tween.startTime)))))){
                        tween.renderTime((t - tween.startTime));
                    } else {
                        if (tween.gc){
                            a.splice(i, 1);
                        };
                    };
                };
                if (a.length == 0){
                    delete ml[tgt];
                };
            };
        }
        public static function killTweensOf(target:Object, complete:Boolean=false):void{
            var a:Array;
            var i:int;
            if ((target in _masterList)){
                if (complete){
                    a = _masterList[target];
                    i = a.length;
                    while (--i > -1) {
                        if (!(TweenNano(a[i]).gc)){
                            TweenNano(a[i]).complete(false);
                        };
                    };
                };
                delete _masterList[target];
            };
        }
        private static function easeOut(t:Number, b:Number, c:Number, d:Number):Number{
            t = (t / d);
            return (((-1 * t) * (t - 2)));
        }

    }
}//package com.greensock 
