package com.tencent.morefun.naruto.plugin.ui.tips
{
	import flash.display.Sprite;

	public class BaseTextTips extends Sprite
	{
		private var systemTipsUI:SystemTipUI;
		
		public function BaseTextTips(content:String)
		{
			super();
			
			systemTipsUI = new SystemTipUI();
			addChild(systemTipsUI);
			systemTipsUI["tipText"].htmlText = content;
		}
		}
}