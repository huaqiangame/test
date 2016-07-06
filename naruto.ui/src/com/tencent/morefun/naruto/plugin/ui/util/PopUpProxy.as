package com.tencent.morefun.naruto.plugin.ui.util 
{
	import com.tencent.morefun.naruto.plugin.ui.layer.LayerManager;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class PopUpProxy extends EventDispatcher
	{
		private var _toggleBt:InteractiveObject;
		private var _popupDO:DisplayObject;
		private var _container:Sprite;
		private var _mask:Shape;
		private var _percent:Number = 0;
		private var _positionHandler:Function;
		private var _isOpen:Boolean = false;
		private var _parent:Object;
		private var _root:DisplayObjectContainer;
		private var _stage:Stage;
		private var _disable:Boolean = true;
		public function PopUpProxy(toggleBt:InteractiveObject,popupDO:DisplayObject,positionHandler:Function=null,parent:Sprite=null) 
		{
			_root = LayerManager.singleton.stage as DisplayObjectContainer;
			_stage = LayerManager.singleton.stage;
			_toggleBt = toggleBt;
			
			disable = false;
			_popupDO = popupDO;
			_positionHandler = positionHandler;
			_container = new Sprite;
			if (parent)
				_parent = parent;
			else
				_parent = _root;
		}
		
		protected function onToggleListVisibility(event:MouseEvent):void {
			if (_isOpen) {
				close()
			} else {
				open();
			}
		}
		public function open():void {
			if (_isOpen) { return; }

			_isOpen = true;
			_stage.addEventListener(Event.ENTER_FRAME, addCloseListener, false, 0, true);			

			if(!_container.contains(_popupDO))
				_container.addChild(_popupDO);
			_parent.addChild(_container);
			if (_positionHandler!=null) {
				_positionHandler();
			}else {
				positionPopupDO();
			}
		}
		private function addCloseListener(event:Event):void {
			_stage.removeEventListener(Event.ENTER_FRAME, addCloseListener);
			if (!_isOpen) { return; }
			_stage.addEventListener(MouseEvent.MOUSE_DOWN, onStageClick, false, 0, true);
		}
		protected function onStageClick(event:MouseEvent):void {
			if (!_isOpen
				|| ((_toggleBt is Sprite) &&  Sprite(_toggleBt).contains(event.target as DisplayObject)) 
				|| ((_popupDO is Sprite) && Sprite(_popupDO).contains(event.target as DisplayObject))
				) {
				return; 
			}
			close();
		}

		protected function positionPopupDO():void {
			var p:Point = _toggleBt.localToGlobal(new Point(0, 0));
			if(_parent is DisplayObject){
				p = _parent.globalToLocal(p);
			}/*else if (_parent is IChildList)*/ {
				p = DisplayObject(_root).globalToLocal(p);
			}
			_container.x = p.x ;
			_container.y = p.y + _toggleBt.height;
		}
		
		public function close():void {
			if (! _isOpen) { return; }
			_stage.removeEventListener(MouseEvent.MOUSE_DOWN, onStageClick);
			_isOpen = false;
			if(_container.parent)
				_container.parent.removeChild(_container);
		}
		public function get popupDO():DisplayObject { return _popupDO; }
		
		public function get toggleBt():InteractiveObject { return _toggleBt; }
		
		public function get container():Sprite 
		{
			return _container;
		}
		
		public function get disable():Boolean 
		{
			return _disable;
		}
		public function dispose():void {
			disable = true;
			_toggleBt = null;
			if(_container.contains(_popupDO))
				_container.removeChild(_popupDO);
			_popupDO = null;
			_container = null;
		}
		public function set disable(value:Boolean):void 
		{
			if (_disable == value) return;
			_disable = value;
			if(_disable){
				_toggleBt.removeEventListener(MouseEvent.MOUSE_DOWN, onToggleListVisibility, false);
				close();
			}else{
				_toggleBt.addEventListener(MouseEvent.MOUSE_DOWN, onToggleListVisibility, false, 8, true);
			}
		}
		
		public function get isOpen():Boolean 
		{
			return _isOpen;
		}
		}
	
}