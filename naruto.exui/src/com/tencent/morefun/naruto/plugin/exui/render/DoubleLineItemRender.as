package com.tencent.morefun.naruto.plugin.exui.render
{
	
	import com.tencent.morefun.naruto.plugin.exui.tooltip.ItemAchievedWayTip;
	import com.tencent.morefun.naruto.plugin.ui.base.ItemRenderer;
	import com.tencent.morefun.naruto.plugin.ui.components.interfaces.IRender;
	
	import flash.display.DisplayObject;
	
	import bag.conf.BagItemConf;
	import bag.data.ItemData;
	import bag.utils.BagUtils;
	
	import ui.exui.DoubleLineItemUI;
	
	/**
	 * @author woodychen
	 * @createTime 2014-7-2 下午8:18:33
	 **/
	public class DoubleLineItemRender extends ItemRenderer implements IRender
	{
		protected const RENDER_WIDTH:int = 76;
		protected const RENDER_HEIGHT:int = 99;
		
		protected var giftItemRender:GiftItemRender;
		
		public function DoubleLineItemRender(skin:DisplayObject=null)
		{
			super(new DoubleLineItemUI());
			initUI();
		}
		
		protected function initUI():void
		{
			giftItemRender = new GiftItemRender();
			giftItemRender.scaleX = giftItemRender.scaleY = 1;
			view.imgPos.addChild(giftItemRender);
		}
		
		/**
		 * @param value可以是itemData，也可以是itemId
		 */
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
					itemData.num = 0;
				}
				
				(itemData) && (view.nameText.htmlText = BagUtils.getColoredItemName(itemData.id));
				giftItemRender.data = itemData;
				view.numText.text = itemData.num.toString();
				
				ItemAchievedWayTip.singleton.unbind(view);
				(itemData) && (ItemAchievedWayTip.singleton.binding(view,itemData,0,[6,-1]));
			}
		}
		
		protected function get view():DoubleLineItemUI
		{
			return m_skin as DoubleLineItemUI;
		}
		
		override public function destroy():void
		{
			ItemAchievedWayTip.singleton.unbind(view);
			
			(giftItemRender.parent) && (giftItemRender.parent.removeChild(giftItemRender));
			giftItemRender.dispose();
			giftItemRender = null;
			
			super.destroy();
		}
		
		public function dispose():void
		{
			destroy();
		}
		
		override public function get width():Number
		{
			return RENDER_WIDTH;
		}
		
		override public function get height():Number
		{
			return RENDER_HEIGHT;
		}
	}
}