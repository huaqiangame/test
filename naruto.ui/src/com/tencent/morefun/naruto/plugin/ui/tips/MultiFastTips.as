package com.tencent.morefun.naruto.plugin.ui.tips
{
	import com.greensock.TweenLite;
	import com.tencent.morefun.naruto.plugin.ui.layer.LayoutManager;
	import com.tencent.morefun.naruto.plugin.ui.layer.def.LayerDef;
	import com.tencent.morefun.naruto.plugin.ui.layer.def.LocationDef;
	import com.tencent.morefun.naruto.plugin.ui.util.TimerProvider;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class MultiFastTips extends Sprite
	{
		private static var ms_instance:MultiFastTips;
		
		private var stayTipsList:Array = [];
		private var waitToShowTipsList:Array = [];
		private var showingTipsList:Array = [];
		
		private var stayY:int = 100;
		private var showY:int = 200;
		private var removeY:int = 50;
		
		private var offset:int = 35;
		
		private var timeOutTimer:Timer;
		
		public function MultiFastTips()
		{
			super();
			
			timeOutTimer = new Timer(1000);
			timeOutTimer.addEventListener(TimerEvent.TIMER, onTimeOutTimer);
		
			var area:BaseTextTips;
			
			area = new BaseTextTips("");
			this.graphics.beginFill(0x000000, 0);
			this.mouseEnabled = false;
			this.mouseChildren = false;
			this.graphics.drawRect(0, 0, area.width, area.height);
		}
		
		public static function get singleton():MultiFastTips
		{
			if(ms_instance == null)
			{
				ms_instance = new MultiFastTips();
				LayoutManager.singleton.addItemAndLayout(ms_instance, LayerDef.TIPS, LocationDef.TOPCENTRE);
			}
			
			return ms_instance;
		}
		
		public function addTipsInfo(value:String):void
		{
			if(waitToShowTipsList.length == 0)
			{
				TimerProvider.addTimeTask(200, onShowNextTips);
				TimerProvider.addTimeTask(200, checkAndRemoveTips);
				
				timeOutTimer.start();
			}
			
			waitToShowTipsList.push(value);
		}
		
		private function onShowNextTips():void
		{
			if(waitToShowTipsList.length != 0)
			{
				showNextTips();
			}
		}
		
		private function checkAndRemoveTips():void
		{
			if(stayTipsList.length > 3)
			{
				removeTips(stayTipsList.shift());
			}
		}
		
		private function onTimeOutTimer(evt:TimerEvent):void
		{
			if(stayTipsList.length != 0)
			{
				removeTips(stayTipsList.shift());
			}
			else if(numChildren == 0 && waitToShowTipsList.length == 0)
			{
				TimerProvider.removeTimeTask(200, onShowNextTips);
				TimerProvider.removeTimeTask(200, checkAndRemoveTips);
				
				timeOutTimer.stop();
			}
		}
		
		private function removeTips(tips:BaseTextTips):void
		{
			TweenLite.killTweensOf(tips);
			TweenLite.to(tips, 0.5, {y:0, alpha:0, onComplete:onRemoveTips, onCompleteParams:[tips]});
		}
		
		private function onRemoveTips(tips:BaseTextTips):void
		{
			this.removeChild(tips);
		}
		
		private function showNextTips():void
		{
			var tips:BaseTextTips;
			var destY:int;
			
			destY = Math.min(stayY + 2 * offset, stayY + showingTipsList.length * offset + stayTipsList.length * offset);
			tips = new BaseTextTips(waitToShowTipsList.shift());
			TweenLite.to(tips, 0.2, {y:destY, onComplete:onShowTipsComplete, onCompleteParams:[tips]});
			tips.y = showY;
			addChild(tips);
			showingTipsList.push(tips);
		}
		
		private function onShowTipsComplete(tips:BaseTextTips):void
		{
			stayTipsList.push(tips);
			
			showingTipsList.splice(showingTipsList.indexOf(tips), 1);
			updateStayTipsPosition();
			timeOutTimer.reset();
			timeOutTimer.start();
		}
		
		private function updateStayTipsPosition():void
		{
			var baseY:int;
			
			baseY = Math.min(stayY + 2 * offset, stayY + (stayTipsList.length - 1) * offset);
			for(var i:int = 0;i < stayTipsList.length;i ++)
			{
				TweenLite.to(stayTipsList[stayTipsList.length - i - 1], 0.2, {y:baseY - i * offset});
			}
		}
		}
}