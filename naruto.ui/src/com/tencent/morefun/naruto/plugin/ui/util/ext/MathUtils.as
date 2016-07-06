package com.tencent.morefun.naruto.plugin.ui.util.ext {

 import flash.display.Sprite;

    import com.tencent.morefun.naruto.i18n.I18n;
    public class MathUtils {
        public function MathUtils() {
        }
        
        /**
         * 获取一个从start到end之间的整数.其中包括start和end;
         * @param start
         * @param end
         * @return
         *
         */
        public static function getIntBetween(start:int, end:int):int {
            return Math.floor(getFloatBetween(start, end + 1));
        }
        
        /**
         * 获取一个从start到end之间的浮点数.不等于start和end;
         * @param start
         * @param end
         * @return
         *
         */
        public static function getFloatBetween(start:Number, end:Number):Number {
            return Math.random() * (end - start) + start;
        }
        
        /**
         * 设置一个概率,返回是否命中概率.类似根据命中率查看是否命中;
         * @param percent 概率的大小.0-1之间的小数,代表百分比;
         * @return 是否命中几率;
         */
        public static function isInProbability(percent:Number):Boolean {
            return Math.random() < percent;
        }
        
        /**
         * 通过角度计算弧度;
         * @param degrees 角度
         * @return 弧度
         *
         */
        public static function parseRadians(degrees:Number):Number {
            return degrees * Math.PI / 180;
        }
        
        /**
         * 通过弧度计算出角度
         * @param radians 弧度
         * @return 角度
         *
         */
        public static function parseDegrees(radians:Number):Number {
            return radians * 180 / Math.PI;
        }
        
        /**
         * 取出两点间线段的长度;
         * @param startX
         * @param startY
         * @param endX
         * @param endY
         * @return
         *
         */
        public static function getLineLength(startX:Number, startY:Number, endX:Number = 0, endY:Number = 0):Number {
            var x:Number = startX - endX;
            var y:Number = startY - endY;
            return (Math.sqrt((x * x + y * y)));
        }
        
        //随机数;
        public static function Random(start:int, end:int):int {
            var ii:int = Math.floor(Math.random() * (end - start + 1) + start);
            return ii;
        }
        
        public static function RandomArr(arr:Array):* {
            return arr[Random(0, arr.length - 1)];
        }
        
        /**
         *根据分钟数获取时间字符串
         * @param value
         * @return
         *
         */
        public static function computeTimeStr(value:int):String {
            
            var days:int = Math.floor(value / (3600 * 24));
            
            if(days > 0)
                return days + I18n.lang("as_ui_1451031579_6190");
            var hour:int = Math.floor(value / 3600);
            
            if(hour > 0)
                return hour + I18n.lang("as_ui_1451031579_6191");
            var cent:int = Math.floor(value % 3600);
            var clever:int = Math.floor(cent % 60);
            cent = Math.floor(cent / 60);
            return cent + ":" + clever;
        }
        
        //返回小数后M位
        public static function round(n:Number, m:int):Number {
            return Math.round(n * Math.pow(10, m)) / Math.pow(10, m);
        }
        
        //获取范围内随机数
        public static function getRnd(max:int, min:int = 0):int {
            return (Math.random() * (max - min + 1) + min) >> 0;
        }
        
        //获取可重复的随机数组 
        public static function getRndArray(max:Number, min:Number, n:int):Array {
            var arr:Array = [];
            
            for(var i:int = 0; i < n; i++) {
                arr.push(getRnd(max, min));
            }
            return arr;
        }
        
//        //计算两点距离
//        public static function distance(x1:int, y1:int, x2:int, y2:int):int {
//            return Math.sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));
//        }
		public static function distance(x0:Number,y0:Number,x1:Number,y1:Number,sqrt:Boolean=true):Number
		{
			if(sqrt)
			{
				return Math.sqrt((x0-x1)*(x0-x1) + (y0-y1)*(y0-y1));
			}else
			{
				return (x0-x1)*(x0-x1) + (y0-y1)*(y0-y1);
			}
		}
		
		
        //角度转弧度
        public static function DtoR(angle:Number):Number {
            return angle * Math.PI / 180;
        }
        
        //弧度转角度
        public static function RtoD(Radians:Number):Number {
            return Radians * 180 / Math.PI;
        }
        
        //角度换算正弦值
        public static function sin(angle:Number):Number {
            return Math.sin(angle * Math.PI / 180);
        }
        
        //角度换算正弦值
        public static function cos(angle:Number):Number {
            return Math.cos(angle * Math.PI / 180);
        }
        
        //角度转正切值
        public static function tan(angle:Number):Number {
            return Math.tan(angle * Math.PI / 180);
        }
        
        //反正切
        public static function atan(rad:Number):Number {
            return Math.atan(rad) * 180 / Math.PI;
        }
        
        //坐标反正切
        public static function atan2(x:Number, y:Number):Number {
            return Math.atan2(y, x) * 180 / Math.PI;
        }
        
        //两点角度
        public static function angle(x1:Number, y1:Number, x2:Number, y2:Number):Number {
            return atan2(x2 - x1, y2 - y1);
        }
        
        //反正弦
        public static function asin(ratio:Number):Number {
            return Math.round(Math.asin(ratio) * 180 / Math.PI);
        }
        
        //反余弦
        public static function acos(ratio:Number):Number {
            return Math.round(Math.acos(ratio) * 180 / Math.PI);
        }
        
        //画圆
        public static function makeCircle(width:Number = 2, color:Number = 0x00ff00):Sprite {
            var sp:Sprite = new Sprite();
            sp.graphics.beginFill(color);
            sp.graphics.drawCircle(0, 0, width);
            sp.graphics.endFill();
            
            var sp2:Sprite = new Sprite();
            sp2.graphics.beginFill(0xffffff);
            sp2.graphics.drawCircle(10, 0, 4);
            sp2.graphics.endFill();
            sp.addChild(sp2);
            return sp;
        }
        
        //画圆
        public static function makeBall(width:Number = 2, color:Number = 0x00ff00):Sprite {
            var sp:Sprite = new Sprite();
            sp.graphics.beginFill(color);
            sp.graphics.drawCircle(0, 0, width);
            sp.graphics.endFill();
            return sp;
        }
        
        /**
         * 随机颜色;
         * @return
         *
         */
        public static function randomColor():uint {
            var r:uint = 255 * Math.random();
            var g:uint = 255 * Math.random();
            var b:uint = 255 * Math.random();
            
            return 0xFF000000 | r << 16 | g << 8 | b;
        }
        
        /**
         * 输入任意数返回2次幂数
         * @param number
         * @return
         *
         */
        public static function getNextPowerOf2(number:int):int {
            if(number == 0) {
                return 2;
            }
            
            if(((number - 1) & number) == 0) {
                return number;
            }
            var power:int = 0;
            
            while(number > 0) {
                number = number >> 1;
                power++;
            }
            return (1 << power);
        }
        
        public static function get360Angle(angle:Number):Number {
            if(angle < 0) {
                return angle + 360;
            }
            return angle;
        }
        
        public static function getFixAngle(angle:Number):Number {
            if(angle > 180) {
                return getFixAngle(360 - angle);
            } else {
                return angle;
            }
        }
		
//        public static function getAngleXZ_BetweenMoveUnit(sorce:Vector3D, vet:Vector3D):Number {
//            return MathUtils.angle(sorce.x, sorce.z, vet.x, vet.z);
//        }
//        
//        public static function getAngleXY_BetweenMoveUnit(sorce:Vector3D, vet:Vector3D):Number {
//            return MathUtils.angle(sorce.x, sorce.y, vet.x, vet.y);
//        }
    	}
}
