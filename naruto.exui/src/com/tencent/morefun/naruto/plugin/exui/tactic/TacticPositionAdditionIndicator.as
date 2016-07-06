package com.tencent.morefun.naruto.plugin.exui.tactic 
{
	import flash.display.Sprite;
	import tactic.model.data.TacticPositionInfo;
	import tactic.utils.getTacticAdditionTypeName;
	import ui.plugin.tactic.TacticPositionAdditionUI;
	
	/**
	 * ...
	 * @author larryhou
	 * @createTime 2015/4/22 11:33
	 */
	public class TacticPositionAdditionIndicator extends Sprite
	{
		private var _view:TacticPositionAdditionUI;
		private var _data:TacticPositionInfo;
		
		/**
		 * 构造函数
		 * create a [TacticPositionIndicator] object
		 */
		public function TacticPositionAdditionIndicator() 
		{
			addChild(_view = new TacticPositionAdditionUI());
			mouseEnabled = mouseChildren = false;
			visible = false;
		}
		
		/**
		 * 垃圾回收
		 */
		public function dispose():void
		{
			_view.parent && _view.parent.removeChild(_view);
			_view = null;
			_data = null;
		}
		
		public function get data():TacticPositionInfo { return _data; }
		public function set data(value:TacticPositionInfo):void 
		{
			_data = value;
			if (_data)
			{
				_view.label.htmlText = "<b>" + getTacticAdditionTypeName(_data.type) + (_data.addition >= 0? "+" : "-") + _data.addition + "</b>";
			}
		}
		
	}

}