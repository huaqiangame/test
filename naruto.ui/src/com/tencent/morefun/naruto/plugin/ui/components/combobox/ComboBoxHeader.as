package com.tencent.morefun.naruto.plugin.ui.components.combobox 
{
	import com.tencent.morefun.naruto.plugin.ui.components.events.ComboBoxEvent;
	import com.tencent.morefun.naruto.plugin.ui.components.interfaces.IComponent;
	import com.tencent.morefun.naruto.plugin.ui.components.interfaces.IRender;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import naruto.component.controls.ComboBoxListBg2;
	
	/**
	 * 请求收起下拉列表
	 */
	[Event(name = "collapseSignal", type = "com.tencent.morefun.naruto.plugin.ui.components.events.ComboBoxEvent")]
	
	/**
	 * 请求展开下拉列表
	 */
	[Event(name = "expandSignal", type = "com.tencent.morefun.naruto.plugin.ui.components.events.ComboBoxEvent")]
	
	/**
	 * 下拉列表组件头
	 * @author larryhou
	 * @createTime 2014/10/9 15:47
	 */
    import com.tencent.morefun.naruto.i18n.I18n;
	internal class ComboBoxHeader extends Sprite implements IRender, IComponent
	{
		private static const MARGIN:uint = 3;
		
		private var _data:Object;
		private var _item:DisplayObject;
		
		private var _background:ComboBoxListBg2;
		private var _button:InteractiveButton;
		
		private var _dealloc:Boolean;
		
		private var _expanding:Boolean;
		private var _enabled:Boolean;
		
		private var _itemOffset:Number;
		
		/**
		 * 构造函数
		 * create a [ComboBoxHeader] object
		 */
		public function ComboBoxHeader(itemRenderClass:Class, itemOffset:Number)
		{
			_itemOffset = itemOffset;
			addChild(_item = new itemRenderClass() as DisplayObject);
			if (_item is IRender == false)
			{
				throw new ArgumentError(I18n.lang("as_ui_1451031579_6154"));
			}
			
			init();
		}
		
		private function init():void 
		{
			addChildAt(_background = new ComboBoxListBg2(), 0);
			addChild(_button = new InteractiveButton());
			
			_background.width = _button.width + _item.width + _itemOffset;
			_background.height = Math.max(_item.height, _button.height) + MARGIN * 2;
			
			layoutUpdate();
		}
		
		/**
		 * 事件侦听
		 */
		private function listen():void
		{
			addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		/**
		 * 取消事件侦听
		 */
		private function unlisten():void
		{
			removeEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		/**
		 * 处理鼠标点击事件
		 */
		private function clickHandler(e:MouseEvent):void 
		{
			e.stopImmediatePropagation();
			
			_expanding = !_expanding;
			if (_expanding)
			{
				_button.scaleY = -1;
				dispatchEvent(new ComboBoxEvent(ComboBoxEvent.EXPAND_SIGNAL));
			}
			else
			{
				_button.scaleY = 1;
				dispatchEvent(new ComboBoxEvent(ComboBoxEvent.COLLAPSE_SIGNAL));
			}
			
			layoutUpdate();
		}
		
		/**
		 * 更新布局
		 */
		private function layoutUpdate():void
		{
			if (_dealloc) return;
			
			var bounds:Rectangle = _button.getBounds(this);
			_button.x = (_background.width - bounds.width - MARGIN) + (_button.x - bounds.x);
			_button.y = (_background.height - bounds.height) / 2 + (_button.y - bounds.y);
			
			_item.x = _itemOffset;
			_item.y = (_background.height - _item.height) / 2;
		}
		
		public function dispose():void 
		{
			if (_dealloc) return;
			
			unlisten();
			
			_dealloc = true;
			_background.parent && _background.parent.removeChild(_background);
			_background = null;
			
			_button.dispose();
			_button.parent && _button.parent.removeChild(_button);
			_button = null;
			
			IRender(_item).dispose();
			_item.parent && _item.parent.removeChild(_item);
			_item = null;
			_data = null;
		}
		
		/* INTERFACE com.tencent.morefun.naruto.plugin.ui.components.interfaces.IComponent */
		
		public function get enabled():Boolean { return _enabled; }
		public function set enabled(value:Boolean):void 
		{
			_enabled = value;
			_enabled? listen() : unlisten();
		}
		
		/* INTERFACE com.tencent.morefun.naruto.plugin.ui.components.interfaces.IRender */
		
		public function get data():Object { return _data; }
		public function set data(value:Object):void
		{
			_data = value;
			if (_item)
			{
				IRender(_item).data = data;
			}
		}
		
		/**
		 * 复写基类宽度逻辑
		 */
		override public function get width():Number { return _background.width; }
		
		/**
		 * 复写基类高度逻辑
		 */
		override public function get height():Number { return _background.height; }
		
		/**
		 * 设置展开状态
		 */
		public function get expanding():Boolean { return _expanding; }
		public function set expanding(value:Boolean):void 
		{
			_expanding = value;
			_button.scaleY = _expanding? -1 : 1;
			layoutUpdate();
		}
		
		/**
		 * 交互按钮
		 */
		public function get button():InteractiveButton { return _button; }
		
		/**
		 * 下拉列表渲染器
		 */
		public function get item():DisplayObject { return _item; }
	}
}

import flash.display.Sprite;
import flash.geom.Rectangle;

import naruto.component.controls.ComboBoxButton;

class InteractiveButton extends Sprite
{
	public function InteractiveButton():void
	{
		var button:ComboBoxButton = new ComboBoxButton();
		var bounds:Rectangle = button.getBounds(button);
		button.x = - bounds.x;
		button.y = - bounds.y;
		addChild(button);
	}
	
	public function dispose():void
	{
		(removeChildAt(0) as ComboBoxButton).dispose();
	}
}