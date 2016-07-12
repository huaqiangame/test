package naruto.component.controls
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	import naruto.component.core.InvalidationType;
	import naruto.component.core.UIComponent;
	
	public class Info_1 extends UIComponent
	{
		public var nameText:TextField;
		public var valueText:TextField;
		public var bg_skin:MovieClip;
		
		protected var _label:String = "标题";
		protected var _value:String = "100%";
		
		
		public function Info_1()
		{
			super();
		}
		
		[Inspectable(defaultValue="标题")]
		public function get label():String
		{
			return _label;
		}
		
		[Inspectable(defaultValue="100%")]
		public function get value():String
		{
			return _value;
		}
		
		
		public function set label(value:String):void
		{
			_label = value;
			if (this.nameText.text != _label)
			{
				this.nameText.htmlText ="<b>"+ _label+"</b>";
			}
			this.invalidate(InvalidationType.SIZE);
		}
		
		public function set value(value:String):void
		{
			_value = value;
			if (this.valueText.text != _value)
			{
				this.valueText.htmlText = "<b>"+_value+"</b>";
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
			if (this["bg_skin"])
			{
				this["bg_skin"].width = this.width;
			}
			
			// 调整文本框
			var tfWidth:int = this.nameText.textWidth + 4;
			var tfHeight:int = this.nameText.textHeight + 4;
			this.nameText.width = Math.min(tfWidth, this.width);
			this.nameText.height = Math.min(tfHeight, this.height);
			this.nameText.x = 10;
			this.nameText.y = Math.round((this.height-this.nameText.height)/2);
			
			tfWidth = this.valueText.textWidth + 4;
			tfHeight = this.valueText.textHeight + 4;
			this.valueText.width = Math.min(tfWidth, this.width);
			this.valueText.height = Math.min(tfHeight, this.height);
			this.valueText.x = this.width - this.valueText.width-10;
			this.valueText.y = Math.round((this.height-this.nameText.height)/2);
		}
		
		override public function dispose():void
		{
			// 事件
			
			// 置空
			this.nameText = null;
			this.valueText = null;
			this.bg_skin = null;
			
			super.dispose();
		}
		
	}
}