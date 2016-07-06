package com.tencent.morefun.naruto.plugin.exui.tooltip 
{

	import com.tencent.morefun.framework.base.CommandEvent;
	import com.tencent.morefun.naruto.plugin.exui.base.Image;
	import com.tencent.morefun.naruto.plugin.ui.layer.LayerManager;
	import com.tencent.morefun.naruto.plugin.ui.layer.LayoutManager;
	import com.tencent.morefun.naruto.plugin.ui.tips.BaseTipsView;
	import com.tencent.morefun.naruto.plugin.ui.tooltip.NinjaPropsTipsUI;
	
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import base.ApplicationData;
	
	import cfgData.CFGDataEnum;
	import cfgData.CFGDataLibs;
	import cfgData.dataStruct.NinjaPropsPropertyColorConfigCFG;
	
	import crew.cmd.RequestNinjaPropsTipsInfoCommand;
	import crew.data.NinjaPropsInfo;
	import crew.def.NinjaPropsTypeDef;
	
	import def.NinjaPropsAssetDef;

    import com.tencent.morefun.naruto.i18n.I18n;
	public class NinjaPropsTip extends BaseTipsView
	{
		private var _info:NinjaPropsInfo;
		private var _view:NinjaPropsTipsUI;
		private var _image:Image;
		
		private var _baseCfgMode:Boolean;
		
		/**
		 * 构造函数
		 * create a [NinjaPropsTip] object
		 */
		public function NinjaPropsTip(params:Object = null) 
		{
			mouseChildren = mouseEnabled = false;
			cacheAsBitmap = true;
			
			addChild(_view = new NinjaPropsTipsUI());
			init();
		}
		
		private function init():void 
		{
			formatText(_view.propsName, true);
			formatText(_view.tips, false);
			formatText(_view.level, true);
			formatText(_view.type, true);
			
			formatText(_view.title1, true);
			formatText(_view.title2, false);
			formatText(_view.title3, false);
			
			formatText(_view.value1, false);
			formatText(_view.value2, false);
			formatText(_view.extraValue, false);			
			
			_view.target.addChild(_image = new Image(60, 60, true, true));
			_view.price.priceless.visible = false;
		}		
		
		/**
		 * 解析装备位名字
		 * @param	index	忍具装备位索引
		 */
		private function getNinjaPropsTypeName(type:uint):String
		{
			switch(type)
			{
				case 0:return I18n.lang("as_exui_1451031568_1362");
				case 1:return I18n.lang("as_exui_1451031568_1363");
				case 2:return I18n.lang("as_exui_1451031568_1364");
				case 3:return I18n.lang("as_exui_1451031568_1365");
				case 4:return I18n.lang("as_exui_1451031568_1366");
				case 5:return I18n.lang("as_exui_1451031568_1367");
				case 6:return I18n.lang("as_exui_1451031568_1368");
				case 7:return I18n.lang("as_exui_1451031568_1369");
				case 8:return I18n.lang("as_exui_1451031568_1370");
				case 9:return I18n.lang("as_exui_1451031568_1371");
				case NinjaPropsTypeDef.EXP_PROPS:return I18n.lang("as_exui_1451031568_1372");
			}
			
			return I18n.lang("as_exui_1451031568_1373");
		}
		
		/**
		 * 格式化文本
		 */
		private function formatText(target:TextField, bold:Boolean):TextField
		{
			var format:TextFormat = target.defaultTextFormat;
			format.font = "SimSun";
			format.bold = bold;
			
			target.setTextFormat(format);
			target.defaultTextFormat = format;
			return target;
		}
		
		/**
		 * 文本着色
		 */
		private function tint(value:*, color:uint):String
		{
			return "<font color='#" + color.toString(16) + "'>" + value + "</font>";
		}
		
		/**
		 * 渲染显示
		 */
		private function render():void
		{
			const COLOR:uint = 0x14CE30;
			
			_view.propsName.text = _info.cfg.name;
			_view.propsName.textColor = _info.cfg.color;
			
			var tips:String;
			if (_info.cfg.type == NinjaPropsTypeDef.EXP_PROPS)
			{
				tips = _info.cfg.description;
				_view.level.visible = false;
			}
			else
			{
				tips = tint("Lv" + _info.equipLevel + I18n.lang("as_exui_1451031568_1374"), (_info.equipLevel > ApplicationData.singleton.selfInfo.level)? 0xFF0000 : 0xFFFFFF) + "\n";			
				if (_baseCfgMode)
				{
					_view.level.visible = false;
					tips += I18n.lang("as_exui_1451031568_1375") + _info.maxLevel;
				}
				else
				{
					_view.level.visible = true;
					_view.level.text = "Lv" + _info.level.toString();
					tips += _info.levelUpInfo.ultimate? tint(I18n.lang("as_exui_1451031568_1376_0"), COLOR) : (I18n.lang("as_exui_1451031568_1376_1") + _info.maxLevel);
				}
			}
			
			_view.tips.htmlText = tips;
			
			_view.type.text = getNinjaPropsTypeName(_info.cfg.type);
			_view.price.sellable['priceText'].htmlText = '<b>' + _info.cfg.price + '</b>';
			
			var htmlText:String;
			var properties:Vector.<String> = _info.keys.slice(0, 2);
			
			var count:uint;
			
			var key:String;
			for (var i:int = 1; i <= 2; i++)
			{
				htmlText = "";
				key = (i - 1) < properties.length? properties[i - 1] : null;
				if (key)
				{
					htmlText = _info.getPropertyName(key) + " " + tint("+" + _info[key], COLOR);
					if (_info.upgradeBuff && _info.upgradeBuff[key])
					{
						htmlText += tint(I18n.lang("as_exui_1451031568_1377") + _info.upgradeBuff[key] + ")", COLOR);
					}
				}
				if (htmlText) count++;
				(_view["value" + i] as TextField).htmlText = htmlText;
			}
			
			if (!count) _view.value1.text = I18n.lang("as_exui_1451031568_1378");
			
			var extras:Vector.<String> = new Vector.<String>();
			var color:uint;
			if (!_baseCfgMode)
			{
				_view.title3.visible = true;
				_view.extraValue.visible = true;
				
				properties = _info.extraBuff.keys;
				for (i = 0; i < properties.length; i++)
				{
					key = properties[i];
					extras.push(tint(_info.getPropertyName(key) + " " + "+" + (_info.extraBuff? _info.extraBuff[key] : "0"), getPropertyColor(_info.getPropertyIndex(key), _info.extraBuff? _info.extraBuff[key] : 0)));
				}
				
				_view.extraValue.htmlText = extras.length? extras.join("<br/>") : I18n.lang("as_exui_1451031568_1379");
				_view.extraValue.height = _view.extraValue.textHeight + 5;
				
				_view.background.height = _view.extraValue.y + _view.extraValue.height + 40;
			}
			else
			{
				_view.title3.visible = false;
				_view.extraValue.visible = false;
				_view.background.height = _view.value2.y + _view.value2.height + 40;
			}
			
			_view.decor.y = _view.background.height - _view.decor.height - 8;
			
			var url:String = NinjaPropsAssetDef.getNinjaPropsUrl(_info.id);
			if (url != _image.url)
			{
				_image.dispose();
				_image.load(url);
			}
			
			this.preMove(LayerManager.singleton.stage.mouseX - LayoutManager.stageOffsetX, LayerManager.singleton.stage.mouseY - LayoutManager.stageOffsetY);
		}
		
		private function getPropertyColor(propertyId:uint, value:uint):uint
		{
			var colorArr:Array = [0x00ce30, 0x1bb1f4, 0xb463ff, 0xffba00];
			var cfg:NinjaPropsPropertyColorConfigCFG;
			
			cfg = CFGDataLibs.getRowData(CFGDataEnum.ENUM_NinjaPropsPropertyColorConfigCFG, propertyId) as NinjaPropsPropertyColorConfigCFG;
			
			if (cfg)
			{
				for (var i:int = 0; i < cfg.grade.length; i++)
				{
					if (value < cfg.grade[i]) break;
				}
				
				i--;
				if (i >= 0 && i < colorArr.length)
				{
					return colorArr[i] as uint;
				}
			}
			return 0xffffff;
		}
		
		/**
		 * 垃圾回收
		 */
		override public function destroy():void 
		{			
			_view.parent && _view.parent.removeChild(_view);
			_view = null;
			_info = null;
		}
		
		/**
		 * 忍具信息
		 */
		override public function get data():Object { return _info; }
		override public function set data(value:Object):void 
		{
			if (value is NinjaPropsInfo)
			{
				_baseCfgMode = false;
				
				_info = value as NinjaPropsInfo;
				_info && render();
			}
			else
			{
				_baseCfgMode = true;
				_view.parent && _view.parent.removeChild(_view);
				
				var id:uint = uint(value);
				var command:RequestNinjaPropsTipsInfoCommand = new RequestNinjaPropsTipsInfoCommand(id);
				command.addEventListener(CommandEvent.FINISH, tipsInfoResponseHandler);
				command.call();
			}
		}
		
        override public function get height():Number
        {
            return _view.background.height;
        }

		private function tipsInfoResponseHandler(e:CommandEvent):void 
		{
			var command:RequestNinjaPropsTipsInfoCommand = e.currentTarget as RequestNinjaPropsTipsInfoCommand;
			command.removeEventListener(e.type, arguments.callee);
			
			if (_view)
			{
				_info = command.data;
				_view.parent == null && addChild(_view);
				
				_info && render();
				dispatchEvent(new MouseEvent(MouseEvent.MOUSE_MOVE));
			}
		}
	}

}