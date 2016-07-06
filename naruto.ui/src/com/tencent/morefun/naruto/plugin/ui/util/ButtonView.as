package com.tencent.morefun.naruto.plugin.ui.util 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Devin Lee
	 */
	[Event(name='click',type='flash.events.MouseEvent')]
	public class ButtonView extends EventDispatcher
	{
		protected var _mc:MovieClip;
		private var _overStart:int;
		private var _overEnd:int;
		private var _outStart:int;
		private var _outEnd:int;
		private var _downStart:int;
		private var _downEnd:int;
		private var _targetFrame:int;
		private var _listenering:Boolean;
		private var _goForward:Boolean;
		private var _upStart:int;
		private var _upEnd:int;
		private var _data:Object;
		private var _index:int;
		private var _selected:Boolean;
		private var _isOver:Boolean;
		
		private var _enabled:Boolean=true;
		private var _enabledStart:int;
		private var _enabledEnd:int;
		private var _hitArea:Sprite;
		private var _selectedStart:int;
		private var _selectedEnd:int;
		public function ButtonView() 
		{
			
		}
		public function configUI(mc:MovieClip):void 
		{
			_mc = mc;
			_mc.stop();
			hitArea = _mc;
		}
		private function onMouseEvent(e:MouseEvent):void 
		{
			if (!_enabled) return;
			if (e.type == MouseEvent.CLICK) {
				dispatchEvent(e);
			}else if (_selected) {
				return;
			}
			
			if (e.type == MouseEvent.ROLL_OVER) {
				if (_overStart) {
					_isOver = true;
					playTo(_overStart, _overEnd);
				}
			}else if (e.type == MouseEvent.ROLL_OUT) {
				if (_outStart) {
					_isOver = false;
					playTo(_outStart, _outEnd);
				}
			}else if (e.type == MouseEvent.MOUSE_DOWN) {
				if (_downStart) {
					playTo(_downStart, _downEnd);
					dispatchEvent(e);
				}
			}else if (e.type == MouseEvent.MOUSE_UP) {
				if (_upStart) {
					
					if (_isOver) {
						playTo(_overStart, _overEnd);
					}else{
						playTo(_upStart, _upEnd);
					}
					dispatchEvent(e);
				}
			}
		}
		public function quickSet(up:int, over:int, out:int, down:int,selected:int=0,enabled:int=0):void {
			_upStart = _upEnd = up;
			_overStart = _overEnd = over;
			_outStart = _outEnd = out;
			_downStart = _downEnd = down;
			_selectedStart = _selectedEnd = selected;
			_enabledStart = _enabledEnd = enabled;
			setEnabldAndSelected(true, true);
		}
		public function setOver(startFrame:int, endFrame:int=0):void {
			_overStart = startFrame;
			_overEnd = endFrame?endFrame:startFrame;
		}
		public function setOut(startFrame:int, endFrame:int=0):void {
			_outStart = startFrame;
			_outEnd = endFrame?endFrame:startFrame;
		}
		public function setDown(startFrame:int, endFrame:int=0):void {
			_downStart = startFrame;
			_downEnd = endFrame?endFrame:startFrame;
		}
		public function setUp(startFrame:int, endFrame:int=0):void {
			_upStart = startFrame;
			_upEnd = endFrame?endFrame:startFrame;
		}
		protected function playTo(startFrame:int, endFrame:int):void {
			if (startFrame == endFrame) {
				_mc.gotoAndStop(startFrame);
				removeListener();
				return;
			}
			var currentFrame:int = _mc.currentFrame;
			if (startFrame < endFrame) {
				if (currentFrame < startFrame || currentFrame>endFrame) {
					_mc.gotoAndStop(startFrame);
				}
			}else {
				if (currentFrame > startFrame || currentFrame<endFrame) {
					_mc.gotoAndStop(startFrame);
				}
			}
			_targetFrame = endFrame;
			currentFrame = _mc.currentFrame;
			if (currentFrame == _targetFrame) {
				_mc.stop();
			}else if (currentFrame < _targetFrame) {
				_goForward = true;
				addListener();
			}else if (currentFrame > _targetFrame) {
				_goForward = false;
				addListener();
			}
		}
		
		private function addListener():void {
			if (!_listenering) {
				_listenering = true;
				_mc.addEventListener(Event.ENTER_FRAME, onFrame);
			}
		}
		
		private function removeListener():void 
		{
			if(_listenering){
				_mc.removeEventListener(Event.ENTER_FRAME, onFrame);
				_listenering = false;
			}
		}
		private function onFrame(e:Event):void 
		{
			if (_listenering) {
				if (_goForward) {
					_mc.nextFrame();
				}else {
					_mc.prevFrame();
				}
				if (_mc.currentFrame == _targetFrame) {
					removeListener();
					return;
				}
			}
		}
		
		public function get data():Object 
		{
			return _data;
		}
		
		public function set data(value:Object):void 
		{
			_data = value;
		}
		
		public function get index():int 
		{
			return _index;
		}
		
		public function set index(value:int):void 
		{
			_index = value;
		}
		
		public function get enabled():Boolean 
		{
			return _enabled;
		}
		
		public function set enabled(value:Boolean):void 
		{
			var change:Boolean = _enabled != value;
			//trace("[ButtonView][Devin]>>>enabled:",_mc.name,value,change);
			_enabled = value;
			setEnabldAndSelected(change, false);
		}
		
		public function setSelected(value:Boolean):void {
			var change:Boolean = _selected != value;
			//trace("[ButtonView]>>>setSelected:",_mc.name,value,change);
			_selected = value;
			setEnabldAndSelected(false, change);
		}
		
		private function setEnabldAndSelected(eChange:Boolean=false,sChange:Boolean=false):void 
		{
			if (!enabled) {
				if(eChange){
					playTo(_enabledStart, _enabledEnd);
				}
				_hitArea.buttonMode = false;
			}else {
				if (eChange ||sChange) {
					if (_selected) {
						playTo(_selectedStart, _selectedEnd);
					}else {
						playTo(_upStart, _upEnd);
					}
				}
				_hitArea.buttonMode = true;
			}
		}
		
		private function removeListeners():void 
		{
			if (_hitArea) {
				_hitArea.buttonMode = false;
				_hitArea.removeEventListener(MouseEvent.ROLL_OVER, onMouseEvent);
				_hitArea.removeEventListener(MouseEvent.ROLL_OUT, onMouseEvent);
				_hitArea.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
				_hitArea.removeEventListener(MouseEvent.MOUSE_UP, onMouseEvent);
				_hitArea.removeEventListener(MouseEvent.CLICK, onMouseEvent);
			}
		}
		
		public function set hitArea(value:Sprite):void 
		{
			removeListeners();
			_hitArea = value?value:_mc;
			if (_hitArea) {
				setEnabldAndSelected();
				_hitArea.addEventListener(MouseEvent.ROLL_OVER, onMouseEvent);
				_hitArea.addEventListener(MouseEvent.ROLL_OUT, onMouseEvent);
				_hitArea.addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
				_hitArea.addEventListener(MouseEvent.MOUSE_UP, onMouseEvent);
				_hitArea.addEventListener(MouseEvent.CLICK, onMouseEvent);
			}
		}
		
		public function get selected():Boolean 
		{
			return _selected;
		}
		
		public function get hitArea():Sprite 
		{
			return _hitArea;
		}
		public function dispose():void {
			removeListeners();
		}
	}

}