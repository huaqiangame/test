package com.tencent.morefun.naruto.plugin.ui.base
{
	import com.tencent.morefun.naruto.plugin.ui.base.def.BaseButtonStatusDef;
	import com.tencent.morefun.naruto.plugin.ui.util.TimerProvider;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.utils.Dictionary;
	

	public class BaseButton extends Sprite
	{
		protected static var disableCM:ColorMatrixFilter = new ColorMatrixFilter([0.33, 0.33, 0.33, 0, 0,
			0.33, 0.33, 0.33, 0, 0,
			0.33, 0.33, 0.33, 0, 0,
			0, 0, 0, 1, 0]);
		
		private var m_skin:MovieClip;
		private var m_selected:Boolean;
		private var m_disable:Boolean;
		private var m_curStatus:int = -1;
		private var m_status:int = 0;
		private var m_focus:Boolean;
		private var m_radioGroup:String;
		
		private var m_selectable:Boolean;
		
		private var m_curTimeStep:int;
		private var m_timerDefaultTimeStep:int= 300;
		private var m_fastTimeStep:int = 50;
		
		private var m_frameIndexMap:Dictionary = new Dictionary();
		
		private var m_repeart:Boolean;
		private var m_disableMatrixFilter:ColorMatrixFilter;
		
		
		/**
		 * 
		 * @param skin
		 * 帧 - 状态 
		 * 1 - MouseUp
		 * 2 - MouseOver
		 * 3 - MouseDown
		 * 4 - SelectedMouseUp
		 * 5 - SelectedMouseOver
		 * 6 - SelectedMouseDown
		 * @param selectable
		 * 是否可选择模式
		 * 
		 */		
		public function BaseButton(skin:MovieClip, selectable:Boolean = false, up:uint=1, over:uint=2, down:uint=3, disable:uint = 4,
								   selectedUp:uint=5, selectedOver:uint=6, selectedDown:uint=7, selectedDisable:uint = 8)
		{
			super();
			this.mouseChildren = false;
			
			m_skin = skin;
			m_selectable = selectable;
			
			m_frameIndexMap[BaseButtonStatusDef.MOUSE_UP] = up;
			m_frameIndexMap[BaseButtonStatusDef.MOUSE_OVER] = over;
			m_frameIndexMap[BaseButtonStatusDef.MOUSE_DOWN] = down;
			m_frameIndexMap[BaseButtonStatusDef.MOUSE_DISABLE] = disable;
			m_frameIndexMap[BaseButtonStatusDef.SELECTED_MOUSE_UP] = selectedUp;
			m_frameIndexMap[BaseButtonStatusDef.SELECTED_MOUSE_OVER] = selectedOver;
			m_frameIndexMap[BaseButtonStatusDef.SELECTED_MOUSE_DOWN] = selectedDown;
			m_frameIndexMap[BaseButtonStatusDef.SELECTED_DISABLE] = selectedDisable;
			
			addSkinEventListener();
			
			addChild(m_skin);
			
			m_disableMatrixFilter = disableCM;
			
			status = m_frameIndexMap[BaseButtonStatusDef.MOUSE_UP];
		}
		
		private function addSkinEventListener():void
		{
			addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		private function removeEventListenr():void
		{
			removeEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		public function get skin():MovieClip
		{
			return m_skin;
		}
		
		/**
		 *使用完毕记得调用销毁函数 
		 * 
		 */		
		public function destroy():void
		{
			this.removeEventListener(Event.ENTER_FRAME, update);
			
			if(stage)
			{
				stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			}
			
			if(m_skin)
			{
				removeEventListener(MouseEvent.ROLL_OVER, onMouseOver);
				removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
				removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				TimerProvider.removeTimeTask(m_curTimeStep, onTimerEvent);
				
				RadionGroup.removeGroupItem(this);
				
				if(contains(m_skin)){removeChild(m_skin)};
			}
			m_skin = null;
		}
		
		public function setDisableMatrixFilter(value:ColorMatrixFilter):void
		{
			m_disableMatrixFilter = value;
		}
		
		
		protected function onMouseOver(evt:MouseEvent):void
		{
			if(evt.buttonDown){return ;}
			if(disable){return;}
			status = m_selected?BaseButtonStatusDef.SELECTED_MOUSE_OVER:BaseButtonStatusDef.MOUSE_OVER;
		}
		
		protected function onMouseOut(evt:MouseEvent):void
		{
			if(evt.buttonDown){return ;}
			
			if(disable){return;}
			
			status = m_selected?BaseButtonStatusDef.SELECTED_MOUSE_UP:BaseButtonStatusDef.MOUSE_UP;
		}
		
		private function onStageMouseUp(evt:MouseEvent):void
		{
			evt.currentTarget.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			
			if(!contains(evt.target as DisplayObject) && evt.target != this)
			{
				status = m_selected?BaseButtonStatusDef.SELECTED_MOUSE_UP:BaseButtonStatusDef.MOUSE_UP;
			}
			else
			{
				if(m_selectable)//是否可选
				{
					if(radioGroup == null)//如果没有组
					{
						selected = !selected;
					}
					else if(!selected)//排除已经选中
					{
						selected = !selected;
					}
				}
				status = m_selected?BaseButtonStatusDef.SELECTED_MOUSE_OVER:BaseButtonStatusDef.MOUSE_OVER;
			}
			
			if(m_repeart)
			{
				stopTimerCount();
			}
		}
		
		protected function onMouseDown(evt:MouseEvent):void
		{
			if(!evt.buttonDown){return ;}
			if(disable){return;}
			stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			status = m_selected?BaseButtonStatusDef.SELECTED_MOUSE_DOWN:BaseButtonStatusDef.MOUSE_DOWN;
			
			if(m_repeart)
			{
				startTimerCount();
			}
		}
		
		private function startTimerCount():void
		{
			m_curTimeStep = m_timerDefaultTimeStep;
			TimerProvider.addTimeTask(m_curTimeStep, onTimerEvent);
		}
		
		private function stopTimerCount():void
		{
			TimerProvider.removeTimeTask(m_curTimeStep, onTimerEvent);
		}
		
		private function onTimerEvent():void
		{
			this.addEventListener(MouseEvent.CLICK, onMouseClick);
			
			if(m_curTimeStep == m_timerDefaultTimeStep)
			{
				TimerProvider.removeTimeTask(m_curTimeStep, onTimerEvent);
				m_curTimeStep = m_fastTimeStep;
				TimerProvider.addTimeTask(m_curTimeStep, onTimerEvent);
			}
			this.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		
		private function onMouseClick(evt:MouseEvent):void
		{
			if(evt.currentTarget != this)
			{
				evt.stopPropagation();
			}
		}
		
		/**
		 *当鼠标长按住时是否连续派发CLICK事件 
		 * @param value
		 * 
		 */		
		public function set repeart(value:Boolean):void
		{
			m_repeart = value;
		}
		
		public function get repeart():Boolean
		{
			return m_repeart;
		}
		
		override public function set width(value:Number):void
		{
			m_skin.width = value;
		}
		
		override public function get width():Number
		{
			return m_skin.width;
		}
		
		override public function set height(value:Number):void
		{
			m_skin.height = value;
		}
		
		override public function get height():Number
		{
			return m_skin.height;
		}
		
		/**
		 *当前的按钮状态 
		 * @param value
		 * 
		 */		
		public function set status(value:int):void
		{
			m_status = value;
			waitUpdate();
		}
		
		public function get status():int
		{
			return m_status;
		}
		
		private function changeSelectedStatus():void
		{
			if(m_selectable){selected = !selected;}
		}
		
		public function set disable(value:Boolean):void
		{
			m_disable = value;
			if(m_disable)
			{
				this.status = (this.selected)?BaseButtonStatusDef.SELECTED_DISABLE:BaseButtonStatusDef.MOUSE_DISABLE;
				if(m_disableMatrixFilter)
				{
					this.filters = [m_disableMatrixFilter];
				}
				else
				{
					this.filters = [];
				}
				stopTimerCount();
				mouseEnabled = false;
			}
			else
			{
				if (this.status == BaseButtonStatusDef.MOUSE_DISABLE || this.status == BaseButtonStatusDef.SELECTED_DISABLE)
				{
					this.status = (this.selected)?BaseButtonStatusDef.SELECTED_MOUSE_UP:BaseButtonStatusDef.MOUSE_UP;
				}
				this.filters = [];
				mouseEnabled = true;
			}
		}
		
		public function get disable():Boolean
		{
			return m_disable;
		}
		
		/**
		 *设置选中状态 
		 * @param value
		 * 
		 */		
		public function set selected(value:Boolean):void
		{
			var changed:Boolean;
			
			if(radioGroup != null)
			{
				if(value == true)
				{
					RadionGroup.setSelectedItem(this);
				}
			}
			changed = value != m_selected;
			m_selected = value;
			if(changed)	
			{
				this.dispatchEvent(new Event(Event.CHANGE));
				statusTrasiform();
			}
		}
		
		public function get selected():Boolean
		{
			return m_selected;	
		}
		
		/**
		 *设置按钮是否为可选择的6态模式 
		 * @param value
		 * 
		 */		
		public function set selectable(value:Boolean):void
		{
			m_selectable = value;
		}
		
		public function get selectable():Boolean
		{
			return m_selectable;
		}
		
		private function statusTrasiform():void
		{
			switch(status)
			{
				case BaseButtonStatusDef.MOUSE_UP:
					status = BaseButtonStatusDef.SELECTED_MOUSE_UP;
					break;
				case BaseButtonStatusDef.MOUSE_OVER:
					status = BaseButtonStatusDef.SELECTED_MOUSE_OVER;
					break;
				case BaseButtonStatusDef.MOUSE_DOWN:
					status = BaseButtonStatusDef.SELECTED_MOUSE_DOWN;
					break;
				case BaseButtonStatusDef.SELECTED_DISABLE:
					status = BaseButtonStatusDef.MOUSE_DISABLE;
					break;
				case BaseButtonStatusDef.SELECTED_MOUSE_UP:
					status = BaseButtonStatusDef.MOUSE_UP;
					break;
				case BaseButtonStatusDef.SELECTED_MOUSE_OVER:
					status = BaseButtonStatusDef.MOUSE_OVER;
					break;
				case BaseButtonStatusDef.SELECTED_MOUSE_DOWN:
					status = BaseButtonStatusDef.MOUSE_DOWN;
					break;
				case BaseButtonStatusDef.MOUSE_DISABLE:
					status = BaseButtonStatusDef.SELECTED_DISABLE;
					break;
			}
			
			waitUpdate();
		}
		
		
		
		/**
		 * 设置按钮是否radio模式
		 * null为解除radio模式
		 * @param value
		 */		
		public function set radioGroup(value:String):void
		{
			if(value != null)
			{
				selectable = true;
				RadionGroup.addGroupItem(this, value);
			}
			else
			{
				RadionGroup.removeGroupItem(this);
			}
			
			m_radioGroup = value;
		}
		
		public function get radioGroup():String
		{
			return m_radioGroup;
		}
		
		/**
		 *立即更新 
		 * 
		 */		
		public function updateNow():void
		{
			update(new Event(Event.ENTER_FRAME));
		}
		
		/**
		 *在下一帧更新 
		 * 
		 */		
		public function waitUpdate():void
		{
			this.addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function update(evt:Event):void
		{
			this.removeEventListener(Event.ENTER_FRAME, update);
			
			if(m_status != m_curStatus)
			{
				m_skin.gotoAndStop(m_frameIndexMap[m_status]);
				m_curStatus = m_status;
			}
		}
		}
}

import com.tencent.morefun.naruto.plugin.ui.base.BaseButton;
import flash.utils.Dictionary;
	

class RadionGroup
{
	private static var ms_groupItemMap:Dictionary = new Dictionary();
	private static var ms_theSelectedItems:Dictionary = new Dictionary();
	
	public function RadionGroup()
	{
		
	}
	
	public static function addGroupItem(button:BaseButton, groupName:String):void
	{
		var itemMap:Dictionary;
		
		itemMap = ms_groupItemMap[groupName];
		if(itemMap == null)
		{
			itemMap = new Dictionary();
			ms_groupItemMap[groupName] = itemMap;
		}
		
		itemMap[button] = button;
	}
	
	public static function removeGroupItem(button:BaseButton):void
	{
		var itemMap:Dictionary;
		
		itemMap = ms_groupItemMap[button.radioGroup];
		if(itemMap == null)
		{
			return ;
		}
		
		if(ms_theSelectedItems[button.radioGroup] == button)
		{
			delete ms_theSelectedItems[button.radioGroup];
		}
		
		delete itemMap[button];
	}
	
	public static function setSelectedItem(button:BaseButton):void
	{
		var old:BaseButton;
		
		old = ms_theSelectedItems[button.radioGroup];
		if(old != null && old.selected)
		{
			old.mouseEnabled = true;
			old.selected = false;
		}
		
		button.mouseEnabled = false;
		ms_theSelectedItems[button.radioGroup] = button;
	}}