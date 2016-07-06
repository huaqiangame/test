package com.tencent.morefun.naruto.plugin.ui.base
{
	
	import flash.display.BitmapData;
	
	public class NumberBitmapText extends BitmapText
	{
		public function NumberBitmapText(style:int)
		{
			var bitmapData:BitmapData;
			var width:int;
			var height:int;
			var gap:int;
			var blank:Boolean;
			var chars:String;
			
			switch(style)
			{
				case NumberBitmapTextStyle.STYLE_1:
					bitmapData = new NumberStyle_1();
					chars = "1234567890:/-";
					width = bitmapData.width / chars.length;
					height = bitmapData.height;
					gap = 0;
					blank = false;
					break;
				case NumberBitmapTextStyle.STYLE_2:
					bitmapData = new NumberStyle_2();
					chars = "1234567890";
					width = bitmapData.width / chars.length;
					height = bitmapData.height;
					gap = -25;
					blank = false;
					break;
				case NumberBitmapTextStyle.STYLE_3:
					bitmapData = new NumberStyle_3();
					chars = "1234567890:";
					width = bitmapData.width / chars.length;
					height = bitmapData.height;
					gap = 0;
					blank = false;
					break;
			}
			
			super(bitmapData, width, height, gap, blank, chars);
		}
	}
}