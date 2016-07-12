//Created by Action Script Viewer - http://www.buraks.com/asv
package com.greensock.plugins {
    import com.greensock.*;

    public class QuaternionsPlugin extends TweenPlugin {

        protected var _target:Object;
        protected var _quaternions:Array;

        public static const API:Number = 1;
        protected static const _RAD2DEG:Number = 57.2957795130823;

        public function QuaternionsPlugin(){
            this._quaternions = [];
            super();
            this.propName = "quaternions";
            this.overwriteProps = [];
        }
        override public function onInitTween(target:Object, value, tween:TweenLite):Boolean{
            var p:String;
            if (value == null){
                return (false);
            };
            for (p in value) {
                this.initQuaternion(target[p], value[p], p);
            };
            return (true);
        }
        public function initQuaternion(start:Object, end:Object, propName:String):void{
            var angle:Number;
            var q1:Object;
            var q2:Object;
            var x1:Number;
            var x2:Number;
            var y1:Number;
            var y2:Number;
            var z1:Number;
            var z2:Number;
            var w1:Number;
            var w2:Number;
            var theta:Number;
            q1 = start;
            q2 = end;
            x1 = q1.x;
            x2 = q2.x;
            y1 = q1.y;
            y2 = q2.y;
            z1 = q1.z;
            z2 = q2.z;
            w1 = q1.w;
            w2 = q2.w;
            angle = ((((x1 * x2) + (y1 * y2)) + (z1 * z2)) + (w1 * w2));
            if (angle < 0){
                x1 = (x1 * -1);
                y1 = (y1 * -1);
                z1 = (z1 * -1);
                w1 = (w1 * -1);
                angle = (angle * -1);
            };
            if ((angle + 1) < 1E-6){
                y2 = -(y1);
                x2 = x1;
                w2 = -(w1);
                z2 = z1;
            };
            theta = Math.acos(angle);
            this._quaternions[this._quaternions.length] = [q1, propName, x1, x2, y1, y2, z1, z2, w1, w2, angle, theta, (1 / Math.sin(theta))];
            this.overwriteProps[this.overwriteProps.length] = propName;
        }
        override public function killProps(lookup:Object):void{
            var i:int = (this._quaternions.length - 1);
            while (i > -1) {
                if (lookup[this._quaternions[i][1]] != undefined){
                    this._quaternions.splice(i, 1);
                };
                i--;
            };
            super.killProps(lookup);
        }
        override public function set changeFactor(n:Number):void{
            var i:int;
            var q:Array;
            var scale:Number;
            var invScale:Number;
            i = (this._quaternions.length - 1);
            while (i > -1) {
                q = this._quaternions[i];
                if ((q[10] + 1) > 1E-6){
                    if ((1 - q[10]) >= 1E-6){
                        scale = (Math.sin((q[11] * (1 - n))) * q[12]);
                        invScale = (Math.sin((q[11] * n)) * q[12]);
                    } else {
                        scale = (1 - n);
                        invScale = n;
                    };
                } else {
                    scale = Math.sin((Math.PI * (0.5 - n)));
                    invScale = Math.sin((Math.PI * n));
                };
                q[0].x = ((scale * q[2]) + (invScale * q[3]));
                q[0].y = ((scale * q[4]) + (invScale * q[5]));
                q[0].z = ((scale * q[6]) + (invScale * q[7]));
                q[0].w = ((scale * q[8]) + (invScale * q[9]));
                i--;
            };
        }

    }
}//package com.greensock.plugins 
