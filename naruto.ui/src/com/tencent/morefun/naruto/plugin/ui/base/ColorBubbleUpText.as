package com.tencent.morefun.naruto.plugin.ui.base
{

	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

    import com.tencent.morefun.naruto.i18n.I18n;
	public class ColorBubbleUpText extends Sprite
	{
		private var m_color:uint;
		private var m_bubbleHeight:int;
		private var m_bold:Boolean;
		private var m_size:int;
		
		public function ColorBubbleUpText(color:uint, bubbleHeight:int = 20, bold:Boolean = true, size:int = 14)
		{
			super();
			
			m_size = size;
			m_color = color;
			m_bold = bold;
			m_bubbleHeight = bubbleHeight;
		}
		
		public function bubbleUp(content:String):void
		{
			var text:TextField;
			
			text = createText();
			text.text = content;
			TweenLite.to(text, 0.7, {y:-m_bubbleHeight, onComplete:onBubbleComplete, onCompleteParams:[text], ease:Cubic.easeOut});
			text.x = -text.width / 2;
			addChild(text);
		}
		
		private function onBubbleComplete(text:TextField):void
		{
			removeChild(text);
		}
		
		private function createText():TextField
		{
			var textField:TextField;
			var textFormat:TextFormat;
			
			textFormat = new TextFormat();
			textFormat.color = m_color;
//			textFormat.font = I18n.lang("as_ui_1451031579_6139");
			textFormat.size = m_size;
			textFormat.bold = m_bold;
			textField = new TextField();
			textField.defaultTextFormat = textFormat;
			//textField.antiAliasType = TextAlign.CENTER;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.filters = [new GlowFilter(0x000000, 1, 3, 3, 10)];
				
			return textField;
		}
		}
}