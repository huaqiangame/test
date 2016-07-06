package com.tencent.morefun.naruto.plugin.exui.loading
{
	import flash.events.Event;
	import ui.loading.FullScreenProgressLoadingUI;
	import ui.loading.ProgressLoadingUI;
	
	/**
	 * 游戏内通用loading
	 * @author larryhou
	 * @createTime 2014/12/31 15:15
	 */
	public class NarutoLoading
	{
		/**
		 * 资源加载结束后不主动关闭loading条开关
		 */
		static public var lockFullLoading:Boolean;
		
		/**
		 * 操作繁忙遮罩
		 */
		static private var _busyIndicator:BusyIndicatorView;
		static public function get busyLoadingView():BusyIndicatorView
		{
			return _busyIndicator ||= new BusyIndicatorView();
		}
		
		/**
		 * 百分比loading条
		 */
		static private var _loadingView:ProgressLoadingView;
		static public function get loadingView():ProgressLoadingView
		{
			if (!_loadingView)
			{
				_loadingView = new ProgressLoadingView(new ProgressLoadingUI, 0);
				_loadingView.addEventListener(Event.ADDED_TO_STAGE, loadingChangeHandler);
			}
			return _loadingView;
		}
		
		/**
		 * 全屏百分比loading条
		 */
		static private var _fullScreenLoadingView:ProgressLoadingView;
		static public function get fullScreenLoadingView():ProgressLoadingView
		{
			if (!_fullScreenLoadingView)
			{
				_fullScreenLoadingView = new ProgressLoadingView(new FullScreenProgressLoadingUI);
				_fullScreenLoadingView.addEventListener(Event.ADDED_TO_STAGE, loadingChangeHandler);
			}
			return _fullScreenLoadingView;
		}
		
		/**
		 * 当前正在运行的loading条
		 */
		static private var _currentLoadingView:ProgressLoadingView;
		static public function get currentLoadingView():ProgressLoadingView { return _currentLoadingView; }
		
		/**
		 * 同时只有一个loading条
		 */
		static private function loadingChangeHandler(e:Event):void 
		{
			_currentLoadingView = e.currentTarget as ProgressLoadingView;
			
			var list:Vector.<ProgressLoadingView> = new Vector.<ProgressLoadingView>();
			list.push(_fullScreenLoadingView);
			list.push(_loadingView);
			
			for each(var item:ProgressLoadingView in list)
			{
				if (item && item != _currentLoadingView) 
				{
					item.hide();
				}
			}
		}
		
		/**
		 * 关闭正在打开的loading条
		 */
		static public function hideLoadingView():void
		{
			if (_currentLoadingView)
			{
				_currentLoadingView.hide();
				_currentLoadingView = null;
			}
		}
	}
}