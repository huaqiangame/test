package com.tencent.morefun.naruto.plugin.exui.render
{
	
	import com.tencent.morefun.naruto.plugin.exui.base.Image;
	import com.tencent.morefun.naruto.plugin.ui.base.ItemRenderer;
	import com.tencent.morefun.naruto.plugin.ui.components.interfaces.IRender;
	import com.tencent.morefun.naruto.plugin.ui.util.VipUtil;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	
	import base.ApplicationData;
	
	import cfgData.dataStruct.NinjaInfoCFG;
	
	import crew.def.NinjaNameColorDef;
	
	import def.NinjaAssetDef;
	
	import guide.guideInterface.IGuideTarget;
	
	import ninja.model.data.NinjaInfo;
	
	import player.datas.PlayerData;
	import player.events.PlayerDataEvent;
	
	import user.data.NinjaInfoConfig;
	import user.event.NinjaInfoEvent;
	
	import utils.PlayerNameUtil;

	public class BaseNinjaTabRender extends ItemRenderer implements IRender, IGuideTarget
	{
		public static const BLUE_FRAME:int      =   1;
		public static const RED_FRAME:int       =   2;
		
		protected var _ui:BaseNinjaTabUI;
		protected var _onTabClick:Function;
		protected var _data:NinjaInfo;
		protected var _selected:Boolean;
		protected var _img:Image;
		
		public function BaseNinjaTabRender(ui:BaseNinjaTabUI = null, onTabClick:Function=null)
		{
			if (!ui || !(ui is BaseNinjaTabUI))
			{
				ui = new BaseNinjaTabUI();
			}
			super(ui);
			
			_ui = ui;
			_ui.mouseChildren = false;
			_ui.addEventListener("refreshData", onRefreshData);
			_onTabClick = onTabClick;
			
			initUI();
		}
		
		protected function onRefreshData(event:Event):void
		{
			if (_data != null)
				this.data = _data;
		}
		
		protected function initUI():void
		{
			_ui.gotoAndStop("normal");
			_ui.addEventListener(MouseEvent.MOUSE_OVER, onOver);
			_ui.addEventListener(MouseEvent.MOUSE_OUT, onOut);
			_ui.addEventListener(MouseEvent.CLICK, onClick);
			
			_img = new Image(50,50);
			_ui.frame.imgPos.addChild(_img);
		}
		
		override public function destroy():void
		{
			_data = null;
			_ui.removeEventListener("refreshData", onRefreshData);
			_ui.removeEventListener(MouseEvent.MOUSE_OVER, onOver);
			_ui.removeEventListener(MouseEvent.MOUSE_OUT, onOut);
			_ui.removeEventListener(MouseEvent.CLICK, onClick);
			
			ApplicationData.singleton.selfInfo.removeEventListener(PlayerDataEvent.PROPERTY_UPDATE, onSelfInfoPropertyUpdate);
			VipUtil.setOtherInfo(_ui.frame.vipIcon,0,null);
			
			_onTabClick = null;
			
			(_img.parent) && (_img.parent.removeChild(_img));
			_img.dispose();
			_img = null;
			
			super.destroy();
		}
		
		public function dispose():void
		{
			destroy();
		}
		
		public function reset():void
		{
			ApplicationData.singleton.selfInfo.removeEventListener(PlayerDataEvent.PROPERTY_UPDATE, onSelfInfoPropertyUpdate);
			VipUtil.setOtherInfo(_ui.frame.vipIcon,0,null);
			_ui.visible = false;
			_ui.gotoAndStop(1);
			
			_img.dispose();
		}
		
		override public function get data():Object
		{
			return _data;
		}
		
		override public function set data(value:Object):void
		{
			var ninjaName:String;
			
			if (value is NinjaInfo)
			{
				_data = value as NinjaInfo;
				
				var ninjaCfgInfo:NinjaInfoCFG = NinjaInfoConfig.getNinjaCfgInfo(_data.id);
				if (!ninjaCfgInfo) return;
				
				if (_ui.frame) 
				{
					if ((value as NinjaInfo).sequence == 0)
					{
						if((value as NinjaInfo).isOtherPlayer == false)
						{
							ninjaName = PlayerNameUtil.standardlizeName(ApplicationData.singleton.selfPlayerKey,ApplicationData.singleton.selfInfo.name);
							ApplicationData.singleton.selfInfo.addEventListener(PlayerDataEvent.PROPERTY_UPDATE, onSelfInfoPropertyUpdate);
							VipUtil.setSelfInfo(_ui.frame.vipIcon);
						}else
						{
							ninjaName = PlayerNameUtil.standardlizeName((value as NinjaInfo).otherPlayerSvrId, (value as NinjaInfo).otherPlayerName);
							ApplicationData.singleton.selfInfo.removeEventListener(PlayerDataEvent.PROPERTY_UPDATE, onSelfInfoPropertyUpdate);
							VipUtil.setOtherInfo(_ui.frame.vipIcon,(value as NinjaInfo).otherPlayerVipLevel,(value as NinjaInfo).otherPlayerDiamondInfo);
						}
					}
					else
					{
						ninjaName = (value as NinjaInfo).cfg.name;
						ApplicationData.singleton.selfInfo.removeEventListener(PlayerDataEvent.PROPERTY_UPDATE, onSelfInfoPropertyUpdate);
						VipUtil.setOtherInfo(_ui.frame.vipIcon,0,null);
					}
					
					_ui.frame.nameText.text = 
						ninjaName
						+ (((value as NinjaInfo).sequence == 0)? "" : ninjaCfgInfo.title)
						+ NinjaNameColorDef.getNameAppendStrByStrengthenLevel(_data.levelUpgrade);
					_ui.frame.nameText.textColor = NinjaNameColorDef.getNameTextColorByStrengthenLevel(_data.levelUpgrade);
					_ui.frame.nameText.autoSize = TextFieldAutoSize.LEFT;
					_ui.frame.nameText.x = _ui.frame.vipIcon.x + _ui.frame.vipIcon.width;
				}
				(_ui.levelText) && (_ui.levelText.htmlText = "<b>" + _data.level.toString() + "</b>");
				(_ui.propertyTag) && (_ui.propertyTag.gotoAndStop(ninjaCfgInfo.property));
//				if (_ui.gradeTag) {
//					if (_data.sequence != 0) {
//						_ui.gradeTag.gotoAndStop(ninjaCfgInfo.rareness);
//					}else {
//						_ui.gradeTag.gotoAndStop("p" + _data.rolePromoteLevel);
//					}
//					_ui.gradeTag.visible = true;
//				}
				_ui.starLabel.gotoAndStop(_data.starLevel+1);
				if (_data.isInFormation)
				{
//					_ui.frame.gotoAndStop(RED_FRAME);
					(_ui.formationTag) && (_ui.formationTag.visible = true); 
				}
				else
				{
//					_ui.frame.gotoAndStop(BLUE_FRAME);
					(_ui.formationTag) && (_ui.formationTag.visible = false);
				}
				
				(_ui.frame) && (_ui.frame.gotoAndStop(NinjaNameColorDef.getNameTextColorNameByStrengthenLevel(_data.levelUpgrade)));
				(_ui.frame) && (_ui.frame.imgPos.addChild(_img));
				_img.load(NinjaAssetDef.getAsset(NinjaAssetDef.HEAD_WIDE, ninjaCfgInfo.id));
				
				_ui.visible = true;
			}
			else
			{
				reset();
			}
		}
		
		protected function onSelfInfoPropertyUpdate(event:PlayerDataEvent):void
		{
			if(event.property == PlayerData.PROPERTY_VIP_LEVEL)
			{
				VipUtil.setSelfInfo(_ui.frame.vipIcon);
				_ui.frame.nameText.x = _ui.frame.vipIcon.x + _ui.frame.vipIcon.width;
			}
		}
		
		
		protected function onOver(event:MouseEvent):void
		{
			if (!this.selected)
				_ui.gotoAndStop("mouseOver");
			
		}
		
		protected function onOut(event:MouseEvent):void
		{
			if (!this.selected)
				_ui.gotoAndStop("normal");
		}
		
		override public function get selected():Boolean
		{
			return _selected;
		}
		
		override public function set selected(value:Boolean):void
		{
			if (value)
			{
				if (!this.selected)
					playSelecting();
			}
			else
			{
				if (this.selected)
					playDeselecting();
			}
			
			_selected = value;
		}
		
		protected function onClick(event:MouseEvent):void
		{
			if (this.selected)
				return;
			
			if (_onTabClick != null)
				_onTabClick(this);
		}
		
		public function get showAvatarOnly():Boolean
		{
			return false;
		}
		
		public function set showAvatarOnly(value:Boolean):void
		{
		}
		
		protected function playSelecting():void
		{
			_ui.gotoAndPlay("selecting");
		}
		
		protected function playDeselecting():void
		{
			_ui.gotoAndPlay("deselecting");
		}
		
		protected function onNinjaInfoAllChanged(event:NinjaInfoEvent):void
		{
			data = _data;
		}
		
		public function get guideTargetName():String
		{
			return (_data && _data is NinjaInfo)? (_data as NinjaInfo).id.toString() : "null"; 
		}
	}
}


