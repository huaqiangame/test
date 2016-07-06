package com.tencent.morefun.naruto.plugin.exui.loading 
{
	import com.tencent.morefun.naruto.plugin.exui.loading.flash.ProgressLoadingUI;
	import com.tencent.morefun.naruto.plugin.ui.layer.def.LayerDef;
	import com.tencent.morefun.naruto.plugin.ui.layer.LayerManager;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * loading条封装
	 * @author larryhou
	 * @createTime 2014/12/31 11:20
	 */
    import com.tencent.morefun.naruto.i18n.I18n;
	public class ProgressLoadingView extends LoadingView
	{
		private var _view:ProgressLoadingUI;
		private var _percent:Number = 0;
		
		private var _bgAlpha:Number;
		
		/**
		 * 构造函数
		 * create a [ProgressLoadingView] object
		 */
		public function ProgressLoadingView(view:ProgressLoadingUI, bgAlpha:Number = 1)
		{
			_bgAlpha = bgAlpha;
			addChild(_view = view);
			stopAnimation(_view);
		}
		
		override protected function resizeUpdate(e:Event):void 
		{
			super.resizeUpdate(e);
			
			var center:Point = globalToLocal(new Point(stage.stageWidth / 2, stage.stageHeight / 2));
			_view.x = center.x;
			_view.y = center.y;
		}
		
		/**
		 * 隐藏非关键信息
		 */
		public function keepClean(reset:Boolean = false):void
		{
			if (_view.indicator)
			{
				_view.indicator.visible = false;
			}
			
			_view.detailInfo.text = "";
			
			_view.errorTips.text = "";
			_view.assetTips.text = "";
			
			if (_view.countdown)
			{
				_view.countdown.text = "";
			}
			
			if (reset)
			{
				this.percent = 0;
			}
		}
		
		/**
		 * 显示loading条
		 */
		public function show():void
		{
			LayerManager.singleton.addItemToLayer(this, LayerDef.LOADING);
			resumeAnimation(_view);
			
			if (tipslist && tipslist.length)
			{
				var index:uint = tipslist.length * Math.random() >> 0;
				
				_view.helpTips.visible = true;
				_view.helpTips.label.htmlText = I18n.lang("as_exui_1451031568_1244") + tipslist[index] + '</b>';
			}
			else
			{
				_view.helpTips.visible = false;
			}
		}
		
		/**
		 * 关闭loading条
		 */
		public function hide():void
		{
			parent && parent.removeChild(this);
			stopAnimation(_view);
		}
		
		/**
		 * 设置倒计时信息
		 * @param	text	倒计时HTML文本
		 */
		public function setCountDownInfo(text:String):void
		{
			if (_view.countdown)
			{
				_view.countdown.htmlText = text;
			}
		}
		
		/**
		 * 设置loading右下方的玩家加载信息
		 * @param	text	HTML文本
		 */
		public function setWaitingInfo(text:String):void
		{
			_view.indicator.visible = Boolean(text);
			_view.detailInfo.htmlText = text;
		}
		
		/**
		 * 设置百分比
		 */
		public function get percent():Number { return _percent; }
		public function set percent(value:Number):void 
		{
			_percent = isNaN(value)? 0 : Math.max(0, Math.min(100, value));
			
			_view.percent.text = Math.floor(_percent + 1 / 10000000).toString();
			_view.loadingMask.scaleX = _percent / 100;
			if (_view.anchor)
			{
				_view.anchor.x = _view.loadingMask.x + _view.loadingMask.width;
			}
			
			if (_view.anchorAnimation)
			{
				_view.anchorAnimation.x = _view.loadingMask.x + _view.loadingMask.width;
			}
		}
		
		/**
		 * loading视图资源
		 */
		public function get view():ProgressLoadingUI { return _view; }
		
		/**
		 * 遮罩透明度
		 */
		override public function get bgAlpha():Number { return _bgAlpha; }
		
		/**
		 * 设置资源加载提示
		 */
		public function get assetTips():String { return _view.assetTips.text; }
		public function set assetTips(value:String):void 
		{
			_view.assetTips.htmlText = value;
		}
		
		/**
		 * 设置错误提示
		 */
		public function get errorTips():String { return _view.errorTips.text; }
		public function set errorTips(value:String):void 
		{
			_view.errorTips.htmlText = value;
		}
	}
}