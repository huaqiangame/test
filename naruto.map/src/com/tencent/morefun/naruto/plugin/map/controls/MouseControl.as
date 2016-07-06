package com.tencent.morefun.naruto.plugin.map.controls
{
	import com.tencent.morefun.naruto.plugin.map.views.MapView;
	import com.tencent.morefun.naruto.plugin.ui.layer.LayerManager;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import map.element.BaseMapElement;
	import map.events.MapElementEvent;
	
	import player.commands.HideAutoFindingAniCommand;
	import player.commands.SelfMoveToPixcelCommand;
	import player.commands.StopCrossBlockCommand;
	import player.commands.StopCrossSceneCommand;

	public class MouseControl
	{
		private var stage:Stage;
		private var tempPoint:Point;
		private var mapView:MapView;
		private var layers:Vector.<Sprite>;
		private var currElement:BaseMapElement;
		
		public function MouseControl(mapView:MapView,layers:Vector.<Sprite>)
		{
			this.stage = LayerManager.singleton.stage;
			this.tempPoint = new Point();
			this.mapView = mapView;
			this.layers = layers;
			this.init();
		}
		
		private function init():void
		{
			mapView.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			mapView.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			mapView.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			mapView.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
		}
		
		private function onMouseMove(e:MouseEvent):void
		{
			var element:BaseMapElement;
			var isMapView:Boolean = e.target === this.mapView;
			
			// 找到目标元素
			if (!isMapView)
			{
				element = this.findMapElement(e.target as DisplayObject);
				if (!element || !element.hitTestPoint(e.stageX, e.stageY, true))
				{
					element = this.getUnderMouseElement();
				}
			}
			
			if (this.currElement !== element)
			{
				// 让之前的元素失去焦点
				if (this.currElement)
				{
					this.currElement.dispatch(MapElementEvent.MOUSE_OUT_ELEMENT);
					this.currElement = null;
				}
				
				// 让最新的元素得到焦点
				if (element)
				{
					this.currElement = element;
					this.currElement.dispatch(MapElementEvent.MOUSE_OVER_ELEMENT);
				}
			}
		}
		
		private function onMouseOver(e:MouseEvent):void
		{
			this.onMouseMove(e);
		}
		
		private function onMouseOut(e:MouseEvent):void
		{
			if (this.currElement)
			{
				this.currElement.dispatch(MapElementEvent.MOUSE_OUT_ELEMENT);
				this.currElement = null;
			}
		}
		
		private function onMouseDown(e:MouseEvent):void
		{
			new HideAutoFindingAniCommand().call();
			new StopCrossBlockCommand().call();
			new StopCrossSceneCommand().call();
			if (this.currElement)
			{
				if (!this.currElement.isDestroyed)
				{
					this.currElement.dispatch(MapElementEvent.MOUSE_DOWN_ELEMENT);
				}
			}
			else
			{
				this.tempPoint.setTo(mapView.mouseX, mapView.mouseY);
				new SelfMoveToPixcelCommand(this.tempPoint.clone()).call();
			}
		}
		
		private function getUnderMouseElement():BaseMapElement
		{
			this.tempPoint.setTo(this.stage.mouseX, this.stage.mouseY);
			//getObjectUnderPoint在窗口小的时候，不能依据mapView来获得,必须通过stage拿才正常
			var arr:Array = this.mapView.parent.getObjectsUnderPoint(this.tempPoint);
			for(var i:int=arr.length-1; i >= 0; i--)
			{
				var dobj:DisplayObject = arr[i] as DisplayObject;
				var ele:BaseMapElement = findMapElement(dobj);
				if(ele)
				{
					if(ele.mouseEnabled && ele.hitTestPoint(this.tempPoint.x, this.tempPoint.y, true))
					{
						return ele;
					}
				}
			}
			
			return null;
		}
		
		private function findMapElement(dobj:DisplayObject):BaseMapElement
		{
			while (dobj)
			{
				if (dobj == null || dobj is Stage)
				{
					break;
				}
				
				if (dobj is BaseMapElement)
				{
					return dobj as BaseMapElement;
				}
				
				dobj = dobj.parent;
			}
			return null;
		}
		
	}
}