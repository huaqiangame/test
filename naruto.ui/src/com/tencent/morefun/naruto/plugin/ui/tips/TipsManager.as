package com.tencent.morefun.naruto.plugin.ui.tips
{
	import com.tencent.morefun.naruto.plugin.ui.layer.LayerManager;
	import com.tencent.morefun.naruto.plugin.ui.layer.LayoutManager;
	import com.tencent.morefun.naruto.plugin.ui.layer.def.LayerDef;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;

	public class TipsManager
	{
        private static const TOOLTIP_DELAY_MILLISECONDS:int                 =   200;

		private static var ms_instance:TipsManager;
		private var m_tipsClsMap:Dictionary = new Dictionary();
		private var m_tipsViewMap:Dictionary = new Dictionary(true)
		private var m_tipsDataMap:Dictionary = new Dictionary(true);
		private var m_tipsTypeMap:Dictionary = new Dictionary(true);
		
		private var _showingTipsView:BaseTipsView;
		private var _overDisplay:DisplayObject;
        private var _timer:Timer;
		
		public function TipsManager()
		{
            _timer = new Timer(TOOLTIP_DELAY_MILLISECONDS, 1);
            _timer.addEventListener(TimerEvent.TIMER, onTimer);
		}
		
//		public function initialize():void
//		{
//			LayerManager.singleton.stage.addEventListener(Event.RESIZE, onStageResize);
//		}

        public function dispose():void
        {
            hideTips();

            _showingTipsView = null;
            _overDisplay = null;

            _timer.reset();
            _timer.removeEventListener(TimerEvent.TIMER, onTimer);
            _timer = null;
        }
		
		public static function get singleton():TipsManager
		{
			if(ms_instance == null)
			{
				ms_instance = new TipsManager();
			}
			
			return ms_instance;
		}
		
		public function registerTipsClass(type:String, viewCls:Class, skinCls:Class):void
		{
			m_tipsClsMap[type] = {cls:viewCls, skin:skinCls};
		}
		
		public function binding(displayObj:DisplayObject, data:Object, type:String = "default"):void
		{
			m_tipsDataMap[displayObj] = data;
			m_tipsTypeMap[displayObj] = type;
			
			displayObj.addEventListener(MouseEvent.ROLL_OVER, onMouseOver, false, 0, true);
			displayObj.addEventListener(MouseEvent.ROLL_OUT, onMouseOut, false, 0, true);
            displayObj.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			displayObj.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage, false, 0, true);
			
			if(displayObj == _overDisplay)
			{
				if(displayObj.hitTestPoint(LayerManager.singleton.stage.mouseX, LayerManager.singleton.stage.mouseY))
				{
					showTips(displayObj);
				}
			}
		}
		
		public function unbinding(displayObj:DisplayObject, type:String = "default"):void
		{
			displayObj.removeEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			displayObj.removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
            displayObj.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			displayObj.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
			if(displayObj == _overDisplay)
			{
				hideTips();
			}
			
			delete m_tipsDataMap[displayObj];
			delete m_tipsTypeMap[displayObj];
		}
		
		public function updateTipsData(data:Object):void
		{
			if(_showingTipsView != null && _showingTipsView.data == data)
			{
				_showingTipsView.data = data;
			}
		}
		
		public function getShowingTipsView():BaseTipsView
		{
			return _showingTipsView;
		}
		
		private function showTips(displayObj:DisplayObject):void
		{
            if (displayObj == null)
                return;

			var type:String;
			var tipsData:Object;
			var tipsRegInfo:Object;
			var tipsSkinCls:Class;
			var tipsViewCls:Class;
			var tipsView:BaseTipsView;
			
			type = m_tipsTypeMap[displayObj];
			if(type == null)
			{
				return ;
			}
			
			tipsView = m_tipsViewMap[displayObj];
			if(tipsView == null)
			{
				tipsRegInfo = m_tipsClsMap[type];
				if(tipsRegInfo == null)
				{
					return ;
				}
				
				tipsViewCls = tipsRegInfo.cls;
				tipsSkinCls = tipsRegInfo.skin;
				m_tipsViewMap[displayObj] = tipsView = new tipsViewCls(tipsSkinCls);
			}
			
			tipsData = m_tipsDataMap[displayObj];
			
			tipsView.doShow();
			tipsView.updateStageSize(LayoutManager.stageWidth, LayoutManager.stageHeight);
			tipsView.data = tipsData;
			
			_showingTipsView = tipsView;
			
			LayerManager.singleton.addItemToLayer(tipsView, LayerDef.TIPS);
//			LayerManager.singleton.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			
			tipsView.preMove(LayerManager.singleton.stage.mouseX - LayoutManager.stageOffsetX, LayerManager.singleton.stage.mouseY - LayoutManager.stageOffsetY);
		}
		
		public function hideTips():void
		{
            if (_showingTipsView == null || _showingTipsView.isShow == false)
                return;

			LayerManager.singleton.removeItemToLayer(_showingTipsView);
//			LayerManager.singleton.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);

			_showingTipsView.doHide();
			_showingTipsView.destroy();
			
			for(var key:* in m_tipsViewMap)
			{
				if(m_tipsViewMap[key] == _showingTipsView)
				{
					delete m_tipsViewMap[key];
					break;
				}
			}
			
			_showingTipsView = null;
		}
		
		private function onMouseOver(evt:MouseEvent):void
		{
            _overDisplay = evt.currentTarget as DisplayObject;
            _timer.start();
		}
		
		private function onMouseOut(evt:MouseEvent):void
		{
			hideTips();

            _overDisplay = null;
            _timer.reset();
		}
		
		private function onMouseMove(evt:MouseEvent):void
		{
            if (_showingTipsView != null)
            {
                _showingTipsView.preMove(LayerManager.singleton.stage.mouseX - LayoutManager.stageOffsetX, LayerManager.singleton.stage.mouseY - LayoutManager.stageOffsetY);
            }
            else
            {
                if (_overDisplay != null)
                {
                    _timer.reset();
                    _timer.start();
                }
            }
		}
		
        private function delayShowTips():void
        {
            showTips(_overDisplay);
        }
		
		private function onStageResize(evt:Event):void
		{
			if(_showingTipsView)
			{
				_showingTipsView.updateStageSize(LayoutManager.stageWidth, LayoutManager.stageHeight);
			}
		}
		
		private function onRemovedFromStage(evt:Event):void
		{
			var displayObject:DisplayObject;
			var tmpTipsView:DisplayObject;
			
			displayObject = evt.currentTarget as DisplayObject;
			if (displayObject)
			{
				tmpTipsView = m_tipsViewMap[displayObject];
				
				if (_showingTipsView == tmpTipsView)
				{
					hideTips();
				}
			}
			
			if(displayObject == _overDisplay)
			{
				_overDisplay = null;
				_timer.reset();
			}
		}

        private function onTimer(event:TimerEvent):void
        {
            delayShowTips();
        }
	}
}