package com.tencent.morefun.naruto.plugin.prewar.view.formation 
{
	
	import com.tencent.morefun.framework.base.CommandEvent;
	
	import com.tencent.morefun.naruto.plugin.prewar.data.PrewarPlayerInfo;
	import com.tencent.morefun.naruto.plugin.prewar.def.NinjaDockStateDef;
	import com.tencent.morefun.naruto.plugin.prewar.def.PlayerType;
	import com.tencent.morefun.naruto.plugin.prewar.def.StatusDef;
	import com.tencent.morefun.naruto.plugin.prewar.event.NinjaEvent;
	import com.tencent.morefun.naruto.plugin.prewar.event.PrewarPlayerInfoEvent;
	import com.tencent.morefun.naruto.plugin.ui.layer.LayerManager;
	
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	
	
	
	
	
	import cfgData.dataStruct.NinjaInfoCFG;
	
	
	
	import ninja.command.RequestNinjaListCommand;
	import ninja.data.NinjaFormation;
	import ninja.def.NinjaListTypeDef;
	import ninja.model.data.NinjaArrangeInfo;
	import ninja.model.data.NinjaInfo;
	
	
	
	
	import user.data.NinjaInfoConfig;
	import user.data.UserInfo;
	
	/**
	 * 数据变更刷新视图
	 */
	[Event(name = "dataChange", type = "com.tencent.morefun.naruto.plugin.ninja.event.NinjaEvent")]
	
	/**
	 * 阵法视图
	 * @author larryhou
	 * @createTime 2013/9/27 14:56
	 */
	public class NinjaTroopView
	{
		private static const ORDER_HASH:Array = [6, 3, 0, 7, 4, 1, 8, 5, 2];
		
		private var _docks:Vector.<NinjaDock>;
		private var _view:MovieClip;
		
		private var _teamPos:int;
		private var _data:PrewarPlayerInfo;
		private var _ninjas:Vector.<TroopNinja>;
		
		private var _selfUserInfo:UserInfo;
		
		private var _container:Sprite;
		
		private var _dragTarget:TroopNinja;
		private var _origin:Point;
		
		private var _dragging:Boolean;
		private var _locked:Boolean;
		private var _qualified:Boolean;
		private var _restoring:Boolean;
		
		private var _map:Dictionary;
		private var _timestamp:uint;
		
		private var _potential:NinjaDock;
		private var _status:MovieClip;
		
		private var _isReady:Boolean;
		
		/**
		 * 构造函数
		 * create a [TroopView] object
		 */
		public function NinjaTroopView(view:MovieClip) 
		{
			super();
			
			_view = view;
			init();
		}
		
		private function init():void
		{
			_docks = new Vector.<NinjaDock>();
			_ninjas = new Vector.<TroopNinja>();
			_map = new Dictionary(false);
			
			_status = _view.status;
			if(_status){_status.visible = false;}
			
			var row:uint, col:uint;
			
			var item:NinjaDock;
			for (var i:int = 0; i < 9; i++)
			{
				item = new NinjaDock(_view["item" + i], i);
				row = i / 3 >> 0;
				col = i % 3;
				
				_docks.push(item);
				_map[row + "_" + col] = item;
			}
			
			if(_view.over)
			{
				_view.over.visible = false;
			}
			if(_view.background)
			{
				_view.background.gotoAndStop(1);
			}
			
			_view.addChild(_container = new Sprite());
			_view.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			_view.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
		}
		
		public function removeMouseListener():void
		{
			_view.removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
			_view.removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
			
			onRollOut(null)
		}
		
		public function addMouseListener():void
		{
			_view.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			_view.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
		}
		
		private function onRollOut(evt:MouseEvent):void
		{
			if(_view.over)
			{
				_view.over.visible = false;
			}
			if(_view.background)
			{
				_view.background.visible = true;
			}
		}
		
		private function onRollOver(evt:MouseEvent):void
		{
			if(_view.over)
			{
				_view.over.visible = true;
			}
			if(_view.background)
			{
				_view.background.visible = false;
			}
		}
		
		/**
		 * 忍者丢放检测
		 */
		private function simulateMonitorHandler(e:Event):void 
		{
			var time:int = getTimer();
			if (time - _timestamp < 100) return;
			
			_timestamp = time;
			_potential = null;
			
			var bounds:Rectangle;
			var position:Point;
			
			var item:MovieClip;
			for each(var dock:NinjaDock in _docks)
			{
				bounds = dock.getBounds(_view);
				for (var key:String in _dragTarget.miniMap)
				{
					item = _dragTarget.miniMap[key];
					position = item.localToGlobal(new Point(0, 0));
					position = _view.globalToLocal(position);
					
					if (bounds.contains(position.x, position.y)) break;
					key = null;
				}
				
				if (key) break;
				dock = null;
			}
			
			if (dock)
			{
				var r0:int = dock.id / 3 >> 0;
				var l0:int = dock.id % 3;
				
				var list:Array = key.match(/\d+/g);
				var r1:int = parseInt(list[0]);
				var l1:int = parseInt(list[1]);
				
				if (r1 > 0)
				{
					if (r0 >= r1)
					{
						r0 -= r1;r1 = 0;
					}
					else
					{
						r1 -= r0;r0 = 0;
					}
				}
				
				if (l1 > 0)
				{
					if (l0 >= l1)
					{
						l0 -= l1; l1 = 0;
					}
					else
					{
						l1 -= l0; l0 = 0;
					}
				}
				
				_dragTarget.simulate(r0, l0, r1, l1);
				if (_dragTarget.qualified)
				{
					_potential = dock;
				}
			}
			else
			{
				_dragTarget.state = NinjaDockStateDef.WARNING;
			}
		}
		
		public function get isReady():Boolean
		{
			return _isReady;
		}
		
		public function set isReady(value:Boolean):void
		{
			_isReady = value;
		}
		
		private function downHandler(e:MouseEvent):void 
		{
			if(_isReady)
			{
				return ;
			}
			
			var target:TroopNinja = e.target as TroopNinja;
			if (target)
			{
				_dragTarget = target;
				_origin = new Point(_view.mouseX, _view.mouseY);
				_dragTarget.updateDockScale();
				
				LayerManager.singleton.stage.addEventListener(MouseEvent.MOUSE_UP, upHandler);
				LayerManager.singleton.stage.addEventListener(MouseEvent.MOUSE_MOVE, dragMonitorHandler);
			}
		}
		
		/**
		 * 拖拽监听
		 */
		private function dragMonitorHandler(e:MouseEvent):void 
		{
			var info:NinjaFormation = _dragTarget.data as NinjaFormation;
			if (Point.distance(_origin, new Point(_view.mouseX, _view.mouseY)) >= 5)
			{
				_dragging = true;
				_container.alpha = 0.5;
				
				e.currentTarget.removeEventListener(e.type, arguments.callee);
				_view.dispatchEvent(new NinjaEvent(NinjaEvent.START_DRAG_NINJA, [_dragTarget.data, _dragTarget], true));
			}
		}
		
		private function upHandler(e:MouseEvent):void 
		{
			LayerManager.singleton.stage.removeEventListener(MouseEvent.MOUSE_UP, upHandler);
			LayerManager.singleton.stage.removeEventListener(MouseEvent.MOUSE_MOVE, dragMonitorHandler);
			
			if (_dragging)
			{
				_dragging = false;
				_container.alpha = 1;
				_view.dispatchEvent(new NinjaEvent(NinjaEvent.STOP_DRAG_NINJA, [_dragTarget.data, _dragTarget], true));
			}
		}
		
		private function onPlayerStatusUpdate(evt:PrewarPlayerInfoEvent):void
		{
			data = data;
			render();
		}
		
		private function onPlayerFormationUpdate(evt:PrewarPlayerInfoEvent):void
		{
			render();
		}
		
		public function hitTestObject(obj:DisplayObject):Boolean
		{
			return _view.hitTestObject(obj);
		}
		
		/**
		 * 获取基座位置
		 */
		public function getNinjaDock(location:uint):NinjaDock
		{
			return (location >= _docks.length)? null : _docks[location];
		}
		
		/**
		 * 重置
		 */
		private function reset():void
		{
			var target:TroopNinja;
			while (_ninjas.length)
			{
				target = _ninjas.pop();
				target.parent && target.parent.removeChild(target);
				target.map = null;
				target.data = null;
				target.unbindingTips();
			}
			
			for each(var dock:NinjaDock in _docks) dock.reset();
		}
		
		private var requestNinjaListCommand:RequestNinjaListCommand;
		private function render():void
		{
			reset();
			
			_container.alpha = 1;
			
			var dict:Dictionary = new Dictionary(true);
			for each(var ninjaArrangeInfo:NinjaArrangeInfo in _data.formationInfo.arranges)
			{
				dict[ninjaArrangeInfo.sequence] = ninjaArrangeInfo;
			}
			
			var provider:Array = [];
			for each(var info:NinjaArrangeInfo in _data.formationInfo.arranges)
			{
				provider.push(info);
			}
			
			provider.sort(function(n1:NinjaArrangeInfo, n2:NinjaArrangeInfo):int
			{
				return (ORDER_HASH[n1.location] > ORDER_HASH[n2.location])? 1 : -1;
			});
			
			var item:NinjaDock;
			var troop:TroopNinja;
			var ninjaCfgInfo:NinjaInfoCFG;
			var ninjaInfo:NinjaInfo;
			
			for (var i:int = 0; i < provider.length; i++)
			{
				info = provider[i];
				info.location = info.location%9;
				
				item = _docks[info.location];
				troop = new TroopNinja();
				troop.order = (i + 1);
				troop.map = _map;
				troop.data = info;
				
				ninjaCfgInfo = NinjaInfoConfig.getNinjaCfgInfo(info.ninjaId);
				switch(ninjaCfgInfo.property)
				{
					case 0:
						troop.state = NinjaDockStateDef.FIRE;
						break;
					case 1:
						troop.state = NinjaDockStateDef.FIRE;
						break;
					case 2:
						troop.state = NinjaDockStateDef.WIND;
						break;
					case 3:
						troop.state = NinjaDockStateDef.THUNDER;
						break;
					case 4:
						troop.state = NinjaDockStateDef.DUST;
						break;
					case 5:
						troop.state = NinjaDockStateDef.WATER;
						break;
				}
				
				troop.x = int(item.x);
				troop.y = int(item.y);
				troop.dockScaleX = item.scaleX;
				troop.dockScaleY = item.scaleY;
				troop.mirror  = !_data.isOur;
				
				_ninjas.push(troop);
				_container.addChild(troop);
			}
			
			if(_data.isSelf)
			{
				if(!requestNinjaListCommand)
				{
					requestNinjaListCommand = new RequestNinjaListCommand(NinjaListTypeDef.ALL);
					requestNinjaListCommand.addEventListener(CommandEvent.FINISH, onNinjaCommandFinish);
					requestNinjaListCommand.call();
				}
				else
				{
					updateNinjaTips();
				}
			}
			
			refreshNinjaIndex();
		}
		
		private function onNinjaCommandFinish(evt:CommandEvent):void
		{
			updateNinjaTips();
		}
		
		private function updateNinjaTips():void
		{
			var ninjaMap:Dictionary;
			
			if(requestNinjaListCommand.ninjas == null){return ;}
			
			requestNinjaListCommand.removeEventListener(CommandEvent.FINISH, onNinjaCommandFinish);
			
			ninjaMap = requestNinjaListCommand.ninjas;
			for each(var troop:TroopNinja in _ninjas)
			{
				troop.bindingTips(getNinjaInfoByNinjaId(troop.data.ninjaId, ninjaMap));
			}
		}
		
		private function getNinjaInfoByNinjaId(ninjaId:int, ninjaMap:Dictionary):NinjaInfo
		{
			var ninjaInfo:NinjaInfo;
			var ninjaList:Vector.<NinjaInfo>;
			
			ninjaList = ninjaMap[NinjaListTypeDef.ALL];
			for each(ninjaInfo in ninjaList)
			{
				if(ninjaInfo.id == ninjaId)
				{
					return ninjaInfo;
				}
			}
			
			return null;
		}
		
		/**
		 * 刷新忍者显示层级
		 */
		public function refreshNinjaIndex():void
		{
			_ninjas.sort(ninjaSortRule);
			for (var i:int = 0; i < _ninjas.length; i++)
			{
				_container.setChildIndex(_ninjas[i], i);
			}
		}
		
		private function ninjaSortRule(n1:TroopNinja, n2:TroopNinja):int
		{
			var r1:uint = n1.data.location / 3 >> 0;
			var c1:uint = n1.data.location % 3;
			
			var r2:uint = n2.data.location / 3 >> 0;
			var c2:uint = n2.data.location % 3;
			
			if (r1 > r2) return 1;
			if (r1 < r2) return -1;
			return c1 > c2? 1 : -1;
		}
		
		public function get data():PrewarPlayerInfo { return _data; }
		public function set data(value:PrewarPlayerInfo):void 
		{
			if(_data)
			{
				if(_view.background){_view.background.gotoAndStop(1);}
				_data.removeEventListener(PrewarPlayerInfoEvent.STATUS_UPDATE, onPlayerStatusUpdate);
				_data.removeEventListener(PrewarPlayerInfoEvent.FORMATION_NINJA_UPDATE, onPlayerFormationUpdate);
				LayerManager.singleton.stage.removeEventListener(MouseEvent.MOUSE_UP, upHandler);
				LayerManager.singleton.stage.removeEventListener(MouseEvent.MOUSE_MOVE, dragMonitorHandler);
			}
			
			if(_status){_status.visible = false;}
			
			_data = value;
			if(_data)
			{
				if(_data.isSelf)
				{
					if(_view.background)
					{
						_view.background.gotoAndStop(2);
					}
					_view.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
				}
				else
				{
					if(_view.background)
					{
						_view.background.gotoAndStop(1);
					}
					_view.removeEventListener(MouseEvent.MOUSE_DOWN, downHandler);
				}
				
				if(_status)
				{
					_status.visible = true;
					switch(_data.status)
					{
						case StatusDef.OPTION:
							_status.gotoAndStop("option");
							break;
						case StatusDef.READY:
							_status.gotoAndStop("ready");
							break;
					}
					
					if(_data.type == PlayerType.NPC)
					{
						_status.gotoAndStop("ready");
					}
				}
				
				_data.addEventListener(PrewarPlayerInfoEvent.STATUS_UPDATE, onPlayerStatusUpdate);
				_data.addEventListener(PrewarPlayerInfoEvent.FORMATION_NINJA_UPDATE, onPlayerFormationUpdate);
				render();
				return ;
			}
			
			reset();
		}
		
		public function get teamPos():int{return _teamPos; }
		public function set teamPos(value:int):void
		{
			_teamPos = value;
		}
		
		public function get selfUserInfo():UserInfo{return _selfUserInfo;}
		public function set selfUserInfo(value:UserInfo):void
		{
			_selfUserInfo = value;
		}
		
		/**
		 * 视图引用
		 */
		public function get view():MovieClip { return _view; }
		
		/**
		 * 基座列表
		 */
		public function get docks():Vector.<NinjaDock> { return _docks; }
		
		/**
		 * 拖拽对象
		 */
		public function get dragTarget():TroopNinja { return _dragTarget; }
		public function set dragTarget(value:TroopNinja):void 
		{
			_dragTarget = value;
			if (_dragTarget)
			{
				_dragTarget.map = _map;
				_container.alpha = 0.5;
				
				if (_dragTarget.parent)
				{
					var pos:Point = _dragTarget.parent.localToGlobal(new Point(_dragTarget.x, _dragTarget.y));
					pos = _view.globalToLocal(pos);
					
					//					_dragTarget.x = pos.x;
					//					_dragTarget.y = pos.y;
				}
				else
				{
					_dragTarget.x = _view.mouseX;
					_dragTarget.y = _view.mouseY;
				}
				
				//				_view.addChild(_dragTarget);
				_view.addEventListener(Event.ENTER_FRAME, simulateMonitorHandler);
			}
			else
			{
				_view.removeEventListener(Event.ENTER_FRAME, simulateMonitorHandler);
			}
		}
		
		/**
		 * 可以放置当前忍者的阵法位置
		 */
		public function get potential():NinjaDock { return _potential; }
		
		/**
		 * 映射表
		 */
		public function get map():Dictionary { return _map; }
		
		/**
		 *销毁 
		 * 
		 */		
		public function destroy():void
		{
			if(_data)
			{
				_data.removeEventListener(PrewarPlayerInfoEvent.STATUS_UPDATE, onPlayerStatusUpdate);
				_data.removeEventListener(PrewarPlayerInfoEvent.FORMATION_NINJA_UPDATE, onPlayerFormationUpdate);
			}
			_view.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			_view.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			reset();
			
			if(requestNinjaListCommand)
			{
				requestNinjaListCommand.removeEventListener(CommandEvent.FINISH, onNinjaCommandFinish);
				requestNinjaListCommand = null;
			}
		}
	}
	
}