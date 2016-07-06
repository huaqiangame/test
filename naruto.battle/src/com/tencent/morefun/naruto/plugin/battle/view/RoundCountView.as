package com.tencent.morefun.naruto.plugin.battle.view
{

	import com.tencent.morefun.naruto.plugin.ui.base.BitmapText;
	import flash.display.Sprite;
	import ui.battle.RoundCountUI;
	import ui.battle.RoundNumber;

    import com.tencent.morefun.naruto.i18n.I18n;
	public class RoundCountView extends Sprite
	{
		private var _count:uint;		
		private var bitmapText:BitmapText;
		
		public function RoundCountView()
		{
			super();
			init();
		}
		
		private function init():void
		{
			var letterData:RoundNumber;
			var bg:RoundCountUI;
			
			bg = new RoundCountUI();
			addChild(bg);
			
			letterData = new RoundNumber();
			bitmapText = new BitmapText(letterData, 50, 50, 0, false, I18n.lang("as_battle_1451031565_390"));
			bitmapText.align = "center";
			bitmapText.y = -50;
			addChild(bitmapText);
		}
		
		public function set count(number:uint):void
		{
			this._count = number;
			bitmapText.text = I18n.lang("as_battle_1451031565_391_0")+number+I18n.lang("as_battle_1451031565_391_1");
		}
		
		public function get count():uint
		{
			return this._count;
		}
		
		public function destroy():void
		{
			if(contains(bitmapText)){removeChild(bitmapText)};
			bitmapText.destroy();
			bitmapText = null;
		}
																
		public function autoSetNull():void
		{

			bitmapText = null;
		}
	}
}