package com.tencent.morefun.naruto.plugin.prewar.component
{
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	/**
	 * 文本消息广播
	 * @author larryhou
	 * @createTime 2013/10/1 17:19
	 */
	public class NoticeSpeeker extends Sprite
	{
		private var _messages:Vector.<String>;
		private var _format:TextFormat;
		
		private var _interval:uint;
		private var _duration:uint;
		
		private var _gap:uint;
		private var _enabled:Boolean;
		
		private var _items:Vector.<TextField>;
		private var _timer:uint;
		
		private var _width:uint;
		
		/**
		 * 构造函数
		 * create a [NoticeSpeeker] object
		 */
		public function NoticeSpeeker(format:TextFormat = null, width:uint = 400)
		{
			_width = width;
			_format = format || new TextFormat();
			_messages = new Vector.<String>();
			
			_interval = 2000;
			_duration = 200;
			_gap = 5;
			
			_items = new Vector.<TextField>();
			
			var item:TextField;
			while (_items.length < 2)
			{
				item = new TextField();
				item.defaultTextFormat = _format;
				item.autoSize = TextFieldAutoSize.LEFT;
				item.cacheAsBitmap = true;
				item.text = ".";
				_items.push(item);
			}
			
			mouseChildren = false;
			scrollRect = new Rectangle(0, 0, _width, item.height);
			
			addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		/**
		 * 鼠标点击强制滚动
		 */
		private function clickHandler(e:MouseEvent):void 
		{
			scroll();
		}
		
		/**
		 * 滚屏显示
		 */
		private function scroll():void
		{
			clearTimeout(_timer);
			
			var current:TextField = _items[0];
			var next:TextField = _items[1];
			
			!next.parent && addChild(next);
			next.x = current.x + Math.max(_width, current.width) + _gap;
			
			next.text = _messages[0];
			
			_items.push(_items.shift());
			_messages.push(_messages.shift());
			
			TweenLite.killTweensOf(current);
			TweenLite.to(next, _duration / 1000, { x:0, onUpdate:function():void
			{
				current.x = next.x - Math.max(current.width, _width) - _gap;
			}} );
			
			_timer = setTimeout(scroll, _interval);
		}
		
		/**
		 * 渲染
		 */
		private function render():void
		{
			var item:TextField = _items[0];
			item.text = _messages[0];
			item.x = 0;
			addChild(item);
			TweenLite.killTweensOf(item);
			
			item = _items[1];
			item.parent && item.parent.removeChild(item);
			
			clearTimeout(_timer);
			if (_enabled)
			{
				_timer = setTimeout(scroll, _interval);
			}
		}
		
		/**
		 * 消息列表
		 */
		public function get messages():Vector.<String> { return _messages; }		
		public function set messages(value:Vector.<String>):void
		{
			_messages = value; 
			_messages && render();
		}
		
		/**
		 * 消息切换间隔：毫秒
		 * @default 2000
		 */
		public function get interval():uint { return _interval; }	
		public function set interval(value:uint):void
		{
			_interval = value;
		}
		
		/**
		 * 消息切换耗时：毫秒
		 * @default 200
		 */
		public function get duration():uint { return _duration; }
		public function set duration(value:uint):void
		{
			_duration = value;
		}
		
		/**
		 * 相邻两条消息的水平间隔
		 * @default 5
		 */
		public function get gap():uint { return _gap; }
		public function set gap(value:uint):void
		{
			_gap = value;
		}
		
		/**
		 * 是否激活切换逻辑
		 */
		public function get enabled():Boolean { return _enabled; }
		public function set enabled(value:Boolean):void
		{
			_enabled = value;
			
			clearTimeout(_timer);
			if (_enabled && _messages && _messages.length)
			{
				_timer = setTimeout(scroll, _interval);
			}
		}
	}

}