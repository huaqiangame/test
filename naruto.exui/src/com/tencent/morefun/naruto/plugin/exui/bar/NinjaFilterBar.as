package com.tencent.morefun.naruto.plugin.exui.bar
{
	import com.tencent.morefun.naruto.plugin.exui.dropDownList.BeHitStateDropDownList;
	import com.tencent.morefun.naruto.plugin.exui.dropDownList.ExStateDropDownList;
	import com.tencent.morefun.naruto.plugin.exui.dropDownList.NinjaClassDropDownList;
	import com.tencent.morefun.naruto.plugin.exui.dropDownList.NinjaStarLevelDropDownList;
	
	import com.tencent.morefun.naruto.plugin.ui.base.event.GridEvent;
	
	
	import flash.display.Sprite;
	
	import flash.text.TextField;
	
	/**
	 * @author woodychen
	 * @createTime 2014-7-17 下午4:47:47
	 **/
	public class NinjaFilterBar extends Sprite
	{
		private var _ninjaRareDDL:NinjaStarLevelDropDownList;
		private var _ninjaClassDDL:NinjaClassDropDownList;
		private var _beHitStateDDL:BeHitStateDropDownList;
		private var _exStateDDL:ExStateDropDownList;
		private var _searchInput:TextField;
		private var _inputMsg:String;
		
		/**
		 * @param own 已拥有复选框
		 * @param rare 稀有度下拉列表
		 * @param ninjaClass 忍者属性下拉列表
		 * @param beHitState 追打状态下拉列表
		 * @param exState 造成状态下拉列表
		 * @param nameSearch 忍者名字搜索栏
		 */
		public function NinjaFilterBar(own:Boolean = true, rare:Boolean = true, ninjaClass:Boolean = true, beHitState:Boolean = true, exState:Boolean = true, nameSearch:Boolean = true)
		{
			super();
			
			initUI();
		}
		
		private function initUI():void
		{
			//rareDropDownList
			_ninjaRareDDL = new NinjaStarLevelDropDownList();
//			_ninjaRareDDL.addEventListener(GridEvent.ITEM_CLICK, onNinjaRareDDLClicked);
			
			//ninjaClassDropDownList
//			_ninjaClassDDL = new NinjaClassDropDownList();
//			_ninjaClassDDL.addEventListener(GridEvent.ITEM_CLICK, onNinjaClassDDLClicked);
			
			//beHitState
			_beHitStateDDL = new BeHitStateDropDownList();
//			_beHitStateDDL.addEventListener(GridEvent.ITEM_CLICK, onBeHitStateDDLClick);
			
			//state
			_exStateDDL = new ExStateDropDownList();
//			_exStateDDL.addEventListener(GridEvent.ITEM_CLICK, onExStateDDLClick);
		}
		
		
	}
}