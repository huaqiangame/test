package com.tencent.morefun.naruto.plugin.prewar.component.tab 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * 选项卡发生变化时派发
	 */
	[Event(name = "change", type = "flash.events.Event")]
	
	/**
	 * 通用选项卡类
	 * @author larryhou
	 * @createTime 2013/9/26 19:02
	 */
	public class SimpleTab extends Sprite
	{
		private var _horizontal:Boolean;
		private var _items:Vector.<TabItemRender>;
		
		private var _gap:int;
		private var _itemRenderClass:Class;
		
		private var _source:Array;
		
		private var _selectedItem:TabItemRender;
		private var _selectedIndex:uint;
		
		private var _enabled:Boolean;
		
		private var _width:Number;
		private var _height:Number;
		
		/**
		 * 构造函数
		 * create a [SimpleTab] object
		 */
		public function SimpleTab(itemRenderClass:Class, gap:int = 5, horizontal:Boolean = true) 
		{
			_items = new Vector.<TabItemRender>();
			
			this.gap = gap; this.horizontal = horizontal; this.itemRenderClass = itemRenderClass;
			this.enabled = true;
		}
		
		/**
		 * 添加事件侦听
		 */
		private function listen():void
		{
			addEventListener(Event.SELECT, selectHandler);
		}
		
		/**
		 * 取消事件侦听
		 */
		private function unlisten():void
		{
			removeEventListener(Event.SELECT, selectHandler);
		}
		
		/**
		 * 处理选项卡选择逻辑
		 */
		private function selectHandler(e:Event):void 
		{
			e.stopPropagation();
			
			var target:TabItemRender = e.target as TabItemRender;
			if (target)
			{
				selectItem(target);
			}
		}
		
		/**
		 * 获取选项卡项目
		 * @param	index	选项卡数据索引
		 */
		public function getItemAt(index:uint):TabItemRender
		{
			return (index >= _items.length)? _items[index] : null;
		}
		
		/**
		 * 查找匹配属性值的项目
		 * @param	property	data属性名
		 * @param	value		data属性值
		 */
		public function findItemMatch(property:String, value:*):TabItemRender
		{
			if (!property) return null;
			for each(var item:TabItemRender in _items)
			{
				if (property in item.data)
				{
					if (item.data[property] == value) return item;
				}
			}
			
			return null;
		}
		
		/**
		 * 列表渲染
		 */
		private function render():void
		{
			if (!_itemRenderClass)
			{
				throw new ArgumentError("[fatalError]itemRenderClass cannot be null.");
				return;
			}
			
			var item:TabItemRender;
			if (_items.length > _source.length)
			{
				while (_items.length > _source.length)
				{
					item = _items.pop();
					item.parent && item.parent.removeChild(item);
					item.dispose();
				}
			}
			else
			if (_items.length < _source.length)
			{
				while (_items.length < _source.length)
				{
					addChild(item = new _itemRenderClass());
					_items.push(item);
				}
			}
			
			layoutUpdate();
			this.selectedIndex = 0;
		}
		
		/**
		 * 布局更新
		 */
		private function layoutUpdate(forceUpdate:Boolean = true):void
		{
			if (!_source) return;
			
			var item:TabItemRender;
			var bounds:Rectangle;
			
			var position:Number = 0;
			for (var i:uint = 0; i < _source.length; i++)
			{				
				item = _items[i];
				if (forceUpdate) item.data = _source[i];
				
				bounds = item.getBounds(item);
				item.x = -bounds.x * item.scaleX;
				item.y = -bounds.y * item.scaleY;
				
				if (_horizontal)
				{
					item.x += position;
					position += item.width + _gap;
				}
				else
				{
					item.y += position;
					position += item.height + _gap;
				}
			}
			
			if (_horizontal)
			{
				_width = position - (item.width + _gap);
				_height = item.height;
			}
			else
			{
				_width = item.width;
				_height = position - (item.height + _gap);
			}
		}
		
		/**
		 * 垃圾回收
		 */
		private function dispose():void
		{
			var item:TabItemRender;
			while (_items.length)
			{
				item = _items.pop();
				item.parent && item.parent.removeChild(item);
				item.dispose();
			}
		}
		
		/**
		 * 选中对象
		 * @param	item	选项卡项目
		 */
		private function selectItem(item:TabItemRender):void
		{
			if (!item) return;
			
			if (_selectedItem)
			{
				_selectedItem.selected = false;
			}
			
			_selectedItem = item;
			_selectedItem.selected = true;
			
			var index:int = _items.indexOf(_selectedItem);
			if (index >= 0)
			{
				_selectedIndex = index;
			}
			else
			{
				throw new Error("Invalide item.");
			}
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**
		 * 横向排列
		 */
		public function get horizontal():Boolean { return _horizontal; }
		public function set horizontal(value:Boolean):void 
		{
			_horizontal = value; layoutUpdate(false);
		}
		
		/**
		 * 渲染器类
		 */
		public function get itemRenderClass():Class { return _itemRenderClass; }
		public function set itemRenderClass(value:Class):void 
		{
			if (value && value != _itemRenderClass)
			{
				if (describeType(value)..extendsClass.(String(@type).match(/TabItemRender$/)).length() < 0)
				{
					throw new ArgumentError("[fatalError]itemRenderClass must be subclass of " + getQualifiedClassName(TabItemRender));
				}
				else
				{
					dispose(); 
					
					_itemRenderClass = value;
					if (_source && _source.length) render();
				}
			}
		}
		
		/**
		 * 项目间距
		 */
		public function get gap():int { return _gap; }
		public function set gap(value:int):void 
		{
			_gap = value; layoutUpdate(false);
		}
		
		/**
		 * 数据列表
		 */
		public function get source():Array { return _source; }
		public function set source(value:Array):void 
		{
			_source = value;
			_source? render() : dispose();
		}
		
		/**
		 * 被选中对象
		 */
		public function get selectedItem():TabItemRender { return _selectedItem; }
		public function set selectedItem(value:TabItemRender):void
		{
			var index:int = _items.indexOf(value);
			if (index >= 0)
			{
				this.selectedIndex = index;
			}
		}
		
		/**
		 * 选中对象索引
		 */
		public function get selectedIndex():uint { return _selectedIndex; }
		public function set selectedIndex(value:uint):void 
		{
			_selectedIndex = Math.min(_items.length - 1, value);
			
			selectItem(_items[_selectedIndex]);
		}
		
		/**
		 * 选项卡交互是否激活
		 */
		public function get enabled():Boolean { return _enabled; }
		public function set enabled(value:Boolean):void 
		{
			_enabled = value;
			_enabled? listen() : unlisten();
		}
		
		override public function get width():Number { return _width; }
		override public function get height():Number { return _height; }
	}

}