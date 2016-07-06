package com.tencent.morefun.naruto.plugin.exui.uihelp 
{
	import com.tencent.morefun.naruto.util.GameTip;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * 帮助提示状态变更时派发
	 */
	[Event(name = "change", type = "flash.events.Event")]
	
	/**
	 * 帮助管理器
	 * @author larryhou
	 * @createTime 2014/10/29 14:42
	 */
    import com.tencent.morefun.naruto.i18n.I18n;
	public class UIHelpProxy extends EventDispatcher
	{
		private var _name:String;
		private var _dict:Dictionary;
		
		private var _visible:Boolean;
		
		private var _borderClass:Class;
		private var _borderWidth:Number;
		
		private var _enabled:Boolean;
		
		private var _mask:Sprite;
		
		/**
		 * 构造函数
		 * create a [UIHelpProxy] object
		 */
		public function UIHelpProxy(name:String, borderClass:Class, borderWidth:Number = 0) 
		{
			_name = name; _borderClass = borderClass; _borderWidth = borderWidth;
			_enabled = true;
			
			_mask = new Sprite();
		}
		
		/**
		 * 获取已注册的帮助提示
		 * @param	id	帮助提示id
		 */
		public function getHelp(id:String):IUIHelpTips
		{
			return _dict[id] as IUIHelpTips;
		}
		
		/**
		 * 注册帮助内容
		 * @param	help	帮助
		 */
		public function pushHelp(help:IUIHelpTips, disposeWhenRepeat:Boolean = false):void
		{
			_dict ||= new Dictionary(false);
			if (disposeWhenRepeat && _dict[help.id])
			{
				removeHelp(help.id).dispose();
			}
			
			if (!_dict[help.id])
			{
				_dict[help.id] = help;
			}
			else
			{
				GameTip.show("[" + getQualifiedClassName(this) + I18n.lang("as_exui_1451031568_1405_0") + help.id + I18n.lang("as_exui_1451031568_1405_1"));
			}
		}
		
		/**
		 * 取消注册帮助提示
		 * @param	id	帮助提示id
		 */
		public function removeHelp(id:String):IUIHelpTips
		{
			var help:IUIHelpTips = _dict[id] as IUIHelpTips;
			if (help)
			{
				help.view.parent && help.view.parent.removeChild(help.view);
				_dict[id] = null;
				
				var border:DisplayObject = _dict[help] as DisplayObject;
				if (border)
				{
					border.parent && border.parent.removeChild(border);
					_dict[help] = null;
				}
			}
			
			return help;
		}
		
		/**
		 * 绘制调试框
		 */
		private function debugAreaIn(bounds:Rectangle, container:DisplayObjectContainer, color:uint = 0xFF0000, lineWidth:uint = 1, alpha:Number = 1):void
		{
			var shape:Shape = new Shape();
			shape.graphics.lineStyle(lineWidth, color, alpha);
			shape.graphics.drawRect(bounds.x, bounds.y, bounds.width, bounds.height);
			container.addChild(shape);
		}
		
		private function debugTargetInStage(target:DisplayObject):void
		{
			var bounds:Rectangle = target.getBounds(target.stage);
			debugAreaIn(bounds, target.stage);
		}
		
		/**
		 * 在容器中显示帮助内容
		 * @param	container	帮助内容显示容器
		 */
		public function showHelpsIn(container:DisplayObjectContainer):void
		{
			if (!container.stage || !_enabled) return;
			container.stage.addEventListener(MouseEvent.CLICK, stageClickHandler, true, int.MAX_VALUE);
			
			var point:Point = container.globalToLocal(new Point(0, 0));
			
			_mask.graphics.clear();
			_mask.graphics.clear();
			_mask.graphics.beginFill(0x000000, 0.5);
			_mask.graphics.drawRect(point.x, point.y, container.stage.stageWidth, container.stage.stageHeight);
			container.addChild(_mask);
			
			const MASK_X:uint = 1 << 0;
			const MASK_Y:uint = 1 << 1;
			
			var helpCount:uint;
			var bounds:Rectangle, border:DisplayObject;
			
			var help:IUIHelpTips, flag:uint;
			for (var key:* in _dict)
			{
				help = _dict[key] as IUIHelpTips;
				if (!help || !isVisible(help.relatedObject) || !help.enabled)
				{
					help && hideHelp(help.id);
					continue;
				}
				
				helpCount++;
				bounds = help.relatedBounds;
				
				// 把坐标变换到container容器坐标空间
				point = help.relatedObject.parent.localToGlobal(new Point(help.relatedObject.x, help.relatedObject.y));
				point = container.globalToLocal(point);
				
				bounds.x += point.x;
				bounds.y += point.y;
				_mask.graphics.drawRect(bounds.x, bounds.y, bounds.width, bounds.height);
				//debugAreaIn(bounds, container);
				//debugTargetInStage(help.relatedObject);
				
				if (_borderClass)
				{
					if (help.borderEnabled)
					{
						if (!_dict[help]) _dict[help] = new _borderClass();
						border = _dict[help] as DisplayObject;
						border.height = bounds.height + _borderWidth * 2;
						border.width = bounds.width + _borderWidth * 2;
						border.x = bounds.x - _borderWidth;
						border.y = bounds.y - _borderWidth;
						if ("mouseChildren" in border) border["mouseChildren"] = false;
						if ("mouseEnabled" in border) border["mouseEnabled"] = false;
						container.addChild(border);
					}
					else
					{
						border = _dict[help] as DisplayObject;
						if (border)
						{
							border.parent && border.parent.removeChild(border);
						}
					}
				}
				
				flag = 0;
				
				// 设置X坐标：优先左对齐
				if ((help.direction & UIHelpDirection.LEFT) > 0)
				{
					flag |= MASK_X;
					help.view.x = bounds.left;
				}
				else
				if ((help.direction & UIHelpDirection.RIGHT) > 0)
				{
					flag |= MASK_X;
					help.view.x = bounds.right;
				}
				
				// 设置Y坐标：优先顶对齐
				if ((help.direction & UIHelpDirection.TOP) > 0)
				{
					flag |= MASK_Y;
					help.view.y = bounds.top;
				}
				else
				if ((help.direction & UIHelpDirection.BOTTOM) > 0)
				{
					flag |= MASK_Y;
					help.view.y = bounds.bottom;
				}
				
				if ((flag & MASK_X) == 0) //X坐标未设置默认左右居中
				{
					help.view.x = (bounds.left + bounds.right) / 2;
				}
				
				if ((flag & MASK_Y) == 0) //Y坐标未设置默认上下居中
				{
					help.view.y = (bounds.top + bounds.bottom) / 2;
				}
				
				help.view.x += help.offset.x;
				help.view.y += help.offset.y;
				
				container.addChild(help.view);
			}
			
			_mask.graphics.endFill();
			if (helpCount == 0)
			{
				_mask.parent && _mask.parent.removeChild(_mask);
			}
			
			if (!_visible)
			{
				_visible = true;
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		/**
		 * 递归检测显示对象是否可见
		 * @param	target	待检测显示对象
		 * @param	depth	递归检测的深度: 默认5层
		 */
		private function isVisible(target:DisplayObject, depth:uint = 5, index:uint = 0):Boolean
		{
			var result:Boolean = target.visible && target.stage;
			if (result && index < depth && target.parent)
			{
				result &&= arguments.callee.call(null, target.parent, index + 1);
			}
			
			return result;
		}
		
		/**
		 * 点击屏幕任意位置TIPS消失
		 */
		private function stageClickHandler(e:MouseEvent):void 
		{
			e.currentTarget.removeEventListener(e.type, arguments.callee);
			_mask && hideAllHelps();
		}
		
		/**
		 * 关闭帮助TIPS
		 */
		public function hideAllHelps():void
		{
			_mask.parent && _mask.parent.removeChild(_mask);
			
			for (var id:String in _dict)
			{
				_dict[id] && hideHelp(id);
			}
			
			if (_visible)
			{
				_visible = false;
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		/**
		 * 关闭单个TIPS
		 */
		public function hideHelp(id:String):void
		{
			var help:IUIHelpTips = _dict[id] as IUIHelpTips;
			if (help)
			{
				help.view.parent && help.view.parent.removeChild(help.view);
				
				var border:DisplayObject = _dict[help] as DisplayObject;
				if (border)
				{
					border.parent && border.parent.removeChild(border);
				}
			}
		}
		
		/**
		 * 垃圾回收
		 */
		public function dispose():void
		{
			_mask.parent && _mask.parent.removeChild(_mask);
			_mask = null;
			
			var help:IUIHelpTips;
			for (var id:String in _dict)
			{
				help = _dict[id] as IUIHelpTips;
				if (help)
				{
					removeHelp(help.id);
					help.dispose();
				}
			}
			
			_dict = null;
		}
		
		/**
		 * 管理器名字
		 */
		public function get name():String { return _name; }
		
		/**
		 * 帮助提示是否正在显示
		 */
		public function get visible():Boolean { return _visible; }
		
		/**
		 * 是否激活TIPS管理器
		 */
		public function get enabled():Boolean { return _enabled; }
		public function set enabled(value:Boolean):void 
		{
			_enabled = value;
			if (!_enabled && _visible)
			{
				hideAllHelps();
			}
		}
	}

}