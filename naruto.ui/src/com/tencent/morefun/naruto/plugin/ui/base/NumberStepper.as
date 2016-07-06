package com.tencent.morefun.naruto.plugin.ui.base
{
	import com.tencent.morefun.naruto.plugin.ui.base.event.NumberStepperEvent;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;

	public class NumberStepper extends Sprite
	{
		protected var m_up:BaseButton;
		protected var m_down:BaseButton;
		protected var m_txt:TextField;
		protected var m_bg:Sprite;
		
		protected var m_min:Number = 0;
		protected var m_max:Number = 100;
		protected var m_value:Number = 0;
		
		protected var m_curValue:Number;
		
		protected var m_step:Number = 1;
		protected var m_fixed:int = 0;
		
		/**
		 *设置基本信息 使用者需在资源中指定 文本是否支持用户输出，输出限制会在类中自动实现
		 * @param up 上按钮
		 * @param down 下按钮
		 * @param txt 数量显示按钮
		 * 
		 */		
		public function NumberStepper(skin:MovieClip, up:BaseButton = null, down:BaseButton = null, txt:TextField = null)
		{
			super();
			
			m_up = up || new BaseButton(skin["up"]);
			m_down = down || new BaseButton(skin["down"]);
			m_txt = txt || skin["txt"];
			m_bg = skin.bg != null ? skin.bg : new Sprite(); 
			
			m_up.repeart = true;
			m_down.repeart = true;
			
			m_up.addEventListener(MouseEvent.CLICK, onUpButtonMouseClick);
			m_down.addEventListener(MouseEvent.CLICK, onDownMouseButtonClick);
			
			addChild(m_bg);
			addChild(m_up);
			addChild(m_down);
			
			if(m_txt)
			{
				m_txt.restrict = "\\- 0-9 \\.";
				m_txt.addEventListener(TextEvent.TEXT_INPUT, onTextInput);
				m_txt.addEventListener(Event.CHANGE, onTextChanged);
				m_txt.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
				addChild(m_txt);
			}
		}
		
		/**
		 *销毁函数 用完记得调用 
		 * 
		 */		
		public function destroy():void
		{
			m_up.destroy();
			m_down.destroy();
			
			m_up.removeEventListener(MouseEvent.CLICK, onUpButtonMouseClick);
			m_down.removeEventListener(MouseEvent.CLICK, onDownMouseButtonClick);
			if(m_txt)
			{
				m_txt.removeEventListener(TextEvent.TEXT_INPUT, onTextInput);
				m_txt.removeEventListener(Event.CHANGE, onTextChanged);
				m_txt.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
				removeChild(m_txt);
			}
			
			removeChild(m_up);
			removeChild(m_down);
			
		}
		
		/**
		 *上按钮点击事件 
		 * @param evt
		 * 
		 */		
		protected function onUpButtonMouseClick(evt:MouseEvent):void
		{
			value -= m_step;
		}
		
		/**
		 *下按钮点击事件 
		 * @param evt
		 * 
		 */		
		protected function onDownMouseButtonClick(evt:MouseEvent):void
		{
			value += m_step;
		}
		
		/**
		 *文本输入时行进内容校验 
		 * @param evt
		 * 
		 */		
		protected function onTextInput(evt:TextEvent):void
		{
			this.stage.addEventListener(MouseEvent.MOUSE_DOWN, onStageMouseDown);
		}
		
		protected function onStageMouseDown(evt:MouseEvent):void
		{
			this.stage.removeEventListener(MouseEvent.MOUSE_DOWN, onStageMouseDown);
			submitValue();
		}
		
		protected function onKeyUp(evt:KeyboardEvent):void
		{
			if(evt.keyCode == Keyboard.ENTER)
			{
				submitValue();
				stage.focus = null;
			}
		}
		
		/**
		 *文本内容改变时进行内容校验 
		 * @param evt
		 * 
		 */		
		protected function onTextChanged(evt:Event):void
		{
			var negativeFlag:Boolean;
			var negativeReg:RegExp;
			var dotIndex:int;
			var dotReg:RegExp;
			var wordWrapReg:RegExp;
			var textLen:int;
			var caretIndex:int;
			var changedTextLen:int;
			
			
			if(m_txt.text == "")
			{
				return ;
			}
			
			textLen = m_txt.text.length;
			caretIndex = m_txt.caretIndex;
			negativeReg = new RegExp("-", "g"); 
			negativeFlag = m_txt.text.charAt(0) == "-";
			m_txt.text = m_txt.text.replace(negativeReg, "");
			if(negativeFlag)
			{
				m_txt.text = "-" + m_txt.text;
			}
			changedTextLen = textLen - m_txt.text.length;
			m_txt.setSelection(caretIndex + changedTextLen, caretIndex + changedTextLen);
			
			textLen = m_txt.text.length;
			caretIndex = m_txt.caretIndex;
			dotReg = new RegExp("\\.", "g");
			dotIndex = m_txt.text.indexOf(".");
			m_txt.text = m_txt.text.replace(dotReg, "");
			if(dotIndex != -1)
			{
				m_txt.text = m_txt.text.substring(0, dotIndex) + "." + m_txt.text.substring(dotIndex, m_txt.text.length);
			}
			changedTextLen = textLen - m_txt.text.length;
			m_txt.setSelection(caretIndex + changedTextLen, caretIndex + changedTextLen);
			
			wordWrapReg = new RegExp("\r", "g");
			m_txt.text = m_txt.text.replace(wordWrapReg, "");
		}
		
		protected function submitValue():void
		{
			if(m_txt.text != "-")
			{
				value = Number(m_txt.text);
			}
			else
			{
				value = int.MAX_VALUE;
				value = 0;
			}
			
			this.stage.removeEventListener(MouseEvent.MOUSE_DOWN, onStageMouseDown);
		}
		
		/**
		 *设置最小值 
		 * @param value
		 * 
		 */		
		public function set min(value:Number):void
		{
			if(m_min == value)
			{
				return ;
			} 
			
			m_min = value;
			waitUpdate();
		}
		
		public function get min():Number
		{
			return m_min;
		}
		
		/**
		 *设置最大值 
		 * @param value
		 * 
		 */		
		public function set max(value:Number):void
		{
			if(m_max == value)
			{
				return ;
			}
			
			m_max = value;
			waitUpdate();
		}
		
		public function get max():Number
		{
			return m_max;	
		}
		
		/**
		 *设置当前值 
		 * @param value
		 * 
		 */		
		public function set value(value:Number):void
		{
			var fixedValue:Number;
			
			fixedValue = fixValue(value);
			if(m_value == fixedValue)
			{
				return ;
			}
			
			m_value = fixedValue;
			waitUpdate();
		}
		
		/**
		 *设置显示小数点后的位数 
		 * @param value
		 * 
		 */		
		public function set fixed(value:int):void
		{
			m_fixed = value;
			waitUpdate();
		}
		
		public function get fixed():int
		{
			return m_fixed;
		}
		
		/**
		 *限制数值在合法区域内 
		 * @param value
		 * @return 
		 * 
		 */		
		protected function fixValue(value:Number):Number
		{	
			if(value > m_max)
			{
				return m_max;
			}
			if(value < m_min)
			{
				return m_min;
			}
			
			return value;
		}
		
		public function get value():Number
		{
			return m_value;
		}
		
		/**
		 *设置 每次增加或减少的值
		 * @param value
		 * 
		 */		
		public function set step(value:Number):void
		{
			if(m_step == value)
			{
				return ;
			}
			
			m_step = value;
		}
		
		public function get step():Number
		{
			return m_step;
		}
		
		/**
		 *下一帧的时候更新 
		 * 
		 */		
		public function waitUpdate():void
		{
			this.addEventListener(Event.ENTER_FRAME, update);
		}
		
		/**
		 *立即更新 
		 * 
		 */		
		public function updateNow():void
		{
			update(new Event(Event.ENTER_FRAME));
		}
		
		/**
		 *更新显示内容 
		 * @param evt
		 * 
		 */		
		protected function update(evt:Event):void
		{
			var event:NumberStepperEvent;
			
			this.removeEventListener(Event.ENTER_FRAME, update);
			
			changeTxt();
			
			m_up.disable = value == min;
			m_down.disable = value == max;
			
			if(m_value != m_curValue)
			{
				event = new NumberStepperEvent(NumberStepperEvent.NUMBER_STEPPER_VALUE_CHANGED);
				event.oldValue = m_curValue;
				event.newValue = m_value;
				
				m_curValue = m_value;
				
				this.dispatchEvent(event);
			}
		}
		
		/**
		 *当value为0时toFixed函数参数为0时返回得也不会是"0",所以这里自己手动一下。
		 * 
		 */		
		protected function changeTxt():void
		{
			if(!m_txt)
			{
				return ;
			}
			
			if(m_fixed == 0 && m_value == 0)
			{
				m_txt.text = "0";
			}
			else
			{
				m_txt.text = m_value.toFixed(m_fixed);
			}
		}
		
		}
}