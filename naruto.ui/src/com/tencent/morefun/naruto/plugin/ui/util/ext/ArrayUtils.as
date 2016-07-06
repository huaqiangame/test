package com.tencent.morefun.naruto.plugin.ui.util.ext {

    public class ArrayUtils {
        public function ArrayUtils() {
        }
        
        /**
         * 删除数组中指定的元素
         * @param arr
         * @param obj
         * @return
         */
        public static function remove(arr:Array, obj:Object):Boolean {
            var i:int = arr.indexOf(obj);
            
            if(i < 0)
                return false;
            else {
                arr.splice(i, 1);
                return true;
            }
        }
        
        /**
         * 将指定的对象添加到数组中,如果这个对象已经被加入到了数组中,那么则什么都不做;
         * @param arr
         * @param obj
         */
        public static function add(arr:Array, obj:Object):void {
            var i:int = arr.indexOf(obj);
            
            if(i < 0) {
                arr.push(obj);
            }
        }
        
        /**
         * 将obj对象添加到数组的指定位置.如果超过了数组的长度则自动添加到数组的最后一个.
         * @param arr
         * @param obj
         * @param index
         */
        public static function insert(arr:Array, obj:Object, index:uint):void {
            if(index > arr.length)
                index = arr.length;
            arr.splice(index, 0, obj);
        }
        
        /**
         * 复制一个数组.可以指定数组的维数;
         * @param arr
         * @param dimension 数组的维数,如果是多维数组,那么只需要设置好维数,那么将会拷贝一个多维数组;
         * @return
         *
         */
        public static function clone(arr:Array, dimension:uint = 1):Array {
            return null
        }
    	}
}
