package com.tencent.morefun.naruto.plugin.exui.render
{
	import com.tencent.morefun.naruto.plugin.exui.base.ExImage;
	import com.tencent.morefun.naruto.plugin.ui.base.BaseButton;
	import com.tencent.morefun.naruto.plugin.ui.base.ItemRenderer;
	import com.tencent.morefun.naruto.plugin.ui.components.interfaces.IRender;
	import com.tencent.morefun.naruto.plugin.ui.tips.TipsManager;
	import com.tencent.morefun.naruto.plugin.ui.util.DisplayUtils;
	import com.tencent.morefun.naruto.plugin.ui.util.VipUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	
	import base.ApplicationData;
	
	import crew.def.NinjaNameColorDef;
	
	import def.NinjaAssetDef;
	import def.TipsTypeDef;
	
	import guide.guideInterface.IGuideTarget;
	
	import ninja.command.OpenNinjaDetailCommand;
	import ninja.model.data.NinjaInfo;
	import ninja.ui.DefaultNinjaHeadImg;
	
	import player.datas.PlayerData;
	import player.events.PlayerDataEvent;
	
	import sound.commands.PlayUISoundCommand;
	import sound.def.UISoundDef;
	
	import utils.PlayerNameUtil;

	public class SimpleNinjaRender extends ItemRenderer implements IRender, IGuideTarget
	{
		protected var img:ExImage;
		static public var defalutImgBitmapData:BitmapData = new DefaultNinjaHeadImg();
		protected var defaultImgBitmap:Bitmap;
		protected var detailButton:BaseButton;
		
		public function SimpleNinjaRender(skin:MovieClip = null)
		{
			if (!skin || !(skin is SimpleNinjaRenderUI))
			{
				skin = new SimpleNinjaRenderUI();
			}
			super(skin);
			init();
		}
		
		protected function init():void
		{
			view.frame.gotoAndStop("empty");
			view.bg.gotoAndStop("white");
			view.upBg.gotoAndStop(1);
			view.nameText.mouseEnabled = false;
			view.levelText.autoSize = TextFieldAutoSize.LEFT;
			view.frame.mouseChildren = view.frame.mouseEnabled = false;
			
			defaultImgBitmap = new Bitmap(defalutImgBitmapData);
			img = new ExImage(0, 0, false, defaultImgBitmap);
			DisplayUtils.replaceDisplay(view.imgRect, img);
			
			this.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			this.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			
			detailButton = new BaseButton(view.detailButton);
			detailButton.addEventListener(MouseEvent.CLICK, onDetailButtonClick);
			detailButton.buttonMode = true;
			view.addChild(detailButton);
			detailButton.visible = false;
		}
		
		override public function set data(value:Object):void
		{
			m_data = value;
			var ninjaName:String;
			
			if (value)
			{
				
				if ((value as NinjaInfo).sequence == 0)
				{	
					if((value as NinjaInfo).isOtherPlayer == false)
					{
						ninjaName = PlayerNameUtil.standardlizeName(ApplicationData.singleton.selfPlayerKey,ApplicationData.singleton.selfInfo.name);
						ApplicationData.singleton.selfInfo.addEventListener(PlayerDataEvent.PROPERTY_UPDATE, onSelfInfoPropertyUpdate);
						VipUtil.setSelfInfo(view.vipIcon);
					}else
					{
						ninjaName = PlayerNameUtil.standardlizeName((value as NinjaInfo).otherPlayerSvrId, (value as NinjaInfo).otherPlayerName);
						ApplicationData.singleton.selfInfo.removeEventListener(PlayerDataEvent.PROPERTY_UPDATE, onSelfInfoPropertyUpdate);
						VipUtil.setOtherInfo(view.vipIcon,0,null);
					}
				}
				else
				{
					ninjaName = (value as NinjaInfo).cfg.name;
					ApplicationData.singleton.selfInfo.removeEventListener(PlayerDataEvent.PROPERTY_UPDATE, onSelfInfoPropertyUpdate);
					VipUtil.setOtherInfo(view.vipIcon,0,null);
				}
				
				view.nameText.text = 
					ninjaName
					+ (((value as NinjaInfo).sequence == 0)? "" : (value as NinjaInfo).cfg.title)
					+ NinjaNameColorDef.getNameAppendStrByStrengthenLevel((value as NinjaInfo).levelUpgrade);
				view.nameText.textColor = NinjaNameColorDef.getNameTextColorByStrengthenLevel((value as NinjaInfo).levelUpgrade);
				view.nameText.autoSize = TextFieldAutoSize.LEFT;
				view.nameText.x = view.vipIcon.x + view.vipIcon.width;
				
				view.levelText.htmlText = "<b>" + (value as NinjaInfo).level.toString() + "</b>";
				view.levelText.x = 128 - view.levelText.textWidth;
				view.levelLabel.x = view.levelText.x - 19;
				view.levelText.visible = view.levelLabel.visible = ((value as NinjaInfo).level > 0);
				view.propertyTag.gotoAndStop((value as NinjaInfo).cfg.property);
				view.frame.gotoAndStop((value as NinjaInfo).selected? "yellow" : "empty");
//				view.gradeTag.visible = ((value as NinjaInfo).sequence != 0);
//				if (view.gradeTag) {
//					if ((value as NinjaInfo).sequence != 0) {
//						view.gradeTag.gotoAndStop((value as NinjaInfo).cfg.rareness);
//					}else {
//						view.gradeTag.gotoAndStop("p" + (value as NinjaInfo).rolePromoteLevel);
//					}
//					view.gradeTag.visible = true;
//				}
				
				if((value as NinjaInfo).sequence != -1)
				{
					view.starLabel.gotoAndStop((value as NinjaInfo).starLevel+1);
				}
				else
				{
					view.starLabel.gotoAndStop((value as NinjaInfo).cfg.starLevel);
				}
				view.bg.gotoAndStop(NinjaNameColorDef.getNameTextColorNameByStrengthenLevel((value as NinjaInfo).levelUpgrade));
				view.upBg.gotoAndStop((value as NinjaInfo).levelUpgrade+1);
				
				img.load(NinjaAssetDef.getAsset(NinjaAssetDef.HEAD_WIDE,(value as NinjaInfo).cfg.id));
				
				TipsManager.singleton.binding(this, value, TipsTypeDef.NINJA_INFO);
			}else
			{
				ApplicationData.singleton.selfInfo.removeEventListener(PlayerDataEvent.PROPERTY_UPDATE, onSelfInfoPropertyUpdate);
				VipUtil.setOtherInfo(view.vipIcon,0,null);
				TipsManager.singleton.unbinding(this, TipsTypeDef.NINJA_INFO);
			}
		}
		
		protected function onSelfInfoPropertyUpdate(event:PlayerDataEvent):void
		{
			if(event.property == PlayerData.PROPERTY_VIP_LEVEL)
			{
				VipUtil.setSelfInfo(view.vipIcon);
				view.nameText.x = view.vipIcon.x + view.vipIcon.width;
			}
		}
		
		protected function onMouseOver(evt:Event):void
		{
			(!this.data.selected) && (view.frame.gotoAndStop("blue"));
//			detailButton.visible = true;
		}
		
		protected function onMouseOut(evt:Event):void
		{
			if (this.data == null) return;
			
			(!this.data.selected) && (view.frame.gotoAndStop("empty"));
			detailButton.visible = false;
		}
		
		protected function onDetailButtonClick(evt:MouseEvent):void
		{
			new OpenNinjaDetailCommand((m_data as NinjaInfo).id, true, (m_data as NinjaInfo).sequence).call();
			new PlayUISoundCommand(UISoundDef.BUTTON_CLICK).call();
		}
		
		override public function set selected(value:Boolean):void 
		{
			m_selected = value;
			view.frame.gotoAndStop(m_selected? "yellow" : "empty");
		}
		
		protected function get view():SimpleNinjaRenderUI
		{
			return m_skin as SimpleNinjaRenderUI;
		}
		
		override public function destroy():void
		{
			TipsManager.singleton.unbinding(this, TipsTypeDef.NINJA_INFO);
			ApplicationData.singleton.selfInfo.removeEventListener(PlayerDataEvent.PROPERTY_UPDATE, onSelfInfoPropertyUpdate);
			this.removeEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			this.removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			(view) && (detailButton) && (detailButton.removeEventListener(MouseEvent.CLICK, onDetailButtonClick));
			(detailButton.parent) && (detailButton.parent.removeChild(detailButton));
			detailButton.destroy();
			detailButton = null;
			
			(img.parent) && (img.parent.removeChild(img));
			img.dispose();
			img = null;
			
			(defaultImgBitmap.parent) && (defaultImgBitmap.parent.removeChild(defaultImgBitmap));
			defaultImgBitmap = null;
			
			super.destroy();
		}
		
		public function dispose():void
		{
			destroy();
		}
		
		override public function get width():Number
		{
			return 167;
		}
		
		override public function get height():Number
		{
			return 79;
		}
		
		public function get guideTargetName():String
		{
			if (data && data.hasOwnProperty("id"))
			{
				return String(data["id"]);
			}
			return "";
		}
	}
}


