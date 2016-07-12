//Created by Action Script Viewer - http://www.buraks.com/asv
package com.greensock.data {

    public class ColorTransformVars extends VarsCore {

        public var tintAmount:Number;
        public var exposure:Number;
        public var brightness:Number;
        public var redMultiplier:Number;
        public var redOffset:Number;
        public var greenMultiplier:Number;
        public var greenOffset:Number;
        public var blueMultiplier:Number;
        public var blueOffset:Number;
        public var alphaMultiplier:Number;
        public var alphaOffset:Number;

        public function ColorTransformVars(tint:Number=NaN, tintAmount:Number=NaN, exposure:Number=NaN, brightness:Number=NaN, redMultiplier:Number=NaN, greenMultiplier:Number=NaN, blueMultiplier:Number=NaN, alphaMultiplier:Number=NaN, redOffset:Number=NaN, greenOffset:Number=NaN, blueOffset:Number=NaN, alphaOffset:Number=NaN){
            super();
            if (((tint) || ((tint == 0)))){
                this.tint = uint(tint);
            };
            if (((tintAmount) || ((tintAmount == 0)))){
                this.tintAmount = tintAmount;
            };
            if (((exposure) || ((exposure == 0)))){
                this.exposure = exposure;
            };
            if (((brightness) || ((brightness == 0)))){
                this.brightness = brightness;
            };
            if (((redMultiplier) || ((redMultiplier == 0)))){
                this.redMultiplier = redMultiplier;
            };
            if (((greenMultiplier) || ((greenMultiplier == 0)))){
                this.greenMultiplier = greenMultiplier;
            };
            if (((blueMultiplier) || ((blueMultiplier == 0)))){
                this.blueMultiplier = blueMultiplier;
            };
            if (((alphaMultiplier) || ((alphaMultiplier == 0)))){
                this.alphaMultiplier = alphaMultiplier;
            };
            if (((redOffset) || ((redOffset == 0)))){
                this.redOffset = redOffset;
            };
            if (((greenOffset) || ((greenOffset == 0)))){
                this.greenOffset = greenOffset;
            };
            if (((blueOffset) || ((blueOffset == 0)))){
                this.blueOffset = blueOffset;
            };
            if (((alphaOffset) || ((alphaOffset == 0)))){
                this.alphaOffset = alphaOffset;
            };
        }
        override protected function initEnumerables(nulls:Array, numbers:Array):void{
            super.initEnumerables(nulls, numbers.concat(["tintAmount", "exposure", "brightness", "redMultiplier", "redOffset", "greenMultiplier", "greenOffset", "blueMultiplier", "blueOffset", "alphaMultiplier", "alphaOffset"]));
        }
        public function get tint():uint{
            return (uint(_values.tint));
        }
        public function set tint(value:uint):void{
            setProp("tint", value);
        }

        public static function create(vars:Object):ColorTransformVars{
            if ((vars is _slot1)){
                return ((vars as _slot1));
            };
            return (new ColorTransformVars(vars.tint, vars.tintAmount, vars.exposure, vars.brightness, vars.redMultiplier, vars.greenMultiplier, vars.blueMultiplier, vars.alphaMultiplier, vars.redOffset, vars.greenOffset, vars.blueOffset, vars.alphaOffset));
        }

    }
}//package com.greensock.data 
