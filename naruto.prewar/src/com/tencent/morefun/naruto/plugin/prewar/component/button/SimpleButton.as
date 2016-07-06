package com.tencent.morefun.naruto.plugin.prewar.component.button
{
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.display.Scene;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	/**
	 * 影片剪辑封装成按钮
	 * @author larryhou
	 * @createTime 2013/9/26 19:07
	 */
	public class SimpleButton extends Sprite
	{
		protected static const STATE_OUT:String = "out";
		protected static const STATE_OVER:String = "over";
		protected static const STATE_DOWN:String = "down";
		protected static const STATE_SELECT:String = "select";
		protected static const STATE_DISABLE:String = "disable";
		
		protected var _view:MovieClip;
		protected var _enabled:Boolean;
		
		protected var _pressing:Boolean;
		protected var _dict:Dictionary;
		
		protected var _selected:Boolean;
		
		/**
		 * 构造函数
		 * create a [SimpleButton] object
		 */
		public function SimpleButton(view:MovieClip) 
		{
			_view = view;
			if (!_view)
			{
				throw new ArgumentError("[fatalError]button view cannot be null.");
			}
			
			if (_view.parent)
			{
				this.x = _view.x;
				this.y = _view.y;
				
				_view.x = _view.y = 0;
				_view.parent.addChild(this);
			}
			
			addChild(_view);
			
			mouseChildren = false;
			buttonMode = true;
			
			_dict = new Dictionary(false);
			for each(var label:FrameLabel in (_view.scenes[0] as Scene).labels)
			{
				if (label.name) _dict[label.name] = true;
			}
			
			this.enabled = true;
		}
		
		protected function listen():void
		{
			addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			addEventListener(MouseEvent.ROLL_OVER, overHandler);
			addEventListener(MouseEvent.ROLL_OUT, outHandler);
		}
		
		protected function unlisten():void
		{
			removeEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			removeEventListener(MouseEvent.ROLL_OVER, overHandler);
			removeEventListener(MouseEvent.ROLL_OUT, outHandler);
		}
		
		protected function setButtonState(state:String):void
		{
			if (_dict[state])
			{
				_view.gotoAndStop(state);
				return;
			}
			
			switch(state)
			{
				case STATE_OUT:_view.gotoAndStop(1); break;
				case STATE_OVER:arguments.callee.call(null, STATE_OUT); break;
				case STATE_DOWN:arguments.callee.call(null, STATE_OUT); break;
				case STATE_SELECT:arguments.callee.call(null, STATE_OUT); break;
				case STATE_DISABLE:arguments.callee.call(null, STATE_OUT); break;
			}
		}
		
		protected function overHandler(e:MouseEvent):void 
		{
			if (!_pressing && !_selected)
			{
				setButtonState(STATE_OVER);
			}
		}
		
		protected function outHandler(e:MouseEvent):void 
		{
			if (!_pressing && !_selected)
			{
				setButtonState(STATE_OUT);
			}
		}
		
		protected function downHandler(e:MouseEvent):void 
		{
			_pressing = true;
			
			if (!_selected)
			{
				setButtonState(STATE_DOWN);
			}
			stage.addEventListener(MouseEvent.MOUSE_UP, upHandler);
		}
		
		protected function upHandler(e:MouseEvent):void 
		{
			e.currentTarget.removeEventListener(e.type, arguments.callee);
			
			if (!_selected)
			{
				setButtonState(e.target == this? STATE_OVER : STATE_OUT);
			}
			
			_pressing = false;
		}
		
		public function get enabled():Boolean { return _enabled; }
		public function set enabled(value:Boolean):void 
		{
			_enabled = value;
			mouseEnabled = _enabled;
			
			_enabled? listen() : unlisten();
			setButtonState(_enabled? STATE_OUT : STATE_DISABLE);
		}
		
		/**
		 * 是否选中
		 */
		public function get selected():Boolean { return _selected; }
		public function set selected(value:Boolean):void 
		{
			_selected = value;
			
			buttonMode = !_selected;
			setButtonState(_selected? STATE_SELECT : STATE_OUT);
		}
	}

}