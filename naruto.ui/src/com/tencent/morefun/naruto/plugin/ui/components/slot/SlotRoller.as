package com.tencent.morefun.naruto.plugin.ui.components.slot 
{
	import com.greensock.TweenLite;
	import com.tencent.morefun.naruto.i18n.I18n;
	import com.tencent.morefun.naruto.plugin.ui.components.interfaces.IRender;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * 抽奖效果完成时派发
	 */
	[Event(name = "complete", type = "flash.events.Event")]
	
	/**
	 * 更换物品时派发
	 */
	[Event(name = "change", type = "flash.events.Event")]
	
	/**
	 * 老虎机滚动器
	 * @author larryhou
	 * @createTime 2015/3/9 15:41
	 */
    import com.tencent.morefun.naruto.i18n.I18n;
	public class SlotRoller extends Sprite
	{
		private static const SWAP_UP	:uint = 1;
		private static const SWAP_DOWN	:uint = 2;
		private static const SWAP_NONE	:uint = 0;
		
		private var _dataProvider:Array;
		private var _items:Vector.<IRender>;
		private var _content:DisplayObjectContainer;
		private var _gap:Number;
		
		private var _initSpeed:Number;
		private var _exitSpeed:Number;
		
		private var _viewport:Rectangle;
		private var _index:int;
		
		private var _info:RuntimeObj;
		
		private var _duration:Number;
		private var _ratio:Number;
		
		private var _complete:Boolean;
		private var _prize:Object;
		
		private var _lite:TweenLite;
		
		private var _currentItem:IRender;
		
		/**
		 * 构造函数
		 * create a [SlotRoller] object
		 */
		public function SlotRoller(renderClass:Class, gap:Number = 0)
		{
			_items = new Vector.<IRender>();
			_gap = gap;
			
			addChild(_content = new Sprite());
			
			var position:Number = 0;
			
			var item:DisplayObject;
			while (_items.length < 2)
			{
				item = new renderClass();
				if (item is IRender && item is Sprite)
				{
					item.x = 0;
					item.y = position;
					position += item.height + gap;
					
					_items.push(item as IRender);
					_content.addChild(item);
				}
				else
				{
					throw new ArgumentError(I18n.lang("as_ui_1451031579_6167_0") + getQualifiedClassName(IRender) + I18n.lang("as_ui_1451031579_6167_1") + getQualifiedClassName(Sprite));
				}
			}
			
			_viewport = new Rectangle(0, 0, DisplayObject(item).width, DisplayObject(item).height);
			_content.scrollRect = _viewport;
			
			_ratio = 0.4;
			
			_initSpeed = 10;
			_exitSpeed = 5;
		}
		
		/**
		 * 开始摇奖动画
		 * @param	prize		被抽到对象
		 * @param	duration	摇奖过程持续时间
		 */
		public function start(prize:Object, duration:Number):void
		{
			_duration = duration;
			_prize = prize;
			
			if (!_initSpeed || !_exitSpeed)
			{
				throw new Error(I18n.lang("as_ui_1451031579_6168"));
				return;
			}
			
			_info = new RuntimeObj();
			_info.speed = _initSpeed;
			
			TweenLite.killTweensOf(_lite);
			_lite = TweenLite.delayedCall(_ratio * _duration, slowdown);
			_complete = false;
			
			addEventListener(Event.ENTER_FRAME, rollTickHandler);
		}
		
		/**
		 * 滚动逻辑
		 */
		private function rollTickHandler(e:Event):void 
		{
			var item:DisplayObject;
			if (!_info.complete)
			{
				_viewport.y += _info.speed;
				
				var state:uint = scrollUpdate();
				if (state)
				{
					if (_complete)
					{
						_info.complete = true;
						if (state == SWAP_UP)
						{
							item = _items[1] as DisplayObject;
							IRender(item).data = _prize;
							
							_info.distance = item.y - _content.scrollRect.y;
						}
						else
						if (state == SWAP_DOWN)
						{
							item = _items[0] as DisplayObject;
							IRender(item).data = _prize;
							
							_info.distance = item.y - _content.scrollRect.y;
						}
						
						_currentItem = item as IRender;
					}
					
					dispatchEvent(new Event(Event.CHANGE));
				}
			}
			else
			{
				var speed:Number = _info.speed;
				if (Math.abs(_info.speed) > Math.abs(_info.distance))
				{
					speed = _info.distance;
				}
				
				_viewport.y += speed;
				_content.scrollRect = _viewport;
				
				_info.distance -= speed;
				if (_info.distance == 0)
				{
					removeEventListener(Event.ENTER_FRAME, rollTickHandler);
					dispatchEvent(new Event(Event.COMPLETE));
				}
			}
		}
		
		/**
		 * 延时减速
		 */
		private function slowdown():void 
		{
			_lite = TweenLite.to(_info, (1 - _ratio) * _duration, { speed:_exitSpeed, onComplete:function():void
			{
				_complete = true;
			}});
		}
		
		/**
		 * 滚动时更新布局
		 */
		private function scrollUpdate():uint
		{
			_content.scrollRect = _viewport;
			
			var item:DisplayObject = _items[0] as DisplayObject;
			var rest:DisplayObject = _items[1] as DisplayObject;
			
			var position:Number = item.y - _content.scrollRect.y;
			if (position + item.height <= 0)
			{
				_items.shift();
				
				item.y = rest.y + rest.height + _gap;
				IRender(item).data = _dataProvider[getUniqueIndex()];
				
				_items.push(_currentItem = item as IRender);
				
				return SWAP_UP;
			}
			else
			if (position >= 0)
			{
				_items.pop();
				
				rest.y = item.y - rest.height - _gap;
				IRender(rest).data = _dataProvider[getUniqueIndex()];
				
				_items.unshift(_currentItem = rest as IRender);
				
				return SWAP_DOWN;
			}
			
			return SWAP_NONE;
		}
		
		/**
		 * 获得随机不重复索引
		 */
		private function getUniqueIndex():uint
		{
			if (_dataProvider.length <= 1) return _index = 0;
			
			var index:uint;
			while (true)
			{
				index = _dataProvider.length * Math.random() >> 0;
				if (index != _index) break;
			}
			
			return _index = index;
		}
		
		/**
		 * 垃圾回收
		 */
		public function dispose():void
		{
			TweenLite.killTweensOf(_lite);
			_lite = null;
			_info = null;
			
			removeEventListener(Event.ENTER_FRAME, rollTickHandler);
			
			_content.removeChildren();
			_content.parent && _content.parent.removeChild(_content);
			_content = null;
			
			while (_items.length)
			{
				_items.pop().dispose();
			}
			
			_items = null;
			_dataProvider = null;
		}
		
		/**
		 * 摇奖数据池
		 */
		public function get dataProvider():Array { return _dataProvider; }
		public function set dataProvider(value:Array):void
		{
			_dataProvider = value || [];
			
			_viewport.y = 0;
			_content.scrollRect = _viewport;
			
			_index = 0;
			
			var position:Number = 0;
			for (var i:int = 0; i < _items.length; i++)
			{
				_items[i].data = _dataProvider[getUniqueIndex()];
				DisplayObject(_items[i]).y = position;
				
				position += DisplayObject(_items[i]).height + _gap;
			}
			
			_currentItem = _items[0];
		}
		
		/**
		 * 初始速度: pixel/frame
		 * @default 10
		 */
		public function get initSpeed():Number { return _initSpeed; }
		public function set initSpeed(value:Number):void 
		{
			_initSpeed = isNaN(value)? 0 : value;
		}
		
		/**
		 * 结束速度: pixel/frame
		 * @default 5
		 */
		public function get exitSpeed():Number { return _exitSpeed; }
		public function set exitSpeed(value:Number):void 
		{
			_exitSpeed = isNaN(value)? 0 : value;
		}
		
		/**
		 * 间距: pixels
		 */
		public function get gap():Number { return _gap; }
		public function set gap(value:Number):void 
		{
			_gap = isNaN(value)? 0 : value;
		}
		
		/**
		 * 匀速摇奖时间占比
		 * @default 0.4
		 */
		public function get ratio():Number { return _ratio; }
		public function set ratio(value:Number):void 
		{
			_ratio = isNaN(value)? 0 : Math.min(1, Math.max(0, value));
		}
		
		/**
		 * 当前数据
		 */
		public function get currentItem():IRender { return _currentItem; }
		
		/**
		 * 尺寸矫正
		 */
		override public function get height():Number { return _viewport.height; }
		override public function get width():Number { return _viewport.width; }
	}
}
import com.greensock.TweenLite;

class RuntimeObj
{
	public var speed:Number;
	public var distance:Number;
	public var complete:Boolean;
}