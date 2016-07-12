//Created by Action Script Viewer - http://www.buraks.com/asv
package com.greensock.data {
    import flash.utils.*;

    public dynamic class VarsCore extends Proxy {

        public const isTV:Boolean = true;

        protected var _numbers:Object;
        protected var _props:Array;
        protected var _values:Object;

        protected static const _empty:Array = [];

        public function VarsCore(){
            this._numbers = {};
            this._values = {};
            super();
            this.initEnumerables(_empty, _empty);
        }
        protected function initEnumerables(nulls:Array, numbers:Array):void{
            this._props = nulls.concat(numbers);
            var i:int = numbers.length;
            while (i-- > 0) {
                this._numbers[numbers[i]] = true;
            };
        }
        override "http://www.adobe.com/2006/actionscript/flash/proxy"?? function getProperty(prop){
            return (this._values[prop]);
        }
        override "http://www.adobe.com/2006/actionscript/flash/proxy"?? function setProperty(prop, value):void{
            this.setProp(String(prop), value);
        }
        override "http://www.adobe.com/2006/actionscript/flash/proxy"?? function hasProperty(name):Boolean{
            return ((name in this._values));
        }
        override "http://www.adobe.com/2006/actionscript/flash/proxy"?? function deleteProperty(prop):Boolean{
            var i:int = this._props.indexOf(prop);
            if (i != -1){
                this._props.splice(i, 1);
                delete this._values[prop];
                return (true);
            };
            return (false);
        }
        override "http://www.adobe.com/2006/actionscript/flash/proxy"?? function nextNameIndex(index:int):int{
            var l:int;
            var p:String;
            var i:int;
            if (index >= this._props.length){
                return (0);
            };
            l = this._props.length;
            i = index;
            while (i < l) {
                p = this._props[i];
                if (this._numbers[p]){
                    if (((this[p]) || ((this[p] == 0)))){
                        return ((i + 1));
                    };
                } else {
                    if (this[p] != null){
                        return ((i + 1));
                    };
                };
                i++;
            };
            return (0);
        }
        override "http://www.adobe.com/2006/actionscript/flash/proxy"?? function nextName(index:int):String{
            return (this._props[(index - 1)]);
        }
        protected function setProp(name:String, value):void{
            if (!((name in this._values))){
                this._props[this._props.length] = name;
            };
            this._values[name] = value;
        }
        protected function copyPropsTo(vars:VarsCore):VarsCore{
            var p:String;
            for (p in this) {
                vars[p] = this[p];
            };
            return (vars);
        }
        public function get exposedVars():Object{
            return (this);
        }

    }
}//package com.greensock.data 
