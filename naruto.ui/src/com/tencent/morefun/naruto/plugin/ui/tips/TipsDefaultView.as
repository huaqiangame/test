package com.tencent.morefun.naruto.plugin.ui.tips
{
	import com.tencent.morefun.naruto.plugin.ui.layer.LayerManager;
	import com.tencent.morefun.naruto.plugin.ui.layer.LayoutManager;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public class TipsDefaultView extends BaseTipsView
	{
		protected var m_bg:DisplayObject;
		protected var m_text:String = "";
		protected var m_textField:TextField;
		
		protected var m_visible:Boolean;
		
		protected var m_paddingWidth:int = 40;
		protected var m_paddingHeight:int = 22;
		protected var m_stageWidth:int;
		protected var m_stageHeight:int
		
		protected var m_textFormat:TextFormat;
		
		protected var m_res:DisplayObjectContainer;
		
		
		public function TipsDefaultView(skinCls:Class)
		{
			super(skinCls);
			
			m_res = new skinCls();
			m_bg = m_res["background"];
			m_textField = new TextField();
			m_textField.autoSize = TextFieldAutoSize.LEFT;
			m_textField.border = false;
			
			m_textFormat = m_res["text"].defaultTextFormat;
			m_textField.filters = m_res["text"].filters;
			m_textFormat.align = TextFormatAlign.LEFT;
			
			initTextFormat();
			addChild(m_res);
			addChild(m_textField);
			
			m_textField.x = m_paddingWidth + int(m_textFormat.leftMargin) / 2;
			m_textField.y = m_paddingHeight + int(m_textFormat.leading) / 2;
			
			this.mouseEnabled = false;
			this.mouseChildren = false;
		}
		
		protected function initTextFormat():void
		{
			if(m_textFormat)
			{
				m_textField.defaultTextFormat = m_textFormat;
			}
			else
			{
				m_textFormat = m_textField.defaultTextFormat;
			}
		}
		
		/**
		 *显示提示
		 * 
		 */		
		override public function move(x:int, y:int):void
		{
			update(x, y);
		}
		
		override public function set data(value:Object):void
		{
			super.data = value;
			
			m_text = value as String;
		}
		
		
		/**
		 *更新显示内容 
		 * @param evt
		 * 
		 */		
		protected function update(x:int, y:int):void
		{
			if(m_text != m_textField.htmlText)
			{
				m_textField.htmlText = m_text;
				
				m_bg.width = int(m_textField.width + m_paddingWidth * 2);
				m_bg.height = int(m_textField.height + m_paddingHeight * 2);
			}
			
			updatePosition(x, y);
		}
		
		/**
		 *更新显示位置
		 * 
		 */		
		protected function updatePosition(x:int, y:int):void
		{
			var stageWidth:int;
			var stageHeight:int;
			
			stageWidth = Math.min(LayerManager.singleton.stage.stageWidth - LayoutManager.stageOffsetX, LayoutManager.singleton.maxFrameWidth);
			stageHeight = Math.min(LayerManager.singleton.stage.stageHeight - LayoutManager.stageOffsetY, LayoutManager.singleton.maxFrameHeight)
			
			if(stage && x + m_bg.width < stageWidth)
			{
				this.x = x + 10;
			}
			else
			{
				this.x = x - m_bg.width;
			}
			
			if(stage && y + m_bg.height < stageHeight)
			{
				this.y = y + 10;
			}
			else
			{
				this.y = y - m_bg.height;
			}
		}
		}
}

