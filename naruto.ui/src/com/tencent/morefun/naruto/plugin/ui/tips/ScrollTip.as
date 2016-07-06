package com.tencent.morefun.naruto.plugin.ui.tips
{
	
	
	import com.tencent.morefun.naruto.plugin.ui.tips.ScrollTipUI;
	import flash.display.Sprite;
	
	import flash.events.TimerEvent;
	
	
	import flash.utils.Timer;
	
	

	public class ScrollTip extends Sprite
	{
		private var timer:Timer;
		private var str:String = "　　　　　　　　　　　　　　　　　";
		private var strArr:Array = new Array();
		private var showLength:uint=16;
		private var newstrArr:Array = new Array();
		private var scrollTipUI:ScrollTipUI = new ScrollTipUI();
		
		
		public function ScrollTip()
		{
			timer = new Timer(200);
			timer.addEventListener(TimerEvent.TIMER,onTimerHandle);
		}
		
		//429,20

		public function show(msg:String):void
		{
			str = str+msg+str;
			for (var i:uint=0;i<str.length;i++)
			{
				strArr.push(str.charAt(i));
			}
			scrollTipUI.scrollText.text = str;
			timer.start();
		}
		private function onTimerHandle(event:TimerEvent):void{
			newstrArr.push(strArr.shift());
			var showStr:String = newstrArr.join("");
			scrollTipUI.scrollText.text = showStr.substr(0,showLength);
			if(newstrArr.length > showLength){
				newstrArr.shift();
			}
			if(scrollTipUI.scrollText.text == ""){
				timer.stop();
			}
		}
		}
}