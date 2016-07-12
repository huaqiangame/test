//Created by Action Script Viewer - http://www.buraks.com/asv
package com.greensock.data {
    import flash.geom.*;

    public class TransformAroundPointVars extends VarsCore {

        public var point:Point;
        public var scaleX:Number;
        public var scaleY:Number;
        public var scale:Number;
        public var rotation:Number;
        public var width:Number;
        public var height:Number;
        public var shortRotation:Object;
        public var x:Number;
        public var y:Number;

        public function TransformAroundPointVars(point:Point=null, scaleX:Number=NaN, scaleY:Number=NaN, rotation:Number=NaN, width:Number=NaN, height:Number=NaN, shortRotation:Object=null, x:Number=NaN, y:Number=NaN){
            super();
            if (point != null){
                this.point = point;
            };
            if (((scaleX) || ((scaleX == 0)))){
                this.scaleX = scaleX;
            };
            if (((scaleY) || ((scaleY == 0)))){
                this.scaleY = scaleY;
            };
            if (((rotation) || ((rotation == 0)))){
                this.rotation = rotation;
            };
            if (((width) || ((width == 0)))){
                this.width = width;
            };
            if (((height) || ((height == 0)))){
                this.height = height;
            };
            if (shortRotation != null){
                this.shortRotation = shortRotation;
            };
            if (((x) || ((x == 0)))){
                this.x = x;
            };
            if (((y) || ((y == 0)))){
                this.y = y;
            };
        }
        override protected function initEnumerables(nulls:Array, numbers:Array):void{
            super.initEnumerables(nulls.concat(["point", "shortRotation"]), numbers.concat(["scaleX", "scaleY", "scale", "rotation", "width", "height", "x", "y"]));
        }

        public static function create(vars:Object):TransformAroundPointVars{
            if ((vars is TransformAroundPointVars)){
                return ((vars as TransformAroundPointVars));
            };
            return (new TransformAroundPointVars(vars.point, vars.scaleX, vars.scaleY, vars.rotation, vars.width, vars.height, vars.shortRotation, vars.x, vars.y));
        }

    }
}//package com.greensock.data 
