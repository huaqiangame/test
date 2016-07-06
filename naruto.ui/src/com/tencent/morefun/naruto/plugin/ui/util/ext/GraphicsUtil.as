package com.tencent.morefun.naruto.plugin.ui.util.ext {
 import flash.display.BitmapData;
 import flash.display.DisplayObject;
 import flash.display.Sprite;
 import flash.geom.ColorTransform;

    public class GraphicsUtil {
        public static function changeColor(target:Sprite, color:uint):void {
            if(target) {
                var c:ColorTransform = new ColorTransform(0, 0, 0);
                var red:int = color >> 16;
                var green:int = color >> 8 & 255;
                var blue:int = color & 255;
                c.redOffset = red;
                c.greenOffset = green;
                c.blueOffset = blue;
                target.transform.colorTransform = c;
            }
        }
        
        /* public static function bling(target:Sprite):void{
            if(target){
                var c:ColorTransform	= new ColorTransform(0,0,0);
                c.redOffset		= red;
                c.greenOffset 	= green;
                c.blueOffset	= blue;
                target.transform.colorTransform	= c;
            }
        } */
        public static function drawDisplayObject(target:DisplayObject):BitmapData {
            if(target) {
                
                var bmp:BitmapData = new BitmapData(target.width, target.height, false);
                bmp.draw(target);
                return bmp;
            }
            return null;
        }
    
    
    
    	}
}
