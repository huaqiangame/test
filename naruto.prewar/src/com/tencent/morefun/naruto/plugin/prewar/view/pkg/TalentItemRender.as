package com.tencent.morefun.naruto.plugin.prewar.view.pkg
{
	
	import com.tencent.morefun.naruto.plugin.ui.base.BaseButton;
	import com.tencent.morefun.naruto.plugin.ui.base.ItemRenderer;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class TalentItemRender extends ItemRenderer
	{
		private var skinBtn:BaseButton;
		
		public function TalentItemRender(skin:DisplayObject)
		{
			skinBtn = new BaseButton(skin as MovieClip); 
			super(skinBtn);
			
			init();
		}
		
		private function init():void
		{
			var defaultFormat:TextFormat;
			skinBtn = m_skin as BaseButton;
			
			defaultFormat = textField.defaultTextFormat;
			defaultFormat.bold = true;
			textField.defaultTextFormat = defaultFormat;
		}
		
		override public function set data(value:Object):void
		{
			textField.text = String(value);
		}
		
		private function get textField():TextField
		{
			return skinBtn.skin["txt"];
		}
		
		override public function destroy():void
		{
			super.destroy();
			skinBtn.destroy();
		}
	}
}