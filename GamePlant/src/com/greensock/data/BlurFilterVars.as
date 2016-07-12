//Created by Action Script Viewer - http://www.buraks.com/asv
package com.greensock.data {

    public class BlurFilterVars extends FilterVars {

        public var blurX:Number;
        public var blurY:Number;

        public function BlurFilterVars(blurX:Number=10, blurY:Number=10, quality:uint=2, remove:Boolean=false, index:int=-1, addFilter:Boolean=false){
            super(remove, index, addFilter);
            this.blurX = blurX;
            this.blurY = blurY;
            this.quality = quality;
        }
        override protected function initEnumerables(nulls:Array, numbers:Array):void{
            super.initEnumerables(nulls, numbers.concat(["blurX", "blurY"]));
        }
        public function get quality():uint{
            return (uint(_values.quality));
        }
        public function set quality(value:uint):void{
            setProp("quality", value);
        }

        public static function create(vars:Object):BlurFilterVars{
            if ((vars is BlurFilterVars)){
                return ((vars as BlurFilterVars));
            };
            return (new BlurFilterVars(((vars.blurX) || (0)), ((vars.blurY) || (0)), ((vars.quality) || (2)), ((vars.remove) || (false)), ((vars.index)==null) ? -1 : vars.index, ((vars.addFilter) || (false))));
        }

    }
}//package com.greensock.data 
