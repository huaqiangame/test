package com.tencent.morefun.naruto.plugin.ui.tips
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public class ToolTip extends BaseTipsView
	{
		private var m_bg:DisplayObject;
		private var m_text:String;
		private var m_textField:TextField;

		private var m_destX:int;
		private var m_destY:int;
		private var m_curDestX:int;
		private var m_curDestY:int;
		private var m_visible:Boolean;
		
		private var m_paddingWidth:int = 40;
		private var m_paddingHeight:int = 15;
		private var m_stageWidth:int;
		private var m_stageHeight:int
		
		private var m_textFormat:TextFormat;
		
		
		public function ToolTip(skinCls:Class)
		{
			super(skinCls);
			
			m_bg = new skinCls();
			m_textField = new TextField();
			m_textField.autoSize = TextFieldAutoSize.LEFT;
			m_textField.border = false;
			m_textField.multiline = true;
			
			m_textFormat = new TextFormat();
			m_textFormat.align = TextFormatAlign.LEFT;

			initTextFormat();
			addChild(m_bg);
			addChild(m_textField);
			
			m_textField.x = m_paddingWidth + int(m_textFormat.leftMargin) / 2;
			m_textField.y = m_paddingHeight + int(m_textFormat.leading) / 2;
			
			this.visible = false;
			
			this.mouseEnabled = false;
			this.mouseChildren = false;
		}
		
		private function initTextFormat():void
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
		 *更新舞台尺寸 
		 * @param width
		 * @param height
		 * 
		 */		
		override public function updateStageSize(width:int, height:int):void
		{
			m_stageWidth = width;
			m_stageHeight = height;
			
			waitUpdate();
		}
	
		/**
		 *显示提示
		 * 
		 */		
		override public function move(x:int, y:int):void
		{
			m_destX = x + 10;
			m_destY = y + 10;
			
			waitUpdate();
		}
		
		override public function set data(value:Object):void
		{
			super.data = value;
			
			m_text = value as String;
			waitUpdate();
		}
		
		/**
		 *延迟更新 
		 * 
		 */		
		public function waitUpdate():void
		{
			this.addEventListener(Event.ENTER_FRAME, update);
		}
		
		/**
		 *更新显示内容 
		 * @param evt
		 * 
		 */		
		private function update(evt:Event):void
		{
			this.removeEventListener(Event.ENTER_FRAME, update);
			
			if(m_text != m_textField.htmlText)
			{
				m_textField.htmlText = m_text;
				
				m_bg.width = m_textField.width + m_paddingWidth * 2;
				m_bg.height = m_textField.height + m_paddingHeight * 2;
			}
			
			if(m_curDestX != m_destX || m_curDestY != m_destY)
			{
				updatePosition();
			}
			
			if(this.visible != m_visible)
			{
				(m_visible == true)? this.visible = true:this.visible = false;
			}
		}
		
		/**
		 *更新显示位置
		 * 
		 */		
		private function updatePosition():void
		{
			if(m_destX + this.width > m_stageWidth)
			{
				this.x = m_stageWidth - this.width;
			}
			else
			{
				this.x = m_destX;
			}
			
			m_curDestX = m_destX;
			
			if(m_destY + this.height > m_stageHeight)
			{
				this.y = m_stageHeight - this.height;
			}
			else
			{
				this.y = m_destY;
			}
			
			m_curDestY = m_destY;
		}
		}
}