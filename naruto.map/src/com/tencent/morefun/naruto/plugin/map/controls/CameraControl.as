package com.tencent.morefun.naruto.plugin.map.controls
{
	import com.tencent.morefun.naruto.plugin.map.views.MapView;
	import com.tencent.morefun.naruto.plugin.ui.layer.LayoutManager;
	import com.tencent.morefun.naruto.plugin.ui.util.TimerProvider;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import map.element.BaseMapElement;

	public class CameraControl
	{
		private var viewpoint:Rectangle;
		
		private var mapview:MapView;
		
		private var centerPos:Point;
		private var stage:Stage;
		private var currElement:BaseMapElement;
//		private var line:Line;
		private var speed:Point;
		
		public function CameraControl(mapview:MapView)
		{
			this.mapview = mapview;
			this.centerPos = new Point();
			this.speed = new Point();
//			
//			line = new Line(300);
//			line.x = 480;
//			line.y = 200;
		}
		
		public function setData(stage:Stage):void
		{
			this.stage = stage;
			
			viewpoint = new Rectangle(0,0,LayoutManager.stageWidth,LayoutManager.stageHeight);
			viewpointUpdated(true);
		}
		
		protected function onEnterFrame(event:Event=null):void
		{
			if (currElement)
			{
				var dx:Number = currElement.x - centerPos.x;
				var dy:Number = currElement.y - centerPos.y;
				
				if (Math.abs(dx) <= 1)
				{
					centerPos.x = int(currElement.x);
				}
				else
				{
					centerPos.x += int(dx * 0.2);
				}
				
				if (Math.abs(dy) <= 1)
				{
					centerPos.y = int(currElement.y);
				}
				else
				{
					centerPos.y += int(dy * 0.2);
				}
				
//				line.add(dx,dy);
				
				viewpointUpdated();
			}
		}
		
		protected function onResize(event:Event):void
		{
			viewpointUpdated(true);
		}
		
		public function setCenterPos(x:Number,y:Number):void
		{
			centerPos.x = x;
			centerPos.y = y;
			
			if (viewpoint)
			{
				viewpointUpdated(true);
			}
		}
		
		protected function unbindElement():void
		{
			if(currElement)
			{
				currElement = null;
			}
		}
		
		public function bindElement(value:BaseMapElement,duration:int=0,completeFun:Function=null):void
		{
			unbindElement();
			this.currElement = value;
			setCenterPos(value.x,value.y);
		}
		
		public function getCenterPosXY():Point
		{
			return centerPos;
		}
		
		private var newViewpoint:Rectangle = new Rectangle();
		
		private function viewpointUpdated(force:Boolean=false):void
		{
			var sw:int = LayoutManager.stageWidth;
			var sh:int = LayoutManager.stageHeight;
			var mw:int = mapview.mapControl.mapData.mapPixelWidth;
			var mh:int = mapview.mapControl.mapData.mapPixelHeight;
			
			newViewpoint.x = int( Math.max(0, Math.min(mw-sw, centerPos.x - (sw>>1) ) ));
			newViewpoint.y = int( Math.max(0, Math.min(mh-sh, centerPos.y - (sh>>1) )) );
			newViewpoint.width = Math.min(sw, mw);
			newViewpoint.height = Math.min(sh, mh);
			
			if (force == false && newViewpoint.equals(viewpoint))
			{
				return;
			}
			
			// 地图小于窗口大小时
			var shouldBeScrollRect:Rectangle = newViewpoint.width < sw || newViewpoint.height < sh ? newViewpoint : null;
			if (shouldBeScrollRect)
			{
				mapview.x = (sw-newViewpoint.width)>>1;
				mapview.y = (sh-newViewpoint.height)>>1;
			}
			else
			{
				mapview.x = -newViewpoint.x;
				mapview.y = -newViewpoint.y;
			}
			mapview.scrollRect = shouldBeScrollRect;
			viewpoint.copyFrom(newViewpoint);
			mapview.mapControl.update(viewpoint);
			mapview.eleControl.update(viewpoint);
		}
		
		public function startup():void
		{
//			stage.addEventListener(Event.RESIZE,onResize);
//			stage.addEventListener(Event.ENTER_FRAME,onEnterFrame,false,9);
			TimerProvider.addActiveEnterFrameTask(onEnterFrame, null, 1, 9);
//			TimerProvider.addEnterFrameTask(onEnterFrame);
		}
		
		public function dispose():void
		{
			if(stage)
			{
//				stage.removeEventListener(Event.RESIZE,onResize);
//				stage.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
				TimerProvider.removeEnterFrameTask(onEnterFrame, null, 9);
//				TimerProvider.removeEnterFrameTask(onEnterFrame);
			}
			unbindElement();
		}
		
		public function destroy():void
		{
			dispose();
		}
		
	}
}