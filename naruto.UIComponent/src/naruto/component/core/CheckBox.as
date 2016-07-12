package naruto.component.core
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	[Event(name="change", type="flash.events.Event")]
	public class CheckBox extends UIComponent
	{
		public var textField:TextField;
		protected var _selected:Boolean = false;
		protected var _label:String = "CheckBox";
//		protected var _labelX:int = 28;
//		protected var _labelY:int = 2;
		
		public function CheckBox()
		{
			super();
			mouseChildren = false;
			textField.autoSize = TextFieldAutoSize.LEFT;
			gotoAndStop(1);
			addEventListener(MouseEvent.CLICK,onClick,false,0,true);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			selected = !selected;
		}
		
		[Inspectable(defaultValue=false, verbose=1)]
		public function get selected():Boolean
		{
			return _selected;
		}

		public function set selected(value:Boolean):void
		{
			if(_selected != value)
			{
				_selected = value;
				gotoAndStop(_selected?2:1);
				
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		
		
		[Inspectable(defaultValue="CheckBox")]
		public function get label():String
		{
			return _label;
		}
		
		public function set label(value:String):void
		{
			_label = value;
			if (this.textField.htmlText != _label)
			{
				this.textField.htmlText = _label;
			}
//			this.invalidate(InvalidationType.SIZE);
		}

		[Inspectable(defaultValue="28",category="Size")]
		public function get labelX():int
		{
			return textField.x;
		}

		public function set labelX(value:int):void
		{
			if(textField.x != value)
			{
				textField.x = value;
			}
			
//			if(_labelX != value)
//			{
//				_labelX = value;
//				invalidate(InvalidationType.SIZE);
//			}
		}

		[Inspectable(defaultValue=3)]
		public function get labelY():int
		{
			return textField.y;
		}

		public function set labelY(value:int):void
		{
			if(textField.y != value)
			{
				textField.y = value;
			}
		}
		
//		override protected function draw():void
//		{
//			if(isInvalid(InvalidationType.SIZE))
//			{
//				textField.x = _labelX;
//			}
//			super.draw();
//		}
		
		override public function dispose():void
		{
			this.removeEventListener(MouseEvent.CLICK,onClick,false);
			this.textField = null;
			super.dispose();
		}

	}
}