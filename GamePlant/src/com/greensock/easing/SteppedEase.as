//Created by Action Script Viewer - http://www.buraks.com/asv
package com.greensock.easing {

    public class SteppedEase {

        private var _steps:int;
        private var _stepAmount:Number;

        public function SteppedEase(steps:int){
            super();
            this._stepAmount = (1 / steps);
            this._steps = (steps + 1);
        }
        public function ease(t:Number, b:Number, c:Number, d:Number):Number{
            var ratio:Number = (t / d);
            if (ratio < 0){
                ratio = 0;
            } else {
                if (ratio >= 1){
                    ratio = 0.999999999;
                };
            };
            return ((((this._steps * ratio) >> 0) * this._stepAmount));
        }
        public function get steps():int{
            return ((this._steps - 1));
        }
        public function autoSetNull():void{
        }

        public static function create(steps:int):Function{
            var se:SteppedEase = new SteppedEase(steps);
            return (se.ease);
        }

    }
}//package com.greensock.easing 
