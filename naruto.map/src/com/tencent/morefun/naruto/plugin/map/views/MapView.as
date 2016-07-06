package com.tencent.morefun.naruto.plugin.map.views
{
	import com.tencent.morefun.naruto.plugin.map.controls.CameraControl;
	import com.tencent.morefun.naruto.plugin.map.controls.DeepControl;
	import com.tencent.morefun.naruto.plugin.map.controls.ElementControl;
	import com.tencent.morefun.naruto.plugin.map.controls.MapControl;
	import com.tencent.morefun.naruto.plugin.map.controls.MouseControl;
	
	import flash.display.Sprite;
	
	import map.def.MapLayerDef;
	
	import ui.map.MoveTargetUI;

	public class MapView extends Sprite
	{
		private var _mapControl:MapControl;
		private var _cameraControl:CameraControl;
		private var _deepControl:DeepControl;
		private var _eleControl:ElementControl;
		private var _mouseControl:MouseControl;
		
		public var layers:Vector.<Sprite>;
		
		public var moveTargetUi:MoveTargetUI;
		
		
		public function MapView()
		{
			super();
			
			moveTargetUi = new MoveTargetUI();
			moveTargetUi.stop();
			
			init();
		}
		
		public function get mapControl():MapControl
		{
			return _mapControl;
		}
		
		public function get cameraControl():CameraControl
		{
			return _cameraControl;
		}
		
		public function get deepControl():DeepControl
		{
			return _deepControl;
		}
		
		public function get eleControl():ElementControl
		{
			return _eleControl;
		}
		
		
		private function init():void
		{
//			moveTargetUi = new moveTargetUI();
			layers = new Vector.<Sprite>(MapLayerDef.COUNT,true);
			for(var i:int=0;i<MapLayerDef.COUNT;i++)
			{
				layers[i] = new Sprite();
				layers[i].name = ""+i;
				layers[i].mouseChildren = layers[i].mouseEnabled = true;
				addChild(layers[i]);
			}
			
			layers[MapLayerDef.POPUP].mouseChildren = layers[MapLayerDef.POPUP].mouseEnabled = false;
			layers[MapLayerDef.BOTTOM_MAP].mouseChildren = layers[MapLayerDef.BOTTOM_MAP].mouseEnabled = false;
			layers[MapLayerDef.FRONT_MAP].mouseChildren = layers[MapLayerDef.FRONT_MAP].mouseEnabled = false;
			
			_mapControl = new MapControl(layers);
			_eleControl = new ElementControl(layers);
			_deepControl = new DeepControl(layers);
			_cameraControl = new CameraControl(this);
			_mouseControl = new MouseControl(this,layers);
		}
		
		public function startup():void
		{
			_deepControl.startup();
			_cameraControl.startup();
		}
		
		public function dispose():void
		{
			hideMoveTargetUI();
			_deepControl.dispose();
			_eleControl.dispose();
			_mapControl.dispose();
			_cameraControl.dispose();
		}
		
		public function destroy():void
		{
			if(_mapControl)
			{
				_mapControl.destroy();
				_mapControl = null;
			}
			if(_cameraControl)
			{
				_cameraControl.destroy();
				_cameraControl = null;
			}
			if(_deepControl)
			{
				_deepControl.destroy();
				_deepControl = null;
			}
		}
		
		public function showMoveTargetUI(x:int,y:int):void
		{
			moveTargetUi.x = x;
			moveTargetUi.y = y;
			moveTargetUi.play();
			
			layers[MapLayerDef.MIDDLE_ELEMENT].addChild(moveTargetUi);
		}
		
		public function hideMoveTargetUI():void
		{
			moveTargetUi.stop();
			if(moveTargetUi.parent)
			{
				moveTargetUi.parent.removeChild(moveTargetUi);
			}
		}
	}
}