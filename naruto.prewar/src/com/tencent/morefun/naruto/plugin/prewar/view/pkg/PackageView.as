package com.tencent.morefun.naruto.plugin.prewar.view.pkg
{
	import com.greensock.TweenLite;
	import com.tencent.morefun.framework.base.Command;
	import com.tencent.morefun.framework.base.CommandEvent;
	import com.tencent.morefun.naruto.plugin.prewar.TalentItemRenderUI;
	import com.tencent.morefun.naruto.plugin.prewar.command.DisableReadyCommand;
	import com.tencent.morefun.naruto.plugin.prewar.command.UpdateSelfSkillInfoCommand;
	import com.tencent.morefun.naruto.plugin.prewar.data.PrewarModel;
	import com.tencent.morefun.naruto.plugin.prewar.data.PrewarPlayerInfo;
	import com.tencent.morefun.naruto.plugin.prewar.def.StatusDef;
	import com.tencent.morefun.naruto.plugin.ui.base.BaseButton;
	import com.tencent.morefun.naruto.plugin.ui.base.BitmapText;
	import com.tencent.morefun.naruto.plugin.ui.base.DirectionGrid;
	import com.tencent.morefun.naruto.plugin.ui.base.def.DirectionDef;
	import com.tencent.morefun.naruto.plugin.ui.base.event.GridEvent;
	import com.tencent.morefun.naruto.plugin.ui.layer.LayerManager;
	import com.tencent.morefun.naruto.plugin.ui.layer.LayoutManager;
	import com.tencent.morefun.naruto.plugin.ui.layer.def.LayerDef;
	import com.tencent.morefun.naruto.plugin.ui.layer.def.LocationDef;
	import com.tencent.morefun.naruto.plugin.ui.util.DisplayUtils;
	import com.tencent.morefun.naruto.plugin.ui.util.TimerProvider;
	import serverProto.formation.FormationType;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import base.ApplicationData;
	
	import battle.command.PrewarReadyAckCommand;
	import battle.data.BattleInfo;
	
	import def.ModelDef;
	
	import hud.utils.HudMenuIconUtils;
	
	import majorRole.commands.GetMajorRoleSkillCommand;
	import majorRole.commands.GetTalentPageIndexCommand;
	import majorRole.commands.SetTalentPageIndexCommand;
	
	import ninja.model.data.NinjaInfo;
	
	import serverProto.fight.FightStartType;
	
	import sound.commands.PlayUISoundCommand;
	import sound.def.UISoundDef;
	
	public class PackageView
	{	
		private static const COOLDOWN:int = 60;
		
		private var _data:PrewarModel;
		private var _view:MovieClip;
		
		private var _talentNameList:Array;
		private var _currentTalentIndex:int;
		
		private var commendBtn:BaseButton;
		private var commendList:DirectionGrid;
		
		private var ninjaList:DirectionGrid;
		private var ninjaListRect:Rectangle;
		
		private var talentBackground:MovieClip;
		
		private var cooldownText:BitmapText;
		
		private var getTalentCommand:GetTalentPageIndexCommand;
		private var getMajorRoleCommand:GetMajorRoleSkillCommand;
		
		private var cooldownSecond:int = COOLDOWN;
		
		private var packageNinjaRenderList:Vector.<PackageNinjaItemRender> = new Vector.<PackageNinjaItemRender>();
		
		public function PackageView(view:MovieClip)
		{
			_view = view;
			
			initUI();
		}
		
		private function initUI():void
		{
			//			for(var i:int = 0;i < 6;i ++)
			//			{
			//				packageNinjaRender = new PackageNinjaItemRender(_view["ninjaItem" + i]);
			//				packageNinjaRenderList.push(packageNinjaRender);
			//			}
			
			ninjaListRect = new Rectangle(_view["listArea"].x, _view["listArea"].y, _view["listArea"].width, _view["listArea"].height);
			ninjaList = new DirectionGrid(1, 12, PackageNinjaItemRender, null, null, DirectionDef.HORIZONTAL, false);
			DisplayUtils.replaceDisplay(_view["listArea"], ninjaList);
			
			cooldownText = new BitmapText(new CoolDownTextAsset(), 40, 43, 0, true, "1234567890");
			DisplayUtils.replaceDisplay(_view["cooldown"]["txt"], cooldownText);
			commendBtn = new BaseButton(_view["talentBtn"]);
			_view.addChild(commendBtn);
			
			talentBackground = _view["talentBackground"];
			
			commendList = new DirectionGrid(0, 1, TalentItemRender, TalentItemRenderUI );
			DisplayUtils.replaceDisplay(_view["talentList"], commendList);
			commendList.addEventListener(GridEvent.ITEM_CLICK, onItemClick);
			
			LayerManager.singleton.stage.addEventListener(MouseEvent.MOUSE_DOWN, onStageMouseDown);
			LayoutManager.singleton.addItemAndLayout(_view, LayerDef.PREWAR_UI, LocationDef.TOPCENTRE);
			
			_view.visible = false;
			commendList.visible = false;
			_view["talentBg"].visible = false;
			
			if(!HudMenuIconUtils.has(HudMenuIconUtils.HUD_TALENT))
			{
				commendBtn.visible = false;
				talentBackground.visible = false;
			}
			
			
			if((ApplicationData.singleton.getModel(ModelDef.BATTLE) as BattleInfo).type == FightStartType.FIGHT_START_TYPE_EXPEDITION)
			{
				_view["cooldown"].visible = false;
			}
			
			reset();
		}
		
		public function startCoolDown(elapseTime:int):void
		{
			cooldownSecond = COOLDOWN - elapseTime;
			TimerProvider.addTimeTask(1000, onNextSecond);
			cooldownText.text = cooldownSecond.toString();
		}
		
		private var readyAckCommand:PrewarReadyAckCommand;
		private function onNextSecond():void
		{
			var selfPrewarPlayer:PrewarPlayerInfo;
			
			cooldownSecond --;
			cooldownText.text = cooldownSecond.toString();
			
			if(cooldownSecond <= 0)
			{
				for each(selfPrewarPlayer in _data.prewarPlayers)
				{
					if(selfPrewarPlayer.isSelf)
					{
						break;
					}
				}
				
				TimerProvider.removeTimeTask(1000, onNextSecond);
				
				if(selfPrewarPlayer.status != StatusDef.READY)
				{
					readyAckCommand = new PrewarReadyAckCommand();
					readyAckCommand.call();
				}
				
				new DisableReadyCommand().call();
			}
		}
		
		private function onReadyFinish(evt:CommandEvent):void
		{
			var selfPrewarPlayer:PrewarPlayerInfo;
			
			readyAckCommand = evt.currentTarget as PrewarReadyAckCommand;
			readyAckCommand.removeEventListener(CommandEvent.FAILD, onReadyFail);
			readyAckCommand.removeEventListener(CommandEvent.FINISH, onReadyFinish);
			
			for each(selfPrewarPlayer in _data.prewarPlayers)
			{
				if(selfPrewarPlayer.isSelf)
				{
					break;
				}
			}
			
			selfPrewarPlayer.status = StatusDef.READY;
		}
		
		private function onReadyFail(evt:CommandEvent):void
		{
			readyAckCommand = evt.currentTarget as PrewarReadyAckCommand;
			readyAckCommand.removeEventListener(CommandEvent.FAILD, onReadyFail);
			readyAckCommand.removeEventListener(CommandEvent.FINISH, onReadyFinish);
		}
		
		private function onStageMouseDown(evt:MouseEvent):void
		{
			if(!_talentNameList)
			{
				return ;
			}
			
			if(commendBtn.contains(evt.target as DisplayObject) || commendList.contains(evt.target as DisplayObject))
			{
				showList();
				new PlayUISoundCommand(UISoundDef.BUTTON_CLICK).call();
			}
			else
			{
				hideList();
				//				new PlayUISoundCommand(UISoundDef.BUTTON_CLICK).call();
			}
		}
		
		private function showList():void
		{
			commendList.visible = true;
			_view["talentBg"].visible = true;
		}
		
		private function hideList():void
		{
			commendList.visible = false;
			_view["talentBg"].visible = false;
		}
		
		private function onItemClick(evt:GridEvent):void
		{
			var setTalentPageCommand:SetTalentPageIndexCommand;
			
			hideList();
			
			setTalentPageCommand = new SetTalentPageIndexCommand(evt.itemRenderer.index);
			setTalentPageCommand.addEventListener(CommandEvent.FINISH, function(evt:CommandEvent):void
			{
				(evt.currentTarget as Command).removeEventListener(CommandEvent.FINISH, arguments.callee);
				updateTalent();
			});
			setTalentPageCommand.call();
		}
		
		private function onTalentFinish(command:GetTalentPageIndexCommand):void
		{
			var padding:int = 20;
			
			_talentNameList = command.names;
			_currentTalentIndex = command.pageIndex;
			commendList.row = _talentNameList.length;
			commendList.width = commendList.col * commendList.cellWidth;
			commendList.height = commendList.row * commendList.cellHeight;
			_view["talentBg"].height = commendList.row * commendList.cellHeight + padding;
			commendList.y = _view["talentBg"].y + padding / 2;
			commendList.source = _talentNameList;
			
			commendBtn.skin["txt"].text =  _talentNameList[_currentTalentIndex];
		}
		
		public function reset():void
		{
			for each(var packageNinjaRender:PackageNinjaItemRender in packageNinjaRenderList)
			{
				packageNinjaRender.hide();
			}
		}
		
		public function hitTestObject(obj:DisplayObject):Boolean
		{
			return _view.hitTestObject(obj);
		}
		
		public function updateTalent():void
		{
			getTalentCommand = new GetTalentPageIndexCommand();
			getTalentCommand.addEventListener(CommandEvent.FAILD, function(evt:CommandEvent):void
			{
				(evt.currentTarget as Command).removeEventListener(CommandEvent.FAILD, arguments.callee);
				(evt.currentTarget as Command).removeEventListener(CommandEvent.FINISH, arguments.callee);
			});
			getTalentCommand.addEventListener(CommandEvent.FINISH, function(evt:CommandEvent):void
			{
				(evt.currentTarget as Command).removeEventListener(CommandEvent.FAILD, arguments.callee);
				(evt.currentTarget as Command).removeEventListener(CommandEvent.FINISH, arguments.callee);
				
				onTalentFinish((evt.currentTarget as GetTalentPageIndexCommand));
				
				var getSkillCommand:GetMajorRoleSkillCommand;
				
				getSkillCommand = new GetMajorRoleSkillCommand();
				getSkillCommand.addEventListener(CommandEvent.FINISH, onGetMajorSkillResult);
				getSkillCommand.addEventListener(CommandEvent.FAILD, onGetMajorSkillResult);
				getSkillCommand.call();
			});
			getTalentCommand.call();
		}
		
		private function onGetMajorSkillResult(evt:CommandEvent):void
		{
			var getSkillCommand:GetMajorRoleSkillCommand;
			
			getSkillCommand = evt.currentTarget as GetMajorRoleSkillCommand;
			getSkillCommand.removeEventListener(CommandEvent.FAILD, onGetMajorSkillResult);
			getSkillCommand.removeEventListener(CommandEvent.FINISH, onGetMajorSkillResult);
			if(evt.type == CommandEvent.FINISH)
			{
				new UpdateSelfSkillInfoCommand(getSkillCommand.special, getSkillCommand.normal, getSkillCommand.skills).call();
			}
		}
		
		public function set data(value:PrewarModel):void
		{
			var i:int;
			var ninjaInfo:NinjaInfo;
			var ninjaInfoList:Vector.<NinjaInfo>;
			var packNinjaList:Vector.<NinjaInfo>;
			var compentPkgNinjaListSource:Array = [];
			var checkType:int;
			var battleModel:BattleInfo;
			
			reset();
			
			_data = value;
			
			packNinjaList = new Vector.<NinjaInfo>();
			battleModel = ApplicationData.singleton.getModel(ModelDef.BATTLE) as BattleInfo;
			
			if(battleModel.type == FightStartType.FIGHT_START_TYPE_EXPEDITION)
			{
				checkType = FormationType.EXPEDITION_FORMATION;
			}
			else
			{
				checkType = FormationType.DEFAULT_FORMATION;
			}
			
			ninjaInfoList = _data.pkgNinjaInfos;
			for(i= 0;i < ninjaInfoList.length;i ++)
			{
				ninjaInfo = ninjaInfoList[i];
				if(!ninjaInfo.checkIsInFormation(checkType))
				{
					packNinjaList.push(ninjaInfo);
				}
			}
			
			for each(ninjaInfo in packNinjaList)
			{
				compentPkgNinjaListSource.push(ninjaInfo);
			}
			
			compentPkgNinjaListSource.sortOn(["sortHp", "sequence"], [Array.DESCENDING, Array.NUMERIC]);
			
			ninjaList.source = compentPkgNinjaListSource;
			ninjaList.x = ninjaListRect.x + (ninjaListRect.width - ninjaList.source.length * ninjaList.cellWidth) / 2;
			if(!HudMenuIconUtils.has(HudMenuIconUtils.HUD_TALENT))
			{
				commendBtn.visible = false;
				talentBackground.visible = false;
			}
			else
			{
				commendBtn.visible = true;
				talentBackground.visible = true;
			}
			
		}

		
		public function get data():PrewarModel
		{
			return _data;
		}
		
		public function destroy():void
		{
			for each(var packageNinjaRender:PackageNinjaItemRender in packageNinjaRenderList)
			{
				packageNinjaRender.destroy();
			}
			
			cooldownText.destroy();
			LayerManager.singleton.stage.removeEventListener(MouseEvent.MOUSE_DOWN, onStageMouseDown);
			LayoutManager.singleton.removeItem(_view);
			TimerProvider.removeTimeTask(1000, onNextSecond);
		}
		
		public function get view():MovieClip
		{
			return _view;
		}
		
		public function show():void
		{
			_view.visible = true;
		}
		
		public function hide():void
		{
			_view.visible = false;
		}
		
		public function close():void
		{
			TweenLite.to(_view, 1, {y:-_view.height + _view.cooldown.height});
		}
	}
}