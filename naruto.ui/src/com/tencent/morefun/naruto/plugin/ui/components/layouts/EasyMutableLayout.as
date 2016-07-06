package com.tencent.morefun.naruto.plugin.ui.components.layouts 
{
	import com.greensock.TweenLite;
	import com.tencent.morefun.naruto.plugin.ui.EasyLayoutScrollBar_2_Skin;
	import com.tencent.morefun.naruto.plugin.ui.components.interfaces.IComponent;
	import com.tencent.morefun.naruto.plugin.ui.components.scrollers.ScrollBar;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * 带滚动条的变高度组件
	 * @author larryhou
	 * @createTime 2014/7/1 14:08
	 */
	public class EasyMutableLayout extends Sprite implements IComponent
	{
		private var _enabled:Boolean;
		
		private var _layout:MutableLayout;
		private var _scroller:ScrollBar;
		
		/**
		 * 构造函数
		 * create a [EasyMutableLayout] object
		 */
		public function EasyMutableLayout(renderClass:Class, width:uint, height:uint, gap:Number = 5)
		{
			_layout = new MutableLayout(width, height, gap);
			_layout.itemRenderClass = renderClass;
			
			_scroller = new ScrollBar(new EasyLayoutScrollBar_2_Skin(), 1);
			_scroller.wheelArea = this;
			_scroller.bar.minHeight = 60;
			_scroller.view.x = _layout.width;
			_scroller.height = _layout.height;
			
			addChild(_layout);
			addChild(_scroller.view);
			
			this.enabled = true;
		}
		
		/**
		 * 滚动到指定数据位置
		 * @param	dataIndex	数据索引
		 */
		public function scrollTo(dataIndex:uint, appearAtBottom:Boolean = true):void
		{
			_layout.scrollTo(dataIndex, appearAtBottom);
			_scroller.value = _layout.value;
		}
		
		/**
		 * 通过缓动方式滚动到指定数据位置
		 * @param	dataIndex	目标数据索引
		 * @param	duration	缓动持续时间：秒
		 * @param	ease		缓动函数：默认为线性
		 */
		public function scrollTweenTo(dataIndex:uint, duration:Number = 0.5, ease:Function = null, appearAtBottom:Boolean = true):void
		{
			var pos:Number = _layout.getItemPosition(dataIndex, appearAtBottom);
			
			mouseChildren = false;
			
			TweenLite.killTweensOf(_layout);
			TweenLite.to(_layout, duration, { position:pos, ease:ease, onUpdate:layoutTweenUpdate, onComplete: layoutTweenComplete} );
		}
		
		/**
		 * 滚动结束激活鼠标感应
		 */
		private function layoutTweenComplete():void 
		{
			mouseChildren = true;
		}
		
		/**
		 * 更新滚动条位置
		 */
		private function layoutTweenUpdate():void
		{
			_scroller.value = _layout.value;
		}
		
		/**
		 * 刷新显示
		 */
		public function refresh():void
		{
			_layout.refresh();
		}
		
		/**
		 * 垃圾回收
		 */
		public function dispose():void
		{
			TweenLite.killTweensOf(_layout);
			removeChildren();
			unlisten();
			
			_layout.dispose();
			_layout.parent && _layout.parent.removeChild(_layout);
			_layout = null;
			
			_scroller.enabled = false;
			_scroller = null;
		}
		
		/**
		 * 事件侦听
		 */
		private function listen():void
		{
			_scroller.addEventListener(Event.CHANGE, scrollChangeHandler);
		}
		
		/**
		 * 取消事件侦听
		 */
		private function unlisten():void
		{
			_scroller.removeEventListener(Event.CHANGE, scrollChangeHandler);
		}
		
		/**
		 * 滚动条位置变更时更新列表视图
		 */
		private function scrollChangeHandler(e:Event):void 
		{
			_layout.value = _scroller.value;
		}
		
		/* INTERFACE com.tencent.morefun.naruto.plugin.ui.components.interfaces.IComponent */
		/**
		 * 控件交互激活开关
		 */
		public function get enabled():Boolean { return _enabled; }
		public function set enabled(value:Boolean):void 
		{
			_enabled = value;
			_scroller.enabled = _enabled;
			_enabled? listen() : unlisten();
		}
		
		/**
		 * 设置渲染器类
		 */
		public function get itemRenderClass():Class { return _layout.itemRenderClass; }
		public function set itemRenderClass(value:Class):void 
		{
			_layout.itemRenderClass = value;
		}
		
		/**
		 * 滚动条比例值：0~100
		 */
		public function get position():Number { return _layout.value; }
		public function set position(value:Number):void 
		{
			_layout.value = value;
			_scroller.value = _layout.value;
		}
		
		/**
		 * 滚动条像素位置
		 */
		public function get pixelPosition():Number { return _layout.position; }
		public function set pixelPosition(value:Number):void 
		{
			_layout.position = value;
			_scroller.value = _layout.value;
		}
		
		/**
		 * 列表布局组件引用
		 */
		public function get layout():MutableLayout { return _layout; }
		
		/**
		 * 滚动条组件引用
		 */
		public function get scroller():ScrollBar { return _scroller; }
		
		/**
		 * 设置滚动数据
		 */
		public function get dataProvider():Array { return _layout.dataProvider; }
		public function set dataProvider(value:Array):void 
		{
			_layout.dataProvider = value;
			
			if (_layout.scrollable)
			{
				_scroller.pageCount = Math.min(_layout.dataProvider.length - 1, _layout.pageCount);
				_scroller.lineCount =  _layout.dataProvider.length;
			}
			else
			{
				if (_scroller.pageCount <= _layout.dataProvider.length)
				{
					_scroller.pageCount = _layout.dataProvider.length + 1;
				}
				
				_scroller.lineCount = 0;
			}
			
			_scroller.value = _layout.value;
		}
		
		/**
		 * 设置列表可视宽度
		 */
		override public function get width():Number { return _layout.width; }
		override public function set width(value:Number):void 
		{
			_layout.width = value;
			_scroller.x = _layout.width;
		}
		
		/**
		 * 设置列表可视高度
		 */
		override public function get height():Number { return _layout.height; }
		override public function set height(value:Number):void 
		{
			_layout.height = value;
			_scroller.height = _layout.height;
		}
		
		/**
		 * 自动记忆位置
		 * @usage 在设置dataProvider属性时，可以自动恢复设置前的滚动位置
		 */
		public function get rememberPosition():Boolean { return _layout.rememberPosition; }
		public function set rememberPosition(value:Boolean):void 
		{
			_layout.rememberPosition = value;
		}
	}

}