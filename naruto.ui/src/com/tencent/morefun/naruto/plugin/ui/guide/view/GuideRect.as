package com.tencent.morefun.naruto.plugin.ui.guide.view
{	
	import com.tencent.morefun.naruto.plugin.ui.layer.LayerManager;
	import com.tencent.morefun.naruto.plugin.ui.layer.LayoutManager;
	import com.tencent.morefun.naruto.plugin.ui.layer.def.LayerDef;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import ui.guide.RectLight;
	
	public class GuideRect extends Sprite
	{
		private var rectUi:RectLight;
		private var mask1:Sprite;
		private var mask2:Sprite;
		private var mask3:Sprite;
		private var mask4:Sprite;
		private var isMask:Boolean;
		private var target:DisplayObject;
		private var targetFrameOffsetRect:Rectangle;
		private var timer:Timer;
		private var targetX:int;
		private var targetY:int;
		
		public function GuideRect(width:int, height:int, mask:Boolean, target:DisplayObject = null, targetFrameOffsetRect:Rectangle = null)
		{
			super();
			
			rectUi = new RectLight();
			rectUi.width = width;
			rectUi.height = height;
			addChild(rectUi);
			
			this.mouseEnabled = false;
			rectUi.mouseChildren = rectUi.mouseEnabled = false;
			
			this.target = target;
			(target) && (addEventListener(Event.ADDED_TO_STAGE, onAddedToStage));
			isMask = mask;
			(mask) && (setupMask());
			
			this.targetFrameOffsetRect = targetFrameOffsetRect;
		}
		
		private function updateMask(evt:Event = null):void
		{
			var stagePoint:Point;
			var frameLineWidth:int = 5;  //蓝色线到rectUI的最外围有一段距离，这部分也要盖住
			
			if (LayoutManager.singleton.stage.contains(this))
			{
				stagePoint = this.globalToLocal(new Point(LayoutManager.stageOffsetX, LayoutManager.stageOffsetY));
				setMaskPosition(mask1, stagePoint.x, stagePoint.y, -stagePoint.x+frameLineWidth, LayoutManager.stageHeight);
				setMaskPosition(mask2, rectUi.width-frameLineWidth, stagePoint.y, stagePoint.x+LayoutManager.stageWidth-rectUi.width+frameLineWidth, LayoutManager.stageHeight);
				setMaskPosition(mask3, frameLineWidth, stagePoint.y, rectUi.width-2*frameLineWidth, -stagePoint.y+frameLineWidth);
				setMaskPosition(mask4, frameLineWidth, rectUi.height-frameLineWidth, rectUi.width-2*frameLineWidth, stagePoint.y+LayoutManager.stageHeight-rectUi.height+frameLineWidth);
			}
		}
		
		private function setupMask():void
		{
			mask1 = new Sprite();
			mask2 = new Sprite();
			mask3 = new Sprite();
			mask4 = new Sprite();
			
			this.addEventListener(Event.ADDED_TO_STAGE, initMask);
		}
		
		private function initMask(evt:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, initMask);
			updateMask(null);
			LayoutManager.singleton.stage.addEventListener(Event.RESIZE, onResizeHandleMask);
		}
		
		protected function onResizeHandleMask(event:Event):void
		{
			updateMask();
		}
		
		public function destory():void
		{
			stopTimer();
			timer = null;
			
			removeChildren();
			rectUi = null;
			if (isMask) 
			{
				LayoutManager.singleton.stage.removeEventListener(Event.RESIZE, onResizeHandleMask);
				this.removeEventListener(Event.ADDED_TO_STAGE, initMask);
				removeMask();
			}
			if (target)
			{
				removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
				removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
				LayoutManager.singleton.stage.removeEventListener(Event.RESIZE, onResizeHandleTrackTarget);
			}
			mask1 = mask2 = mask3 = mask4 = null;
		}
		
		private function setMaskPosition(mask:Sprite, x:Number, y:Number, width:Number, height:Number):void
		{
			var stagePoint:Point;
			
			mask.graphics.clear();
			mask.graphics.beginFill(0x000000, 0.5);
			mask.graphics.drawRect(0, 0, width, height);
			mask.graphics.endFill();
			stagePoint = localToGlobal(new Point(x, y));
			mask.x = stagePoint.x - LayoutManager.stageOffsetX;
			mask.y = stagePoint.y - LayoutManager.stageOffsetY;
			LayerManager.singleton.addItemToLayer(mask, LayerDef.GUIDE_UI_MASK);
		}
		
		private function removeMask():void
		{
			LayerManager.singleton.removeItemToLayer(mask1);
			LayerManager.singleton.removeItemToLayer(mask2);
			LayerManager.singleton.removeItemToLayer(mask3);
			LayerManager.singleton.removeItemToLayer(mask4);
		}
		
		private function onAddedToStage(evt:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			trackTarget();
			startTimer();
			LayoutManager.singleton.stage.addEventListener(Event.RESIZE, onResizeHandleTrackTarget);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		protected function onResizeHandleTrackTarget(event:Event):void
		{
			trackTarget();
			startTimer();
		}
		
		private function trackTarget(evt:Event = null):void
		{
			var frameGap:int = 5; //蓝色光圈外围的透明部分宽度
			var targetRect:Rectangle;
			
			try
			{
				target["drawNow"]();  //这个是给公用组件用的，因为有时候刚创建的时候这个对象还没有刷新，一些大小的设置还没有生效
			} 
			catch(error:Error) 
			{
			}
			targetX = target.x;
			targetY = target.y;
			targetRect = target.getBounds(LayerManager.singleton.findLayerByName(LayerDef.GUIDE_UI));
			this.x = targetRect.x - frameGap;
			this.y = targetRect.y - frameGap;
			rectUi.width = targetRect.width + 2*frameGap;
			rectUi.height = targetRect.height + 2*frameGap;
			
			if (targetFrameOffsetRect)
			{
				this.x += targetFrameOffsetRect.x;
				this.y += targetFrameOffsetRect.y;
				rectUi.width += targetFrameOffsetRect.width;
				rectUi.height += targetFrameOffsetRect.height;
			}
		}
		
		private function onRemovedFromStage(evt:Event):void
		{
			LayoutManager.singleton.stage.removeEventListener(Event.RESIZE, onResizeHandleTrackTarget);
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			stopTimer();
		}
		
		private function startTimer():void
		{
			if (!timer)
			{
				timer = new Timer(300, 10);
			}
			else
			{
				timer.reset();
			}
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
		}
		
		protected function onTimer(event:TimerEvent):void
		{
			if (target)
			{
				if (targetX != target.x || targetY != target.y)
				{
					trackTarget();
					(isMask) && (updateMask());
				}
			}
		}
		
		private function stopTimer():void
		{
			if (timer)
			{
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER, onTimer);
			}
		}
	}
}