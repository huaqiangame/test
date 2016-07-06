package naruto.component.core
{
	import flash.text.TextField;
	
	
	public class LabelButton extends BaseButton
	{
		public var textField:TextField;
		
		protected var _label:String = "确定";
		
		public function LabelButton()
		{
			super();
		}
		
		[Inspectable(defaultValue="确定")]
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
			this.invalidate(InvalidationType.SIZE);
		}
		
		override protected function configUI():void
		{
			this.textField.mouseEnabled = false;
			super.configUI();
		}
		
		override protected function drawLayout():void
		{
			super.drawLayout();
			
			// 文本框
			var tfWidth:int = this.textField.textWidth + 4;
			var tfHeight:int = this.textField.textHeight + 4;
			this.textField.width = Math.min(tfWidth, this.width);
			this.textField.height = Math.min(tfHeight, this.height);
			this.textField.x = Math.round((this.width-this.textField.width)/2);
//			this.textField.y = Math.round((this.height-this.textField.height)/2);
		}
		
		override public function dispose():void
		{
			this.textField = null;
			super.dispose();
		}
		
	}
	
}
