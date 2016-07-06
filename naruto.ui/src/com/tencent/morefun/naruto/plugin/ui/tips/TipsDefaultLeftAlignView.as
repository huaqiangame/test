package com.tencent.morefun.naruto.plugin.ui.tips
{
	import flash.text.TextFormatAlign;

	public class TipsDefaultLeftAlignView extends TipsDefaultView
	{
		public function TipsDefaultLeftAlignView(skinCls:Class)
		{
			super(skinCls);
		}
		
		override protected function initTextFormat():void
		{
			if(m_textFormat)
			{
				m_textFormat.align = TextFormatAlign.LEFT;
				m_textField.defaultTextFormat = m_textFormat;
			}
			else
			{
				m_textFormat = m_textField.defaultTextFormat;
			}
		}
		}
}