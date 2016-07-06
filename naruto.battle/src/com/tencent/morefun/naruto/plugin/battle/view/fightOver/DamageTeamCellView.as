package  com.tencent.morefun.naruto.plugin.battle.view.fightOver
{
	import com.tencent.morefun.naruto.plugin.battle.view.fightOver.damage.DamagePlayerInfo;
	import com.tencent.morefun.naruto.plugin.ui.base.ItemRenderer;
	import com.tencent.morefun.naruto.plugin.ui.components.interfaces.IRender;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import naruto.battle.ui.TeamCellUI;
	/**
	 * ...
	 * @author Devin Lee
	 */
	public class DamageTeamCellView extends ItemRenderer implements IRender
	{
		private var _ui:TeamCellUI;
		private var _leftNinjas:Array;
		private var _rightNinjas:Array;
		private var _rightIcon:MovieClip;
		private var _leftIcon:MovieClip;
		
		public function DamageTeamCellView() 
		{
			_ui = new TeamCellUI;
			addChild(_ui);
			configUI();
		}
		
		private function configUI():void 
		{
			var lor:MovieClip;
			var ninjas:Array;
			var i:int;
			
			ninjas = [];
			lor = _ui.leftUI;
			
			for (i = 0; i < 4; i++) 
			{
				ninjas.push(new DamageInfoRender(lor["c" + i]));
			}
			_leftNinjas = ninjas;
			_leftIcon = lor.iconUI;
			
			ninjas = [];
			lor = _ui.rightUI;
			
			for (i = 0; i < 4; i++) 
			{
				ninjas.push(new DamageInfoRender(lor["c" + i]));
			}
			_rightNinjas = ninjas;
			_rightIcon = lor.iconUI;
			
		}
		override public function get data():Object 
		{
			return super.data;
		}
		
		override public function set data(value:Object):void 
		{
			var damageInfoRender:DamageInfoRender;
			var pi:DamagePlayerInfo;
			var ninjas:Array;
			super.data = value;
			
			for (i = 0; i < _leftNinjas.length; i++) 
			{
				_leftNinjas[i].visible = false;
				_rightNinjas[i].visible = false;
			}
			if (!value) return;
			
			var datas:Array = value as Array;
			for (var j:int = 0; j < datas.length; j++) 
			{
				pi = datas[j]; 
				
				if (pi.teamPos == 0 || pi.teamPos == 2 || pi.teamPos == 4) {
					ninjas = _leftNinjas;
				}else {
					ninjas = _rightNinjas;
				}
				for(var i:int = 0;i < pi.damageNinjaInfos.length;i ++)
				{
					damageInfoRender = ninjas[i];
					damageInfoRender.visible = true;
					damageInfoRender.update(pi.damageNinjaInfos[i]);
				}
			}
			
			if (pi.teamPos == 0 || pi.teamPos == 1) {
				_leftIcon.gotoAndStop(1);
				_rightIcon.gotoAndStop(1);
			}else if (pi.teamPos == 4 || pi.teamPos == 5) {
				_leftIcon.gotoAndStop(3);
				_rightIcon.gotoAndStop(3);
			}else if (pi.teamPos == 2 || pi.teamPos == 3) {
				_leftIcon.gotoAndStop(2);
				_rightIcon.gotoAndStop(2);
			}
			
		}
		public function changeTab(curModel:int):void 
		{
			var damageInfoRender:DamageInfoRender;
			
			for each(damageInfoRender in _leftNinjas)
			{
				damageInfoRender.changeModel(curModel);
			}
			
			for each(damageInfoRender in _rightNinjas)
			{
				damageInfoRender.changeModel(curModel);
			}
		}
		
		/* INTERFACE com.tencent.morefun.naruto.plugin.ui.components.interfaces.IRender */
		
		public function dispose():void 
		{
			var damageInfoRender:DamageInfoRender;
			
			
			for each(damageInfoRender in _leftNinjas)
			{
				damageInfoRender.destroy();
			}
			
			for each(damageInfoRender in _rightIcon)
			{
				damageInfoRender.destroy();
			}
		}
		
	}

}