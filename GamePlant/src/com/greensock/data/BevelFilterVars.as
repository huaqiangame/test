//Created by Action Script Viewer - http://www.buraks.com/asv
package com.greensock.data {

    public class BevelFilterVars extends FilterVars {

        public var distance:Number;
        public var blurX:Number;
        public var blurY:Number;
        public var strength:Number;
        public var angle:Number;
        public var highlightAlpha:Number;
        public var shadowAlpha:Number;

        public function BevelFilterVars(distance:Number=4, blurX:Number=4, blurY:Number=4, strength:Number=1, angle:Number=45, highlightAlpha:Number=1, highlightColor:uint=0xFFFFFF, shadowAlpha:Number=1, shadowColor:uint=0, quality:uint=2, remove:Boolean=false, index:int=-1, addFilter:Boolean=false){
            super(remove, index, addFilter);
            this.distance = distance;
            this.blurX = blurX;
            this.blurY = blurY;
            this.strength = strength;
            this.angle = angle;
            this.highlightAlpha = highlightAlpha;
            this.highlightColor = highlightColor;
            this.shadowAlpha = shadowAlpha;
            this.shadowColor = shadowColor;
            this.quality = quality;
        }
        override protected function initEnumerables(nulls:Array, numbers:Array):void{
            super.initEnumerables(nulls, numbers.concat(["distance", "blurX", "blurY", "strength", "angle", "highlightAlpha", "shadowAlpha"]));
        }
        public function get highlightColor():uint{
            return (uint(_values.highlightColor));
        }
        public function set highlightColor(value:uint):void{
            setProp("highlightColor", value);
        }
        public function get shadowColor():uint{
            return (uint(_values.shadowColor));
        }
        public function set shadowColor(value:uint):void{
            setProp("shadowColor", value);
        }
        public function get quality():uint{
            return (uint(_values.quality));
        }
        public function set quality(value:uint):void{
            setProp("quality", value);
        }

        public static function create(vars:Object):BevelFilterVars{
            if ((vars is BevelFilterVars)){
                return ((vars as BevelFilterVars));
            };
            return (new BevelFilterVars(((vars.distance) || (0)), ((vars.blurX) || (0)), ((vars.blurY) || (0)), ((vars.strength)==null) ? 1 : vars.strength, ((vars.angle)==null) ? 45 : vars.angle, ((vars.highlightAlpha)==null) ? 1 : vars.highlightAlpha, ((vars.highlightColor)==null) ? 0xFFFFFF : vars.highlightColor, ((vars.shadowAlpha)==null) ? 1 : vars.shadowAlpha, ((vars.shadowColor)==null) ? 0xFFFFFF : vars.shadowColor, ((vars.quality) || (2)), ((vars.remove) || (false)), ((vars.index)==null) ? -1 : vars.index, ((vars.addFilter) || (false))));
        }

    }
}//package com.greensock.data 
