package com.tencent.morefun.naruto.plugin.ui.tips
{
 import com.greensock.TweenLite;
 import com.tencent.morefun.naruto.plugin.ui.layer.LayerManager;
 import com.tencent.morefun.naruto.plugin.ui.layer.LayoutManager;
 import com.tencent.morefun.naruto.plugin.ui.layer.def.LayerDef;
 
 import flash.text.TextFieldAutoSize;
 import flash.utils.getTimer;
	

    public class SystemTip
    {
        private static const TIP_Y:int                      =   150;
        private static const APPEAR_SPEED:Number            =   2.0;
        private static const APPEAR_MOVE:int                =   -80;
        private static const DISAPPEAR_MOVE:int             =   -50;
        private static const DISAPPEAR_SPEED:Number         =   0.5;
        private static const SHOW_TIP_MIN_MILLISEC:int      =   500;
		private static const WAIT_TIME:int                  =   2000;
		
		private static var msgArr:Array =   new Array();
		private static var msgUIArr:Array = new Array();
        private static var _lastShowTime:int = 0;
		private static var nowrunBoo:Boolean = true;
		
		
        public static function show(msg:String):void
        {
			msgArr.push(msg);
			showui();
        }
		
		private static function showui():void
		{
			if(msgArr.length == 0){
				return;
			}
			var t:int = getTimer();
			if (t - _lastShowTime < SHOW_TIP_MIN_MILLISEC)
				return;
			var ui:SystemTipUI = new SystemTipUI();
			msgUIArr.push(ui);
			ui.alpha = 0;
			ui.tipText.autoSize = TextFieldAutoSize.CENTER;
			ui.tipText.htmlText = msgArr.shift();
			ui.x = LayoutManager.stageWidth - ui.width >> 1;
			var index:int =  msgUIArr.indexOf(ui);
			if(index == 0){
				ui.y = TIP_Y;
			}else{
				ui.y = TIP_Y + (msgUIArr[index-1] as SystemTipUI).bg.y + (msgUIArr[index-1] as SystemTipUI).bg.height+30;
			}
			
			LayerManager.singleton.addItemToLayer(ui, LayerDef.MAIN_UI);
			TweenLite.to(ui, APPEAR_SPEED, {alpha:1, y:ui.y+APPEAR_MOVE, onComplete:onAppear, onCompleteParams:[ui]});
			_lastShowTime = t;
		}
		
		
        private static function onAppear(ui:SystemTipUI):void
        {
            TweenLite.to(ui, DISAPPEAR_SPEED, {alpha:0, y:ui.y+DISAPPEAR_MOVE, onComplete:onDisappear, onCompleteParams:[ui]});
			showui();
        }

        private static function onDisappear(ui:SystemTipUI):void
        {
			LayerManager.singleton.removeItemToLayer(ui);
			var index:int =  msgUIArr.indexOf(ui);
			msgUIArr.splice(index,1);
		}
		

        public function SystemTip()
        {
            throw new Error(SystemTip + " can not be instantiated.")
        }
    	}
}