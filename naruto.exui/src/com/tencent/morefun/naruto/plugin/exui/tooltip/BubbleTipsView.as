package com.tencent.morefun.naruto.plugin.exui.tooltip
{
	import com.tencent.morefun.naruto.plugin.ui.layer.LayoutManager;
	import com.tencent.morefun.naruto.plugin.ui.tips.BaseTipsView;
	import com.tencent.morefun.naruto.plugin.ui.tooltip.BubbleTipsUI;
	import com.tencent.morefun.naruto.plugin.ui.tooltip.DefaultTipsViewUI;

	public class BubbleTipsView extends BaseTipsView
	{
		private var tipsUI:BubbleTipsUI;
		private var ui:DefaultTipsViewUI;
		
		public function BubbleTipsView(skinCls:Class)
		{
			super(skinCls);
			
			tipsUI = new BubbleTipsUI();
			addChild(tipsUI);
		}
		
		override public function set data(value:Object):void
		{
			tipsUI.text.text = value as String;
			tipsUI.text.width = tipsUI.text.textWidth+5;
			tipsUI.bg.width = tipsUI.text.textWidth + 10;
		}
		
		override public function move(x:int, y:int):void
		{
			if(stage && x + width > LayoutManager.stageWidth)
			{
				this.x = LayoutManager.stageWidth - width;
			}else
			{
				this.x = x;
			}
			this.y = y + 10;
		}
	}
}