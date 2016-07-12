//Created by Action Script Viewer - http://www.buraks.com/asv
package com.greensock.plugins {
    import com.greensock.*;
    import flash.display.*;

    public class EndArrayPlugin extends TweenPlugin {

        protected var _a:Array;
        protected var _info:Array;

        public static const API:Number = 1;

        public function EndArrayPlugin(){
            this._info = [];
            super();
            this.propName = "endArray";
            this.overwriteProps = ["endArray"];
        }
        override public function onInitTween(target:Object, value, tween:TweenLite):Boolean{
            if (((!((target is Array))) || (!((value is Array))))){
                return (false);
            };
            this.init((target as Array), value);
            return (true);
        }
        public function init(start:Array, end:Array):void{
            this._a = start;
            var i:int = end.length;
            while (i--) {
                if (((!((start[i] == end[i]))) && (!((start[i] == null))))){
                    this._info[this._info.length] = new ArrayTweenInfo(i, this._a[i], (end[i] - this._a[i]));
                };
            };
        }
        override public function set changeFactor(n:Number):void{
            var ti:ArrayTweenInfo;
            var val:Number;
            var i:int = this._info.length;
            if (this.round){
                while (i--) {
                    ti = this._info[i];
                    val = (ti.start + (ti.change * n));
                    this._a[ti.index] = ((val)>0) ? int((val + 0.5)) : int((val - 0.5));
                };
            } else {
                while (i--) {
                    ti = this._info[i];
                    this._a[ti.index] = (ti.start + (ti.change * n));
                };
            };
        }

    }
}//package com.greensock.plugins 

class ArrayTweenInfo {

    public var index:uint;
    public var start:Number;
    public var change:Number;

    private function ArrayTweenInfo(index:uint, start:Number, change:Number){
        super();
        this.index = index;
        this.start = start;
        this.change = change;
    }
}
