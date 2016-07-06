package com.tencent.morefun.naruto.plugin.exui.render
{
	
	import com.tencent.morefun.naruto.plugin.exui.base.ExImage;
	import com.tencent.morefun.naruto.plugin.ui.base.ItemRenderer;
	import com.tencent.morefun.naruto.plugin.ui.components.interfaces.IRender;
	import com.tencent.morefun.naruto.plugin.ui.tips.TipsManager;
	import com.tencent.morefun.naruto.plugin.ui.util.DisplayUtils;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import crew.def.NinjaNameColorDef;
	
	import def.NinjaAssetDef;
	import def.TipsTypeDef;
	
	import ninja.command.OpenNinjaDetailCommand;
	import ninja.model.data.NinjaInfo;
	import ninja.ui.DefaultNinjaHeadImg;
	
	import sound.commands.PlayUISoundCommand;
	import sound.def.UISoundDef;
	
	public class StarSimpleNinjaRender extends ItemRenderer implements IRender
	{
		protected var img:ExImage;
		static public var defalutImgBitmapData:BitmapData = new DefaultNinjaHeadImg();
		protected var defaultImgBitmap:Bitmap;
		private var _showDeath:Boolean;
		private var _showHp:Boolean;
		protected var statusIcon:StarSimpleNinjaStatusIconUI;
		
		/**
		 * 是否显示星级
		 */
		public var showStar:Boolean = true;
		/**
		 * 是否显示等级
		 */
		public var showLv:Boolean = true;
		/**
		 * 自定义头像大小
		 */
		public var setDefaultImgWH:Array = [0,0];
		
		public function StarSimpleNinjaRender(skin:MovieClip = null)
		{
			if (!skin || !(skin is StarSimpleNinjaRenderUI))
			{
				skin = new StarSimpleNinjaRenderUI();
			}
			super(skin);
			init();
		}
		
		public function get showHp():Boolean
		{
			return _showHp;
		}
		
		public function set showHp(value:Boolean):void
		{
			_showHp = value;
		}
		
		public function get showDeath():Boolean
		{
			return _showDeath;
		}
		
		public function set showDeath(value:Boolean):void
		{
			_showDeath = value;
		}
		
		override public function get height():Number
		{
			return 70;
		}
		
		override public function get width():Number
		{
			return 57;
		}
		
		protected function init():void
		{
			view.frame.gotoAndStop("empty");
			view.bg.gotoAndStop(1);
			view.upBg.gotoAndStop(1);
			view.frame.mouseChildren = view.frame.mouseEnabled = false;
			
			defaultImgBitmap = new Bitmap(defalutImgBitmapData);
			if(setDefaultImgWH[0] != 0){
				view.upBg.width = (61/45)*setDefaultImgWH[0];
				view.bg.width = (61/45)*setDefaultImgWH[0];
				view.frame.width = (57/45)*setDefaultImgWH[0];
				view.upBg.height = (61/45)*setDefaultImgWH[1];
				view.bg.height = (61/45)*setDefaultImgWH[1];
				view.frame.height = (52/45)*setDefaultImgWH[1];
			}
			img = new ExImage(setDefaultImgWH[0], setDefaultImgWH[1], (setDefaultImgWH[0] == 0)?false:true, defaultImgBitmap);
			DisplayUtils.replaceDisplay(view.imgRect, img);
			
			statusIcon = new StarSimpleNinjaStatusIconUI();
			
			view.star.stop();
			
			buttonMode = true;
		}
		
		override public function set data(value:Object):void
		{
			m_data = value;
			
			this.removeEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			this.removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			
			if (value)
			{
				view.levelText.htmlText = "<b>LV" + (value as NinjaInfo).level.toString() + "</b>";
				view.frame.gotoAndStop((value as NinjaInfo).selected? "yellow" : "empty");
				view.bg.gotoAndStop(NinjaNameColorDef.getFrameIndexByStrengthenLevel((value as NinjaInfo).levelUpgrade));
				view.upBg.gotoAndStop(NinjaNameColorDef.getBgIndexByStrengthenLevel((value as NinjaInfo).levelUpgrade));
				
				view.star.gotoAndStop((value as NinjaInfo).starLevel + 1);
				
				img.load(NinjaAssetDef.getAsset(NinjaAssetDef.HEAD_SMALL,(value as NinjaInfo).cfg.id));
				
				//				((value as NinjaInfo).sequence != 0) && (TipsManager.singleton.binding(this, value, TipsTypeDef.NINJA_INFO));
				TipsManager.singleton.binding(this, value, TipsTypeDef.NINJA_INFO);
				
				view.levelText.visible = showLv;
				view.star.visible = showStar;
				
				
				if(_showHp)
				{
					view.hp.scaleX = (value as NinjaInfo).detail.life / (value as NinjaInfo).detail.lifeMax.value;
					view.hp.visible = true;
					view.hpBg.visible = true;
				}
				else
				{
					view.hp.visible = false;
					view.hpBg.visible = false;
				}
				
				if(_showDeath)
				{
					var isDead:Boolean;
					isDead = (value as NinjaInfo).detail.life == 0;
					if(isDead)
					{
						view.filters = [DisplayUtils.disableCM];
						if(!contains(statusIcon))
						{
							addChild(statusIcon);
						}
					}
					else
					{
						view.filters = [];
						if(contains(statusIcon))
						{
							removeChild(statusIcon);
						}
					}
				}
				
				this.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
				this.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			}		
		}
		
		protected function onMouseOver(evt:Event):void
		{
			(!this.data.selected) && (view.frame.gotoAndStop("blue"));
			//			detailButton.visible = true;
		}
		
		protected function onMouseOut(evt:Event):void
		{
			(!this.data.selected) && (view.frame.gotoAndStop("empty"));
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
		
		protected function get view():StarSimpleNinjaRenderUI
		{
			return m_skin as StarSimpleNinjaRenderUI;
		}
		
		override public function destroy():void
		{
			TipsManager.singleton.unbinding(this, TipsTypeDef.NINJA_INFO);
			this.removeEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			this.removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			
			(img.parent) && (img.parent.removeChild(img));
			img.dispose();
			img = null;
			
			(defaultImgBitmap.parent) && (defaultImgBitmap.parent.removeChild(defaultImgBitmap));
			defaultImgBitmap = null;
			
			if(contains(statusIcon))
			{
				removeChild(statusIcon);
			}
			
			super.destroy();
		}
		
		public function dispose():void
		{
			destroy();
		}
	}
}


