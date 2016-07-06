package com.tencent.morefun.naruto.plugin.ui.util.ext {
 import flash.display.BitmapData;
 import flash.display.BlendMode;
 import flash.display.DisplayObject;
 import flash.geom.ColorTransform;
 import flash.geom.Matrix;
 import flash.geom.Point;
 import flash.geom.Rectangle;

    public class CollisionDetection {
        
        /*  public static function simpleHitTest( target1:DisplayObject, target2:DisplayObject):Boolean{
                var bitmapData1:BitmapData = new BitmapData(target1.width,target1.height,true);
                bitmapData1.draw(target1);
        
                var bitmapData2:BitmapData = new BitmapData(target2.width,target2.height,true);
                bitmapData2.draw(target2);
                var pt1:Point = new Point(target2.x, target2.y);
                var pt2:Point = new Point(target2.x+target2.width, target2.y+target2.height);
                var b = bitmapData1.hitTest(pt1, 0xFF, bitmapData2,pt2);
                trace("cell",b)
                return b
        
          } */
        
        public static function checkForCollision(p_obj1:DisplayObject, p_obj2:DisplayObject):Rectangle {
            // それぞれの境界ボックス取得
            var bounds1:Object = p_obj1.getBounds(p_obj1.root);
            var bounds2:Object = p_obj2.getBounds(p_obj2.root);
            
            // 重なっている部分がまったくない場合は処理中断
            if(((bounds1.right < bounds2.left) || (bounds2.right < bounds1.left)) || ((bounds1.bottom < bounds2.top) || (bounds2.
                bottom < bounds1.top))) {
                return null;
            }
            
            // 交差する領域の境界ボックスを算出
            var bounds:Object = {};
            bounds.left = Math.max(bounds1.left, bounds2.left);
            bounds.right = Math.min(bounds1.right, bounds2.right);
            bounds.top = Math.max(bounds1.top, bounds2.top);
            bounds.bottom = Math.min(bounds1.bottom, bounds2.bottom);
            
            // 交差する領域の境界ボックスの幅と高さを算出
            var w:Number = bounds.right - bounds.left;
            var h:Number = bounds.bottom - bounds.top;
            
            // どちらか1ピクセル未満の場合、『ArgumentError: Error #2015: BitmapData が無効です。』が出る
            if(w < 1 || h < 1) {
                //    trace(w,h);
                return null;
            }
            
            // 交差する領域の境界ボックスと同じサイズのBitmapDataを生成  
            var bitmapData:BitmapData = new BitmapData(w, h, false);
            
            // オブジェクト1を描画
            var matrix:Matrix = p_obj1.transform.concatenatedMatrix;
            matrix.tx -= bounds.left; // x方向平行移動
            matrix.ty -= bounds.top; // y方向平行移動
            bitmapData.draw(p_obj1, matrix, new ColorTransform(1, 1, 1, 1, 255, -255, -255, 255));
            
            // オブジェクト2を重ね塗り
            matrix = p_obj2.transform.concatenatedMatrix;
            matrix.tx -= bounds.left; // x方向平行移動
            matrix.ty -= bounds.top; // y方向平行移動
            bitmapData.draw(p_obj2, matrix, new ColorTransform(1, 1, 1, 1, 255, 255, 255, 255), BlendMode.DIFFERENCE);
            
            // 完全に重なる部分（0xFF00FFFF）の領域を取得
            var intersection:Rectangle = bitmapData.getColorBoundsRect(0xFFFFFFFF, 0xFF00FFFF);
            
            //『ArgumentError: Error #2015: BitmapData が無効です。』予防
            /*try{
             bitmapData.dispose();
            }catch(e:Error){}*/
            
            // 完全に重なる部分がない場合
            if(intersection.width == 0) {
                return null;
            }
            
            // 位置調整
            intersection.x += bounds.left;
            intersection.y += bounds.top;
            
            return intersection;
        }
    	}
}
