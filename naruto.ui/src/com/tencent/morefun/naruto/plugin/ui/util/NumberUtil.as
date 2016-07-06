package com.tencent.morefun.naruto.plugin.ui.util {
	import com.tencent.morefun.naruto.util.ext.ToolKit;
	
	import base.ApplicationData;
    
    
    import com.tencent.morefun.naruto.i18n.I18n;
    public class NumberUtil {
        
        public function NumberUtil() {
        
        }
        
        /**
         *
         * @param	date
         * @param	formatter ["YY","MO","DD","HH","MM","SS","MS"];
         * @return
         */
        static public function formatDate(date:Date, formatter:Array = null):String {
            var out:String = "";
            out = date.getFullYear().toString() + I18n.lang("as_ui_1451031579_6193");
            out += addZero(date.getMonth() + 1) + I18n.lang("as_ui_1451031579_6194");
            out += addZero(date.getDate()) + I18n.lang("as_ui_1451031579_6195");
            out += addZero(date.getHours()) + I18n.lang("as_ui_1451031579_6196");
            out += addZero(date.getMinutes()) + I18n.lang("as_ui_1451031579_6197");
            return out;
        }
        
        /**
         * 格式化时间
         * @param	time
         * @param	formatter  = ["HH","MM","SS","MS"];
         * @return
         */
        public static function FormatMillisecond(time:int, formatter:Array = null):String {
            var hh:int, mm:int, ss:int, ms:int;
            hh = time / 1000 / 60 / 60;
            
            if(hh < 1)
                hh = 0;
            time -= hh * 1000 * 60 * 60;
            mm = time / 1000 / 60;
            
            if(mm < 1)
                mm = 0;
            time -= mm * 1000 * 60;
            ss = time / 1000;
            
            if(ss < 1)
                ss = 0;
            ms = time - ss * 1000;
            
            if(!formatter)
                return addZero(hh) + ":" + addZero(mm) + ":" + addZero(ss) + ":" + addZero(ms);
            
            var out:String = "";
            var index:int;
            index = formatter.indexOf("HH");
            
            if(index > -1) {
                out += addZero(hh) + ((index == formatter.length - 1) ? "" : ":");
            }
            index = formatter.indexOf("MM");
            
            if(index > -1) {
                out += addZero(mm) + ((index == formatter.length - 1) ? "" : ":");
            }
            index = formatter.indexOf("SS");
            
            if(index > -1) {
                out += addZero(ss) + ((index == formatter.length - 1) ? "" : ":");
            }
            index = formatter.indexOf("MS");
            
            if(index > -1) {
                out += addZero(ms);
            }
            return out;
        }
        
        public static function FormatMillisecondToArray(time:int, formatter:Array = null):Array {
            var hh:int, mm:int, ss:int, ms:int;
            hh = time / 1000 / 60 / 60;
            
            if(hh < 1)
                hh = 0;
            time -= hh * 1000 * 60 * 60;
            mm = time / 1000 / 60;
            
            if(mm < 1)
                mm = 0;
            time -= mm * 1000 * 60;
            ss = time / 1000;
            
            if(ss < 1)
                ss = 0;
            ms = time - ss * 1000;
            
            if(!formatter)
                return addZero2(mm).concat(addZero2(ss));
            
            var arr:Array = [];
            var index:int;
            index = formatter.indexOf("HH");
            
            if(index > -1) {
                arr = arr.concat(addZero2(hh));
            }
            index = formatter.indexOf("MM");
            
            if(index > -1) {
                arr = arr.concat(addZero2(mm));
            }
            index = formatter.indexOf("SS");
            
            if(index > -1) {
                arr = arr.concat(addZero2(ss));
            }
            index = formatter.indexOf("MS");
            
            if(index > -1) {
                arr = arr.concat(addZero2(ms));
            }
            return arr;
        }
        
        public static function addZero2(n:int, digit:int = 2):Array {
            var arr:Array;
            
            if(n < 10) {
                arr = [0, n];
            } else {
                arr = toArray(n);
            }
            return arr;
        }
        
        public static function addZero(n:Number, digit:int = 2):String {
            var out:String, count:Number;
            count = Math.pow(10, digit);
            
            if(n < count) {
                out = count + "" + n;
                out = out.substr(-digit);
            } else {
                out = String(n);
            }
            return out;
        }
        
        static public function toArray(n:int, digit:int = 2):Array {
            var arr:Array = [];
            var out:String = addZero(n, digit);
            arr = out.split("");
            
            for(var i:int = 0; i < arr.length; i++) {
                arr[i] = int(arr[i]);
            }
            return arr;
        }		
		public static var self_today:Date = new Date();
		public static var self_targetDay:Date = new Date();
		/**
		 * 通用的获取周几 用于活动限时 周几开启
		 * @param timeLeft 距离开启 还有多少秒
		 * @return 如果开启时间和当前时间不是同一天返回周几，同一天返回空
		 * 
		 */		
		public static function getWeekDay(timeLeft:uint):String{
			self_today.setTime(ApplicationData.singleton.curServerTime * 1000 +self_today.getTimezoneOffset() * 60 * 1000 + 480 * 60 * 1000);
			self_targetDay.setTime(self_today.getTime() + timeLeft * 1000);
			const strs:Array = [ I18n.lang("as_ui_1451031579_6198_0") ,I18n.lang("as_ui_1451031579_6198_1"), I18n.lang("as_ui_1451031579_6198_2"), I18n.lang("as_ui_1451031579_6198_3"), I18n.lang("as_ui_1451031579_6198_4"), I18n.lang("as_ui_1451031579_6198_5"), I18n.lang("as_ui_1451031579_6198_6")];
			if (self_targetDay.date != self_today.date) {
				return I18n.lang("as_ui_1451031579_6199") +strs[self_targetDay.day];
			}else {
				return "";
			}
		}
			
		/**
		 * 
		 * @param severTime 秒 时间搓
		 * @param format YMDhmsS
		 * @return 返回东八区 北京时间 
		 * 
		 */		
		public static function getServerFormatDate(severTime:Number = 0, format:String = "YMDhmsS"):String{
			var date:Date = new Date();
			var timezoneOffset:Number = date.getTimezoneOffset();
			date.setTime(severTime*1000 + timezoneOffset * 60 * 1000 + 480 * 60 * 1000);
			var year:Number = date.getFullYear();
			var month:Number = date.getMonth() + 1;
			var day:Number = date.getDate();
			var hour:Number = date.getHours();
			var min:Number = date.getMinutes();
			var sec:Number = date.getSeconds();
			var msec:Number = date.getMilliseconds();
			
			var s:String = "";
			
			if(format.indexOf("Y") >= 0) {
				s += year;
			}
			
			if(format.indexOf("M") >= 0) {
				s += (format.indexOf("Y") >= 0 ? I18n.lang("as_ui_1451031579_6200") : "") + ToolKit.add0(month);
			}
			
			if(format.indexOf("D") >= 0) {
				s += I18n.lang("as_ui_1451031579_6201_0") + ToolKit.add0(day)+I18n.lang("as_ui_1451031579_6201_1");
			}
			
			if(format.indexOf("h") >= 0) {
				s += " " + ToolKit.add0(hour);
			}
			
			if(format.indexOf("m") >= 0) {
				s += (format.indexOf("h") >= 0 ? ":" : "") + ToolKit.add0(min);
			}
			
			if(format.indexOf("s") >= 0) {
				s += (format.indexOf("m") >= 0 ? ":" : "") + ToolKit.add0(sec);
			}
			
			if(format.indexOf("S") >= 0) {
				s += (format.indexOf("s") >= 0 ? "." : "") + ToolKit.add0(msec, 3);
			}
			
			return s;
		}
		
		
    }

}
