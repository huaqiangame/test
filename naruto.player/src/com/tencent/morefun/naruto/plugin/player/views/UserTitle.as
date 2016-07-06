package com.tencent.morefun.naruto.plugin.player.views 
{
	import com.tencent.morefun.naruto.plugin.exui.base.Image;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import rank.model.data.RankTitleCfgInfo;
	
	/**
	 * 玩家称号
	 * @author larryhou
	 * @createTime 2014/10/17 16:35
	 */
	public class UserTitle extends Sprite
	{
		private var _data:RankTitleCfgInfo;
		private var _label:TextField;
		
		private var _image:Image;
		
		/**
		 * 构造函数
		 * create a [UserTitle] object
		 */
		public function UserTitle() 
		{
			_label = new TextField();
			_label.defaultTextFormat = new TextFormat("SimSun", 16, 0xFFFFFF, true);
			_label.filters = [new GlowFilter(0, 1, 3, 3, 3)];
			_label.autoSize = TextFieldAutoSize.LEFT;
			_label.mouseEnabled = false;
			
			_image = new Image(0, 0, false, false);
			_image.smoothing = false;
		}
		
		/**
		 * 垃圾回收
		 */
		public function dispose():void
		{
			_image.dispose();
			_image.parent && _image.parent.removeChild(_image);
			_image.removeEventListener(Event.COMPLETE, imageCompleteHandler);
			_image = null;
			
			_label.parent && _label.parent.removeChild(_label);
			_label = null;
			
			_data = null;
		}
		
		public function get data():RankTitleCfgInfo { return _data; }
		public function set data(value:RankTitleCfgInfo):void 
		{
			_data = value;
			if (_data)
			{
				_label.htmlText = "<b>" + _data.formattedName + "</b>";
				_label.x = -_label.width / 2;
				_label.y = -_label.height;
				
				if (_data.image)
				{
					_image.dispose();
					_image.addEventListener(Event.COMPLETE, imageCompleteHandler);
					_image.load(_data.image);
					addChild(_image);
					
					_label.parent && _label.parent.removeChild(_label);
				}
				else
				{
					addChild(_label);
					_image.parent && _image.parent.removeChild(_image);
				}
			}
			else
			{
				_label.parent && _label.parent.removeChild(_label);
				_image.parent && _image.parent.removeChild(_image);
			}
		}
		
		/**
		 * 调整图片坐标
		 */
		private function imageCompleteHandler(e:Event):void 
		{
			e.currentTarget.removeEventListener(e.type, arguments.callee);
			_image.x = -_image.width / 2;
			_image.y = -_image.height;
		}
	}

}