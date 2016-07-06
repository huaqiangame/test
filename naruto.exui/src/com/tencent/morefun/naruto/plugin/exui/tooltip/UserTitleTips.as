package com.tencent.morefun.naruto.plugin.exui.tooltip 
{
	import com.greensock.TweenLite;
	import com.tencent.morefun.naruto.plugin.exui.base.Image;
	import com.tencent.morefun.naruto.plugin.ui.tips.BaseTipsView;
	import flash.display.Sprite;
	import rank.model.data.RankTitleCfgInfo;
	import ui.plugin.tooltip.crew.UserTitleTipsUI;
	
	/**
	 * 称号提示
	 * @author larryhou
	 * @createTime 2014/10/17 12:00
	 */
	public class UserTitleTips extends BaseTipsView
	{
		private var _view:UserTitleTipsUI;
		private var _info:RankTitleCfgInfo;
		
		private var _lite:TweenLite;
		private var _image:Image;
		
		/**
		 * 构造函数
		 * create a [UserTitleTips] object
		 */
		public function UserTitleTips(params:Object = null) 
		{
			super(null);
			
			mouseChildren = false;
			addChild(_view = new UserTitleTipsUI());
			
			_image = new Image(160, 60, false, true, true);
			_image.moveLoadingMovie(80, 30);
			_view.icon.addChild(_image);
			_image.smoothing = false;
			_image.visible = false;
		}
		
		/**
		 * 垃圾回收
		 */
		public function dispose():void
		{
			_lite && _lite.kill();
			_lite = null;
			
			_image.dispose();
			_image.parent && _image.parent.removeChild(_image);
			_image = null;
			
			_view.parent && _view.parent.removeChild(_view);
			_view = null;
			_info = null;
		}
		
		override public function get data():Object { return _info; }
		override public function set data(value:Object):void 
		{
			_info = value as RankTitleCfgInfo;
			if (_info)
			{
				const LINE_GAP:uint = 4;
				
				if (_info.image)
				{
					_image.dispose();
					_image.load(_info.image);
					_image.visible = true;
					
					_view.title.visible = false;
				}
				else
				{
					_view.title.htmlText = "<b>" + _info.formattedName + "</b>";
					_view.title.visible = true;
					
					_image.visible = false;
				}
				
				_view.tips1.text = _info.obtainTips;
				_view.tips1.height = _view.tips1.textHeight + (_view.tips1.numLines - 1 ) * LINE_GAP;
				
				_lite && _lite.kill();
				_lite = TweenLite.to(_view.label2, 0.15, {y:_view.tips1.y + _view.tips1.height + 5, onUpdate:update } );
				
				_view.tips2.text = _info.expireTips;
				_view.tips2.height = _view.tips2.textHeight + (_view.tips2.numLines - 1 ) * LINE_GAP;
			}
		}
		
		private function update():void 
		{
			_view.tips2.y = _view.label2.y;
			_view.background.height = _view.tips2.y + _view.tips2.height + 30;
		}
	}

}