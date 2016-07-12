//Created by Action Script Viewer - http://www.buraks.com/asv
package com.greensock.easing {

    public class Back {

        public static function easeIn(t:Number, b:Number, c:Number, d:Number, s:Number=1.70158):Number{
            t = (t / d);
            return (((((c * t) * t) * (((s + 1) * t) - s)) + b));
        }
        public static function easeOut(t:Number, b:Number, c:Number, d:Number, s:Number=1.70158):Number{
            t = ((t / d) - 1);
            return (((c * (((t * t) * (((s + 1) * t) + s)) + 1)) + b));
        }
        public static function easeInOut(t:Number, b:Number, c:Number, d:Number, s:Number=1.70158):Number{
            t = (t / (d * 0.5));
            if (t < 1){
                s = (s * 1.525);
                return ((((c * 0.5) * ((t * t) * (((s + 1) * t) - s))) + b));
            };
            t = (t - 2);
            s = (s * 1.525);
            return ((((c / 2) * (((t * t) * (((s + 1) * t) + s)) + 2)) + b));
        }

    }
}//package com.greensock.easing 
