package com.tencent.morefun.naruto.plugin.ui.util
{
 import flash.display.MovieClip;
 import flash.utils.getDefinitionByName;

    public class SmileyUtils
    {
        public static function getSmiley(id:int):MovieClip
        {
            var className:String = "com.tencent.morefun.naruto.plugin.ui.smiley.Smiley" + id;
            var cls:Class = getDefinitionByName(className) as Class;

            if (cls != null)
                return (new cls() as MovieClip);
            else
                return null;
        }

        public static function playSmiley(smiley:MovieClip):void
        {
            if (smiley == null)
                return;

            var animation:MovieClip = getSmileyAnimation(smiley);
            animation.gotoAndPlay(2);
        }

        public static function stopSmiley(smiley:MovieClip):void
        {
            if (smiley == null)
                return;

            var animation:MovieClip = getSmileyAnimation(smiley);
            animation.gotoAndStop(1);
        }

        public static function getSmileyAnimation(smiley:MovieClip):MovieClip
        {
            var animation:MovieClip = smiley.inner is MovieClip ? smiley.inner : smiley;
            return animation;
        }

        public function SmileyUtils()
        {
            throw new Error(SmileyUtils + " can not be instantiated.");
        }
    	}
}