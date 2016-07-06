package naruto.component.controls
{
	import flash.display.MovieClip;
	
	import naruto.component.core.LabelButton;
	
	public class ButtonLittle extends LabelButton
	{
		public var upSkin:MovieClip;
		public var overSkin:MovieClip;
		public var downSkin:MovieClip;
		public var disabledSkin:MovieClip;
		
		private var buttonSound:ButtonSound;
		
		public function ButtonLittle()
		{
			super();
			
			this.buttonSound = new ButtonSound(this);
		}
		
		[Inspectable(enumeration="none,click,close", defaultValue="none", name="clickSound")]
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
		
		override protected function drawLayout():void
		{
			super.drawLayout();
			this.textField.y = Math.round((this.height-this.textField.height)/2);
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