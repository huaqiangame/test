package naruto.component.controls
{
	import flash.display.DisplayObject;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import naruto.component.core.InvalidationType;
	import naruto.component.core.UIComponent;
	
	public class BaseTitleBar extends UIComponent
	{
		public var textField:TextField;
		
		protected var _label:String = "标题";
		
		public function BaseTitleBar()
		{
			super();
			
			textField.defaultTextFormat = new TextFormat("CXingKaiHK-Bold");
			textField.embedFonts = true;
		}
		
		[Inspectable(defaultValue="标题")]
		public function get label():String
		{
			return _label;
		}
		
		public function set label(value:String):void
		{
			_label = value;
			if (this.textField.text != _label)
			{
				this.textField.text = _label;
			}
			this.invalidate(InvalidationType.SIZE);
		}
		
		override protected function draw():void
		{
			if (this.isInvalid(InvalidationType.SIZE))
			{
				this.drawLayout();
			}
			super.draw();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			this.mouseChildren = false;
			this.mouseEnabled = false;
		}
		
		protected function drawLayout():void
		{
			// 背景皮肤
			var bg:DisplayObject;
			if (this["backgroundSkin"])
			{
				bg = this["backgroundSkin"];
				bg.width = this.width;
			}
			
			// 文本框
			var tfWidth:int = this.textField.textWidth + 4;
			var tfHeight:int = this.textField.textHeight + 4;
			this.textField.width = Math.min(tfWidth, this.width);
			this.textField.height = tfHeight;
			this.textField.x = Math.round((this.width-this.textField.width)/2);
			this.textField.y = bg ? (this["backgroundSkin"].height - tfHeight+5) : 0;
		}
		
		
		override public function dispose():void
		{
			// 事件
			
			// 置空
			this.textField = null;
			
			super.dispose();
		}
		
	}
}