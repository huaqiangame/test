package com.tencent.morefun.naruto.plugin.exui.loading 
{
	import com.tencent.morefun.framework.net.LoadManager;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * loading基类
	 * @author larryhou
	 * @createTime 2014/12/31 11:03
	 */
	public class LoadingView extends Sprite implements ILoadingMask
	{
		// 0x968A58
		protected static var tipslist:Vector.<String>;
		
		/**
		 * 构造函数
		 * create a [LoadingView] object
		 */
		public function LoadingView() 
		{
			mouseChildren = false;
			addEventListener(Event.REMOVED_FROM_STAGE, stageHandler);
			addEventListener(Event.ADDED_TO_STAGE, stageHandler);
			
			if (!tipslist)
			{
				tipslist = new Vector.<String>();
				LoadManager.getManager().loadTask('config/LoadingTips.xml', processTipsTask);
			}
		}
		
		private function processTipsTask(config:XML):void 
		{
			if (!config) return;
			for each(var item:XML in config.item)
			{
				tipslist.push(item.@msg);
			}
		}
		
		private function stageHandler(e:Event):void 
		{
			if (e.type == Event.ADDED_TO_STAGE)
			{
				resizeUpdate(null);
				stage.addEventListener(Event.RESIZE, resizeUpdate);
			}
			else
			if (e.type == Event.REMOVED_FROM_STAGE)
			{
				stage.removeEventListener(Event.RESIZE, resizeUpdate);
			}
		}
		
		/**
		 * 屏幕尺寸变更时更新背景遮罩
		 */
		protected function resizeUpdate(e:Event):void 
		{
			var origin:Point = globalToLocal(new Point());
			
			graphics.clear();
			graphics.beginFill(bgColor, bgAlpha);
			graphics.drawRect(origin.x, origin.y, stage.stageWidth, stage.stageHeight);
			graphics.endFill();
		}
		
		/**
		 * 停止播放动画
		 */
		protected static function stopAnimation(container:DisplayObjectContainer):void
		{
			if (container is MovieClip)
			{
				(container as MovieClip).stop();
			}
			
			var child:DisplayObject;
			for (var i:int = 0; i < container.numChildren; i++)
			{
				child = container.getChildAt(i);
				if (child is DisplayObjectContainer) arguments.callee(child as DisplayObjectContainer);
			}
		}
		
		/**
		 * 继续播放动画
		 */
		protected static function resumeAnimation(container:DisplayObjectContainer):void
		{
			if (container is MovieClip)
			{
				(container as MovieClip).play();
			}
			
			var child:DisplayObject;
			for (var i:int = 0; i < container.numChildren; i++)
			{
				child = container.getChildAt(i);
				if (child is DisplayObjectContainer) arguments.callee(child as DisplayObjectContainer);
			}
		}
		
		/* INTERFACE com.tencent.morefun.naruto.plugin.exui.loading.ILoadingMask */
		
		public function get bgColor():uint { return 0x000000; }
		
		public function get bgAlpha():Number { return 1; }
	}

}