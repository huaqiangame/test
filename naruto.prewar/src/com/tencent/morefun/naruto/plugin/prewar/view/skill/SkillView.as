package com.tencent.morefun.naruto.plugin.prewar.view.skill
{
	import com.tencent.morefun.naruto.plugin.prewar.data.PrewarModel;
	import com.tencent.morefun.naruto.plugin.prewar.data.PrewarPlayerInfo;
	import com.tencent.morefun.naruto.plugin.ui.core.CoreValueBar;
	import com.tencent.morefun.naruto.plugin.ui.layer.LayoutManager;
	import com.tencent.morefun.naruto.plugin.ui.layer.def.LayerDef;
	import com.tencent.morefun.naruto.plugin.ui.layer.def.LocationDef;
	import serverProto.formation.FormationType;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import base.ApplicationData;
	
	import battle.data.BattleInfo;
	
	import def.ModelDef;
	
	import ninja.model.data.NinjaInfo;
	
	import serverProto.fight.FightStartType;
	
	public class SkillView
	{
		private var _data:PrewarModel;
		private var _view:MovieClip;
		private var _skillMpValueBar:CoreValueBar;
		private var _skillRenderList:Vector.<SkillItemRender> = new Vector.<SkillItemRender>();
		
		public function SkillView(view:MovieClip)
		{
			_view = view;
			super();
			
			initUI();
		}
		
		public function initUI():void
		{
			var skillItemRender:SkillItemRender;
			
			for(var i:int = 0;i < 4;i ++)
			{
				skillItemRender = new SkillItemRender(_view["skillItem" + i]);
				_skillRenderList.push(skillItemRender);
			}
			
			_view.indicator["mpTxt"].text = "0/100";
			_skillMpValueBar = new CoreValueBar(_view.indicator["mp"]);
			_skillMpValueBar.update(0, 100);
			reset();
			
			LayoutManager.singleton.stage.addEventListener(Event.RESIZE, onResize);
			LayoutManager.singleton.addItemAndLayout(_view, LayerDef.PREWAR_UI, LocationDef.BOTTOMCENTRE);
			
			onResize(null);
		}
		
		public function reset():void
		{
			var skillItemRender:SkillItemRender;
			
			for(var i:int = 0;i < _skillRenderList.length;i ++)
			{
				skillItemRender = _skillRenderList[i];
				skillItemRender.data = null;
			}
		}
		
		public function set data(value:PrewarModel):void
		{
			var i:int;
			var j:int;
			var sequence:int;
			var skillItemRender:SkillItemRender;
			var packNinjaList:Vector.<NinjaInfo>;
			var formationNinjaList:Vector.<NinjaInfo>;
			var ninjaInfo:NinjaInfo;
			var ninjaInfoList:Vector.<NinjaInfo>;
			var selfPrewarPlayer:PrewarPlayerInfo;
			var battleModel:BattleInfo;
			var checkType:int;
			
			_data = value;
			
			reset();
			
			for each(selfPrewarPlayer in value.prewarPlayers)
			{
				if(selfPrewarPlayer.isSelf)
				{
					break;
				}
			}
			
			battleModel = ApplicationData.singleton.getModel(ModelDef.BATTLE) as BattleInfo;
			
			if(battleModel.type == FightStartType.FIGHT_START_TYPE_EXPEDITION)
			{
				checkType = FormationType.EXPEDITION_FORMATION;
			}
			else
			{
				checkType = FormationType.DEFAULT_FORMATION;
			}
			
			packNinjaList = new Vector.<NinjaInfo>();
			formationNinjaList = new Vector.<NinjaInfo>();
			ninjaInfoList = _data.pkgNinjaInfos;
			for(i= 0;i < ninjaInfoList.length;i ++)
			{
				ninjaInfo = ninjaInfoList[i];
				
				if(!ninjaInfo.checkIsInFormation(checkType))
				{
					packNinjaList.push(ninjaInfo);
				}
				else
				{
					formationNinjaList.push(ninjaInfo);
				}
			}
			
			if(selfPrewarPlayer.hotkeyInfo != null)
			{
				for(j = 0;j < selfPrewarPlayer.hotkeyInfo.list.length;j ++)
				{
					if(j >= 4){continue ;}
					
					sequence = selfPrewarPlayer.hotkeyInfo.list[j];
					if(sequence != -1)
					{
						for(i = 0;i < formationNinjaList.length;i ++)
						{
							ninjaInfo = formationNinjaList[i];
							if(ninjaInfo.sequence == sequence)
							{
								skillItemRender = _skillRenderList[j];
								skillItemRender.data = ninjaInfo;
								skillItemRender.hotKeyInfo = selfPrewarPlayer.hotkeyInfo;
							}
						}
					}
				}
			}
			
			_view.indicator["mpTxt"].text = selfPrewarPlayer.mp + "/100";
			_skillMpValueBar.update(selfPrewarPlayer.mp, 100);
		}
		
		private function onResize(evt:Event):void
		{
			var stageWidth:int;
			var stageHeight:int;
			var minWidth:int = 1020;
			var maxWidth:int = 1300;
			
			stageWidth = LayoutManager.singleton.stage.stageWidth;
			stageHeight = LayoutManager.singleton.stage.stageHeight;
			stageWidth = Math.min(stageWidth, maxWidth);
			stageWidth = Math.max(stageWidth, minWidth);
			
			_view.x = stageWidth - (stageWidth - 280);
		}
		
		public function get data():PrewarModel
		{
			return _data;
		}
		
		public function destroy():void
		{
			LayoutManager.singleton.removeItem(_view);
			LayoutManager.singleton.stage.removeEventListener(Event.RESIZE, onResize);
			
			for each(var skillItemRender:SkillItemRender in _skillRenderList)
			{
				skillItemRender.destroy();
			}
		}
	}
}