package com.tencent.morefun.naruto.plugin.exui.dropDownList.friendList
{
	import com.tencent.morefun.naruto.plugin.ui.base.ItemRenderer;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	
	import friend.data.FriendInfo;
	
	import ui.exui.dropDownList.FriendInfoRenderUI;
	
	import utils.PlayerNameUtil;

	public class FriendInfoRender extends ItemRenderer
	{
		public function FriendInfoRender(skin:DisplayObject)
		{
			super(skin);
			view.gotoAndStop(1);
			view.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			view.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			view.dropDownBtn.visible = false;
			view.bg.bg.width = 235;
			
			view.friendNameText.wordWrap = false;
			view.friendNameText.autoSize = TextFieldAutoSize.LEFT;
		}
		
		override public function set data(value:Object):void
		{
			m_data = value;
			if (value)
			{
				view.friendNameText.text = PlayerNameUtil.standardlizeName((value as FriendInfo).playerKey, (value as FriendInfo).name);
			}
		}
		
		protected function get view():FriendInfoRenderUI
		{
			return m_skin as FriendInfoRenderUI;
		}
		
		protected function onMouseOver(evt:MouseEvent):void
		{
			view.gotoAndStop(2);
		}
		
		protected function onMouseOut(evt:MouseEvent):void
		{
			view.gotoAndStop(1);
		}
		
		override public function destroy():void
		{
			view.removeEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			view.removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			
			super.destroy();
		}
		
		public function switchToOpenRenderMode():void	
		{
			view.friendNameText.visible = false;
			view.bg.visible = false;
			view.occupySpaceItem.visible = false;
			view.dropDownBtn.visible = true;
		}
	}
}