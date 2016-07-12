//Created by Action Script Viewer - http://www.buraks.com/asv
package com.greensock.easing {
    import com.greensock.*;

    public class FastEase {

        public static function activateEase(ease:Function, type:int, power:uint):void{
            TweenLite.fastEaseLookup[ease] = [type, power];
        }
        public static function activate(easeClasses:Array):void{
            var easeClass:Object;
            var i:int = easeClasses.length;
            while (i--) {
                easeClass = easeClasses[i];
                if (easeClass.hasOwnProperty("power")){
                    activateEase(easeClass.easeIn, 1, easeClass.power);
                    activateEase(easeClass.easeOut, 2, easeClass.power);
                    activateEase(easeClass.easeInOut, 3, easeClass.power);
                    if (easeClass.hasOwnProperty("easeNone")){
                        activateEase(easeClass.easeNone, 1, 0);
                    };
                };
            };
        }

    }
}//package com.greensock.easing 
