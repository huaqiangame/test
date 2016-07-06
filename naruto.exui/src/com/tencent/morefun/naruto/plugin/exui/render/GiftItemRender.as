package com.tencent.morefun.naruto.plugin.exui.render
{

	import com.tencent.morefun.naruto.plugin.exui.item.ItemIcon;
	import com.tencent.morefun.naruto.plugin.ui.base.ItemRenderer;
	import com.tencent.morefun.naruto.plugin.ui.components.interfaces.IRender;
	import com.tencent.morefun.naruto.plugin.ui.tips.TipsManager;
	import com.tencent.morefun.naruto.plugin.ui.util.DisplayUtils;
	
	import flash.display.DisplayObject;
	import flash.text.TextFieldAutoSize;
	
	import bag.conf.BagItemConf;
	import bag.data.ItemData;
	import bag.utils.BagUtils;
	
	import def.TipsTypeDef;
	
	import ui.exui.GiftItemUI;

    import com.tencent.morefun.naruto.i18n.I18n;
	public class GiftItemRender extends ItemRenderer implements IRender
	{
		private static const IMG_WIDTH:Number = 64;
		private static const IMG_HEIGHT:Number = 64;
		private static const TXT_OFFSET_X:int = -4;
		private static const TXT_OFFSET_Y:int = -1;
		
		protected var _icon:ItemIcon;
		
		public function GiftItemRender(skin:DisplayObject = null)
		{
			super(new GiftItemUI());
			initUI();
		}
		
		protected function initUI():void
		{
			view.txt.wordWrap = false;
			view.txt.autoSize = TextFieldAutoSize.RIGHT;
			view.txt.mouseEnabled = false;
			view.txt.visible = false;
			
			_icon = new ItemIcon();	
			view.img.addChild(_icon);
			
			this.scaleX = this.scaleY = 0.75; //把60*60缩放成40*40
		}
		
		override public function set data(value:Object):void
		{	
			var itemData:ItemData;
			
			if(m_data == value){return;}
			m_data = value;
					
			if (m_data != 0 && m_data != null)
			{
				if (m_data is ItemData)
				{
					itemData = m_data as ItemData;
				}
				else
				{
					if (BagUtils.isNinjaPropsItem(int(m_data)))
					{
						itemData = new ItemData();
						itemData.id = int(m_data);
					}
					else
					{
						itemData = BagItemConf.findDataById(int(m_data));
					}
					if (!itemData && !(m_data is ItemData))
					{
						throw new Error(I18n.lang("as_exui_1451031568_1254_0") + m_data + I18n.lang("as_exui_1451031568_1254_1"));
						return;
					}
					itemData.num = 0;
				}
				
				_icon.loadIcon(itemData.id);
				view.txt.text = "" + itemData.num;
				
				TipsManager.singleton.unbinding(view, TipsTypeDef.BAG_ITEM);
				TipsManager.singleton.unbinding(view, TipsTypeDef.NINJA_PROPS);
				
				if (itemData.id != 0)
				{
					if (BagUtils.isNinjaPropsItem(itemData.id))
					{
						TipsManager.singleton.binding(view, itemData.id, TipsTypeDef.NINJA_PROPS);
					}
					else
					{
						(itemData.name) && (TipsManager.singleton.binding(view, itemData, TipsTypeDef.BAG_ITEM));
					}
				}
			}
		}
		
		protected function get view():GiftItemUI
		{
			return m_skin as GiftItemUI;
		}
		
		override public function destroy():void
		{
			(_icon.parent) && (_icon.parent.removeChild(_icon));
			_icon.destroy();
			_icon = null;
			
			DisplayUtils.clear(view);
			super.destroy();
		}
		
		public function dispose():void
		{
			destroy();
		}
		
		override public function set scaleX(value:Number):void
		{
			_icon.scaleX = value;
			view.bg.scaleX = value;
			updateNumTextPosition();
		}
		
		override public function set scaleY(value:Number):void
		{
			_icon.scaleY = value;
			view.bg.scaleY = value;
			updateNumTextPosition();
		}
		
		override public function get scaleX():Number
		{
			return _icon.scaleX;
		}
		
		override public function get scaleY():Number
		{
			return _icon.scaleY;
		}
		
		override public function get width():Number
		{
			return IMG_WIDTH * _icon.scaleX;
		}
		
		override public function get height():Number
		{
			return IMG_HEIGHT * _icon.scaleY;
		}
		
		private function updateNumTextPosition():void
		{
			view.txt.x = this.width - view.txt.width + TXT_OFFSET_X * _icon.scaleX;
			view.txt.y = this.height - view.txt.height + TXT_OFFSET_Y * _icon.scaleY;
		}
	}
}