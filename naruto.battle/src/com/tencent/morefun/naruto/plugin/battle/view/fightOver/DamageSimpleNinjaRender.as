package com.tencent.morefun.naruto.plugin.battle.view.fightOver
{
	
	import com.tencent.morefun.naruto.plugin.exui.base.ExImage;
	import com.tencent.morefun.naruto.plugin.exui.render.StarSimpleNinjaRenderUI;
	import com.tencent.morefun.naruto.plugin.exui.render.StarSimpleNinjaStatusIconUI;
	
	import com.tencent.morefun.naruto.plugin.ui.base.ItemRenderer;
	import com.tencent.morefun.naruto.plugin.ui.components.interfaces.IRender;
	import com.tencent.morefun.naruto.plugin.ui.tips.TipsManager;
	import com.tencent.morefun.naruto.plugin.ui.util.DisplayUtils;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	
	import bag.data.CardItemData;
	
	import crew.def.NinjaNameColorDef;
	
	import def.NinjaAssetDef;
	import def.TipsTypeDef;
	
	import majorRole.def.MajorNinjaDef;
	
	import ninja.command.OpenNinjaDetailCommand;
	import ninja.model.data.NinjaInfo;
	import ninja.ui.DefaultNinjaHeadImg;
	
	import sound.commands.PlayUISoundCommand;
	import sound.def.UISoundDef;
	
	public class DamageSimpleNinjaRender extends ItemRenderer implements IRender
	{
		protected var img:ExImage;
		static public var defalutImgBitmapData:BitmapData = new DefaultNinjaHeadImg();
		protected var defaultImgBitmap:Bitmap;
		protected var statusIcon:StarSimpleNinjaStatusIconUI;
		
		public function DamageSimpleNinjaRender(skin:MovieClip = null)
		{
			if (!skin || !(skin is StarSimpleNinjaRenderUI))
			{
				skin = new StarSimpleNinjaRenderUI();
			}
			super(skin);
			init();
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
			img = new ExImage(0, 0, false, defaultImgBitmap);
			DisplayUtils.replaceDisplay(view.imgRect, img);
			
			statusIcon = new StarSimpleNinjaStatusIconUI();
			
			view.star.stop();
		}
		
		override public function set data(value:Object):void
		{
			var itemData:CardItemData;
			var cardItemData:CardItemData;
			
			m_data = value;
			
			if (value)
			{
				view.levelText.htmlText = "<b>LV" + (value as NinjaInfo).level.toString() + "</b>";
				view.frame.gotoAndStop((value as NinjaInfo).selected? "yellow" : "empty");
				view.bg.gotoAndStop(NinjaNameColorDef.getFrameIndexByStrengthenLevel((value as NinjaInfo).levelUpgrade));
				view.upBg.gotoAndStop(NinjaNameColorDef.getBgIndexByStrengthenLevel((value as NinjaInfo).levelUpgrade));
				
				view.star.gotoAndStop((value as NinjaInfo).starLevel + 1);
				
				img.load(NinjaAssetDef.getAsset(NinjaAssetDef.HEAD_SMALL,(value as NinjaInfo).cfg.id));
				
				if(MajorNinjaDef.isMajorNinjaId((value as NinjaInfo).id) == false)
				{
					TipsManager.singleton.binding(this, value, TipsTypeDef.NINJA_INFO);
				}
				else
				{
					TipsManager.singleton.binding(this, MajorNinjaDef.getMajorNinjaName((value as NinjaInfo).id), TipsTypeDef.DEFAULT);
				}
				
				view.hp.visible = false;
				view.hpBg.visible = false;
				
			}		
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
			TipsManager.singleton.unbinding(this, TipsTypeDef.DEFAULT);
			
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



