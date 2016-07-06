package naruto.component.controls
{
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import naruto.component.core.InvalidationType;
	import naruto.component.core.UIComponent;
	
	public class TitleBar_2 extends UIComponent
	{
		public var textField:TextField;
		public var background:MovieClip;
		public var backgroundTexture:MovieClip;
		
		protected var _label:String = "标题";
		
		public function TitleBar_2()
		{
			super();
		}
		
		[Inspectable(defaultValue="标题")]
		public function get label():String
		{
			return _label;
		}
		
		public function set label(value:String):void
		{
			_label = value;
			if (this.textField.htmlText != _label)
			{
				this.textField.htmlText = "<b>"+_label+"</b>";
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
		
		protected function drawLayout():void
		{
			this.background.width = this.width;
			this.backgroundTexture.x = int((this.width-this.backgroundTexture.width)/2);
			if (this.backgroundTexture.width > this.width)
			{
				this.backgroundTexture.scrollRect = new Rectangle(0, 0, this.width, this.backgroundTexture.height);
			}
			else
			{
				this.backgroundTexture.scrollRect = null;
			}
			
			// 调整文本框
			var tfWidth:int = this.textField.textWidth + 4;
			var tfHeight:int = this.textField.textHeight + 4;
			this.textField.width = Math.min(tfWidth, this.width);
			this.textField.height = Math.min(tfHeight, this.height);
			this.textField.x = Math.round((this.width-this.textField.width)/2);
		}
		
		override public function dispose():void
		{
			// 事件
			
			// 置空
			this.textField = null;
			this.background = null;
			this.backgroundTexture = null;
			
			super.dispose();
		}
		
	}
}