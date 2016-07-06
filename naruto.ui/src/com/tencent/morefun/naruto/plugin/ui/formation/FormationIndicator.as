package com.tencent.morefun.naruto.plugin.ui.formation  
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.getDefinitionByName;
	import tactic.model.data.TacticPositionInfo;

	public class FormationIndicator extends TroopIndicator
	{
		protected var _occupied:Boolean;
		protected var _id:uint;
		
		protected var _target:SimpleTroop;
		protected var _tacticPositionIndicator:Sprite;
		
		/**	
		 * 构造函数
		 * create a [FormationIndicator] object
		 */
		public function FormationIndicator(id:uint, view:MovieClip, offsetX:uint, offsetY:uint) 
		{
			_id = id;
			
			view.visible = false;
			super(view, offsetX, offsetY);
			
			var TacticPositionAdditionIndicator:Class = getDefinitionByName("com.tencent.morefun.naruto.plugin.exui.tactic.TacticPositionAdditionIndicator") as Class;
			addChild(_tacticPositionIndicator = new TacticPositionAdditionIndicator());
			
			_tacticPositionIndicator.visible = false;
		}
		
		/**
		 * 重置状态
		 */
		public function reset():void
		{
			_target = null;
			_occupied = false;
			
			this.status = IndicatorStatusDef.NORMAL;
		}
		
		override public function dispose():void 
		{
			super.dispose();
			
			_tacticPositionIndicator["dispose"]();
			_tacticPositionIndicator = null;
			
			_target = null;
		}
		
		/**
		 * 基座是否被占用标记
		 */
		public function get occupied():Boolean { return _occupied; }
		public function set occupied(value:Boolean):void 
		{
			_occupied = value;
		}
		
		/**
		 * 阵法位置
		 */
		public function get id():uint { return _id; }
		
		/**
		 * 阵法基座引用的小队
		 */
		public function get target():SimpleTroop { return _target; }
		public function set target(value:SimpleTroop):void 
		{
			_target = value;
		}
		
		/**
		 * 战法站位信息
		 */
		public function get tacticPositionInfo():TacticPositionInfo { return _tacticPositionIndicator["data"]; }
		public function set tacticPositionInfo(value:TacticPositionInfo):void 
		{
			_tacticPositionIndicator.visible = value != null;
			_tacticPositionIndicator["data"] = value;
		}
	}

}