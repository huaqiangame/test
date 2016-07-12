//Created by Action Script Viewer - http://www.buraks.com/asv
package com.greensock.data {
    import com.greensock.*;

    public dynamic class TweenLiteVars extends VarsCore {

        public var data;
        public var delay:Number;
        public var ease:Function;
        public var easeParams:Array;
        public var onInit:Function;
        public var onInitParams:Array;
        public var onStart:Function;
        public var onStartParams:Array;
        public var onUpdate:Function;
        public var onUpdateParams:Array;
        public var onComplete:Function;
        public var onCompleteParams:Array;
        public var dynamicProps:Object;
        public var scrollRect:Object;
        public var autoAlpha:Number;
        public var endArray:Array;
        public var frameLabel:String;
        public var volume:Number;
        public var bevelFilter:BevelFilterVars;
        public var bezier:Array;
        public var bezierThrough:Array;
        public var blurFilter:BlurFilterVars;
        public var colorMatrixFilter:ColorMatrixFilterVars;
        public var dropShadowFilter:DropShadowFilterVars;
        public var glowFilter:GlowFilterVars;
        public var hexColors:Object;
        public var orientToBezier:Array;
        public var quaternions:Object;
        public var setSize:Object;
        public var shortRotation:Object;
        public var transformAroundPoint:TransformAroundPointVars;
        public var transformAroundCenter:TransformAroundCenterVars;
        public var colorTransform:ColorTransformVars;
        public var motionBlur:Object;

        protected static var _subVars:Object = {blurFilter:BlurFilterVars, colorMatrixFilter:ColorMatrixFilterVars, bevelFilter:BevelFilterVars, glowFilter:GlowFilterVars, transformAroundPoint:TransformAroundPointVars, transformAroundCenter:TransformAroundCenterVars, colorTransform:ColorTransformVars};

        public function TweenLiteVars(vars:Object=null){
            var p:String;
            super();
            initEnumerables(["data", "ease", "easeParams", "onInit", "onInitParams", "onStart", "onStartParams", "onUpdate", "onUpdateParams", "onComplete", "onCompleteParams", "endArray", "frameLabel", "bevelFilter", "bezier", "bezierThrough", "blurFilter", "colorMatrixFilter", "dropShadowFilter", "glowFilter", "hexColors", "orientToBezier", "quaternions", "setSize", "shortRotation", "transformAroundPoint", "transformAroundCenter", "colorTransform", "motionBlur", "dynamicProps"], ["autoAlpha", "delay", "volume"]);
            if (vars != null){
                for (p in vars) {
                    if ((p in _subVars)){
                        _subVars[p].create(vars[p]);
                    } else {
                        this[p] = vars[p];
                    };
                };
            };
            if (TweenLite.version < 11){
                trace("TweenLiteVars error! Please update your TweenLite class or try deleting your ASO files. TweenLiteVars requires a more recent version. Download updates at http://www.TweenLite.com.");
            };
        }
        public function addProp(name:String, value:Number, relative:Boolean=false):void{
            this[name] = (relative) ? String(value) : value;
        }
        public function clone():TweenLiteVars{
            return ((this.copyPropsTo(new TweenLiteVars()) as _slot1));
        }
        public function get removeTint():Boolean{
            return (Boolean(_values.removeTint));
        }
        public function set removeTint(value:Boolean):void{
            setProp("removeTint", value);
        }
        public function get visible():Boolean{
            return (Boolean(_values.visible));
        }
        public function set visible(value:Boolean):void{
            setProp("visible", value);
        }
        public function get frame():int{
            return (int(_values.frame));
        }
        public function set frame(value:int):void{
            setProp("frame", value);
        }
        public function get tint():uint{
            return (uint(_values.tint));
        }
        public function set tint(value:uint):void{
            setProp("tint", value);
        }
        public function get immediateRender():Boolean{
            return (Boolean(_values.immediateRender));
        }
        public function set immediateRender(value:Boolean):void{
            setProp("immediateRender", value);
        }
        public function get runBackwards():Boolean{
            return (Boolean(_values.runBackwards));
        }
        public function set runBackwards(value:Boolean):void{
            setProp("runBackwards", value);
        }
        public function get useFrames():Boolean{
            return (Boolean(_values.useFrames));
        }
        public function set useFrames(value:Boolean):void{
            setProp("useFrames", value);
        }
        public function get overwrite():int{
            if (("overwrite" in _values)){
                return (int(_values.overwrite));
            };
            return (-1);
        }
        public function set overwrite(value:int):void{
            setProp("overwrite", value);
        }

    }
}//package com.greensock.data 
