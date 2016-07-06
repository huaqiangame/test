package com.tencent.morefun.naruto.plugin.ui.core
{
	import com.tencent.morefun.naruto.plugin.ui.util.TimerProvider;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	

	public class CoreShakeDisplay extends EventDispatcher
	{
		private var shakeParamObj:ShakeParam;
		private var shakeTarget:DisplayObject;
		private var typeParamMap:Dictionary = new Dictionary();
		private var destroy:Boolean;
		private static var createIndex:int;
		private static var releaseIndex:int;
		private var index:int;
		private var startX:int;
		private var startY:int;
		
		public function CoreShakeDisplay(content:DisplayObject, type:int)
		{
			startX = content.x;
			startY = content.y;
			shakeTarget = content;
			
			typeParamMap[1] = new ShakeParam(20, 20, 6);
			typeParamMap[2] = new ShakeParam(0, 0, 0, 20, 20, 8);
			typeParamMap[3] = new ShakeParam(20, 20, 6, 20, 20, 8);
			
			createIndex += 1;
			index = createIndex;
			
			playShake(type);
		}
		
		private function stop():void
		{
			if(destroy == false)
			{
				shakeTarget.x = startX;
				shakeTarget.y = startY;
				TimerProvider.removeEnterFrameTask(onEnterFrame);
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		private function release():void
		{
			destroy = true;
			
			TimerProvider.removeEnterFrameTask(onEnterFrame);
			shakeTarget.x = startX;
			shakeTarget.y = startY;
			shakeTarget = null;
			
			releaseIndex += 1;
			
		}
		
		public function playShake(type:int):void
		{
			shakeParamObj = typeParamMap[type].clone();
			
			TimerProvider.addEnterFrameTask(onEnterFrame);
		}
		
		private function onEnterFrame():void
		{
			//		MotionLogger.output("[ShakeScreenAction][onEnterFrame]", shakeParamObj.verRange, shakeParamObj.verFalloff, shakeParamObj.verFrequency, shakeTarget.y, shakeParamObj.horRange, shakeParamObj.horFalloff, shakeParamObj.horFrequency, shakeTarget.x);
			if(shakeParamObj.verRange != 0)
			{
				verShake();
			}
			
			if(shakeParamObj.horRange != 0)
			{
				horShake();
			}
			
			if(shakeParamObj.verRange == 0 && shakeParamObj.horRange == 0)
			{
				TimerProvider.removeEnterFrameTask(onEnterFrame);
				this.dispatchEvent(new Event(Event.COMPLETE));
				
				release();
			}
		}
		
		private function verShake():void
		{
			if(Math.abs(startY - shakeTarget.y) == shakeParamObj.verRange)
			{
				shakeParamObj.verFrequency *= -1;
				shakeParamObj.verRange -= shakeParamObj.verFalloff;
				shakeParamObj.verRange = Math.max(0, shakeParamObj.verRange);
				
				if(Math.abs(shakeParamObj.verFrequency) > shakeParamObj.verRange)
				{
					shakeParamObj.verFrequency = (shakeParamObj.verFrequency > 0)?shakeParamObj.verRange:-shakeParamObj.verRange;
				}
			}
			
			shakeTarget.y += shakeParamObj.verFrequency;
			if(Math.abs(startY - shakeTarget.y) > shakeParamObj.verRange)
			{
				shakeTarget.y = (shakeParamObj.verRange > 0)?shakeParamObj.verRange:-shakeParamObj.verRange;
				shakeTarget.y += startY;
			}
		}
		
		private function horShake():void
		{
			if(Math.abs(startX - shakeTarget.x) == shakeParamObj.horRange)
			{
				shakeParamObj.horFrequency *= -1;
				shakeParamObj.horRange -= shakeParamObj.horFalloff;
				shakeParamObj.horRange = Math.max(0, shakeParamObj.horRange);
				if(Math.abs(shakeParamObj.horFrequency) > shakeParamObj.horRange)
				{
					shakeParamObj.horFrequency = (shakeParamObj.horFrequency > 0)?shakeParamObj.horRange:-shakeParamObj.horRange;
				}
			}
			
			shakeTarget.x += shakeParamObj.horFrequency;
			if(Math.abs(startX - shakeTarget.x) > shakeParamObj.horRange)
			{
				shakeTarget.x = startX + (shakeParamObj.horRange > 0)?shakeParamObj.horRange:-shakeParamObj.horRange;
				shakeTarget.x += startX;
			}
		}
		}
}

class ShakeParam
{
	public var horRange:Number;
	public var horFrequency:Number;
	public var horFalloff:Number;
	public var verRange:Number;
	public var verFrequency:Number;
	public var verFalloff:Number;
	
	public function ShakeParam(verRange:Number = 0, verFrequency:Number = 0, verFalloff:Number = 0,
							   horRange:Number = 0, horFrequency:Number = 0, horFalloff:Number = 0)
	{
		this.verRange = verRange;
		this.verFrequency = verFrequency;
		this.verFalloff = verFalloff;
		this.horRange = horRange;
		this.horFrequency = horFrequency;
		this.horFalloff = horFalloff;
	}
	
	public function clone():ShakeParam
	{
		var shakeParam:ShakeParam;
		
		shakeParam = new ShakeParam();
		shakeParam.horRange = this.horRange;
		shakeParam.horFrequency = this.horFrequency;
		shakeParam.horFalloff = this.horFalloff;
		
		shakeParam.verRange = this.verRange;
		shakeParam.verFrequency = this.verFrequency;
		shakeParam.verFalloff = this.verFalloff
		
		return shakeParam;
	}}