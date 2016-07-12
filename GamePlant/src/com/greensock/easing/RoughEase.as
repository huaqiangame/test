//Created by Action Script Viewer - http://www.buraks.com/asv
package com.greensock.easing {

    public class RoughEase {

        private var _name:String;
        private var _first:EasePoint;
        private var _last:EasePoint;

        private static var _all:Object = {};
        private static var _count:uint = 0;

        public function RoughEase(strength:Number=1, points:uint=20, restrictMaxAndMin:Boolean=false, templateEase:Function=null, taper:String="none", randomize:Boolean=true, name:String=""){
            var x:Number;
            var y:Number;
            var bump:Number;
            var invX:Number;
            var obj:Object;
            super();
            if (name == ""){
                _count++;
                this._name = ("roughEase" + _count);
            } else {
                this._name = name;
            };
            if ((((taper == "")) || ((taper == null)))){
                taper = "none";
            };
            _all[this._name] = this;
            var a:Array = [];
            var cnt:uint;
            var i:uint = points;
            while (i--) {
                x = (randomize) ? Math.random() : ((1 / points) * i);
                y = ((templateEase)!=null) ? templateEase(x, 0, 1, 1) : x;
                if (taper == "none"){
                    bump = (0.4 * strength);
                } else {
                    if (taper == "out"){
                        invX = (1 - x);
                        bump = (((invX * invX) * strength) * 0.4);
                    } else {
                        bump = (((x * x) * strength) * 0.4);
                    };
                };
                if (randomize){
                    y = (y + ((Math.random() * bump) - (bump * 0.5)));
                } else {
                    if ((i % 2)){
                        y = (y + (bump * 0.5));
                    } else {
                        y = (y - (bump * 0.5));
                    };
                };
                if (restrictMaxAndMin){
                    if (y > 1){
                        y = 1;
                    } else {
                        if (y < 0){
                            y = 0;
                        };
                    };
                };
                var _temp1 = cnt;
                cnt = (cnt + 1);
                var _local16 = _temp1;
                a[_local16] = {x:x, y:y};
            };
            a.sortOn("x", Array.NUMERIC);
            this._first = (this._last = new EasePoint(1, 1, null));
            i = points;
            while (i--) {
                obj = a[i];
                this._first = new EasePoint(obj.x, obj.y, this._first);
            };
            this._first = new EasePoint(0, 0, this._first);
        }
        public function ease(t:Number, b:Number, c:Number, d:Number):Number{
            var p:EasePoint;
            var time:Number = (t / d);
            if (time < 0.5){
                p = this._first;
                while (p.time <= time) {
                    p = p.next;
                };
                p = p.prev;
            } else {
                p = this._last;
                while (p.time >= time) {
                    p = p.prev;
                };
            };
            return ((b + ((p.value + (((time - p.time) / p.gap) * p.change)) * c)));
        }
        public function get name():String{
            return (this._name);
        }
        public function set name(s:String):void{
            delete _all[this._name];
            this._name = s;
            _all[s] = this;
        }

        public static function create(strength:Number=1, points:uint=20, restrictMaxAndMin:Boolean=false, templateEase:Function=null, taper:String="none", randomize:Boolean=true, name:String=""):Function{
            return (new RoughEase(strength, points, restrictMaxAndMin, templateEase, taper, randomize, name).ease);
        }
        public static function byName(name:String):Function{
            return (_all[name].ease);
        }

    }
}//package com.greensock.easing 

class EasePoint {

    public var time:Number;
    public var gap:Number;
    public var value:Number;
    public var change:Number;
    public var next:EasePoint;
    public var prev:EasePoint;

    private function EasePoint(time:Number, value:Number, next:EasePoint){
        super();
        this.time = time;
        this.value = value;
        if (next){
            this.next = next;
            next.prev = this;
            this.change = (next.value - value);
            this.gap = (next.time - time);
        };
    }
}
