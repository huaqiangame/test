package com.tencent.morefun.naruto.plugin.exui.render
{

	import com.tencent.morefun.naruto.plugin.ui.base.ItemRenderer;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import skill.config.SkillDef;
	import ui.exui.dropDownList.StartLeveRightUI;

    import com.tencent.morefun.naruto.i18n.I18n;
	public class ExStateDownItemRender extends ItemRenderer
	{
		public var isLabel:Boolean;
		
		public function ExStateDownItemRender(skin:DisplayObject)
		{
			super(skin);
			view.gotoAndStop(1);
			view.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			view.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			view.bg.bg.width = 90;
		}
		
		private function get view():StartLeveRightUI
		{
			return m_skin as StartLeveRightUI;
		}
		
		override public function set data(value:Object):void
		{
			m_data = value;
			var index:int = value as int;
			if (index == -1)
			{
				if (isLabel) {
					view.leaderShipText.text = I18n.lang("as_exui_1451031568_1251");
				}else{
					view.leaderShipText.text = I18n.lang("as_exui_1451031568_1252");
				}
			}
			else
			{
				view.leaderShipText.text = "" + SkillDef.getExStateString(index);
			}
		}
		
		private function onMouseOver(evt:MouseEvent):void
		{
			view.gotoAndStop(2);
		}
		
		private function onMouseOut(evt:MouseEvent):void
		{
			view.gotoAndStop(1);
		}
		
		override public function destroy():void
		{
			view.removeEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			view.removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			
			super.destroy();
		}
		
	}
}