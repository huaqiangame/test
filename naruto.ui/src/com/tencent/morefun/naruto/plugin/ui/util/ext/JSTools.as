package com.tencent.morefun.naruto.plugin.ui.util.ext{
 import flash.display.Stage;
 import flash.display.StageDisplayState;
 import flash.events.FullScreenEvent;
 import flash.events.MouseEvent;
 import flash.external.ExternalInterface;
 import flash.geom.Point;
 import flash.utils.Dictionary;

    public class JSTools {
        private static var STAGE:Stage;
        private static var isFullScreen:Boolean = false;
        
        
        public static function callJS(... rest):void {
            if(ExternalInterface.available) {
                try {
                    ExternalInterface.call.apply(null, rest);
                } catch(e:Error) {
                }
            }
        }
        
        public static function exeJS(jsString:String):void {
            callJS("eval", jsString);
        }
        
        public static function addCallback(functionName:String, listener:Function):void {
            if(ExternalInterface.available) {
                try {
                    ExternalInterface.addCallback(functionName, listener);
                } catch(e:Error) {
                }
            }
        }
        
        public static function getParamFromUrlOrCookie(name:String):String {
            if(ExternalInterface.available) {
                var s:String = ExternalInterface.call("getEncodeParamFromUrlOrCookie", name);
                
                if(s) {
                    return decodeURIComponent(s);
                }
            }
            return null;
        }
        
        public static function openWindow(url:String, target:String = "_blank"):void {
            callJS("openWindow", url, target);
        }
        
        public static function refreshPageAfterRecharge():void {
            callJS("gotoServerPage", false);
        }
        
        public static function setHomepage():void {
            callJS("setHomepage");
        }
        
        public static function reload():void {
            callJS("reload");
        }
        
        public static function preloaderOK():void {
            callJS("preloaderIsOk");
        }
        
        public static function getQQgameHash():String {
            if(ExternalInterface.available) {
                var s:String = ExternalInterface.call("getQQgameHash");
                
                if(s) {
                    return decodeURIComponent(s);
                }
            }
            return null;
        }
        
        public static function getZoneName(zoneID:int):String {
            if(ExternalInterface.available) {
                var s:String = ExternalInterface.call("getZoneName", zoneID);
                
                if(s) {
                    return decodeURIComponent(s);
                }
            }
            return null;
        }
        
        public static function isFromClient():Boolean {
            if(ExternalInterface.available) {
                return ExternalInterface.call("isFromClient");
            }
            return false;
        }
        
        public static function openCDKey(serverid:String, roleid:String):void {
            if(ExternalInterface.available) {
                ExternalInterface.call("showCDKey", serverid, roleid);
            }
        }
        
        public static function showBlueVipAward(serverid:String, roleid:String):void {
            if(ExternalInterface.available) {
                ExternalInterface.call("showBlueVipAward", serverid, roleid);
            }
        }
        
        public static function getCfgObj():Object {
            if(ExternalInterface.available) {
                return ExternalInterface.call("getCfgObj");
            }
            return null;
        }
        
        public static function getPayURL(uin:uint):String {
            if(ExternalInterface.available) {
                return ExternalInterface.call("getPayURL", uin);
            }
            return null;
        }
        
        public static function getServerURL():String {
            if(ExternalInterface.available) {
                return ExternalInterface.call("getServerURL");
            }
            return null;
        }
        
        public static function sendStory(title:String, img:String, summary:String, msg:String, source:String):void {
            callJS("sendStory", encodeURIComponent(title), encodeURIComponent(img), encodeURIComponent(summary),
                encodeURIComponent(msg), encodeURIComponent(source));
        }
        
        public static function buyBlueVip():void {
            callJS("buyBlueVip");
        }
        
        public static function buyJHDQ(rolename:String):void {
            callJS("buyJHDQ", encodeURIComponent(rolename));
        }
        
        public static function buyJHDQ2(UrlParams:String):void {
            callJS("buyJHDQ2", encodeURIComponent(UrlParams));
        }
        
        public static function checkQQmusic():void {
            callJS("checkQQmusic");
        }
        
        public static function checkGuanjiaIsInstall():uint {
            if(ExternalInterface.available) {
                return ExternalInterface.call("checkIsInstall");
            }
            return 0;
        }
        
        public static function GuanjiaSign(uin:uint):void {
            callJS("gjSign", uin);
        }
        
        public static function installGuanjia():void {
            callJS("installGuanjia");
        }
        
        public static function QQGameScoreUrl():void {
            callJS("QQGameScoreUrl");
        }
        
        public static function getServerIPAndPort(svr:String):String {
            if(ExternalInterface.available) {
                return ExternalInterface.call("getServerIPAndPort", svr);
            }
            return null;
        }
        
        
        
        /**
         * 初始化Stage，同时初始化对RightClick和MouseWheel的监听。
         * @param _stage
         *
         */
        public static function init(_stage:Stage, listenRightClick:Boolean = true,
            listenerMouseWheel:Boolean = true):void {
            STAGE = _stage;
            STAGE.addEventListener(FullScreenEvent.FULL_SCREEN, __fs);
            addCallback("msunMouseWheel", __defaultWheel); //普通状态的MouseWheel
            addCallback("msunRightClick", onRightClick);
       
            
            //addCallback("msunSaveLink", __msunSaveLink);
            
            
            if(listenRightClick) {
                exeJS("RightClick.init(flashObjectIDName, flashContainer);");
            }
            
            if(listenerMouseWheel) {
                exeJS("MouseWheel.init(flashObjectIDName);");
            }
            initBgsCallback();
        }
        
        private static function __fs(event:FullScreenEvent):void {
            isFullScreen = event.fullScreen;
            STAGE.removeEventListener(MouseEvent.MOUSE_WHEEL, __fsWheel);
            
            if(event.fullScreen) {
                //全屏状态
                STAGE.addEventListener(MouseEvent.MOUSE_WHEEL, __fsWheel); //全屏状态的MouseWheel
            }
        }
        
        private static function __fsWheel(event:MouseEvent):void {
            if(STAGE.displayState == StageDisplayState.FULL_SCREEN) {
                onMouseWheel(event.delta);
            }
        }
        
        private static function __defaultWheel(delta:int):void {
            if(STAGE.displayState == StageDisplayState.NORMAL) {
                onMouseWheel(delta);
            }
        }
        
        private static var ls:Array = [];
        private static var rs:Array = [];
        
        public static function addWheelListener(listener:Function):void {
            if(ls.indexOf(listener) < 0) {
                ls.push(listener);
            }
        }
        
        public static function removeWheelListener(listener:Function):void {
            var index:int = ls.indexOf(listener);
            
            if(index >= 0) {
                ls.splice(index, 1);
            }
        }
        
        private static function onMouseWheel(delta:int):void {
            var sx:int = STAGE.mouseX;
            var sy:int = STAGE.mouseY;
            var arr:Array = STAGE.getObjectsUnderPoint(new Point(sx, sy));
            
            for each(var f:Function in ls) {
                f(delta, sx, sy, arr);
            }
        }
        
        public static function addRightClickListener(listener:Function):void {
            if(rs.indexOf(listener) < 0) {
                rs.push(listener);
            }
        }
        
        public static function removeRightClickListener(listener:Function):void {
            var index:int = rs.indexOf(listener);
            
            if(index >= 0) {
                rs.splice(index, 1);
            }
        }
        
        private static function onRightClick():void {
            for each(var f:Function in rs) {
                f();
            }
        }
        
        //-----------js callback
        public static var N:int = 1;
        private static var inited:Boolean = false;
        private static var funcMap:Dictionary = new Dictionary(true);
        
        public static function createOneCallback(callback:Function):String {
            var name:String = "bgsCallback" + (N++);
            addBgsCallback(name, callback);
            return name;
        }
        
        private static function addBgsCallback(functionName:String, listener:Function):void {
            initBgsCallback();
            var funcs:Array = funcMap[functionName] as Array;
            
            if(funcs == null) {
                funcMap[functionName] = [listener];
            } else {
                funcs.push(listener);
            }
        }
        
        private static function callBgsCallback(functionName:String, rest:Array):void {
            var funcs:Array = funcMap[functionName] as Array;
            
            if(funcs != null) {
                try {
                    for each(var f:Function in funcs) {
                        f.apply(null, rest);
                    }
                } catch(e:Error) {
                }
            }
        }
        
        public static function initBgsCallback():void {
            if(!inited) {
                inited = true;
                addCallback("bgsCallback", callBgsCallback);
            }
        }
    
    
    	}
}
