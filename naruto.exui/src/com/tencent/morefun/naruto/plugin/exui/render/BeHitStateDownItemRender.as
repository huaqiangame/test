package com.tencent.morefun.naruto.plugin.exui.render
{

	import com.tencent.morefun.naruto.plugin.exui.dropDownList.data.BeHitStateData;
	import com.tencent.morefun.naruto.plugin.ui.base.ItemRenderer;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import skill.config.SkillDef;
	import ui.exui.dropDownList.StartLeveRightUI;

    import com.tencent.morefun.naruto.i18n.I18n;
	public class BeHitStateDownItemRender extends ItemRenderer
	{
		public var isLabel:Boolean;
		public function BeHitStateDownItemRender(skin:DisplayObject)
		{
			super(skin);
			view.gotoAndStop(1);
			view.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			view.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			
			view.bg.bg.width = 85;
		}
		
		private function get view():StartLeveRightUI
		{
			return m_skin as StartLeveRightUI;
		}
		
		override public function set data(value:Object):void
		{
			m_data = value;
			var d:BeHitStateData = value as BeHitStateData;
			if (d.state == -1)
			{
				if (isLabel) {
					view.leaderShipText.text = I18n.lang("as_exui_1451031568_1248");
				}else{
					view.leaderShipText.text = I18n.lang("as_exui_1451031568_1249");
				}
			}
			else
			{
				view.leaderShipText.text = I18n.lang("as_exui_1451031568_1250")+SkillDef.getBeHitState1String(d.state,d.param);
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