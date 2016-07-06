package com.tencent.morefun.naruto.plugin.ui.formation  
{
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	

	public class SimpleTroop extends Sprite
	{
		private static const TWEEN_DURATION:Number = 0.1;		
		
		protected var _occupyWidth:uint;
		protected var _occupyHeight:uint;
		protected var _gap:uint;
		
		protected var _map:Dictionary;
		
		protected var _indicators:Vector.<TroopIndicator>;
		protected var _located:Boolean;
		
		protected var _status:String;
		protected var _indicatorClass:Class;
		
		protected var _center:Point;
		protected var _location:uint;
		
		protected var _adsorptable:Boolean;
		
		/**
		 * 构造函数
		 * create a [SimpleTroop] object
		 */
		public function SimpleTroop(indicatorClass:Class, gap:uint = 10) 
		{
			_gap = gap;
			_indicatorClass = indicatorClass;
			
			_indicators = new Vector.<TroopIndicator>();
			_map = new Dictionary(false);
			
			_center = new Point();
		}
		
		/**
		 * 获取小队指示器
		 * @param	offsetX	横向偏移
		 * @param	offsetY	竖向偏移
		 */
		public function getIndicator(offsetX:uint, offsetY:uint):TroopIndicator
		{
			return _map[offsetX + "_" + offsetY] as TroopIndicator;
		}
		
		/**
		 * 更新固定区域的指示器坐标显示
		 * @param	offsetX	横向偏移
		 * @param	offsetY	竖向偏移
		 * @param	dockMap	坐标映射表
		 * @return	@see LocateStatusDef
		 */
		public function updateArea(offsetX:uint, offsetY:uint, refer:FormationIndicator, dockMap:Dictionary):uint
		{
			var status:uint = 0;
			
			var pos:Point;
			var count:uint;
			var item:TroopIndicator;
			var index:uint, dock:FormationIndicator;
			for (var i:uint = 0; i < _occupyWidth; i++)
			{
				for (var j:uint = 0; j < _occupyHeight; j++)
				{
					item = _map[i + "_" + j] as TroopIndicator;
					if (!item) continue;
					
					if (i >= offsetX && j >= offsetY)
					{
						dock = dockMap[(i - offsetX + refer.offsetX) + "_" + (j - offsetY + refer.offsetY)] as FormationIndicator;
						if (dock)
						{
							pos = new Point(dock.x, dock.y);
							pos = dock.parent.localToGlobal(pos);
							pos = globalToLocal(pos);
							
							if (_adsorptable)
							{
								TweenLite.killTweensOf(item);
								TweenLite.to(item, TWEEN_DURATION, { x:pos.x, y:pos.y } );
							}
							
							if (dock.occupied && dock.target != this)
							{
								item.status = IndicatorStatusDef.FAIL;
								status |= LocateStatusDef.LOCATE_FAIL_OCCUPIED;
							}
							else
							{
								count++;
								item.status = IndicatorStatusDef.PASS;
								status |= LocateStatusDef.LOCATE_PASS;
							}
						}
						else
						{
							if (_adsorptable)
							{
								TweenLite.killTweensOf(item);
								TweenLite.to(item, TWEEN_DURATION, { x:item.anchorX, y:item.anchorY } );
							}
							
							item.status = IndicatorStatusDef.FAIL;
							status |= LocateStatusDef.LOCATE_FAIL_NULL;
						}
					}
					else
					{
						if (_adsorptable)
						{
							TweenLite.killTweensOf(item);
							TweenLite.to(item, TWEEN_DURATION, { x:item.anchorX, y:item.anchorY } );
						}
						
						item.status = IndicatorStatusDef.FAIL;
						status |= LocateStatusDef.LOCATE_FAIL_NULL;
					}
				}
			}
			
			_located = count == _indicators.length;
			return status;
		}
		
		/**
		 * 设置占用
		 * @param	occupyWidth		占用格子宽度
		 * @param	occupyHeight	占用格子高度
		 */
		public function setArea(occupyWidth:uint, occupyHeight:uint):void
		{
			_occupyWidth = occupyWidth; _occupyHeight = occupyHeight;
			
			var count:uint = _occupyWidth * _occupyHeight;
			while (_indicators.length)
			{
				item = _indicators.pop();
				item.parent && item.parent.removeChild(item);
				item.dispose();
				
				delete _map[item.offsetX + "_" + item.offsetY];
			}
			
			var item:TroopIndicator;
			for (var k:int = 0; k < count; k++)
			{
				item = new TroopIndicator(new _indicatorClass(), k % _occupyWidth, k / _occupyWidth >> 0);
				item.status = IndicatorStatusDef.NORMAL;
				
				_indicators.push(addChild(item));
				_map[item.offsetX + "_" + item.offsetY] = item;
			}
			
			layoutUpdate(false);
			for each(item in _indicators) item.setAnchor(item.x, item.y);
			
			item = getIndicator(0, 0);
			
			_center.x = item.x;
			_center.y = item.y;
			
			item = getIndicator(_occupyWidth - 1, _occupyHeight - 1);
			_center.x = (item.x + _center.x) / 2;
			_center.y = (item.y + _center.y) / 2;
		}
		
		/**
		 * 设置指示器的坐标空间
		 * @param	dict	坐标映射表
		 */
		public function setIndicatorMap(dict:Dictionary):void
		{
			var pos:Point;
			var item:TroopIndicator;
			for (var key:String in dict)
			{
				pos = dict[key] as Point;
				item = _map[key] as TroopIndicator;
				item.x = pos.x;
				item.y = pos.y;
			}
		}
		
		/**
		 * 布局更新
		 */
		public function layoutUpdate(useTween:Boolean = false):void
		{
			var item:TroopIndicator;
			var locX:Number = 0, locY:Number = 0;
			for (var j:int = 0; j < _occupyHeight; j++)
			{
				locX = 0;
				for (var i:int = 0; i < _occupyWidth; i++)
				{
					item = _map[i + "_" + j];
					if (!useTween)
					{
						item.x = locX;
						item.y = locY;
					}
					else
					{
						TweenLite.killTweensOf(item);
						TweenLite.to(item, TWEEN_DURATION, { x:item.anchorX, y:item.anchorY } );
					}
					
					locX += item.width + _gap;
				}
				
				locY += item.height + _gap;
			}
		}
		
		/**
		 * 垃圾回收
		 */
		public function dispose():void
		{
			var item:TroopIndicator;
			while (_indicators.length)
			{
				item = _indicators.pop();
				item.parent && item.parent.removeChild(item);
				item.dispose();
				
				delete _map[item.offsetX + "_" + item.offsetY];
			}
		}
		
		/**
		 * 占用行
		 */
		public function get occupyWidth():uint { return _occupyWidth; }
		
		/**
		 * 占用列
		 */
		public function get occupyHeight():uint { return _occupyHeight; }
		
		/**
		 * 默认指示器间隔
		 */
		public function get gap():uint { return _gap; }	
		
		/**
		 * 是否已经在阵法上定位到坐标
		 */
		public function get located():Boolean { return _located; }
		public function set located(value:Boolean):void 
		{
			_located = value;
		}
		
		/**
		 * 指示器列表
		 */
		public function get indicators():Vector.<TroopIndicator> { return _indicators; }
		
		/**
		 * 中心点坐标
		 */
		public function get center():Point { return new Point(); }
		
		/**
		 * 小队状态
		 */
		public function get status():String { return _status; }
		public function set status(value:String):void 
		{
			_status = value;
			for each(var item:TroopIndicator in _indicators) item.status = _status;
		}
		
		/**
		 * 阵法位置
		 */
		public function get location():uint { return _location; }
		public function set location(value:uint):void 
		{
			_location = value;
		}
		
		/**
		 * 是否有网格吸附效果
		 */
		public function get adsorptable():Boolean { return _adsorptable; }
		public function set adsorptable(value:Boolean):void 
		{
			_adsorptable = value;
		}
		}

}