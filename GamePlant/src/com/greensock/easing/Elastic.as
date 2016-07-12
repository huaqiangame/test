﻿//Created by Action Script Viewer - http://www.buraks.com/asv
package com.greensock.easing {

    public class Elastic {

        private static const _2PI:Number = 6.28318530717959;

        public static function easeIn(t:Number, b:Number, c:Number, d:Number, a:Number=0, p:Number=0):Number{
            var s:Number;
            if (t == 0){
                return (b);
            };
            t = (t / d);
            if (t == 1){
                return ((b + c));
            };
            if (!(p)){
                p = (d * 0.3);
            };
            if (((((!(a)) || ((((c > 0)) && ((a < c)))))) || ((((c < 0)) && ((a < -(c))))))){
                a = c;
                s = (p / 4);
            } else {
                s = ((p / _2PI) * Math.asin((c / a)));
            };
            t = (t - 1);
            return ((-(((a * Math.pow(2, (10 * t))) * Math.sin(((((t * d) - s) * _2PI) / p)))) + b));
        }
        public static function easeOut(t:Number, b:Number, c:Number, d:Number, a:Number=0, p:Number=0):Number{
            var s:Number;
            if (t == 0){
                return (b);
            };
            t = (t / d);
            if (t == 1){
                return ((b + c));
            };
            if (!(p)){
                p = (d * 0.3);
            };
            if (((((!(a)) || ((((c > 0)) && ((a < c)))))) || ((((c < 0)) && ((a < -(c))))))){
                a = c;
                s = (p / 4);
            } else {
                s = ((p / _2PI) * Math.asin((c / a)));
            };
            return (((((a * Math.pow(2, (-10 * t))) * Math.sin(((((t * d) - s) * _2PI) / p))) + c) + b));
        }
        public static function easeInOut(t:Number, b:Number, c:Number, d:Number, a:Number=0, p:Number=0):Number{
            var s:Number;
            if (t == 0){
                return (b);
            };
            t = (t / (d * 0.5));
            if (t == 2){
                return ((b + c));
            };
            if (!(p)){
                p = (d * (0.3 * 1.5));
            };
            if (((((!(a)) || ((((c > 0)) && ((a < c)))))) || ((((c < 0)) && ((a < -(c))))))){
                a = c;
                s = (p / 4);
            } else {
                s = ((p / _2PI) * Math.asin((c / a)));
            };
            if (t < 1){
                t = (t - 1);
                return (((-0.5 * ((a * Math.pow(2, (10 * t))) * Math.sin(((((t * d) - s) * _2PI) / p)))) + b));
            };
            t = (t - 1);
            return ((((((a * Math.pow(2, (-10 * t))) * Math.sin(((((t * d) - s) * _2PI) / p))) * 0.5) + c) + b));
        }

    }
}//package com.greensock.easing 
