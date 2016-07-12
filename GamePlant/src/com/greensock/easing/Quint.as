//Created by Action Script Viewer - http://www.buraks.com/asv
package com.greensock.easing {

    public class Quint {

        public static const power:uint = 4;

        public static function easeIn(t:Number, b:Number, c:Number, d:Number):Number{
            t = (t / d);
            return (((((((c * t) * t) * t) * t) * t) + b));
        }
        public static function easeOut(t:Number, b:Number, c:Number, d:Number):Number{
            t = ((t / d) - 1);
            return (((c * (((((t * t) * t) * t) * t) + 1)) + b));
        }
        public static function easeInOut(t:Number, b:Number, c:Number, d:Number):Number{
            t = (t / (d * 0.5));
            if (t < 1){
                return ((((((((c * 0.5) * t) * t) * t) * t) * t) + b));
            };
            t = (t - 2);
            return ((((c * 0.5) * (((((t * t) * t) * t) * t) + 2)) + b));
        }

    }
}//package com.greensock.easing 
