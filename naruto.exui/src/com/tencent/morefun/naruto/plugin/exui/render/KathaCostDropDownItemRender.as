package com.tencent.morefun.naruto.plugin.exui.render
{

	import com.tencent.morefun.naruto.plugin.ui.base.ItemRenderer;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import ui.exui.dropDownList.StartLeveRightUI;

    import com.tencent.morefun.naruto.i18n.I18n;
	public class KathaCostDropDownItemRender extends ItemRenderer
	{
		public var isLabel:Boolean;
		public function KathaCostDropDownItemRender(skin:DisplayObject)
		{
			super(skin);
			view.gotoAndStop(1);
			view.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			view.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			view.bg.bg.width = 70;
		}
		
		private function get view():StartLeveRightUI
		{
			return m_skin as StartLeveRightUI;
		}
		
		override public function set data(value:Object):void
		{
			m_data = value;
			var i:int = value as int;
			if (i == -1)
			{
				if(isLabel){
					view.leaderShipText.text = I18n.lang("as_exui_1451031568_1259");
				}else {
					view.leaderShipText.text = I18n.lang("as_exui_1451031568_1260");
				}
			}
			else
			{
				view.leaderShipText.text = "" + i;
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