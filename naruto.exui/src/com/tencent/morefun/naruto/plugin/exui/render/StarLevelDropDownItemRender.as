package com.tencent.morefun.naruto.plugin.exui.render
{

	import com.tencent.morefun.naruto.plugin.ui.base.ItemRenderer;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import ui.exui.dropDownList.StartLeveRightUI;

    import com.tencent.morefun.naruto.i18n.I18n;
	public class StarLevelDropDownItemRender extends ItemRenderer
	{
		public var isLabel:Boolean;
		public function StarLevelDropDownItemRender(skin:DisplayObject)
		{
			super(skin);
			view.gotoAndStop(1);
			view.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			view.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			view.bg.bg.width = 52;
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
					view.leaderShipText.text = I18n.lang("as_exui_1451031568_1263");
				}else {
					view.leaderShipText.text = I18n.lang("as_exui_1451031568_1264");
				}
			}
			else
			{
				view.leaderShipText.text = getStarLevelText(i);
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
		
		private function getStarLevelText(value:int):String
		{
			switch(value)
			{
				case 0:
					return I18n.lang("as_exui_1451031568_1265");
					break;
				case 1:
					return I18n.lang("as_exui_1451031568_1266");
					break;
				case 2:
					return I18n.lang("as_exui_1451031568_1267");
					break;
				case 3:
					return I18n.lang("as_exui_1451031568_1268");
					break;
				case 4:
					return I18n.lang("as_exui_1451031568_1269");
					break;
				
				default:
					return "";
					break;
			}
		}
		
		override public function get width():Number
		{
			return 56;
		}
	}
}