package com.tencent.morefun.naruto.plugin.exui.render
{
	import flash.display.DisplayObject;

	public class GiftItemWithNumRender extends GiftItemRender
	{
		public function GiftItemWithNumRender(skin:DisplayObject=null)
		{
			super(skin);
			view.txt.visible = true;
		}
	}
}