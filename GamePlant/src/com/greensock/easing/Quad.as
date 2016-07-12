//Created by Action Script Viewer - http://www.buraks.com/asv
package com.greensock.easing {

    public class Quad {

        public static const power:uint = 1;

        public static function easeIn(t:Number, b:Number, c:Number, d:Number):Number{
            t = (t / d);
            return ((((c * t) * t) + b));
        }
        public static function easeOut(t:Number, b:Number, c:Number, d:Number):Number{
            t = (t / d);
            return ((((-(c) * t) * (t - 2)) + b));
        }
        public static function easeInOut(t:Number, b:Number, c:Number, d:Number):Number{
            t = (t / (d * 0.5));
            if (t < 1){
                return (((((c * 0.5) * t) * t) + b));
            };
            --t;
            return ((((-(c) * 0.5) * ((t * (t - 2)) - 1)) + b));
        }

    }
}//package com.greensock.easing 
