package com.tencent.morefun.naruto.plugin.ui.components.layouts 
{

	import com.tencent.morefun.naruto.plugin.ui.EasyLayoutScrollBar_2_Skin;
	import com.tencent.morefun.naruto.plugin.ui.components.interfaces.IComponent;
	import com.tencent.morefun.naruto.plugin.ui.components.scrollers.ScrollBar;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	
	/**
	 * 常用布局控制类
	 * @author larryhou
	 * @createTime 2012/5/29 12:03
	 */
	public class EasyLayout extends Sprite implements IComponent
	{
		private var _scroller:ScrollBar;
		private var _layout:ScrollLayout;
		
		private var _enabled:Boolean;
		private var _virtical:Boolean;
		
		private var _position:Number;
		
		/**
		 * 构造函数
		 * create a [EasyLayout] object
		 */
		public function EasyLayout(renderClass:Class, row:int, column:int = 1, hgap:Number = 5, vgap:Number = 5, virtical:Boolean = true, scrollerView:MovieClip = null) 
		{
			_virtical = virtical;
			
			if (_virtical)
			{
				_layout = new VirticalScrollLayout(row, column, hgap, vgap);
			}
			else
			{
				_layout = new HorizontalScrollLayout(row, column, hgap, vgap);
			}
			
			_layout.itemRenderClass = renderClass;
			
			_scroller = new ScrollBar(scrollerView || new EasyLayoutScrollBar_2_Skin(), _virtical? row : column);
			_scroller.bar.minHeight = 60;
			_scroller.wheelArea = this;
			
			scrollerUpdate();
			
			addChild(_layout);
			addChild((_scroller as ScrollBar).view);
			
			this.enabled = true;
		}
		
		/**
		 * 滚动列表到指定数据位置
		 * @param	dataIndex	数据索引
		 */
		public function scrollTo(dataIndex:int):void
		{
			_layout.scrollTo(dataIndex);
			_scroller.value = _layout.value;
			
			_position = _layout.value;
		}
		
		/**
		 * 强制刷新当前页面数据
		 */
		public function refresh():void
		{
			_layout.refresh();
		}
		
		public function dispose():void
		{
			if (_layout)
			{
				_layout.dispose();
				_layout.enabled = false;
				_layout = null;
			}
			
			if (_scroller)
			{
				_scroller.enabled = false;
				_scroller = null;
			}
			
			removeChildren();
		}
		
		/**
		 * 刷新显示
		 */
		private function scrollerUpdate():void
		{
			var bounds:Rectangle = _scroller.view.getBounds(_scroller.view);
			
			if (_virtical)
			{
				_scroller.x = _layout.width - bounds.x;
				_scroller.height = _layout.height;
				
				_scroller.view.rotation = 0;
			}
			else
			{
				_scroller.y = _layout.height - bounds.y + bounds.width;
				_scroller.height = _layout.width;
				
				_scroller.view.rotation = -90;
			}
			
			_scroller.lineCount = _layout.lineCount;
			_scroller.value = _layout.value;
		}
		
		/**
		 * 添加事件侦听
		 */
		private function listen():void
		{
			_layout.addEventListener(Event.CHANGE, changeHandler);
			_scroller.addEventListener(Event.CHANGE, changeHandler);
		}
		
		/**
		 * 移除事件侦听
		 */
		private function unlisten():void
		{
			_layout.removeEventListener(Event.CHANGE, changeHandler);
			_scroller.removeEventListener(Event.CHANGE, changeHandler);
		}
		
		/**
		 * 更新渲染
		 * @param	e
		 */
		protected function changeHandler(e:Event):void 
		{
			if(e.currentTarget == _scroller)
			{
				_layout.value = _scroller.value;
			}
			else
			{
				_scroller.value = _layout.value;
			}
			
			_position = _layout.value;
		}
		
		/* INTERFACE com.qzone.corelib.controls.interfaces.IController */
		// getter & setter
		//*************************************************
		/**
		 * 控件是否被激活
		 * @default true
		 */
		public function get enabled():Boolean { return _enabled; }
		public function set enabled(value:Boolean):void 
		{
			_enabled = value;
			
			_layout.enabled = _enabled;
			_scroller.enabled = _enabled;
			
			_enabled? listen() : unlisten();
		}
		
		/**
		 * 代理布局列表数据
		 */
		public function get dataProvider():Array { return _layout.dataProvider; }
		public function set dataProvider(value:Array):void 
		{
			_layout.dataProvider = value || [];
			
			_scroller.lineCount = _layout.lineCount;
			_scroller.value = _layout.value;
			refresh();
		}
		
		protected function get renderers():Array
		{
			return this.layout.items;
		}
		
		/**
		 * 滚动控件
		 */
		public function get scroller():ScrollBar { return _scroller; }
		
		/**
		 * 布局控件
		 */
		public function get layout():ScrollLayout { return _layout; }
		
		/**
		 * 列表项目渲染类
		 */
		public function get itemRenderClass():Class { return _layout.itemRenderClass; }
		public function set itemRenderClass(value:Class):void 
		{
			
			_layout.itemRenderClass = value; scrollerUpdate();
		}
		
		/**
		 * 列表是否为竖直布局
		 */
		public function get virtical():Boolean { return _virtical; }
		
		/**
		 * 滚动列表列数
		 */
		public function get column():uint { return _layout.column; }
		public function set column(value:uint):void 
		{
			_layout.column = value; 
			if (!_virtical) 
			{
				_scroller.pageCount = value;
			}
			
			scrollerUpdate();
		}
		
		/**
		 * 滚动列表行数
		 */
		public function get row():uint { return _layout.row; }
		public function set row(value:uint):void 
		{
			_layout.row = value; 
			if (_virtical) 
			{
				_scroller.pageCount = value;
			}
			
			scrollerUpdate();
		}
		
		/**
		 * 滚动条位置
		 */
		public function get position():Number { return _position; }
		public function set position(value:Number):void 
		{
			_position = isNaN(value)? 0 : Math.max(0, Math.min(value, 100));
			
			_layout.forceUpdate = true;
			_layout.value = _position;
			
			_scroller.value = _position;
		}
		
		/**
		 * 使用列表宽高
		 */
		override public function get width():Number { return _layout.width; }
		override public function get height():Number { return _layout.height; }
				
		
		/**
		 * 滚动条的像素位置，与position不同，后者返回的是百分比
		 */
		public function get pixelPosition():Number
		{
			var result:Number;
			
			if (_virtical)
			{
				result = _position / 100 * ((layout.itemHeight + layout.vgap)*(layout.lineCount-layout.row));
			}
			else
			{
				result = _position / 100 * ((layout.itemWidth + layout.hgap)*(layout.lineCount-layout.column));
			}
			return result;
		}
		
		/**
		 * 滚动条的像素位置，与position不同，后者设置的是百分比
		 */
		public function set pixelPosition(value:Number):void
		{
			var result:Number;
			
			if (_virtical)
			{
				result =  value / ((layout.itemHeight + layout.vgap)*(layout.lineCount-layout.row)) * 100;
			}
			else
			{
				result =  value / ((layout.itemWidth + layout.hgap)*(layout.lineCount-layout.column)) * 100;
			}
			
			position = result;
		}
	}

}