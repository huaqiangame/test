package naruto.component.controls
{
	import flash.display.MovieClip;
	
	import naruto.component.core.BaseButton;
	
	public class ButtonClose extends BaseButton
	{
		public var upSkin:MovieClip;
		public var overSkin:MovieClip;
		public var downSkin:MovieClip;
		public var disabledSkin:MovieClip;
		
		private var buttonSound:ButtonSound;
		
		public function ButtonClose()
		{
			super();
			
			buttonSound = new ButtonSound(this);
			buttonSound.clickSound = ButtonSound.CLOSE;
		}
		
		[Inspectable(enumeration="none,click,close", defaultValue="close", name="clickSound")]
		public function get clickSound():String
		{
			return this.buttonSound.clickSound;
		}

		public function set clickSound(value:String):void
		{
			this.buttonSound.clickSound = value;
		}
		
		override public function dispose():void
		{
			// 事件
			
			// 置空
			this.upSkin = null;
			this.overSkin = null;
			this.downSkin = null;
			this.disabledSkin = null;
			
			buttonSound.dispose();
			buttonSound = null;
			super.dispose();
		}
		
	}
}