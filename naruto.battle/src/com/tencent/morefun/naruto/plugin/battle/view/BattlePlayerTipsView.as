package com.tencent.morefun.naruto.plugin.battle.view
{
	import com.tencent.morefun.naruto.plugin.battle.data.UIPlayerData;
	import com.tencent.morefun.naruto.plugin.motion.manager.ninja.NinjaConfig;
	import com.tencent.morefun.naruto.plugin.ui.layer.LayoutManager;
	import com.tencent.morefun.naruto.plugin.ui.tips.BaseTipsView;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import majorRole.def.MajorNinjaDef;
	
	import ui.battle.FightPlayerTipsUI;

	public class BattlePlayerTipsView extends BaseTipsView
	{
		private var viewUI:FightPlayerTipsUI;
		private var player:UIPlayerData;
		private var ninjaTextList:Array = [];
		private var paddingWidth:int = 40;
		private var paddingHeight:int = 25;
		private var content:DisplayObject;
		private var background:DisplayObject;
		
		public function BattlePlayerTipsView(skinCls:Class)
		{
			viewUI = (new skinCls) as FightPlayerTipsUI;
			super(null);

			initUI();
		}
		
		private function initUI():void
		{
			var textFormat:TextFormat;
			
			content = viewUI["content"];
			background = viewUI["background"];
			
			replaceTextField(ninjaInfo);
			ninjaInfo.autoSize = TextFieldAutoSize.LEFT;
			ninjaInfo.cacheAsBitmap = true;
			
			textFormat = playerNameRes.defaultTextFormat;
			textFormat.bold = true;
			playerNameRes.defaultTextFormat = textFormat;
			
			addChild(viewUI);
			
			mouseEnabled = mouseChildren = false;
		}
		
		private function replaceTextField(source:TextField):void
		{
			var textFormat:TextFormat;
			var textField:TextField;
			var parent:DisplayObjectContainer;
			
			textField = new TextField();
			textField.defaultTextFormat = source.defaultTextFormat;
			textField.name = source.name;
			textField.x = source.x;
			textField.y = source.y;
			textField.autoSize = source.autoSize;
			textField.defaultTextFormat.align = source.defaultTextFormat.align;
			textField.filters = source.filters;
			textField.multiline = source.multiline;
			textFormat = source.defaultTextFormat;
			textFormat.bold = source.defaultTextFormat.bold;
			textFormat.font = source.defaultTextFormat.font;
			textField.defaultTextFormat = textFormat;
			parent = source.parent;
			parent.removeChild(source);
			parent.addChild(textField);
			parent[textField.name] = textField;
		}
		
		override public function set data(value:Object):void
		{
			var tipsText:String;
			
			player = value as UIPlayerData;
			
			playerNameRes.text = player.name || "";
			battlePower.text = player.battlePower.toString();
			
			tipsText = "";
			for(var i:int = 0;i < 18;i ++)
			{
				if(player.ninjas.length - 1 >= i)
				{
					if(MajorNinjaDef.isMajorNinjaId(player.ninjas[i].id))
					{
						tipsText += player.name + " Lv" + player.ninjas[i].level + " \n";
					}
					else
					{
						tipsText += NinjaConfig.getNinjaInfoById(player.ninjas[i].id).cfgInfo.name + " Lv" + player.ninjas[i].level + " \n";
					}
				}
			}
			
			if(ninjaInfo.text != tipsText)
			{
				ninjaInfo.text = tipsText;
			}
			
			updateSize();
		}
		
		private function updateSize():void
		{
			background.width = content.width + paddingWidth * 2;
			background.height = content.height + paddingHeight * 2;
			
			content.x = int(background.x + paddingWidth);
			content.y = int(background.y + paddingHeight);
			
			move(_moveX, _moveY);
		}
		
		override public function move(x:int, y:int):void
		{
			if(x + width > LayoutManager.stageWidth)
			{
				this.x = LayoutManager.stageWidth - width;
			}
			else
			{
				this.x = x - 10;
			}
			if(y + height > LayoutManager.stageHeight)
			{
				this.y = LayoutManager.stageWidth - height;
			}
			else
			{
				this.y = y + 10;
			}
		}
		
		private function get playerNameRes():TextField
		{
			return viewUI.content["playerName"];
		}
		
		private function get battlePower():TextField
		{
			return viewUI.content["battlePower"];
		}
		
		private function get ninjaInfo():TextField
		{
			return viewUI.content["ninjaInfo"];
		}
		
																
		public function autoSetNull():void
		{
			if(super.hasOwnProperty("autoSetNull"))
			{
				super["autoSetNull"]();
			}

			viewUI = null;
			player = null;
			ninjaTextList = null;
			content = null;
			background = null;
		}
	}
}