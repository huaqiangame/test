package com.tencent.morefun.naruto.plugin.exui.tooltip 
{
	import com.tencent.morefun.framework.base.CommandEvent;
	import com.tencent.morefun.naruto.plugin.exui.avatar.BeastAvatar;
	import com.tencent.morefun.naruto.plugin.exui.render.SkillType1IconRender;
	import com.tencent.morefun.naruto.plugin.ui.components.layouts.SimpleLayout;
	import com.tencent.morefun.naruto.plugin.ui.layer.LayoutManager;
	import com.tencent.morefun.naruto.plugin.ui.tips.BaseTipsView;
	import com.tencent.morefun.naruto.plugin.ui.tooltip.BeastFragmentTooltipUI;
	import com.tencent.morefun.naruto.util.GameTip;
	import com.tencent.morefun.naruto.util.StrReplacer;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import bag.data.BeastFragmentData;
	
	import throughTheBeast.command.GetBeastByIdCmd;
	import throughTheBeast.data.BeastData;
	import throughTheBeast.utils.BeastUtils;

	public class BeastFragmentTooltip extends BaseTipsView
	{
		private static const leftSpace:int = 8;
		private static const rightSpace:int = 10;
		private static const topSpage:int = 11;
		private static const downSpage:int = 11;
		
		private var _ui:BeastFragmentTooltipUI;
		private var _bg:Sprite;
		private var _img:BeastAvatar;
		private var type1List:SimpleLayout;
//		private var ninJutsuTypeList:SimpleLayout;
        private var _propsTitleText:TextField;
        private var _propsText:TextField;
		
		public function BeastFragmentTooltip() 
		{
			super(null);

            this.mouseEnabled = false;
            this.mouseChildren = false;

			_ui = new BeastFragmentTooltipUI();
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
            if (!(value is BeastFragmentData))
                return;

            reset();

            var fragData:BeastFragmentData = value as BeastFragmentData;
            _data = value;

            type1List.dataProvider = BeastUtils.getSkillTypesById(fragData.beastId);

            showName(fragData);
            showIcon(fragData);
            showProps(fragData);
            showBottomBar(fragData);

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

            _ui.bottomBar.visible = false;

            _data = null;
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
            _bg.height = _ui.bottomBar.y + _ui.bottomBar.height + 12;

            _ui.texture_left.x = leftSpace;
            _ui.texture_left.y = topSpage;
            _ui.texture_right.x = this._ui.bg.width - this._ui.texture_right.width - rightSpace;
            _ui.texture_right.y = this._ui.bg.height - this._ui.texture_right.height - downSpage;
        }

        private function showName(data:BeastFragmentData):void
        {
            var str:String = "<b><font color='#" + data.color.toString(16) + "'>" + (data.name + TooltipConst.FRAGMENT) + "</font></b>";
            _ui.nameTf.htmlText = str;
        }

        private function showIcon(data:BeastFragmentData):void
        {
            if (data.beastId != 0)
            {
                var beastData:BeastData = new BeastData();
                beastData.id = data.beastId;

                _img.loadByData(beastData, false);
            }
            else
            {
                _img.reset();
            }
        }

        private function showProps(data:BeastFragmentData):void
        {
            if (data == null)
                return;

            _ui.typeListPos.y = _img.y + 105;

            _ui.desTf.y = _ui.typeListPos.y + 35;
            _ui.desTf.htmlText = data.description;

            _propsTitleText.y = _ui.desTf.y + _ui.desTf.textHeight + 20;

            var str:String = "";

            str += StrReplacer.replace(TooltipConst.BEAST_PROPS[0], data.baseProps[0]) + "\n";
            str += StrReplacer.replace(TooltipConst.BEAST_PROPS[1], data.baseProps[1]) + "\n";
            str += StrReplacer.replace(TooltipConst.BEAST_PROPS[2], data.baseProps[2]) + "\n";
            str += StrReplacer.replace(TooltipConst.BEAST_PROPS[3], data.baseProps[3]) + "\n";
            str += StrReplacer.replace(TooltipConst.BEAST_PROPS[4], data.baseProps[4]);

            _propsText.y = _propsTitleText.y + _propsTitleText.textHeight + 10;
            _propsText.htmlText = str;
        }

        private function showBottomBar(data:BeastFragmentData):void
        {
            var cmd:GetBeastByIdCmd = new GetBeastByIdCmd(data.beastId);
            cmd.addEventListener(CommandEvent.FINISH, onBeastData);
            cmd.addEventListener(CommandEvent.FAILD, onBeastData);
            cmd.call();
        }

        private function onBeastData(event:CommandEvent):void
        {
            var cmd:GetBeastByIdCmd = event.currentTarget as GetBeastByIdCmd;
            cmd.removeEventListener(CommandEvent.FINISH, onBeastData);
            cmd.removeEventListener(CommandEvent.FAILD, onBeastData);

            switch(event.type)
            {
                case CommandEvent.FINISH:
                    udpateBottomBar(cmd.beastInfo);
                    break;
                case CommandEvent.FAILD:
                    GameTip.show(TooltipConst.FAILED_TO_GET_BEAST_DATA);
                    break;
            }
        }

        private function udpateBottomBar(beastData:BeastData):void
        {
            if (!(_data is BeastFragmentData) || _ui == null)
                return;

            _ui.bottomBar.y = _propsText.y + _propsText.textHeight + 20;

            var ownedBeast:Boolean = beastData != null;
            var str:String;

            if (!ownedBeast)
                str = StrReplacer.replace(TooltipConst.BEAST_FRAGMENT_TEXT, [data.beastFragmentNum, data.name]);
            else
                str = StrReplacer.replace(TooltipConst.BEAST_OWNED_TEXT, data.name);

            _ui.bottomBar.txt.text = str;
            _ui.bottomBar.visible = true;
        }
	}

}