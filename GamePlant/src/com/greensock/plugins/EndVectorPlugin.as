//Created by Action Script Viewer - http://www.buraks.com/asv
package com.greensock.plugins {
    import com.greensock.*;
    import flash.display.*;
    import __AS3__.vec.*;

    public class EndVectorPlugin extends TweenPlugin {

        protected var _v:Vector.<Number>;
        protected var _info:Vector.<VectorInfo>;

        public static const API:Number = 1;

        public function EndVectorPlugin(){
            this._info = new Vector.<_slot2>();
            super();
            this.propName = "endVector";
            this.overwriteProps = ["endVector"];
        }
        override public function onInitTween(target:Object, value, tween:TweenLite):Boolean{
            if (((!((target is Vector.<Number>))) || (!((value is Vector.<Number>))))){
                return (false);
            };
            this.init((target as Vector.<Number>), (value as Vector.<Number>));
            return (true);
        }
        public function init(start:Vector.<Number>, end:Vector.<Number>):void{
            this._v = start;
            var i:int = end.length;
            var cnt:uint;
            while (i--) {
                if (this._v[i] != end[i]){
                    var _temp1 = cnt;
                    cnt = (cnt + 1);
                    var _local5 = _temp1;
                    this._info[_local5] = new VectorInfo(i, this._v[i], (end[i] - this._v[i]));
                };
            };
        }
        override public function set changeFactor(n:Number):void{
            var vi:VectorInfo;
            var val:Number;
            var i:int = this._info.length;
            if (this.round){
                while (i--) {
                    vi = this._info[i];
                    val = (vi.start + (vi.change * n));
                    this._v[vi.index] = ((val)>0) ? int((val + 0.5)) : int((val - 0.5));
                };
            } else {
                while (i--) {
                    vi = this._info[i];
                    this._v[vi.index] = (vi.start + (vi.change * n));
                };
            };
        }

    }
}//package com.greensock.plugins 

class VectorInfo {

    public var index:uint;
    public var start:Number;
    public var change:Number;

    private function VectorInfo(index:uint, start:Number, change:Number){
        super();
        this.index = index;
        this.start = start;
        this.change = change;
    }
}
