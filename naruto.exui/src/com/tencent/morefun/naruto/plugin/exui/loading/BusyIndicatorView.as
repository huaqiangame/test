package com.tencent.morefun.naruto.plugin.exui.loading 
{
	import com.tencent.morefun.naruto.plugin.ui.layer.def.LayerDef;
	import com.tencent.morefun.naruto.plugin.ui.layer.LayerManager;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import ui.loading.BusyLoadingUI;
	
	/**
	 * 操作繁忙遮罩
	 * @author larryhou
	 * @createTime 2014/12/31 10:47
	 */
	public class BusyIndicatorView extends LoadingView
	{
		private var _indicator:BusyLoadingUI;
		
		/**
		 * 构造函数
		 * create a [BusyIndicatorView] object
		 */
		public function BusyIndicatorView() 
		{
			addChild(_indicator = new BusyLoadingUI());
			stopAnimation(_indicator);
		}
		
		/**
		 * 显示繁忙遮罩
		 * @param	useAnimationIndicator	是否显示动画
		 */
		public function show(useAnimationIndicator:Boolean = true):void
		{
			LayerManager.singleton.addItemToLayer(this, LayerDef.LOADING);
			if (useAnimationIndicator)
			{
				_indicator.visible = true;
				resumeAnimation(_indicator);
			}
			else
			{
				_indicator.visible = false;
				stopAnimation(_indicator);
			}
		}
		
		override protected function resizeUpdate(e:Event):void 
		{
			super.resizeUpdate(e);
			
			var center:Point = globalToLocal(new Point(stage.stageWidth / 2, stage.stageHeight / 2));
			_indicator.x = center.x;
			_indicator.y = center.y;
		}
		
		/**
		 * 隐藏繁忙遮罩
		 */
		public function hide():void
		{
			parent && parent.removeChild(this);
			stopAnimation(_indicator);
		}
		
		override public function get bgAlpha():Number { return 0; }
	}
}