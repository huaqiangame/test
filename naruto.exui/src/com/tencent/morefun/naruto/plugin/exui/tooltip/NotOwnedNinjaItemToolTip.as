package com.tencent.morefun.naruto.plugin.exui.tooltip
{	import bag.data.CardItemData;
	import bag.data.ItemData;
	
	import cfgData.dataStruct.NinjaInfoCFG;
	
	import user.data.NinjaInfoConfig;


	public class NotOwnedNinjaItemToolTip extends CardItemTooltip
	{
		public function NotOwnedNinjaItemToolTip(skinCls:Class=null)
		{
			super(skinCls);
			
			_nijiaui.cardtips.visible = false;
		}
		
		override protected function showNinjiaSkill(data:ItemData):void
		{
			var ninjaInfoCfg:NinjaInfoCFG;
			
			super.showNinjiaSkill(data);
			_nijiaui.nameText.htmlText = "<b><font color='#ffffff'>"+itemData.name+itemData.title+"</font></b>"; //名字加称号
			
			ninjaInfoCfg = NinjaInfoConfig.getNinjaCfgInfo((data as CardItemData).ninjaId);
			if (ninjaInfoCfg.starLevel > 0)
			{
				_nijiaui.starLabel.visible = true;
				_nijiaui.starLabel.gotoAndStop(ninjaInfoCfg.starLevel);
			}
			else
			{
				_nijiaui.starLabel.visible = false;
			}
		}
	}
}