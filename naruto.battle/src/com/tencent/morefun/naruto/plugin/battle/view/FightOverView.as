package com.tencent.morefun.naruto.plugin.battle.view
{

	import com.tencent.morefun.framework.apf.core.facade.Facade;
	import com.tencent.morefun.naruto.plugin.battle.view.fightOver.ExamWinView;
	import com.tencent.morefun.naruto.plugin.battle.view.fightOver.FightFailView;
	import com.tencent.morefun.naruto.plugin.battle.view.fightOver.FightWinView;
	
	import flash.display.Sprite;
	
	import battle.data.BattleInfo;
	
	import def.ModelDef;
	
	import serverProto.fight.FightStartType;

	public class FightOverView extends Sprite
	{
		private var _view:Object;
		public function FightOverView(isWin:Boolean, showDamage:Boolean)
		{
			super();
			var battleModel:BattleInfo = Facade.getInstance().model.retrieveModel(ModelDef.BATTLE) as BattleInfo;
			
			
			if (isWin)
			{
				if (battleModel.type == FightStartType.FIGHT_START_TYPE_NINJA_EXAM) 
				{
					_view = new ExamWinView();
				}
				else
				{
					_view = new FightWinView(showDamage);
				}
			}
			else
			{
				_view = new FightFailView(showDamage);
			}
			addChild(_view.ui);
		}
		
		public function destroy():void
		{
			_view["destroy"]();
			if (_view && contains(_view.ui)) {
				removeChild(_view.ui);
			}
			_view = null;
		}
		override public function get numChildren():int 
		{
			return 0;
		}
																
		public function autoSetNull():void
		{

			_view = null;
		}
	}
}