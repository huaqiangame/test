//Created by Action Script Viewer - http://www.buraks.com/asv
package com.adobe.utils {
    import flash.utils.*;

    public class DictionaryUtil {

        public static function getKeys(d:Dictionary):Array{
            var key:Object;
            var a:Array = new Array();
            for (key in d) {
                a.push(key);
            };
            return (a);
        }
        public static function getValues(d:Dictionary):Array{
            var value:Object;
            var a:Array = new Array();
            for each (value in d) {
                a.push(value);
            };
            return (a);
        }

    }
}//package com.adobe.utils 
