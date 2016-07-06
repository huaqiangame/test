package com.tencent.morefun.naruto.plugin.ui.guide.view
{	
	import com.tencent.morefun.naruto.plugin.ui.layer.LayerManager;
	import com.tencent.morefun.naruto.plugin.ui.layer.LayoutManager;
	import com.tencent.morefun.naruto.plugin.ui.layer.def.LayerDef;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	
	import ui.guide.Arrow;
	import ui.guide.Harrow;
	import ui.guide.TunTunBeast;
	import ui.guide.XiaoyingNinja;
	import ui.guide.ninjaMove;
	import ui.guide.zuozhuNinja;
	
	public class GuideArrow extends Sprite
	{
		private var arrowUi:MovieClip;
		private var target:DisplayObject;
		private var targetFrameOffsetRect:Rectangle;
		private var timer:Timer;
		private var targetX:int;
		private var targetY:int;
		
		public function GuideArrow(desc:String, direction:int = 4, target:DisplayObject = null, playLight:Boolean = true, targetFrameOffsetRect:Rectangle = null)
		{
			super();
			
			this.mouseChildren = this.mouseEnabled = false;
			if (direction == 5)
			{
				arrowUi = new ninjaMove();
			}
			else if (direction == 6)
			{
				arrowUi = new zuozhuNinja();
			}
			else if (direction == 7)
			{
				arrowUi = new XiaoyingNinja();
			}
			else if (direction == 8)
			{
				arrowUi = new TunTunBeast();
			}
			else
			{
				arrowUi = (direction == 2)? new Harrow() : new Arrow();
			}
			(!playLight) && (arrowUi.stop());
			addChild(arrowUi);
			
			if (desc != "")
			{
				if (arrowUi.text)
				{
					(arrowUi.text as TextField).htmlText = "<b>" + desc + "</b>";
					(arrowUi.text as TextField).wordWrap = false;
					(arrowUi.text as TextField).autoSize = TextFieldAutoSize.RIGHT;
					(arrowUi.text as TextField).visible = true;
					(arrowUi.text as TextField).y = 0 - (arrowUi.text as TextField).height/2;
					if (arrowUi.textBg)
					{
						(arrowUi.textBg as MovieClip).width = (arrowUi.text as TextField).width + 56;
						(arrowUi.textBg as MovieClip).height = (arrowUi.text as TextField).height + 34;
						(arrowUi.textBg as MovieClip).x = (arrowUi.text as TextField).x + (arrowUi.text as TextField).width / 2 - (arrowUi.textBg as MovieClip).width / 2;
						(arrowUi.textBg as MovieClip).y = (arrowUi.text as TextField).y + (arrowUi.text as TextField).height / 2 - (arrowUi.textBg as MovieClip).height / 2;
						(arrowUi.textBg as MovieClip).visible = true;
					}
				}
			}
			else
			{
				(arrowUi.text) && (arrowUi.text.visible = false);
				(arrowUi.textBg) && (arrowUi.textBg.visible = false);
			}
			
			
			this.target = target;
			
			(target) && (addEventListener(Event.ADDED_TO_STAGE, onAddedToStage));
			
			this.targetFrameOffsetRect = targetFrameOffsetRect;
		}
		
		public function stop():void
		{
			arrowUi && arrowUi.stop();
		}
		
		public function play():void
		{
			arrowUi && arrowUi.play();
		}
		
		public function destory():void
		{
			stopTimer();
			timer = null;
			
			if (target)
			{
				removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
				removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
				LayoutManager.singleton.stage.removeEventListener(Event.RESIZE, onResizeHandleTrackTarget);
			}
			this.removeChild(arrowUi);
			arrowUi = null;
		}
		
		private function onAddedToStage(evt:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage)
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
			
			this.x = targetRect.x;
			this.y = targetRect.y + targetRect.height/2;
			
			if (targetFrameOffsetRect)
			{
				this.x += targetFrameOffsetRect.x;
				this.y += targetFrameOffsetRect.y;
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