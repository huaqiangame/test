package com.tencent.morefun.naruto.plugin.prewar.view.formation
{
	import com.tencent.morefun.naruto.mmefile.render.MmeAssetRender;
	import com.tencent.morefun.naruto.mmefile.render.MmeAssetRenderEvent;
	import com.tencent.morefun.naruto.plugin.prewar.HpValueBarUI;
	import com.tencent.morefun.naruto.plugin.prewar.NinjaDockViewUI;
	import com.tencent.morefun.naruto.plugin.prewar.OrderLabel;
	import com.tencent.morefun.naruto.plugin.prewar.def.NinjaDockStateDef;
	import com.tencent.morefun.naruto.plugin.ui.core.CoreValueBar;
	import com.tencent.morefun.naruto.plugin.ui.tips.TipsManager;
	import com.tencent.morefun.naruto.plugin.ui.util.DisplayUtils;
	
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	
	import cfgData.dataStruct.NinjaInfoCFG;
	
	import def.NinjaAssetDef;
	import def.TipsTypeDef;
	
	import ninja.model.data.NinjaArrangeInfo;
	import ninja.model.data.NinjaInfo;
	
	
	
	
	import user.data.NinjaInfoConfig;
	
	
	/**
	 * 阵法中的忍者
	 * @author larryhou
	 * @createTime 2013/9/27 15:01
	 */
    import com.tencent.morefun.naruto.i18n.I18n;
	public class TroopNinja extends Sprite
	{
		private var _data:NinjaArrangeInfo;
		
		private var _indicator:Sprite;
		private var _ninja:MmeAssetRender;
		
		private var _state:String;
		private var _bounds:Rectangle;
		
		private var _origin:DisplayObject;
		
		private var _dock:NinjaDock;
		private var _map:Dictionary;
		
		private var _miniMap:Dictionary;
		private var _qualified:Boolean;
		
		private var _label:OrderLabel;
		private var _order:int;
		
		private var _hpBar:CoreValueBar;
		private var _hpResUI:HpValueBarUI;
		private var _mirror:Boolean;
		
		private var _dockScaleX:Number;
		private var _dockScaleY:Number;
		
		/**
		 * 构造函数
		 * create a [TroopNinja] object
		 */
		public function TroopNinja() 
		{
			init();
		}
		
		public function get mirror():Boolean
		{
			return _mirror;
		}
		
		public function set mirror(value:Boolean):void
		{
			_mirror = value;
			if(_mirror)
			{
				_ninja.scaleX = -1;
			}
			else
			{
				_ninja.scaleX = 1;
			}
		}
		
		public function set dockScaleX(value:Number):void
		{
			for each(var disp:DisplayObject in _miniMap)
			{
				disp.scaleX = value;
			}
			
			_dockScaleX = value;
		}
		
		public function set dockScaleY(value:Number):void
		{
			for each(var disp:DisplayObject in _miniMap)
			{
				disp.scaleY = value;
			}
			
			_dockScaleY = value;
		}
		
		public function updateDockScale():void
		{
			dockScaleX = _dockScaleX;
			dockScaleY = _dockScaleY;
		}
		
		private function init():void
		{
			addChild(_indicator = new Sprite());
			mouseChildren = false;
			
			_miniMap = new Dictionary(false);
			
			_label = new OrderLabel();
			_label.mouseChildren = false;
			_label.visible = false;
			addChild(_label);
			
			_hpResUI = new HpValueBarUI();
			addChild(_hpResUI);
			_hpBar = new CoreValueBar(_hpResUI.valueMask);
			_hpResUI.mouseChildren = false;
			_hpResUI.mouseEnabled = false;
		}
		
		private function outHandler(e:MouseEvent):void 
		{
			if(data && data.life == 0){return ;}
			if (_ninja)
			{
				this.filters = [];
				this.state = NinjaDockStateDef.NORMAL;
			}
		}		
		private function overHandler(e:MouseEvent):void 
		{
			if(data && data.life == 0){return ;}
			if (_ninja)
			{
				this.filters = [new GlowFilter(0xFFDA96, 1, 3, 3, 4)];
				this.state = NinjaDockStateDef.HIGLIGHT;
			}
		}
		
		public function bindingTips(ninjaInfo:NinjaInfo):void
		{
			TipsManager.singleton.binding(this, ninjaInfo, TipsTypeDef.NINJA_INFO);
		}
		
		public function unbindingTips():void
		{
			TipsManager.singleton.unbinding(this, TipsTypeDef.NINJA_INFO);
		}
		
		/**
		 * 渲染忍者
		 */
		private function render():void
		{
			var url:String = NinjaAssetDef.getAsset(NinjaAssetDef.IMAGE, _data.ninjaId);
			addChildAt(_ninja = new MmeAssetRender(), 1);
			
			addEventListener(MouseEvent.ROLL_OVER, overHandler);
			addEventListener(MouseEvent.ROLL_OUT, outHandler);
			
			_ninja.addEventListener(MmeAssetRenderEvent.READY, function(e:Event):void
			{
				e.currentTarget.removeEventListener(e.type, arguments.callee);
				
				_label.x = _ninja.x;
				_label.y = _ninja.y - _ninja.height;
			});
			
			_ninja.loadUrlAndAutoPlay(url);
			if(!_ninja.isReady)
			{
				_ninja.addEventListener(MmeAssetRenderEvent.READY, function(evt:MmeAssetRenderEvent):void
				{
					(evt.currentTarget as MmeAssetRender).removeEventListener(MmeAssetRenderEvent.READY, arguments.callee);
					_hpResUI.y = _ninja.y - _ninja.height;
					_hpResUI.x = _ninja.x;
				});
			}
			else
			{
				_hpResUI.y = _ninja.y - _ninja.height;
				_hpResUI.x = _ninja.x;
			}
			
			var row:uint = _data.location / 3 >> 0;
			var col:uint = _data.location % 3;
			
			var refer:NinjaDock = _map[row + "_" + col];
			var dock:NinjaDock;
			
			var cfg:NinjaInfoCFG = NinjaInfoConfig.getNinjaCfgInfo(_data.ninjaId);
			var occupyHeight:int;
			var occupyWidth:int;
			
			occupyHeight = cfg.occupyHeight;
			occupyWidth = cfg.occupyWidth;
			
//			if(_hpBar.curValue != _data.life && _hpBar.maxValue != _data.lifeMax)
//			{
				_hpBar.update(_data.life, _data.lifeMax, 0);
//			}
			hpText.text = _data.life + "/" + _data.lifeMax;
			
			if(_data.life == 0)
			{
				this.filters = [DisplayUtils.disableCM];
//				this.mouseChildren = false;
//				this.mouseEnabled = false;
			}
			else
			{
				this.filters = [];
//				this.mouseChildren = true;
//				this.mouseEnabled = true;
			}
			
			if (cfg)
			{
				var item:NinjaDockViewUI;
				for (var i:int = 0; i < occupyHeight; i++)
				{
					for (var j:uint = 0; j < occupyWidth; j++)
					{
						item = new NinjaDockViewUI();
						dock = _map[(row + i) + "_" + (col + j)];
						dock.target = this;
						
						item.x = dock.x - refer.x;
						item.y = dock.y - refer.y;
						
						_indicator.addChild(item);
						_miniMap[i + "_" + j] = item;
						
						if (!_origin) _origin = item;
						
						item.visible = cfg.type != 2;
					}
				}
				
				_ninja.x = int((dock.x - refer.x) / 2);
				_ninja.y = int((dock.y - refer.y) / 2);
				_hpResUI.y = _ninja.y - _ninja.height;
				_hpResUI.x = _ninja.x;
				
				_label.x = _ninja.x;
				_label.y = _ninja.y - _ninja.height;
			}
			
			this.state = NinjaDockStateDef.NORMAL;
		}
		
		/**
		 * 模拟当前位置是否可用
		 */
		public function simulate(r0:int, l0:int, r1:int, l1:int):void
		{
			var count:uint;
			var dict:Dictionary = new Dictionary(true);
			
			var cfg:NinjaInfoCFG = NinjaInfoConfig.getNinjaCfgInfo(_data.ninjaId);
			
			var dock:NinjaDock = _map[r0 + "_" + l0];
			var offset:Point = new Point(dock.x, dock.y);
			
			var item:MovieClip;
			for (var i:int = r1; i < cfg.occupyHeight; i++)
			{
				for (var j:int = l1; j < cfg.occupyWidth; j++)
				{
					dock = _map[(i - r1 + r0) + "_" + (j - l1 + l0)];
					item = _miniMap[i + "_" + j];
					dict[item] = true;
					
					if (!dock)
					{
						item.gotoAndStop(NinjaDockStateDef.WARNING);
					}
					else
					{
						count++;
						if (dock.target && dock.target != this)
						{
							item.gotoAndStop(NinjaDockStateDef.WARNING);
						}
						else
						{
							item.gotoAndStop(NinjaDockStateDef.READY);
						}
						
						(item as MovieClip).scaleX = dock.scaleX;
						(item as MovieClip).scaleY = dock.scaleY;
						if (i > r1 || j > l1)
						{
							item.x = dock.x - offset.x;
							item.y = dock.y - offset.y;
						}
					}
				}
			}
			
			for each(item in _miniMap)
			{
				if (!dict[item]) item.gotoAndStop(NinjaDockStateDef.WARNING);
			}
			
			_qualified = (count == cfg.occupyWidth * cfg.occupyHeight);
		}
		
		/**
		 * 垃圾回收
		 */
		private function dispose():void
		{
			if (_ninja)
			{
				_ninja.destroy();
				_ninja = null;
			}
			
			while (_indicator.numChildren)
			{
				_indicator.removeChildAt(0);
			}
			
			removeEventListener(MouseEvent.ROLL_OVER, overHandler);
			removeEventListener(MouseEvent.ROLL_OUT, outHandler);
			
			_data = null;
		}
		
		private function get hpText():TextField
		{
			return _hpResUI.txt;
		}
		
		/**
		 * 忍者数据
		 */
		public function get data():NinjaArrangeInfo { return _data; }
		public function set data(value:NinjaArrangeInfo):void 
		{
			dispose();
			
			_data = value;
			_data && render();
		}
		
		/**
		 * 忍者状态
		 */
		public function get state():String { return _state; }
		public function set state(value:String):void 
		{
			_state = value;
			if (!_state || _state == NinjaDockStateDef.NONE)
			{
				_indicator.visible = false;
			}
			else
			{
				_indicator.visible = true;
				for each(var item:MovieClip in _miniMap)
				{
					item.gotoAndStop(_state);
				}
			}
		}
		
		/**
		 * 高亮底座
		 */
		public function get indicator():Sprite { return _indicator; }
		
		/**
		 * 原点对象
		 */
		public function get origin():DisplayObject { return _origin; }
		
		/**
		 * 坐标映射表
		 */
		public function get map():Dictionary { return _map; }
		public function set map(value:Dictionary):void 
		{
			_map = value;
		}
		
		/**
		 * 局部映射表
		 */
		public function get miniMap():Dictionary { return _miniMap; }
		
		/**
		 * 是否满足条件
		 */
		public function get qualified():Boolean { return _qualified; }
		
		/**
		 * 出手顺序
		 */
		public function get order():uint { return _order; }
		public function set order(value:uint):void 
		{
			_order = value;
			_label.label.htmlText = I18n.lang("as_prewar_1451031577_5359_0") + _order + I18n.lang("as_prewar_1451031577_5359_1");
		}
		
		/**
		 * 忍者头顶标签
		 */
		public function get labelVisible():Boolean { return _label.visible; }
		public function set labelVisible(value:Boolean):void
		{
			_label.visible = value;
		}
		
	}
	
}