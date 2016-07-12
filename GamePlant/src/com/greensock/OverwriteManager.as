//Created by Action Script Viewer - http://www.buraks.com/asv
package com.greensock {
    import com.greensock.core.*;
    import flash.errors.*;
    import flash.utils.*;

    public class OverwriteManager {

        public static const version:Number = 6.02;
        public static const NONE:int = 0;
        public static const ALL_IMMEDIATE:int = 1;
        public static const AUTO:int = 2;
        public static const CONCURRENT:int = 3;
        public static const ALL_ONSTART:int = 4;
        public static const PREEXISTING:int = 5;

        public static var mode:int;
        public static var enabled:Boolean;

        public static function init(defaultMode:int=2):int{
            if (TweenLite.version < 11.1){
                throw (new Error("Warning: Your TweenLite class needs to be updated to work with OverwriteManager (or you may need to clear your ASO files). Please download and install the latest version from http://www.tweenlite.com."));
            };
            TweenLite.overwriteManager = OverwriteManager;
            mode = defaultMode;
            enabled = true;
            return (mode);
        }
        public static function manageOverwrites(tween:TweenLite, props:Object, targetTweens:Array, mode:uint):Boolean{
            var i:int;
            var changed:Boolean;
            var curTween:TweenLite;
            var l:uint;
            var combinedTimeScale:Number;
            var combinedStartTime:Number;
            var cousin:TweenCore;
            var cousinStartTime:Number;
            var timeline:SimpleTimeline;
            if (mode >= 4){
                l = targetTweens.length;
                i = 0;
                while (i < l) {
                    curTween = targetTweens[i];
                    if (curTween != tween){
                        if (curTween.setEnabled(false, false)){
                            changed = true;
                        };
                    } else {
                        if (mode == 5){
                            break;
                        };
                    };
                    i++;
                };
                return (changed);
            };
            var startTime:Number = (tween.cachedStartTime + 1E-10);
            var overlaps:Array = [];
            var cousins:Array = [];
            var cCount:uint;
            var oCount:uint;
            i = targetTweens.length;
            while (--i > -1) {
                curTween = targetTweens[i];
                if ((((curTween == tween)) || (curTween.gc))){
                } else {
                    if (curTween.timeline != tween.timeline){
                        if (!(getGlobalPaused(curTween))){
                            var _temp1 = cCount;
                            cCount = (cCount + 1);
                            var _local19 = _temp1;
                            cousins[_local19] = curTween;
                        };
                    } else {
                        if ((((((curTween.cachedStartTime <= startTime)) && ((((curTween.cachedStartTime + curTween.totalDuration) + 1E-10) > startTime)))) && (!(getGlobalPaused(curTween))))){
                            var _temp2 = oCount;
                            oCount = (oCount + 1);
                            _local19 = _temp2;
                            overlaps[_local19] = curTween;
                        };
                    };
                };
            };
            if (cCount != 0){
                combinedTimeScale = tween.cachedTimeScale;
                combinedStartTime = startTime;
                timeline = tween.timeline;
                while (timeline) {
                    combinedTimeScale = (combinedTimeScale * timeline.cachedTimeScale);
                    combinedStartTime = (combinedStartTime + timeline.cachedStartTime);
                    timeline = timeline.timeline;
                };
                startTime = (combinedTimeScale * combinedStartTime);
                i = cCount;
                while (--i > -1) {
                    cousin = cousins[i];
                    combinedTimeScale = cousin.cachedTimeScale;
                    combinedStartTime = cousin.cachedStartTime;
                    timeline = cousin.timeline;
                    while (timeline) {
                        combinedTimeScale = (combinedTimeScale * timeline.cachedTimeScale);
                        combinedStartTime = (combinedStartTime + timeline.cachedStartTime);
                        timeline = timeline.timeline;
                    };
                    cousinStartTime = (combinedTimeScale * combinedStartTime);
                    if ((((cousinStartTime <= startTime)) && ((((((cousinStartTime + (cousin.totalDuration * combinedTimeScale)) + 1E-10) > startTime)) || ((cousin.cachedDuration == 0)))))){
                        var _temp3 = oCount;
                        oCount = (oCount + 1);
                        _local19 = _temp3;
                        overlaps[_local19] = cousin;
                    };
                };
            };
            if (oCount == 0){
                return (changed);
            };
            i = oCount;
            if (mode == 2){
                while (--i > -1) {
                    curTween = overlaps[i];
                    if (curTween.killVars(props)){
                        changed = true;
                    };
                    if ((((curTween.cachedPT1 == null)) && (curTween.initted))){
                        curTween.setEnabled(false, false);
                    };
                };
            } else {
                while (--i > -1) {
                    if (TweenLite(overlaps[i]).setEnabled(false, false)){
                        changed = true;
                    };
                };
            };
            return (changed);
        }
        public static function getGlobalPaused(tween:TweenCore):Boolean{
            while (tween) {
                if (tween.cachedPaused){
                    return (true);
                };
                tween = tween.timeline;
            };
            return (false);
        }

    }
}//package com.greensock 
