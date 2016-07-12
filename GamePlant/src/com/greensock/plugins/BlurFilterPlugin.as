//Created by Action Script Viewer - http://www.buraks.com/asv
package com.greensock.plugins {
    import flash.filters.*;
    import flash.display.*;
    import com.greensock.*;

    public class BlurFilterPlugin extends FilterPlugin {

        public static const API:Number = 1;

        private static var _propNames:Array = ["blurX", "blurY", "quality"];

        public function BlurFilterPlugin(){
            super();
            this.propName = "blurFilter";
            this.overwriteProps = ["blurFilter"];
        }
        override public function onInitTween(target:Object, value, tween:TweenLite):Boolean{
            _target = target;
            _type = BlurFilter;
            initFilter(value, new BlurFilter(0, 0, ((value.quality) || (2))), _propNames);
            return (true);
        }

    }
}//package com.greensock.plugins 
