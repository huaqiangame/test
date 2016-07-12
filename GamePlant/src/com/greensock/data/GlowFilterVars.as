//Created by Action Script Viewer - http://www.buraks.com/asv
package com.greensock.data {

    public class GlowFilterVars extends BlurFilterVars {

        public var alpha:Number;
        public var strength:Number;

        public function GlowFilterVars(blurX:Number=10, blurY:Number=10, color:uint=0xFFFFFF, alpha:Number=1, strength:Number=2, inner:Boolean=false, knockout:Boolean=false, quality:uint=2, remove:Boolean=false, index:int=-1, addFilter:Boolean=false){
            super(blurX, blurY, quality, remove, index, addFilter);
            this.color = color;
            this.alpha = alpha;
            this.strength = strength;
            this.inner = inner;
            this.knockout = knockout;
        }
        override protected function initEnumerables(nulls:Array, numbers:Array):void{
            super.initEnumerables(nulls, numbers.concat(["alpha", "strength"]));
        }
        public function get color():uint{
            return (uint(_values.color));
        }
        public function set color(value:uint):void{
            setProp("color", value);
        }
        public function get inner():Boolean{
            return (Boolean(_values.inner));
        }
        public function set inner(value:Boolean):void{
            setProp("inner", value);
        }
        public function get knockout():Boolean{
            return (Boolean(_values.knockout));
        }
        public function set knockout(value:Boolean):void{
            setProp("knockout", value);
        }

        public static function create(vars:Object):GlowFilterVars{
            if ((vars is GlowFilterVars)){
                return ((vars as GlowFilterVars));
            };
            return (new GlowFilterVars(((vars.blurX) || (0)), ((vars.blurY) || (0)), ((vars.color)==null) ? 0 : vars.color, ((vars.alpha) || (0)), ((vars.strength)==null) ? 2 : vars.strength, Boolean(vars.inner), Boolean(vars.knockout), ((vars.quality) || (2)), ((vars.remove) || (false)), ((vars.index)==null) ? -1 : vars.index, ((vars.addFilter) || (false))));
        }

    }
}//package com.greensock.data 
