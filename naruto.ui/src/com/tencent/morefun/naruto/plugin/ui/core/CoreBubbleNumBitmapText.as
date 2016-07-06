package com.tencent.morefun.naruto.plugin.ui.core
{
	import com.tencent.morefun.naruto.plugin.ui.base.BitmapText;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;

	public class CoreBubbleNumBitmapText extends Sprite
	{
		public static const RAD:int = 0;
		public static const GREEN:int = 1;
		public static const BLUE:int = 2;
		
		public function CoreBubbleNumBitmapText()
		{
			super();
		}
		
		/**
		 * color 0 红 1绿 2蓝
		 */	
		public function bubbleNum(value:int, color:int, animation:MovieClip):void
		{
			var bitmapText:BitmapText;
			
			switch(color)
			{
				case RAD:
					bitmapText = new BitmapText(new RadBitmapText(),29,29,0,false,"0123456789-");
					break;
				case GREEN:
					bitmapText = new BitmapText(new GreenBitmapText(),29,29,1,false,"0123456789+");
					break;
				case BLUE:
					bitmapText = new BitmapText(new BlueBitmapText(),29,29,1,false,"0123456789+");
					break;
			}
			
			if(value > 0)
			{
				bitmapText.text = "+" + value.toString();
			}
			else
			{
				bitmapText.text = value.toString();
			}
			
			bitmapText.x = -bitmapText.width / 2;
			bitmapText.y = -bitmapText.height / 2;
			
			animation["num"].addChild(bitmapText);
			animation.play();
			animation.addEventListener(Event.COMPLETE, onAnimationComplete);
			addChild(animation);
		}
		
		private function onAnimationComplete(evt:Event):void
		{
			this.removeChild(evt.target as DisplayObject);
		}
		}
}