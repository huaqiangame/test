package com.tencent.morefun.naruto.plugin.exui.render
{
	import com.tencent.morefun.naruto.plugin.ui.base.ItemRenderer;
	import com.tencent.morefun.naruto.plugin.ui.components.interfaces.IRender;
	import com.tencent.morefun.naruto.plugin.ui.tooltip.SkillType1RenderUI;
	
	import flash.display.DisplayObject;
	
	/**
	 * @author woodychen
	 * @createTime 2014-7-14 下午3:12:01
	 **/
	public class SkillType1IconRender extends ItemRenderer implements IRender
	{
		public function SkillType1IconRender(skin:DisplayObject=null)
		{
			super(new SkillType1RenderUI());
			view.gotoAndStop(1);
		}
		
		override public function set data(value:Object):void
		{
			view.gotoAndStop("label"+value);
		}
		
		private function get view():SkillType1RenderUI
		{
			return m_skin as SkillType1RenderUI;
		}
		
		public function dispose():void
		{
			destroy();
		}
	}
}