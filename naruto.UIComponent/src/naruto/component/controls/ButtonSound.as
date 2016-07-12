package naruto.component.controls
{
	import flash.events.MouseEvent;
	import flash.utils.getDefinitionByName;
	
	import naruto.component.core.BaseButton;
	
	//import sound.commands.PlayUISoundCommand;
	//import sound.def.UISoundDef;

	public class ButtonSound
	{
		public static const NONE:String = "none";
		public static const CLICK:String = "click";
		public static const CLOSE:String = "close";
		public static const OVER:String = "over";
		
		public static const CLICK_ID:uint = 1;//UISoundDef.BUTTON_CLICK;
		public static const CLOSE_ID:uint = 2;//UISoundDef.CANCEL_OR_CLOSE_BUTTON_CLICK;
		public static const OVER_ID:uint = 3;//UISoundDef.BUTTON_ROLL_OVER;
		
		//private static var playClickSoundCommand:PlaySoundCommand = new PlayUISoundCommand(UISoundDef.BUTTON_CLICK);
		//private static var playOverSoundCommand:PlaySoundCommand = new PlayUISoundCommand(UISoundDef.BUTTON_ROLL_OVER);
		//private static var playCloseSoundCommand:PlaySoundCommand = new PlayUISoundCommand(UISoundDef.CANCEL_OR_CLOSE_BUTTON_CLICK);
		
		private static var playClickSoundCommand:Object;
		private static var playOverSoundCommand:Object;
		private static var playCloseSoundCommand:Object;
		{//init cmd
			(function():void{
				try
				{
					var cmdClass:Class = getDefinitionByName("sound.commands.PlayUISoundCommand") as Class;
					if (cmdClass != null)
					{
						playClickSoundCommand = new cmdClass(CLICK_ID);
						playOverSoundCommand = new cmdClass(OVER_ID);
						playCloseSoundCommand = new cmdClass(CLOSE_ID);
						cmdClass = null;
					}
				}catch (err:Error) { }
			}());
		}
		
		private var _clickSound:String;
		private var _overSound:String;
		
		public var button:BaseButton;
		
		public function ButtonSound(button:BaseButton)
		{
			this.button = button;
		}
		
		public function get overSound():String
		{
			return _overSound;
		}

		public function set overSound(value:String):void
		{
			_overSound = value;
			if(overSound == OVER)
			{
				button.addEventListener(MouseEvent.MOUSE_OVER,onOverButton);
			}else{
				button.removeEventListener(MouseEvent.MOUSE_OVER,onOverButton);
			}
		}
		
		protected function onOverButton(event:MouseEvent):void
		{
			if(overSound == OVER)
			{
				playOverSoundCommand.call();	
			}
		}

		public function get clickSound():String
		{
			return _clickSound;
		}

		public function set clickSound(value:String):void
		{
			_clickSound = value;
			if(clickSound==CLICK || clickSound==CLOSE)
			{
				button.addEventListener(MouseEvent.CLICK,onClickButton);
			}else
			{
				button.removeEventListener(MouseEvent.CLICK,onClickButton);
			}
		}

		protected function onClickButton(event:MouseEvent):void
		{
			if(clickSound == CLICK)
			{
				playClickSoundCommand&&playClickSoundCommand.call();
			}else if(clickSound == CLOSE)
			{
				playClickSoundCommand&&playCloseSoundCommand.call();
			}
		}
		
		public function dispose():void
		{
			button.removeEventListener(MouseEvent.MOUSE_OVER,onOverButton);
			button.removeEventListener(MouseEvent.CLICK,onClickButton);
			_clickSound = null;
			_overSound = null;
			button = null;
		}
	}
}