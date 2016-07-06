package com.tencent.morefun.naruto.plugin.ui.components.wrappers
{	
	import com.tencent.morefun.naruto.plugin.ui.components.interfaces.IRender;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	/**
	 * 列表渲染器包装器
	 * @author larryhou&georgehu
	 */
    import com.tencent.morefun.naruto.i18n.I18n;
	public class RenderWrapper extends Sprite
	{
		private var _data:Object = null;
		
		private var _index:int = 0;
		private var _dataIndex:int = 0;
		
		private var _scrolling:Boolean = false;
		
		private var _target:IRender = null;
		
		/**
		 * 构造函数
		 * create a [RenderWrapper] object 
		 * @param	RenderClass		渲染器类
		 */
		public function RenderWrapper(RenderClass:Class)
		{
			mouseEnabled = false;
			
			_target = new RenderClass() as IRender;
			if (_target is DisplayObject)
			{
				addChild(_target as DisplayObject);
				
				if (this.width == 0 || this.height == 0)
				{
					throw new ArgumentError(_target + I18n.lang("as_ui_1451031579_6174"));
				}
			}
			else
			{
				throw new ArgumentError(RenderClass + I18n.lang("as_ui_1451031579_6175"));
			}
		}
		
		/**
		 * 垃圾回收
		 */
		public function dispose():void
		{
			if (_target)
			{
				var item:DisplayObject = _target as DisplayObject;
				item.parent && item.parent.removeChild(item);
				
				_target.data = null;
			}
			
			var method:String = "dispose";
			if (_target && (method in _target))
			{
				if (_target[method] is Function)
				{
					(_target[method] as Function).call();
				}
			}
			
			_target = null;
			_data = null;
		}
		
		/**
		 * 数据，如果必要，需要将data转换成特定类型
		 */
		public function get data():Object { return _data; }
		public function set data(value:Object):void
		{
			_data = value;
			_target.data = value;
			
		}
		
		/**
		 * 视图索引
		 */
		public function get index():int { return _index; }
		public function set index(value:int):void 
		{
			_index = value;
			try{
				if(_target["index"]!=undefined){
					_target["index"] = index;
				}
			}
			catch( errObject:Error){
				
			}
		}
		
		/**
		 * 数据索引
		 */
		public function get dataIndex():int { return _dataIndex; }
		public function set dataIndex(value:int):void 
		{
			_dataIndex = value;
			
		}
		
		/**
		 * 优先使用Renderer的高度
		 */
		override public function get height():Number { return DisplayObject(_target).height; }
		
		/**
		 * 优先使用Renderer的宽度
		 */
		override public function get width():Number { return DisplayObject(_target).width; }
		
		/**
		 * 渲染器实例对象
		 */
		public function get target():IRender { return _target; }
		
		/**
		 * 是否正在滚动
		 */
		public function get scrolling():Boolean { return _scrolling; }
		public function set scrolling(value:Boolean):void
		{
			_scrolling = value;
		}
	}

}