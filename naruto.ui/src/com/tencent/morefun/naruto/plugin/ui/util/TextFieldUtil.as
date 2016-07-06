package com.tencent.morefun.naruto.plugin.ui.util
{
	import flash.display.DisplayObjectContainer;
	import flash.events.TextEvent;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class TextFieldUtil
	{
		public static function textFieldToBold(textField:TextField):void
		{
			var textFormat:TextFormat;
			
			textFormat = textField.defaultTextFormat;
			textFormat.bold = true;
			textField.defaultTextFormat = textFormat;
		}
		
		public static function replaceTextField(source:TextField, autoSize:String = TextFieldAutoSize.CENTER, bold:Boolean = false):void
		{
			var textFormat:TextFormat;
			var textField:TextField;
			var parent:DisplayObjectContainer;
			
			textField = new TextField();
			textField.defaultTextFormat = source.defaultTextFormat;
			textField.name = source.name;
			textField.x = source.x;
			textField.y = source.y;
			textField.autoSize = autoSize;
			textField.defaultTextFormat.align = source.defaultTextFormat.align;
			textField.filters = source.filters;
			textField.mouseEnabled = source.mouseEnabled;
			textField.selectable = source.selectable;
			textField.multiline = source.multiline;
			textFormat = source.defaultTextFormat;
			textFormat.bold = bold;
			textField.defaultTextFormat = textFormat;
			parent = source.parent;
			parent.removeChild(source);
			parent.addChild(textField);
			parent[textField.name] = textField;
		}
		public static function toHtmlText(text:String, color:Object = null, bold:Boolean = false):String {
			var str:String = '';
			if (color !== null) {
				str = "<font color='#" + color.toString(16) + "'>";
			}else {
				str = "<font>";
			}
			if(!bold){
				return str + text + "</font>";
			}
			return "<b/>" + str + text + "</font></b>";
		}
		/**
		 * 例子： appendHtmlText(["some contents", 0xff0000, isBold], ["other contents", 0x00ff00, isBold]);
		 * @see toHtmlText
		 * */
		public static function appendHtmlText(...args):String {
			var str:String = '';
			for (var i:int = 0; i < args.length; i++) 
			{
				str += toHtmlText.apply(null,args[i]);
			}
			return str;
		}
		static public function toLinkHtmlText(text:String,eText:String,callback:Function,bt:TextField):String 
		{
			var style:StyleSheet = new StyleSheet();
			style.setStyle("a:link", { color: '#CCCCCC'});
			style.setStyle("a:hover", { color:'#ffffff', textDecoration: 'underline' } );
			bt.styleSheet = style;
			bt.addEventListener(TextEvent.LINK, function onLink(e:TextEvent):void 
			{
				if (e.text == eText) {
					callback();
				}
			}
			,false, 0, true);
			
			return "<a href='event:"+ eText +"'>" + text + "</a>";
			
		}
		}
}