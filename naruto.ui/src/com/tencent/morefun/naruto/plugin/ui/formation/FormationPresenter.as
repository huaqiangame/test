package com.tencent.morefun.naruto.plugin.ui.formation  
{

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import tactic.model.data.TacticPositionInfo;
	

    import com.tencent.morefun.naruto.i18n.I18n;
	public class FormationPresenter extends Sprite
	{
		private var _view:MovieClip;
		private var _docks:Vector.<FormationIndicator>;
		private var _map:Dictionary;
		
		private var _troops:Vector.<SimpleTroop>;
		private var _container:Sprite;
		
		private var _occupyWidth:uint;
		private var _occupyHeight:uint;
		
		/**
		 * 构造函数
		 * create a [FormationPresenter] object
		 */
		public function FormationPresenter(view:MovieClip, occupyWidth:uint = 3, occupyHeight:uint = 3) 
		{
			_occupyWidth = occupyWidth;
			_occupyHeight = occupyHeight;
			
			addChild(_view = view);
			
			_docks = new Vector.<FormationIndicator>();
			_map = new Dictionary(false);
			
			var item:MovieClip;
			var position:Point;
			var dock:FormationIndicator;
			for (var i:int = 0; i < 9; i++)
			{
				item = _view["item" + i];
				
				position = new Point(item.x, item.y);
				item.x = item.y = 0;
				
				dock = new FormationIndicator(i, item, i % _occupyWidth, i / _occupyWidth >> 0);
				dock.x = position.x;
				dock.y = position.y;
				addChild(dock);
				
				_docks.push(dock);
				_map[dock.offsetX + "_" + dock.offsetY] = dock;
			} 	
			
			_troops = new Vector.<SimpleTroop>();
			addChild(_container = new Sprite());
		}
		
		/**
		 * 设置战法站位加成信息
		 */
		public function setTacticPositionAdditions(list:Vector.<TacticPositionInfo>):void
		{
			list ||= new Vector.<TacticPositionInfo>();
			list.length = _docks.length;
			
			for (var i:int = 0; i < _docks.length; i++)
			{
				_docks[i].tacticPositionInfo = list[i];
			}
		}
		
		/**
		 * 获取阵法指示器
		 * @param	offsetX	阵法横坐标偏移
		 * @param	offsetY	阵法竖坐标偏移
		 */
		public function getIndicator(offsetX:uint, offsetY:uint):FormationIndicator
		{
			return _map[offsetX + "_" + offsetY] as FormationIndicator;
		}
		
		/**
		 * 尝试放置阵法
		 */
		public function locate(troop:SimpleTroop):FormationIndicator
		{
			troop.located = false;
			
			var pos:Point;
			var item:TroopIndicator;
			var dock:FormationIndicator;
			
			var flag:Boolean;
			for each(dock in _docks)
			{
				for each (item in troop.indicators)
				{
					pos = new Point(item.anchorX, item.anchorY);
					pos = item.parent.localToGlobal(pos);
					
					if (dock.hitTestPoint(pos.x, pos.y))
					{
						flag = true;
						break;
					}
				}
				
				if (flag) break;
			}
			
			if (flag)
			{
				var status:uint = troop.updateArea(item.offsetX, item.offsetY, dock, _map);
				if ((status & LocateStatusDef.LOCATE_FAIL_NULL) == 0)
				{
					dock = getIndicator(dock.offsetX - item.offsetX, dock.offsetY - item.offsetY);
					if (dock) return dock;
				}
			}
			else
			{
				troop.layoutUpdate(true);
				troop.status = IndicatorStatusDef.FAIL;
			}
			
			return null;
		}
		
		/**
		 * 放置小队到阵法上
		 * @param	troop	SimpleTroop对象
		 */
		public function pushTroopInFormation(troop:SimpleTroop):Boolean
		{
			if (!checkTroopValidate(troop)) 
			{
				throw new Error(this + I18n.lang("as_ui_1451031579_6176"));
				return false;
			}
			
			var dock:FormationIndicator;
			dock = _docks[troop.location];
			
			var dict:Dictionary = new Dictionary(true);
			
			var refer:FormationIndicator;
			for (var i:int = 0; i < troop.occupyWidth; i++)
			{
				for (var j:int = 0; j < troop.occupyHeight; j++)
				{
					refer = getIndicator(dock.offsetX + i, dock.offsetY + j);
					if (!refer)
					{
						throw new Error(this + I18n.lang("as_ui_1451031579_6177"));
					}
					
					refer.occupied = true;
					refer.target = troop;
					
					dict[i + "_" + j] = new Point(refer.x - dock.x, refer.y - dock.y);
				}
			}
			
			troop.x = dock.x;
			troop.y = dock.y;
			troop.status = IndicatorStatusDef.NORMAL;
			troop.setIndicatorMap(dict);
			
			_troops.push(troop);
			_container.addChild(troop);
			return true;
		}
		
		/**
		 * 检测小队是否合法
		 */
		private function checkTroopValidate(troop:SimpleTroop, strictMode:Boolean = true):Boolean
		{
			var dock:FormationIndicator;
			dock = _docks[troop.location];
			if (!dock) return false;
			
			var refer:FormationIndicator;
			for (var i:int = dock.offsetX; i < troop.occupyWidth; i++)
			{
				for (var j:int = dock.offsetY; j < troop.occupyHeight; j++)
				{
					refer = _map[i + "_" + j] as FormationIndicator;
					if (strictMode)
					{
						if (!refer || refer.occupied) return false;
					}
					else
					{
						if (!refer) return false;
					}
				}
			}
			
			return true;
		}
		
		/**
		 * 刷新小队显示层深顺序
		 */
		public function refreshTroopDepth():void
		{
			_troops.sort(depthSortRule);
			for (var i:int = 0; i < _troops.length; i++)
			{
				_container.setChildIndex(_troops[i], i);
			}
		}
		
		/**
		 * 深度排序算法
		 */
		private function depthSortRule(n1:SimpleTroop, n2:SimpleTroop):int
		{
			var r1:uint = n1.location / _occupyWidth >> 0;
			var c1:uint = n1.location % _occupyWidth;
			
			var r2:uint = n2.location / _occupyWidth >> 0;
			var c2:uint = n2.location % _occupyWidth;
			
			if (r1 > r2) return 1;
			if (r1 < r2) return -1;
			return c1 > c2? 1 : -1;
		}
		
		/**
		 * 重置标记位
		 */
		public function resetOccupyFlags():void
		{
			for each(var dock:FormationIndicator in _docks) dock.reset();
		}
		
		/**
		 * 垃圾回收
		 */
		public function reset():void
		{
			var troop:SimpleTroop;
			while (_troops.length)
			{
				troop = _troops.pop();
				troop.dispose();
				
				troop.parent && troop.parent.removeChild(troop);
			}
			
			resetOccupyFlags();
		}
		
		/**
		 * 垃圾回收
		 */
		public function dispose():void
		{
			reset();
			while (_docks.length)
			{
				_docks.pop().dispose();
			}
		}
		
		/**
		 * 复写宽高
		 */
		override public function get width():Number { return _view.width; }
		override public function get height():Number { return _view.height; }
		
		/**
		 * 小队显示容器
		 */
		public function get container():Sprite { return _container; }
		
		/**
		 * 阵法宽度
		 */
		public function get occupyWidth():uint { return _occupyWidth; }
		
		/**
		 * 阵法高度
		 */
		public function get occupyHeight():uint { return _occupyHeight; }
		}

}