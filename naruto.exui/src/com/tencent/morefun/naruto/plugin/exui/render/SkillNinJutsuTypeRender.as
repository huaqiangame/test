package com.tencent.morefun.naruto.plugin.exui.render
{
	import com.tencent.morefun.naruto.plugin.ui.base.ItemRenderer;
	import com.tencent.morefun.naruto.plugin.ui.components.interfaces.IRender;
	import com.tencent.morefun.naruto.plugin.ui.tooltip.TipsIconUI;
	
	import flash.display.DisplayObject;
	
	/**
	 * @author woodychen
	 * @createTime 2014-7-14 下午3:17:32
	 **/
	public class SkillNinJutsuTypeRender extends ItemRenderer implements IRender
	{
		public function SkillNinJutsuTypeRender(skin:DisplayObject=null)
		{
			super(new TipsIconUI());
			view.gotoAndStop(1);
		}
		
		override public function set data(value:Object):void
		{
			view.gotoAndStop(""+value);
		}
		
		private function get view():TipsIconUI
		{
			return m_skin as TipsIconUI;
		}
		
		public function dispose():void
		{
			destroy();
		}
	}
}