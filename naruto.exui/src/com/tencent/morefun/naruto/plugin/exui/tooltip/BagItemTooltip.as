package com.tencent.morefun.naruto.plugin.exui.tooltip
{
    import com.tencent.morefun.naruto.plugin.ui.tips.BaseTipsView;
    
    import bag.data.CardItemData;
    import bag.data.EquipmentItemData;
    import bag.data.GemItemData;
    import bag.data.ItemData;
    import bag.utils.BagUtils;

    public class BagItemTooltip extends BaseTipsView
    {
        private var _detailTooltip:BaseTipsView;

        public function BagItemTooltip(skinCls:Class=null)
        {
            this..mouseEnabled = false;
            this.mouseChildren = false;
        }

        override public function destroy():void
        {
            clearDetailTooltip();
        }

        override public function set data(value:Object):void
        {
            if (!(value is ItemData))
                return;

            clearDetailTooltip();

            if (value is EquipmentItemData)
                _detailTooltip = new EquipmentItemTooltip();
            else if (value is GemItemData)
                _detailTooltip = new GemItemTooltip();
            else if (value is CardItemData)
                _detailTooltip = new CardItemTooltip();
            else if (BagUtils.isRewardPackageItem(value.id))
                _detailTooltip = new RewardPackageItemTooltip();
            else if (BagUtils.isBeastFragment(value.id))
                _detailTooltip = new BeastFragmentTooltip();
            else if (BagUtils.isBeastRune(value.id))
                _detailTooltip = new BeastRuneTooltip();
            else
                _detailTooltip = new CommonItemTooltip();

            _detailTooltip.data = value;
            this.addChild(_detailTooltip);
        }

        private function clearDetailTooltip():void
        {
            if (_detailTooltip != null && this.contains(_detailTooltip))
            {
                this.removeChild(_detailTooltip);
                _detailTooltip.destroy();
                _detailTooltip = null;
            }
        }

        override public function get height():Number
        {
            if (_detailTooltip != null && this.contains(_detailTooltip))
                return _detailTooltip.height;
            else
                return super.height;
        }
   	}
}