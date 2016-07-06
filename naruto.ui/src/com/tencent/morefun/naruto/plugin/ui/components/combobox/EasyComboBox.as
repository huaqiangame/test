package com.tencent.morefun.naruto.plugin.ui.components.combobox 
{
	import com.greensock.TweenLite;
	import com.tencent.morefun.naruto.plugin.ui.components.events.ComboBoxEvent;
	import com.tencent.morefun.naruto.plugin.ui.components.interfaces.IComponent;
	import com.tencent.morefun.naruto.plugin.ui.components.interfaces.IRender;
	import com.tencent.morefun.naruto.plugin.ui.components.layouts.EasyLayout;
	import com.tencent.morefun.naruto.plugin.ui.components.wrappers.RenderWrapper;
	import com.tencent.morefun.naruto.plugin.ui.EasyLayoutScrollBar_1_Skin;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import naruto.component.controls.ComboBoxListBg;
	
	/**
	 * 列表项目选择变更时派发
	 */
	[Event(name = "selectChange", type = "com.tencent.morefun.naruto.plugin.ui.components.events.ComboBoxEvent")]
	
	/**
	 * 列表打开时派发
	 */
	[Event(name = "open", type = "com.tencent.morefun.naruto.plugin.ui.components.events.ComboBoxEvent")]
	
	/**
	 * 下拉列表组件
	 * @author larryhou
	 * @createTime 2014/10/9 15:45
	 */
	public class EasyComboBox extends Sprite implements IComponent
	{
		private static const DATA_SELECT_KEY:String = "selected";
		
		private var _enabled:Boolean;
		
		private var _curtain:Shape;
		private var _layout:EasyLayout;
		
		private var _margin:Number;
		
		private var _background:ComboBoxListBg;
		
		private var _header:ComboBoxHeader;
		private var _selectedItem:Object;
		private var _selectedIndex:uint;
		
		private var _dealloc:Boolean;
		
		private var _animating:Boolean;
		private var _lite:TweenLite;
		
		private var _dropdownContainer:DisplayObjectContainer;
		
		/**
		 * 构造函数
		 * create a [EasyComboBox] object
		 * @param	itemRenderClass		下拉列表渲染器
		 * @param	headerRenderClass	下拉列表表头展示渲染器，可以与itemRenderClass相同，留空默认使用itemRenderClass
		 * @param	rowCount			下拉列表最多展示行数
		 * @param	gap					下拉列表项目属相间隔
		 */
		public function EasyComboBox(itemRenderClass:Class, headerRenderClass:Class = null, rowCount:uint = 5, gap:Number = 5, margin:Number = 5, dropdownContainer:DisplayObjectContainer = null)
		{
			_margin = margin;
			_dropdownContainer = dropdownContainer;
			
			_curtain = new Shape();
			_curtain.graphics.beginFill(0, 1);
			_curtain.graphics.drawRect(0, 0, 10, 10);
			
			_layout = new EasyLayout(itemRenderClass, rowCount, 1, 0, gap, true, new EasyLayoutScrollBar_1_Skin());
			_layout.addChildAt(_background = new ComboBoxListBg(), 0);
			
			addChild(_header = new ComboBoxHeader(headerRenderClass || itemRenderClass, margin));
			this.enabled = true;
		}
		
		/**
		 * 添加事件侦听
		 */
		private function listen():void
		{
			_header.addEventListener(ComboBoxEvent.COLLAPSE_SIGNAL, headerInteractHandler);
			_header.addEventListener(ComboBoxEvent.EXPAND_SIGNAL, headerInteractHandler);
			
			_layout.addEventListener(MouseEvent.CLICK, selectHandler);
			
			addEventListener(Event.REMOVED_FROM_STAGE, removeHandler);
		}
		
		/**
		 * 取消事件侦听
		 */
		private function unlisten():void
		{
			_header.removeEventListener(ComboBoxEvent.COLLAPSE_SIGNAL, headerInteractHandler);
			_header.removeEventListener(ComboBoxEvent.EXPAND_SIGNAL, headerInteractHandler);
			
			_layout.removeEventListener(MouseEvent.CLICK, selectHandler);
			
			removeEventListener(Event.REMOVED_FROM_STAGE, removeHandler);
		}
		
		/**
		 * 从舞台移除时滚动列表同步移除
		 */
		private function removeHandler(e:Event):void 
		{
			_lite && _lite.kill();
			_layout.parent && _layout.parent.removeChild(_layout);
		}
		
		/**
		 * 列表选择逻辑处理
		 */
		private function selectHandler(e:MouseEvent):void 
		{
			if (e.target is IRender)
			{
				_selectedIndex = ((e.target as DisplayObject).parent as RenderWrapper).dataIndex;
				selectItemWith(IRender(e.target).data);
			}
		}
		
		/**
		 * 选中数据
		 */
		private function selectItemWith(data:Object):void
		{
			if (_selectedItem && DATA_SELECT_KEY in _selectedItem)
			{
				_selectedItem[DATA_SELECT_KEY] = false;
			}
			
			_selectedItem = data;
			if (DATA_SELECT_KEY in _selectedItem)
			{
				_selectedItem[DATA_SELECT_KEY] = true;
			}
			
			_header.data = _selectedItem;
			_layout.refresh();
			
			dispatchEvent(new ComboBoxEvent(ComboBoxEvent.SELECT_CHANGE));
		}
		
		/**
		 * 下拉列表交互处理
		 */
		private function headerInteractHandler(e:ComboBoxEvent):void 
		{
			if (e.type == ComboBoxEvent.COLLAPSE_SIGNAL)
			{
				collapseWithTween();
			}
			else
			if (e.type == ComboBoxEvent.EXPAND_SIGNAL)
			{
				expandWithTween();
			}
		}
		
		/**
		 * 收起下拉列表
		 */
		private function collapseWithTween():void
		{
			_layout.mouseChildren = false;
			_animating = true;
			
			_lite && _lite.kill();
			_lite = TweenLite.to(_layout, 0.15, { y:_curtain.y + _margin - _background.height, onComplete:function():void
			{
				_animating = false;
				
				_curtain.parent && _curtain.parent.removeChild(_curtain);
				_layout.parent && _layout.parent.removeChild(_layout);
			}} );
			
			if (stage)
			{
				stage.removeEventListener(MouseEvent.CLICK, stageClickHandler);
			}
		}
		
		/**
		 * 展开下拉列表
		 */
		private function expandWithTween():void
		{
			var bounds:Rectangle;
			
			// 背景尺寸调整
			_background.x = -_margin;
			_background.y = -_margin;
			if (_layout.row >= _layout.dataProvider.length)
			{
				_background.width = _layout.width + _margin * 2;
			}
			else
			{
				_background.width = _header.width;
				
				// 滚动条相对下拉按钮左右居中对齐
				bounds = _header.button.getBounds(this);
				var sView:DisplayObject = _layout.scroller.view;
				sView.x = (bounds.x - _margin) + (bounds.width - sView.width) / 2 - sView.getBounds(sView).x;
			}
			
			_background.height = _layout.height + _margin * 2;
			_curtain.height = _background.height;
			_curtain.width = _background.width;
			
			var container:DisplayObjectContainer = _dropdownContainer || stage;
			
			// 对齐下拉列表
			bounds = _header.getBounds(container);
			_curtain.y = bounds.bottom;
			_curtain.x = bounds.x; 
			
			if (!_animating)
			{
				_layout.x = bounds.x + _margin;
				_layout.y = bounds.bottom + _margin - _background.height;
			}
			
			container.addChild(_layout);
			stage.addEventListener(MouseEvent.CLICK, stageClickHandler);
			
			// 设置滚动遮罩
			_layout.mask = stage.addChild(_curtain);
			
			// 开始滚动显示列表
			_layout.mouseChildren = false;
			_animating = true;
			
			_lite && _lite.kill();
			_lite = TweenLite.to(_layout, 0.15, { y:_curtain.y + _margin, onComplete:function():void
			{
				_animating = false;
				_layout.mouseChildren = true;
			}} );
			
			dispatchEvent(new ComboBoxEvent(ComboBoxEvent.OPEN));
		}
		
		/**
		 * 收起下拉列表
		 */
		private function stageClickHandler(e:MouseEvent):void 
		{
			if (!_header.expanding) return;
			
			var target:DisplayObject = e.target as DisplayObject;
			if (!target || !_layout.contains(target) || (_layout.contains(target) && target is IRender))
			{
				e.currentTarget.removeEventListener(e.type, arguments.callee);
				
				_header.expanding = false;
				collapseWithTween();
			}
		}
		
		/**
		 * 垃圾回收
		 */
		public function dispose():void
		{
			if (_dealloc) return;
			
			unlisten();
			
			_lite && _lite.kill();
			_lite = null;
			
			_layout.dispose();
			_layout.parent && _layout.parent.removeChild(_layout);
			_layout = null;
			
			_dropdownContainer = null;
			_curtain.parent && _curtain.parent.removeChild(_curtain);
			_curtain = null;
			
			_header.dispose();
			_header.parent && _header.parent.removeChild(_header);
			_header = null;
			
			_background.parent && _background.parent.removeChild(_background);
			_background = null;
			
			_selectedItem = null;
		}
		
		/* INTERFACE com.tencent.morefun.naruto.plugin.ui.components.interfaces.IComponent */
		
		public function get enabled():Boolean { return _enabled; }
		public function set enabled(value:Boolean):void 
		{
			_enabled = value;
			_layout.enabled = _enabled;
			_header.enabled = _enabled;
			_enabled? listen() : unlisten();
		}
		
		/**
		 * 下拉列表数据源
		 */
		public function get dataProvider():Array { return _layout.dataProvider; }
		public function set dataProvider(value:Array):void 
		{
			_layout.dataProvider = value;
			if (value && value.length)
			{
				var index:int = -1;
				if (DATA_SELECT_KEY in value[0])
				{
					for (var i:uint = 0; i < value.length; i++)
					{
						if (value[i][DATA_SELECT_KEY] && index == -1)
						{
							index = i;
						}
						else
						{
							value[i][DATA_SELECT_KEY] = false;
						}
					}
				}
				
				if (index == -1)
				{
					index = _selectedIndex;
					if (index >= value.length) index = 0;
				}
				
				this.selectedIndex = index;
			}
			else
			{
				_selectedItem = null;
				_selectedIndex = 0;
			}
		}
		
		/**
		 * 通过设置数据来选中下拉列表项目
		 */
		public function get selectedItem():Object { return _selectedItem; }
		public function set selectedItem(value:Object):void 
		{
			if (_layout.dataProvider.indexOf(value) >= 0)
			{
				selectItemWith(value);
			}
		}
		
		/**
		 * 当前已选择索引
		 */
		public function get selectedIndex():int { return _selectedIndex; }
		public function set selectedIndex(value:int):void 
		{
			if (value < _layout.dataProvider.length)
			{
				_selectedIndex = value;
				selectItemWith(_layout.dataProvider[value]);
			}
		}
		
		/**
		 * 读取下拉列表高度
		 */
		override public function get height():Number { return _header.height; }
		
		/**
		 * 读取下拉列表宽度
		 */
		override public function get width():Number { return _header.width; }
		
		/**
		 * 是否处于展开状态
		 */
		public function get expending():Boolean { return _header.expanding; }
		public function set expending(value:Boolean):void 
		{
			if (_header.expanding != value && stage)
			{
				_header.expanding = value;
				_header.expanding? expandWithTween() : collapseWithTween();
			}
		}
		
		/**
		 * 获取表头渲染器
		 */
		public function get headerItem():IRender { return _header.item as IRender; }
		
		/**
		 * 滚动列表
		 */
		public function get layout():EasyLayout { return _layout; }
	}

}