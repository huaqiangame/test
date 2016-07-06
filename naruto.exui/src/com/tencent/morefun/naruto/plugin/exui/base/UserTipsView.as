package com.tencent.morefun.naruto.plugin.exui.base
{

	import com.tencent.morefun.naruto.plugin.ui.layer.LayoutManager;
	import com.tencent.morefun.naruto.plugin.ui.tips.BaseTipsView;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import cfgData.dataStruct.NinjaInfoCFG;
	import ninja.model.data.NinjaInfo;
	import ui.naruto.UserTipsUI;
	
	import user.data.NinjaInfoConfig;
	import user.data.UserConfig;
	import user.data.UserInfo;
	import user.event.UserInfoEvent;

    import com.tencent.morefun.naruto.i18n.I18n;
	public class UserTipsView extends BaseTipsView
	{
		private var userInfo:UserInfo;
		private var userTipsUI:UserTipsUI;
		
		private var padding:int = 30;
		
		public function UserTipsView(skinCls:Class)
		{
			super();
			
			userTipsUI = new skinCls();
			addChild(userTipsUI);
			
			text.autoSize = TextFieldAutoSize.LEFT;
		}
		
		override public function set data(value:Object):void
		{
			if(userInfo)
			{
				userInfo.removeEventListener(UserInfoEvent.BASE_UPDATE, onUserInfoUpdated);
				userInfo.removeEventListener(UserInfoEvent.NINJA_INFO_UPDATE, onUserInfoUpdated);
			}
			
			userInfo = value as UserInfo;
			userInfo.addEventListener(UserInfoEvent.BASE_UPDATE, onUserInfoUpdated);
			userInfo.addEventListener(UserInfoEvent.NINJA_INFO_UPDATE, onUserInfoUpdated);
			
			
			updateTipsInfo();
		}
		
		private function onUserInfoUpdated(evt:Event):void
		{
			updateTipsInfo();
		}
		
		private function updateTipsInfo():void
		{
			var ninjaCfgInfo:NinjaInfoCFG;
			
			if(userInfo.baseInited == false)
			{
				return ;
			}
			
			text.text = "QQ:" + userInfo.uin + "\n";
			text.appendText(I18n.lang("as_exui_1451031568_1236") + UserConfig.getProfessionsStr(userInfo.professions) + "\n");
			text.appendText(I18n.lang("as_exui_1451031568_1237") +　userInfo.battlePower + "\n");
			text.appendText("－－－－－－－－－－－－－－－－\n");
			//			text.text += userInfo.场景 todo
			
			if(userInfo.ninjaInited == false)
			{
				return ;
			}
			
			for each(var ninjaInfo:NinjaInfo in userInfo.ninjaInfoList)
			{
				ninjaCfgInfo = NinjaInfoConfig.getNinjaCfgInfo(ninjaInfo.id);
				
				if(ninjaInfo.isInFormation)
				{
					text.appendText(ninjaCfgInfo.name + "\n");
				}
			}
			
			background.width = text.width + padding;
			background.height = text.height + padding;
			
			text.x = padding / 2;
			text.y = padding / 2;
		}
		
		override public function move(x:int, y:int):void
		{
			if((x + this.width) > LayoutManager.stageWidth)
			{
				this.x = x - this.width;
			}
			else
			{
				this.x = x;
			}
			
			if((y + this.height) > LayoutManager.stageHeight)
			{
				this.y = y - this.height - 10;
			}
			else
			{
				this.y = y + 10;
			}
			
		}
		
		private function get text():TextField
		{
			return userTipsUI["text"];
		}
		
		private function get background():DisplayObject
		{
			return userTipsUI["bg"];
		}
	}
}