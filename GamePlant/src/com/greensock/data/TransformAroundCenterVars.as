//Created by Action Script Viewer - http://www.buraks.com/asv
package com.greensock.data {

    public class TransformAroundCenterVars extends TransformAroundPointVars {

        public function TransformAroundCenterVars(scaleX:Number=NaN, scaleY:Number=NaN, rotation:Number=NaN, width:Number=NaN, height:Number=NaN, shortRotation:Object=null, x:Number=NaN, y:Number=NaN){
            super(null, scaleX, scaleY, rotation, width, height, shortRotation, x, y);
        }
        public static function create(vars:Object):TransformAroundCenterVars{
            if ((vars is TransformAroundCenterVars)){
                return ((vars as TransformAroundCenterVars));
            };
            return (new TransformAroundCenterVars(vars.scaleX, vars.scaleY, vars.rotation, vars.width, vars.height, vars.shortRotation, vars.x, vars.y));
        }

    }
}//package com.greensock.data 
