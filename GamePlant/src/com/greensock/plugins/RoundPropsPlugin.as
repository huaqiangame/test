//Created by Action Script Viewer - http://www.buraks.com/asv
package com.greensock.plugins {
    import flash.display.*;
    import com.greensock.*;

    public class RoundPropsPlugin extends TweenPlugin {

        public static const API:Number = 1;

        public function RoundPropsPlugin(){
            super();
            this.propName = "roundProps";
            this.overwriteProps = [];
            this.round = true;
        }
        public function add(object:Object, propName:String, start:Number, change:Number):void{
            addTween(object, propName, start, (start + change), propName);
            this.overwriteProps[this.overwriteProps.length] = propName;
        }

    }
}//package com.greensock.plugins 
