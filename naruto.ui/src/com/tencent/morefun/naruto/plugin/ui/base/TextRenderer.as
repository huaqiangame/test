package com.tencent.morefun.naruto.plugin.ui.base
{
	import flash.display.MovieClip;

	public class TextRenderer extends ItemRenderer
	{
		public function TextRenderer(skin:MovieClip)
		{
			super(skin);
		}
		
		override public function set data(value:Object):void
		{
			if(value == null)
			{
				return ;
			}
			
			super.data = value;
			super.m_skin["text"].text = value;
		}
		}
}