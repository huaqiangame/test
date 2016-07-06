package com.tencent.morefun.naruto.plugin.exui.tooltip 
{
	import com.tencent.morefun.naruto.plugin.exui.avatar.BeastAvatar;
	import com.tencent.morefun.naruto.plugin.exui.render.SkillType1IconRender;
	import com.tencent.morefun.naruto.plugin.ui.components.layouts.SimpleLayout;
	import com.tencent.morefun.naruto.plugin.ui.layer.LayoutManager;
	import com.tencent.morefun.naruto.plugin.ui.tips.BaseTipsView;
	import com.tencent.morefun.naruto.plugin.ui.tooltip.BeastTooltipUI;
	import com.tencent.morefun.naruto.util.StrReplacer;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import bag.data.BeastRuneData;
	import bag.utils.BagUtils;
	
	import cfgData.dataStruct.SkillCFG;
	
	import throughTheBeast.data.BeastData;
	import throughTheBeast.utils.BeastUtils;

	public class BeastTooltip extends BaseTipsView
	{
		private static const leftSpace:int = 8;
		private static const rightSpace:int = 10;
		private static const topSpage:int = 11;
		private static const downSpage:int = 11;
		
		private var _ui:BeastTooltipUI;
		private var _bg:Sprite;
		private var _img:BeastAvatar;
		private var type1List:SimpleLayout;
//		private var ninJutsuTypeList:SimpleLayout;
        private var _propsTitleText:TextField;
        private var _propsText:TextField;
		
		public function BeastTooltip(skinCls:Class=null)
		{
			super(null);

            this.mouseEnabled = false;
            this.mouseChildren = false;

			_ui = new BeastTooltipUI();
			addChild(_ui);

			_bg = _ui.bg;

			_img = new BeastAvatar();
			_img.x = 0;
			_img.y = 0;
			_ui.icon.addChild(_img);
			
			type1List = new SimpleLayout(1, 3, 0, 0);
			type1List.itemRenderClass = SkillType1IconRender;
			_ui.typeListPos.addChild(type1List);
			
//			ninJutsuTypeList = new SimpleLayout(1, 3, 0, 0);
//			ninJutsuTypeList.itemRenderClass = SkillNinJutsuTypeRender;
//			_ui.typeListPos.addChild(ninJutsuTypeList);

            _propsTitleText = _ui.propsTitleText;
            _propsTitleText.htmlText = TooltipConst.BEAST_RUNE_VALUE_LABEL;

            _propsText = _ui.propsText;

            reset();
		}
		
		override public function set data(value:Object):void
		{
            if (!(value is BeastData))
                return;

            var beastData:BeastData = value as BeastData;

            reset();

            type1List.dataProvider = BeastUtils.getSkillTypesById(beastData.id);

            showName(beastData);
            showIcon(beastData);
            showProps(beastData);

            resize();
		}
		
		private function reset():void 
		{
            _img.reset();

			_ui.nameTf.text = "";
			
			(type1List) && (type1List.dataProvider = null);
//			(ninJutsuTypeList) && (ninJutsuTypeList.dataProvider = null);
			
			_ui.desTf.text = "";

//            _propsTitleText.htmlText = "";
            _propsText.htmlText = "";
		}
		
		override public function destroy():void
		{
			(_img.parent) && (_img.parent.removeChild(_img));
			_img.destroy();
			_img = null;
			
			(type1List.parent) && (type1List.parent.removeChild(type1List));
			type1List.dispose();
			type1List = null;
			
//			(ninJutsuTypeList.parent) && (ninJutsuTypeList.parent.removeChild(ninJutsuTypeList));
//			ninJutsuTypeList.dispose();
//			ninJutsuTypeList = null;
			
            _propsTitleText = null;
            _propsText = null;

			_bg = null;
			
			(_ui.parent) && (_ui.parent.removeChild(_ui));
			_ui = null;
			
			super.destroy();
		}
		
		override public function move(x:int, y:int):void
		{
			var stageWidth:int;
			var stageHeight:int;
			
			stageWidth = Math.min(stage.stageWidth - LayoutManager.stageOffsetX, LayoutManager.singleton.maxFrameWidth);
			stageHeight = Math.min(stage.stageHeight - LayoutManager.stageOffsetY, LayoutManager.singleton.maxFrameHeight)
			
			if(stage && x + 10 + width < stageWidth)
			{
				this.x = x + 10;
			}
			else
			{
				this.x = x - width;
			}
			
			if(stage && y + 10 + height < stageHeight)
			{
				this.y = y + 10;
			}
			else
			{
				this.y = y - height;
			}
		}

        override protected function resize():void
        {
            _bg.height = _propsText.y + _propsText.textHeight + 30;

            _ui.texture_left.x = leftSpace;
            _ui.texture_left.y = topSpage;
            _ui.texture_right.x = this._ui.bg.width - this._ui.texture_right.width - rightSpace;
            _ui.texture_right.y = this._ui.bg.height - this._ui.texture_right.height - downSpage;
        }

        private function showName(data:BeastData):void
        {
            var color:uint = BagUtils.QUALITY_COLORS[data.type + 1];
            var str:String = "<b><font color='#" + color.toString(16) + "'>" + data.name + "</font></b>";
            _ui.nameTf.htmlText = str;
        }

        private function showIcon(data:BeastData):void
        {
            if (data.id != 0)
            {
                _img.loadByData(data, false);
            }
            else
            {
                _img.reset();
            }
        }

        private function showProps(data:BeastData):void
        {
            if (data == null)
                return;

            _ui.typeListPos.y = _img.y + 105;

            var skillCfg:SkillCFG = BeastUtils.getSkillCfgById(data.id);

            _ui.desTf.y = _ui.typeListPos.y + 35;
            _ui.desTf.htmlText = skillCfg.desc;

            _propsTitleText.y = _ui.desTf.y + _ui.desTf.textHeight + 20;

            var str:String = "";
            var len:int = TooltipConst.BEAST_PROPS.length;
            var totalRuneVal:int;

            for (var i:int=0; i<len; ++i)
            {
                str += StrReplacer.replace(TooltipConst.BEAST_PROPS[i], data.baseProps[i]);

                totalRuneVal = getTotalRuneValue(data, i);

                if (totalRuneVal > 0)
                    str += StrReplacer.replace(TooltipConst.BEAST_RUNE_VALUE, totalRuneVal);

                if (i < len - 1)
                    str += "\n";
            }

            _propsText.y = _propsTitleText.y + _propsTitleText.textHeight + 10;
            _propsText.htmlText = str;
        }

        private function getTotalRuneValue(data:BeastData, index:int):int
        {
            if (data == null || data.runes == null)
                return 0;

            var len:int = data.runes.length;
            var runeData:BeastRuneData;
            var totalVal:int = 0;

            for (var i:int=0; i<len; ++i)
            {
                runeData = data.runes[i];
                totalVal += runeData["val" + (index + 1)];
            }

            return totalVal;
        }
	}

}