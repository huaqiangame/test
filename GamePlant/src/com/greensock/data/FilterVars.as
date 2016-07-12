//Created by Action Script Viewer - http://www.buraks.com/asv
package com.greensock.data {

    public dynamic class FilterVars extends VarsCore {

        public function FilterVars(remove:Boolean=false, index:int=-1, addFilter:Boolean=false){
            super();
            this.remove = remove;
            if (index > -1){
                this.index = index;
            };
            this.addFilter = addFilter;
        }
        public function get remove():Boolean{
            return (Boolean(_values.remove));
        }
        public function set remove(value:Boolean):void{
            setProp("remove", value);
        }
        public function get addFilter():Boolean{
            return (Boolean(_values.addFilter));
        }
        public function set addFilter(value:Boolean):void{
            setProp("addFilter", value);
        }
        public function get index():int{
            return (int(_values.index));
        }
        public function set index(value:int):void{
            setProp("index", value);
        }

    }
}//package com.greensock.data 
