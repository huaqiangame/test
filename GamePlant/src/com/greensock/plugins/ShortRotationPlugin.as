﻿//Created by Action Script Viewer - http://www.buraks.com/asv
package com.greensock.plugins {
    import flash.display.*;
    import com.greensock.*;

    public class ShortRotationPlugin extends TweenPlugin {

        public static const API:Number = 1;

        public function ShortRotationPlugin(){
            super();
            this.propName = "shortRotation";
            this.overwriteProps = [];
        }
        override public function onInitTween(target:Object, value, tween:TweenLite):Boolean{
            var p:String;
            if (typeof(value) == "number"){
                return (false);
            };
            for (p in value) {
                this.initRotation(target, p, target[p], ((typeof(value[p]))=="number") ? Number(value[p]) : (target[p] + Number(value[p])));
            };
            return (true);
        }
        public function initRotation(target:Object, propName:String, start:Number, end:Number):void{
            var dif:Number = ((end - start) % 360);
            if (dif != (dif % 180)){
                dif = ((dif)<0) ? (dif + 360) : (dif - 360);
            };
            addTween(target, propName, start, (start + dif), propName);
            this.overwriteProps[this.overwriteProps.length] = propName;
        }

    }
}//package com.greensock.plugins 
