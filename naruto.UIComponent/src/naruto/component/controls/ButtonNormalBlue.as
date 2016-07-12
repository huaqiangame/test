package naruto.component.controls
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import naruto.component.core.LabelButton;
	
	public class ButtonNormalBlue extends LabelButton
	{
		private static const MOUSE_UP_TEXT_COLOR:String = "#FFFFFF";
		private static const MOUSE_DOWN_TEXT_COLOR:String = "#7B7B7B";
		
		public var upSkin:MovieClip;
		public var overSkin:MovieClip;
		public var downSkin:MovieClip;
		public var disabledSkin:MovieClip;
		
		private var buttonSound:ButtonSound;
		
		public function ButtonNormalBlue()
		{
			super();
			this.buttonSound = new ButtonSound(this);
			this.buttonSound.clickSound = ButtonSound.CLICK;
		}
		
		[Inspectable(enumeration="none,click,close", defaultValue="click", name="clickSound")]
		public function get clickSound():String
		{
			return this.buttonSound.clickSound;
		}

		public function set clickSound(value:String):void
		{
			this.buttonSound.clickSound = value;
		}
		
		[Inspectable(enumeration="none,over", defaultValue="none", name="overSound")]
		public function get overSound():String
		{
			return buttonSound.overSound;
		}
		
		public function set overSound(value:String):void
		{
			buttonSound.overSound = value;
		}

		override protected function mouseDownHandler(event:MouseEvent):void
		{
			super.mouseDownHandler(event);
			var htmlText:String = this.textField.htmlText;
			this.textField.htmlText = htmlText.replace(/COLOR="#.*"/g, "COLOR=\""+MOUSE_DOWN_TEXT_COLOR+"\"");
		}
		
		override protected function mouseUpHandler(event:MouseEvent):void
		{
			super.mouseUpHandler(event);
			var htmlText:String = this.textField.htmlText;
			this.textField.htmlText = htmlText.replace(/COLOR="#.*"/g, "COLOR=\""+MOUSE_UP_TEXT_COLOR+"\"");
		}
		
		override protected function mouseOutHandler(event:MouseEvent=null):void
		{
			super.mouseOutHandler(event);
			var htmlText:String = this.textField.htmlText;
			this.textField.htmlText = htmlText.replace(/COLOR="#.*"/g, "COLOR=\""+MOUSE_UP_TEXT_COLOR+"\"");
		}
		
		override public function set label(value:String):void
		{
			super.label = "<font size='14' COLOR=\"#FFFFFF\"><b>"+value+"</b></font>";
		}
		
		override public function dispose():void
		{
			// 事件
			
			// 置空
			this.upSkin = null;
			this.overSkin = null;
			this.downSkin = null;
			this.disabledSkin = null;
			
			this.buttonSound.dispose();
			this.buttonSound = null;
			super.dispose();
		}
		
	}
}