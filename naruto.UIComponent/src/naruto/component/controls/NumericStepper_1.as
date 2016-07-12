package naruto.component.controls
{
	import flash.text.TextField;
	
	import naruto.component.core.BaseNumericStepper;
	import naruto.component.core.Button;
	
	public class NumericStepper_1 extends BaseNumericStepper
	{
		public var upBtn:Button;
		public var downBtn:Button;
		public var textField:TextField;
		
		public function NumericStepper_1()
		{
			super();
		}
		
		override protected function configUI():void
		{
			this._upBtn = this.upBtn;
			this._downBtn = this.downBtn;
			this._textField = this.textField;
			super.configUI();
		}
		
		override public function dispose():void
		{
			// 事件
			
			// 置空
			this.upBtn.dispose();
			this.upBtn = null;
			this.downBtn.dispose();
			this.downBtn = null;
			this.textField = null;
			
			super.dispose();
		}
		
	}
}