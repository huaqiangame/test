//Created by Action Script Viewer - http://www.buraks.com/asv
package com.greensock.plugins {
    import com.greensock.*;

    public class BezierThroughPlugin extends BezierPlugin {

        public static const API:Number = 1;

        public function BezierThroughPlugin(){
            super();
            this.propName = "bezierThrough";
        }
        override public function onInitTween(target:Object, value, tween:TweenLite):Boolean{
            if (!((value is Array))){
                return (false);
            };
            init(tween, (value as Array), true);
            return (true);
        }

    }
}//package com.greensock.plugins 
