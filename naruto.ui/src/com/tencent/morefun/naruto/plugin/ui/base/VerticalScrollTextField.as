package com.tencent.morefun.naruto.plugin.ui.base
{
	
	import com.tencent.morefun.naruto.plugin.ui.EasyLayoutScrollBar_2_Skin;
	import com.tencent.morefun.naruto.plugin.ui.components.scrollers.ScrollBar;
	import com.tencent.morefun.naruto.plugin.ui.util.DisplayUtils;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * @author woodychen
	 * @createTime 2014-9-12 上午10:50:43
	 **/
	public class VerticalScrollTextField extends Sprite
	{
		private var _width:uint;
		private var _height:uint;
		private var _text:TextField;
		private var _scrollBarOffsetX:int;
		private var _scrollBar:com.tencent.morefun.naruto.plugin.ui.components.scrollers.ScrollBar;
		
		public function VerticalScrollTextField(width:uint, height:uint, scrollBarUI:MovieClip = null, scrollBarOffsetX:int = 0)
		{
			super();
			
			this._width = width;
			this._height = height;
			this._scrollBarOffsetX = scrollBarOffsetX;
			
			initUI(scrollBarUI);
			
		}
		
		private function initUI(scrollBarUI:MovieClip = null):void
		{
			var textFormat:TextFormat;
			
			_text = new TextField();
			_text.width = _width - _scrollBarOffsetX;
			_text.height = _height;
			_text.wordWrap = true;
			_text.multiline = true;
			_text.filters = [DisplayUtils.textGlowFilter];
			textFormat = _text.defaultTextFormat;
			textFormat.font = "SimSun";
				
			_text.addEventListener(Event.CHANGE, onTextChanged);
			_text.addEventListener(Event.SCROLL, onTextChanged);
			addChild(_text);
			
			this._scrollBar = new com.tencent.morefun.naruto.plugin.ui.components.scrollers.ScrollBar((scrollBarUI)? scrollBarUI : new EasyLayoutScrollBar_2_Skin(), _height);
			this._scrollBar.bar.minHeight = 10;
			this._scrollBar.addEventListener(Event.CHANGE, onScrollBarValueChange);
			_scrollBar.view.x = _width - _scrollBar.width;
			this.addChild(_scrollBar.view);
			scrollerUpdate();
		}
		
		private function scrollerUpdate():void
		{
			var value:Number;
			
			_scrollBar.height = this._height;
			_scrollBar.pageCount = this._height;
			_scrollBar.lineCount = _text.textHeight;
			this._scrollBar.removeEventListener(Event.CHANGE, onScrollBarValueChange);
			value = Number(_text.scrollV) / _text.maxScrollV * 100;
			(_scrollBar.value != value) && (_scrollBar.value = value); 
			this._scrollBar.addEventListener(Event.CHANGE, onScrollBarValueChange);
		}
		
		protected function onTextChanged(event:Event):void
		{
			var value:int;
			value = (_text.textHeight <= this._height)? this._width - _scrollBarOffsetX: this._width - _scrollBar.width - _scrollBarOffsetX;
			(_text.width != value) && (_text.width = value);
			scrollerUpdate();
		}
		
		protected function onScrollBarValueChange(event:Event):void
		{
			var value:int = _scrollBar.value / 100 * _text.maxScrollV;
			
			_text.removeEventListener(Event.SCROLL, onTextChanged);
			(_text.scrollV != value) && (_text.scrollV = value); 
			_text.addEventListener(Event.SCROLL, onTextChanged);
		}
		
		override public function get width():Number
		{
			return _width;
		}
		
		override public function get height():Number
		{
			return _height;
		}

		override public function set width(value:Number):void
		{
			_width = value;
			_text.width = value - _scrollBarOffsetX;
			scrollerUpdate();
		}

		override public function set height(value:Number):void
		{
			_height = value;
			_text.height = value;
			scrollerUpdate();
		}

		public function get text():TextField
		{
			return _text;
		}

		public function destroy():void	
		{
			_text.removeEventListener(Event.CHANGE, onTextChanged);
			_text.removeEventListener(Event.SCROLL, onTextChanged);
			(_text.parent) && (_text.parent.removeChild(_text));
			_text = null;
			
			_scrollBar.removeEventListener(Event.CHANGE, onScrollBarValueChange);
			(_scrollBar.view.parent) && (_scrollBar.view.parent.removeChild(_scrollBar.view));
			_scrollBar = null;
		}
	}
}