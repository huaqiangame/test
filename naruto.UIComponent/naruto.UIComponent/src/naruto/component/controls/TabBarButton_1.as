package naruto.component.controls
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	import naruto.component.core.ToggleButton;
	import flash.text.TextFormat;
	
	public class TabBarButton_1 extends ToggleButton
	{
		public var upSkin:MovieClip;
		public var overSkin:MovieClip;
		public var downSkin:MovieClip;
		public var disabledSkin:MovieClip;
		public var upSelectedSkin:MovieClip;
		public var overSelectedSkin:MovieClip;
		public var downSelectedSkin:MovieClip;
		public var disabledSelectedSkin:MovieClip;
		public var selectedTxt:TextField;
		
		private static const NORMAL_FORMAT:TextFormat = new TextFormat("SimSun",12,0x92cdea,true);
		private static const NORMAL_DISABLED_FORMAT:TextFormat = new TextFormat("SimSun",12,0xcccccc,true);
		//private static const SELECTED_FORMAT:TextFormat = new TextFormat("SimSun",14,0xffffff,true);
		//private static const SELECTED_DISABLED_FORMAT:TextFormat = new TextFormat("SimSun", 14, 0xcccccc, true);
		
		private var buttonSound:ButtonSound;
		
		public function TabBarButton_1()
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
		
		
		override public function set label(value:String):void
		{
			value = "<b>" + value + "</b>";
			super.label = value;
			if (selectedTxt.htmlText != _label)
			{
				selectedTxt.htmlText = _label;
			}
		}
		
		override protected function drawSkin():void
		{
			var state:String = _state;
			
			if(selected)
			{
				state = state + "Selected";
				selectedTxt.visible = true;
				textField.visible = false;
			}else
			{
				selectedTxt.visible = false;
				textField.visible = true;
			}
			
			if (enabled)
			{
				//selectedTxt.setTextFormat(SELECTED_FORMAT);
				textField.setTextFormat(NORMAL_FORMAT);
			}else
			{
				//selectedTxt.setTextFormat(SELECTED_DISABLED_FORMAT);
				textField.setTextFormat(NORMAL_DISABLED_FORMAT);
			}
			
			this.gotoAndStop(state);
			var skinName:String = state + "Skin";
			if (this[skinName])
			{
				this.currentSkin = this[skinName];
			}
		}
		
		override public function dispose():void
		{
			// 事件
			
			// 置空
			this.upSkin = null;
			this.overSkin = null;
			this.downSkin = null;
			this.disabledSkin = null;
			this.upSelectedSkin = null;
			this.overSelectedSkin = null;
			this.downSelectedSkin = null;
			this.disabledSelectedSkin = null;
			
			this.buttonSound.dispose();
			this.buttonSound = null;
			
			super.dispose();
		}
		
	}
}