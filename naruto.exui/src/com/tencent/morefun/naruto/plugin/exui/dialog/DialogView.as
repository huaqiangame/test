package com.tencent.morefun.naruto.plugin.exui.dialog
{
	import com.greensock.TweenLite;
	import com.tencent.morefun.naruto.plugin.exui.teammate.TeammateTalkUI;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	public class DialogView extends Sprite
	{
		private var _ui:TeammateTalkUI;
		
		public function DialogView()
		{
			super();
			
			_ui = new TeammateTalkUI();
			(_ui.context.textfield as TextField).wordWrap = false;
			(_ui.context.textfield as TextField).autoSize = TextFieldAutoSize.LEFT;
			_ui.gotoAndStop(1);
			addChild(_ui);
		}
		
		public function showDialog(text:String):void
		{
			var cutStr:String = text;
			
			if (cutStr.length > 10)
			{
				cutStr = text.substr(0, 9);
				cutStr += "..."
			}
			
			TweenLite.killDelayedCallsTo(_ui.gotoAndPlay);
			_ui.gotoAndStop(1);
			_ui.context.textfield.htmlText = "<b>" + cutStr + "</b>";
			_ui.gotoAndPlay("show");
			TweenLite.delayedCall(3, _ui.gotoAndPlay, ["hide"]);
		}
		
		public function destory():void
		{
			TweenLite.killDelayedCallsTo(_ui.gotoAndPlay);
			(_ui.parent) && (_ui.parent.removeChild(_ui));
			_ui.stop();
			_ui = null;
		}
		
		public function reset():void
		{
			if (_ui)
			{
				TweenLite.killDelayedCallsTo(_ui.gotoAndPlay);
				_ui.gotoAndStop(1);
			}
		}
	}
}