package naruto.component.core
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.utils.clearInterval;
	import flash.utils.clearTimeout;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	/**
	 * 数字选择器。
	 * @author yboyjiang
	 */	
	[Event(name="change", type = "flash.events.Event")]
	public class BaseNumericStepper extends UIComponent
	{
		protected var _upBtn:Button;
		protected var _downBtn:Button;
		protected var _textField:TextField;
		protected var _editable:Boolean;
		protected var _min:int;
		protected var _max:int;
		protected var _value:int = int.MIN_VALUE;
		
		private var mouseDownTimeOut:uint;
		private var intervalID:uint;
		
		public function BaseNumericStepper()
		{
			super();
		}
		
		public function get editable():Boolean
		{
			return _editable;
		}
		
		public function set editable(value:Boolean):void
		{
			if (_editable != value)
			{
				_editable = value;
				if (value)
				{
					this._textField.type = TextFieldType.INPUT;
					this._textField.restrict = "0-9";
					this._textField.addEventListener(Event.CHANGE, this.onTextInput);
					this._textField.addEventListener(FocusEvent.FOCUS_OUT, this.onTextFocusOut);
				}
				else
				{
					this._textField.type = TextFieldType.DYNAMIC;
					this._textField.removeEventListener(Event.CHANGE, this.onTextInput);
					this._textField.removeEventListener(FocusEvent.FOCUS_OUT, this.onTextFocusOut);
				}
			}
		}
		
		private function onTextFocusOut(e:FocusEvent):void 
		{
			var num:int = int(this._textField.text);
			this.value = Math.min(max, Math.max(min, num));
		}
		
		protected function onTextInput(event:Event):void
		{
			if (!this._textField.text)
			{
				return;
			}
			
			var num:int = int(this._textField.text);
			this.value = Math.min(max, Math.max(min, num));
		}
		
		public function get min():int
		{
			return _min;
		}
		
		public function set min(value:int):void
		{
			_min = value;
			this.value = _value;
		}
		
		public function get max():int
		{
			return _max;
		}
		
		public function set max(value:int):void
		{
			_max = value;
			this.value = _value;
		}
		
		public function get value():int
		{
			return _value;
		}
		
		public function set value(value:int):void
		{
			if (value > _max)
			{
				value = _max;
			}
			else if (value < _min)
			{
				value = _min;
			}
			
			this._upBtn.enabled = value < _max;
			this._downBtn.enabled = value > _min;
			this.invalidate(InvalidationType.STATE);
			if (_value != value)
			{
				_value = value;
				this.dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		override protected function configUI():void
		{
			super.configUI();
			this._upBtn.addEventListener(MouseEvent.MOUSE_DOWN, this.onUpButtonDown);
			this._downBtn.addEventListener(MouseEvent.MOUSE_DOWN, this.onDownButtonDown);
			_min = 0;
			_max = 3;
			this.value = 1;
		}
		
		protected function onUpButtonDown(event:MouseEvent):void
		{
			this.addValue(1);
			this.mouseDownTimeOut = setTimeout(this.readyToAutoAddValue, 800, 1);
			this._upBtn.addEventListener(MouseEvent.MOUSE_UP, this.clearAllTicker);
			this._upBtn.addEventListener(MouseEvent.MOUSE_OUT, this.clearAllTicker);
		}
		
		
		protected function onDownButtonDown(event:MouseEvent):void
		{
			this.addValue(-1);
			this.mouseDownTimeOut = setTimeout(this.readyToAutoAddValue, 800, -1);
			this._downBtn.addEventListener(MouseEvent.MOUSE_UP, this.clearAllTicker);
			this._downBtn.addEventListener(MouseEvent.MOUSE_OUT, this.clearAllTicker);
		}
		
		private function readyToAutoAddValue(num:int):void
		{
			this.intervalID = setInterval(this.addValue, 80, num);
		}
		
		private function addValue(num:int):void
			
		{
			this.value = _value + num;
		}
		
		private function clearAllTicker(event:MouseEvent=null):void
		{
			this._upBtn.removeEventListener(MouseEvent.MOUSE_UP, this.clearAllTicker);
			this._upBtn.removeEventListener(MouseEvent.MOUSE_OUT, this.clearAllTicker);
			this._downBtn.removeEventListener(MouseEvent.MOUSE_UP, this.clearAllTicker);
			this._downBtn.removeEventListener(MouseEvent.MOUSE_OUT, this.clearAllTicker);
			clearInterval(this.intervalID);
			clearTimeout(this.mouseDownTimeOut);
		}
		
		override protected function draw():void
		{
			if (this.isInvalid(InvalidationType.STATE))
			{
				this._textField.text = _value+"";
			}
			
			if (this.isInvalid(InvalidationType.SIZE))
			{
				// TODO
			}
			
			super.draw();
		}
		
		override public function dispose():void
		{
			// 事件
			this._textField.removeEventListener(Event.CHANGE, this.onTextInput);
			this._textField.removeEventListener(FocusEvent.FOCUS_OUT, this.onTextFocusOut);
			this._upBtn.removeEventListener(MouseEvent.MOUSE_DOWN, this.onUpButtonDown);
			this._downBtn.removeEventListener(MouseEvent.MOUSE_DOWN, this.onDownButtonDown);
			this.clearAllTicker();
			
			// 置空
			this._upBtn.dispose();
			this._downBtn.dispose();
			this._textField = null;
			
			super.dispose();
		}
		
	}
}