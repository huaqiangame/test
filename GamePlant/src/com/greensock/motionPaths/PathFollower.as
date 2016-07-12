//Created by Action Script Viewer - http://www.buraks.com/asv
package com.greensock.motionPaths {

    public class PathFollower {

        public var target:Object;
        public var cachedProgress:Number;
        public var cachedNext:PathFollower;
        public var cachedPrev:PathFollower;
        public var path:MotionPath;
        public var autoRotate:Boolean;
        public var rotationOffset:Number;

        public function PathFollower(target:Object, autoRotate:Boolean=false, rotationOffset:Number=0){
            super();
            this.target = target;
            this.autoRotate = autoRotate;
            this.rotationOffset = rotationOffset;
            this.cachedProgress = 0;
        }
        public function get progress():Number{
            return (this.cachedProgress);
        }
        public function set progress(value:Number):void{
            if (value > 1){
                value = (value - int(value));
            } else {
                if (value < 0){
                    value = (value - (int(value) - 1));
                };
            };
            this.cachedProgress = value;
            if (this.path){
                this.path.renderObjectAt(this.target, value, this.autoRotate, this.rotationOffset);
            };
        }

    }
}//package com.greensock.motionPaths 
