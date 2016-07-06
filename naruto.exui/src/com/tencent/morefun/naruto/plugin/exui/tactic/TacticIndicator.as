package com.tencent.morefun.naruto.plugin.exui.tactic 
{
	import base.ApplicationData;
	import com.tencent.morefun.framework.base.CommandEvent;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import serverProto.inc.NinjaSourceType;
	import tactic.command.OpenTacticCommand;
	import tactic.command.TacticQueryCommand;
	import tactic.model.data.TacticInfo;
	import tactic.model.TacticModel;
	import tactic.model.TacticUniqueModel;
	import ui.plugin.tactic.TacticIndicatorUI;
	
	/**
	 * 战法数据加载完成时派发
	 */
	[Event(name = "change", type = "flash.events.Event")]
	
	/**
	 * ...
	 * @author larryhou
	 * @createTime 2015/4/22 11:33
	 */
	public class TacticIndicator extends Sprite
	{
		private var _view:TacticIndicatorUI;
		private var _data:TacticInfo;
		private var _type:uint;
		
		private var _model:TacticUniqueModel;
		
		/**
		 * 构造函数
		 * create a [TacticIndicator] object
		 */
		public function TacticIndicator() 
		{
			addChild(_view = new TacticIndicatorUI());
			setTacticVisible(false);
			
			addEventListener(MouseEvent.CLICK, clickHandler);
			
			_view.buttonAnimation.stop();
			with (_view.buttonAnimation)
			{
				mouseChildren = mouseEnabled = false;
				visible = false;
			}
			
			super.visible = false;
		}
		
		private function setTacticVisible(value:Boolean):void
		{
			for (var i:int = 0; i < _view.numChildren; i++)
			{
				var target:DisplayObject = _view.getChildAt(i);
				if (target != _view.openTacticBtn && target != _view.buttonAnimation)
				{
					target.visible = value;
				}
			}
		}
		
		/**
		 * 载入战法数据
		 * @param type @see serverProto.inc.NinjaSourceType
		 */
		public function load(type:uint):void
		{
			if (ApplicationData.singleton.selfInfo.level < 40)
			{
				this.visible = false;
				return;
			}
			
			this.visible = true;
			
			if (_model)
			{
				_model.removeEventListener(Event.CHANGE, modelChangeHandler);
				_model = null;
			}
			
			_model = TacticModel.singleton.getUniqueModel(type);
			_model.addEventListener(Event.CHANGE, modelChangeHandler);
			
			new TacticQueryCommand(_type = type).call();
		}
		
		private function modelChangeHandler(e:Event):void 
		{
			var tactics:Vector.<TacticInfo> = _model.list;
			
			var needAnimation:Boolean = false;
			
			_data = null;
			for (var i:int = 0; i < tactics.length; i++)
			{
				if (tactics[i].using)
				{
					_data = tactics[i];
					_view.tactic.htmlText = "<b>" + _data.name + "LV" + _data.level + "</b>";
				}
				
				if (tactics[i].levelUpAvailable)
				{
					needAnimation = true;
				}
			}
			
			_view.buttonAnimation.visible = needAnimation;
			_view.buttonAnimation.visible? _view.buttonAnimation.play() : _view.buttonAnimation.stop();
			
			setTacticVisible(_data != null);
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			if (e.target == _view.openTacticBtn)
			{
				new OpenTacticCommand(_type).call();
			}
		}
		
		/**
		 * 垃圾回收
		 */
		public function dispose():void
		{
			removeEventListener(MouseEvent.CLICK, clickHandler);
			if (_model)
			{
				_model.removeEventListener(Event.CHANGE, modelChangeHandler);
				_model = null;
			}
			
			_view.parent && _view.parent.removeChild(_view);
			_view = null;
			_data = null;
		}
		
		override public function get visible():Boolean { return super.visible; }
		override public function set visible(value:Boolean):void 
		{
			return;
			super.visible = value;
		}
		
		public function get data():TacticInfo { return _data; }
		
		/**
		 * 忍者来源
		 */
		public function get type():uint { return _type; }
	}
}