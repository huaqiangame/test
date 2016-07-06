package com.tencent.morefun.naruto.plugin.exui.uihelp 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.display.DisplayObject;
	
	/**
	 * 普通帮助提示
	 * @author larryhou
	 * @createTime 2014/10/29 16:07
	 */
	public class UIHelpTips implements IUIHelpTips
	{
		protected var _id:String;
		protected var _view:DisplayObject;
		protected var _direction:uint;
		protected var _relatedObject:DisplayObject;
		
		protected var _relatedBoundsProvider:Function;
		protected var _enabledProvider:Function;
		
		protected var _borderEnabled:Boolean;
		protected var _offset:Point;
		
		/**
		 * 构造函数
		 * create a [UIHelpTips] object
		 */
		public function UIHelpTips(id:String, view:DisplayObject, relatedObject:DisplayObject, direction:uint)
		{
			_id = id; _view = view; _relatedObject = relatedObject; _direction = direction;
			_borderEnabled = true;
		}
		
		/**
		 * 注册外部方法计算当前TIPS是否需要显示
		 * @param	callback	函数格式: function(params:IUIHelpTips):boolean
		 */
		public function setEnabledProvider(callback:Function):void
		{
			_enabledProvider = callback;
		}
		
		/**
		 * 注册外部方法计算当前TIPS指向UI边框
		 * @param	callback	函数格式: function(params:IUIHelpTips):flash.geom.Rectangle
		 */
		public function setRelatedBoundsProvider(callback:Function):void
		{
			_relatedBoundsProvider = callback;
		}
		
		/**
		 * 垃圾回收
		 */
		public function dispose():void 
		{
			if (_view)
			{
				_view.parent && _view.parent.removeChild(_view);
				_view = null;
			}
			
			_relatedObject = null;
			_relatedBoundsProvider = null;
			_enabledProvider = null;
		}
		
		/* INTERFACE com.tencent.morefun.naruto.plugin.exui.uihelp.IUIHelpTips */
		
		public function get enabled():Boolean 
		{
			if (_enabledProvider != null)
			{
				return _enabledProvider.call(null, this);
			}
			
			return true;
		}
		
		public function get relatedBounds():Rectangle 
		{ 
			if (_relatedBoundsProvider != null)
			{
				return _relatedBoundsProvider.call(null, this);
			}
			
			return _relatedObject.getBounds(_relatedObject);
		}
		
		public function get relatedObject():DisplayObject { return _relatedObject; }
		public function set relatedObject(value:DisplayObject):void 
		{
			_relatedObject = value;
		}
		
		public function get direction():uint { return _direction; }
		public function set direction(value:uint):void
		{
			_direction = value;
		}
		
		public function get view():DisplayObject { return _view; }
		public function set view(value:DisplayObject):void 
		{
			_view = value;
		}
		
		public function get id():String { return _id; }
		
		/**
		 * 是否显示边框
		 */
		public function get borderEnabled():Boolean { return _borderEnabled; }
		public function set borderEnabled(value:Boolean):void 
		{
			_borderEnabled = value;
		}
		
		/**
		 * 箭头偏移
		 */
		public function get offset():Point { return _offset ||= new Point(); }
		public function set offset(value:Point):void 
		{
			_offset = value;
		}
	}
}