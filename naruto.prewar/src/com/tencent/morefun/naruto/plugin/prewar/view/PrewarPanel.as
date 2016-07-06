package com.tencent.morefun.naruto.plugin.prewar.view
{
	import com.tencent.morefun.framework.base.CommandEvent;
	import com.tencent.morefun.naruto.i18n.I18n;
	import com.tencent.morefun.naruto.model.event.ModelEvent;
	import com.tencent.morefun.naruto.plugin.exui.base.Image;
	import com.tencent.morefun.naruto.plugin.prewar.PrewarUI;
	import com.tencent.morefun.naruto.plugin.prewar.command.UpdateSelfFormationCommand;
	import com.tencent.morefun.naruto.plugin.prewar.command.UpdateSelfNinjaListCommand;
	import com.tencent.morefun.naruto.plugin.prewar.command.UpdateSelfSkillInfoCommand;
	import com.tencent.morefun.naruto.plugin.prewar.component.NoticeSpeeker;
	import com.tencent.morefun.naruto.plugin.prewar.data.PrewarModel;
	import com.tencent.morefun.naruto.plugin.prewar.data.PrewarPlayerInfo;
	import com.tencent.morefun.naruto.plugin.prewar.def.DataDef;
	import com.tencent.morefun.naruto.plugin.prewar.def.NinjaDockStateDef;
	import com.tencent.morefun.naruto.plugin.prewar.def.PlayerType;
	import com.tencent.morefun.naruto.plugin.prewar.def.StatusDef;
	import com.tencent.morefun.naruto.plugin.prewar.event.NinjaEvent;
	import com.tencent.morefun.naruto.plugin.prewar.util.SimpleClipboard;
	import com.tencent.morefun.naruto.plugin.prewar.view.formation.NinjaTroopView;
	import com.tencent.morefun.naruto.plugin.prewar.view.formation.TroopNinja;
	import com.tencent.morefun.naruto.plugin.prewar.view.formation.TroopView;
	import com.tencent.morefun.naruto.plugin.prewar.view.pkg.PackageView;
	import com.tencent.morefun.naruto.plugin.prewar.view.skill.SkillView;
	import com.tencent.morefun.naruto.plugin.ui.base.BaseButton;
	import com.tencent.morefun.naruto.plugin.ui.fonts.FontStyleMgr;
	import com.tencent.morefun.naruto.plugin.ui.layer.LayerManager;
	import com.tencent.morefun.naruto.plugin.ui.layer.LayoutManager;
	import com.tencent.morefun.naruto.plugin.ui.layer.def.LayerDef;
	import com.tencent.morefun.naruto.plugin.ui.layer.def.LocationDef;
	import serverProto.formation.FormationType;
	import serverProto.inc.NinjaSourceType;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	import base.ApplicationData;
	
	import battle.command.PrewarReadyAckCommand;
	import battle.data.BattleInfo;
	
	import def.BoxFlagDef;
	import def.ModelDef;
	
	import majorRole.commands.GetMajorRoleSkillCommand;
	
	import naruto.component.controls.ButtonNormalYellow;
	
	import ninja.command.OperateFormationCommand;
	import ninja.command.RequestFormationTroopCommand;
	import ninja.model.data.FormationInfo;
	import ninja.model.data.NinjaArrangeInfo;
	
	import prewar.def.PrewarModelKeyDef;
	
	import serverProto.fight.FightStartType;
	
	import sound.commands.PlayUISoundCommand;
	import sound.def.UISoundDef;
	
	import team.cmd.RequestChangeMemberPosCommand;
	import team.def.MemberIndexDef;
	
	import ui.command.ShowTextBoxCommand;
	
	import user.data.UserInfo;
	
	/**
	 * 更新忍者图标数字展示
	 */
	[Event(name = "updateIconsNum", type = "com.tencent.morefun.naruto.plugin.ninja.event.NinjaEvent")]
	
	/**
	 * 阵法页面
	 * @author larryhou
	 * @createTime 2013/9/23 17:38
	 */
    import com.tencent.morefun.naruto.i18n.I18n;
	public class PrewarPanel extends Sprite
	{
		private var _view:PrewarUI;
		
		private var _packageView:PackageView;
		private var _troopView:TroopView;
		private var _skillView:SkillView;
		//		private var _frame:PrewarFrame;
		
		private var _dragTarget:TroopNinja;
		
		private var _speeker:NoticeSpeeker;
		
		private var _dict:Dictionary;
		
		private var _selfInfo:UserInfo;
		private var _prewarModel:PrewarModel;
		
		private var _readyBtn:ButtonNormalYellow;
		
		private var _teamTToMBtn:BaseButton;
		private var _teamMToTBtn:BaseButton;
		private var _teamBToMBtn:BaseButton;
		private var _teamMToBBtn:BaseButton;
		
		private var _selfTeamPos:int;
		private var _selfFormation:FormationInfo;
		private var _dragNinjaContainer:MovieClip;
		private var _background:Image;
		
		private var _isCaptain:Boolean;
		
		/**
		 * 构造函数
		 * create a [FormationNinjaPage] object
		 */
		public function PrewarPanel(prewarModel:PrewarModel) 
		{
			_prewarModel = prewarModel;
			
			_selfInfo = ApplicationData.singleton.selfInfo;
		}
		
		public function get selfFormation():FormationInfo
		{
			return _selfFormation;
		}
		
		public function set selfFormation(value:FormationInfo):void
		{
			_selfFormation = value;
		}
		
		public function get selfTeamPos():int
		{
			return _selfTeamPos;
		}
		
		public function set selfTeamPos(value:int):void
		{
			_selfTeamPos = value;
		}
		
		public function startCoolDown(elapseTime:int):void
		{
			_packageView.startCoolDown(elapseTime);
		}
		
		public function disableReady():void
		{
			_readyBtn.enabled = false;
		}
		
		public function show():void
		{
			_view.visible = true;
			_packageView.show();
		}
		
		public function close():void
		{
			_view.visible = false;
			_packageView.hide();
		}
		
		private function onPrewarModelEvent(evt:ModelEvent):void
		{
			switch(evt.key)
			{
				case PrewarModelKeyDef.ADD_PREWAR_PLAYER:
					onAddPrewarModelPlayer(evt.oldValue as PrewarPlayerInfo);
					break;
				case PrewarModelKeyDef.REMOVE_PREWAR_PLAYER:
					onRemovePrewarModelPlayer(evt.oldValue as PrewarPlayerInfo);
					break;
			}
		}
		
		private function onAddPrewarModelPlayer(prewarPlayer:PrewarPlayerInfo):void
		{
			_troopView.setPrewarPlayer(prewarPlayer.teamPos, prewarPlayer);
			updateCaptainOption();
			refresh();
		}
		
		private function onRemovePrewarModelPlayer(prewarPlayer:PrewarPlayerInfo):void
		{
			_troopView.setPrewarPlayer(prewarPlayer.teamPos, null);
			updateCaptainOption();
			refresh();
		}
		
		public function init():void
		{
			_prewarModel.addEventListener(ModelEvent.UPDATE, onPrewarModelEvent);
			addChild(_view = new PrewarUI());
			
			_teamTToMBtn = new BaseButton(_view.troop.teamTToMBtn);
			_teamMToTBtn = new BaseButton(_view.troop.teamMToTBtn);
			_teamMToBBtn = new BaseButton(_view.troop.teamMToBBtn);
			_teamBToMBtn = new BaseButton(_view.troop.teamBToMBtn);
			
			_view.troop.addChild(_teamTToMBtn);
			_view.troop.addChild(_teamMToTBtn);
			_view.troop.addChild(_teamBToMBtn);
			_view.troop.addChild(_teamMToBBtn);
			
			_teamTToMBtn.visible = false;
			_teamMToTBtn.visible = false;
			_teamBToMBtn.visible = false;
			_teamMToBBtn.visible = false;
			
			//			var format:TextFormat = _view.battle.defaultTextFormat;
			//			format.font = FontStyleMgr.HYXueJunJ;
			//			format.size = 18;
			//			
			//			_view.battle.defaultTextFormat = format;
			//			_view.leadership.defaultTextFormat = format;
			
			//			_view.battle.embedFonts = true;
			//			_view.leadership.embedFonts = true;
			
			var format:TextFormat = _view.pkg.battle.defaultTextFormat;
			format.font = FontStyleMgr.HYXueJunJ;
			format.size = 18;
			
			_view.pkg.battle.defaultTextFormat = format;
			//_view.pkg.leadership.defaultTextFormat = format;
			
			_readyBtn = _view.pkg.ready;
			
			_view.pkg.battle.embedFonts = true;
			//_view.pkg.leadership.embedFonts = true;
			
			_background = new Image();
			
			_packageView = new PackageView(_view.pkg);
			_skillView = new SkillView(_view.skill);
			_troopView = new TroopView(_view.troop, _selfInfo);
			_view.background.container.addChild(_background);
			_background.load(_prewarModel.backgroundURL);
			//			_frame = new PrewarFrame();
			_view.background.blackMask.gotoAndPlay("show");
			
			_dragNinjaContainer = _view.troop.playerNinjaContainer;
			_dragNinjaContainer.mouseEnabled = false;
			_dragNinjaContainer.mouseChildren = false;
			_view.pkg.addEventListener(NinjaEvent.START_DRAG_NINJA, dragHandler);
			_view.pkg.addEventListener(NinjaEvent.STOP_DRAG_NINJA, dragHandler);
			_view.addEventListener(NinjaEvent.START_DRAG_NINJA, dragHandler);
			_view.addEventListener(NinjaEvent.STOP_DRAG_NINJA, dragHandler);
			_readyBtn.addEventListener(MouseEvent.CLICK, onReadyClick);
			
			_view.visible = false;
			LayoutManager.singleton.addItemAndLayout(this, LayerDef.PREWAR, LocationDef.MIDCENTRE);
			LayerManager.singleton.addItemToLayer(_dragNinjaContainer, LayerDef.PREWAR_FORE_GROUND);
			
			_teamTToMBtn.addEventListener(MouseEvent.CLICK, onUpdateTeamPosBtnClick);
			_teamMToTBtn.addEventListener(MouseEvent.CLICK, onUpdateTeamPosBtnClick);
			_teamBToMBtn.addEventListener(MouseEvent.CLICK, onUpdateTeamPosBtnClick);
			_teamMToBBtn.addEventListener(MouseEvent.CLICK, onUpdateTeamPosBtnClick);
		}
		
		public function updateTalent():void
		{
			_packageView.updateTalent();
		}
		
		public function hideBlackMask():void
		{
			_view.background.blackMask.gotoAndPlay("hide");
		}
		
		private function onUpdateTeamPosBtnClick(evt:MouseEvent):void
		{
			switch(evt.currentTarget)
			{
				case _teamTToMBtn:
					new RequestChangeMemberPosCommand(MemberIndexDef.TOP, MemberIndexDef.CENTER).call();
					//					new PlayUISoundCommand(UISoundDef.BUTTON_CLICK).call();
					disableAllBtns();
					break;
				case _teamMToTBtn:
					new RequestChangeMemberPosCommand(MemberIndexDef.CENTER, MemberIndexDef.TOP).call();
					//					new PlayUISoundCommand(UISoundDef.BUTTON_CLICK).call();
					disableAllBtns();
					break;
				case _teamMToBBtn:
					new RequestChangeMemberPosCommand(MemberIndexDef.CENTER, MemberIndexDef.BOTTOM).call();
					//					new PlayUISoundCommand(UISoundDef.BUTTON_CLICK).call();
					disableAllBtns();
					break;
				case _teamBToMBtn:
					new RequestChangeMemberPosCommand(MemberIndexDef.BOTTOM, MemberIndexDef.CENTER).call();
					//					new PlayUISoundCommand(UISoundDef.BUTTON_CLICK).call();
					disableAllBtns();
					break;
			}
		}
		
		private function disableAllBtns():void
		{
			_teamTToMBtn.disable = true;
			_teamMToTBtn.disable = true;
			_teamMToBBtn.disable = true;
			_teamBToMBtn.disable = true;
		}
		
		private var readyAckCommand:PrewarReadyAckCommand;
		private function onReadyClick(evt:MouseEvent):void
		{
			var selfPrewarPlayer:PrewarPlayerInfo;
			
			for each(selfPrewarPlayer in _prewarModel.prewarPlayers)
			{
				if(selfPrewarPlayer.isSelf)
				{
					break;
				}
			}
			
			if(selfPrewarPlayer.formationInfo.arranges.length != 0)
			{
				readyAckCommand = new PrewarReadyAckCommand();
				readyAckCommand.addEventListener(CommandEvent.FAILD, onReadyFail);
				readyAckCommand.addEventListener(CommandEvent.FINISH, onReadyFinish);
				readyAckCommand.call();
			}
			else
			{
				new ShowTextBoxCommand(I18n.lang("as_prewar_1451031577_5360"), BoxFlagDef.OK, true, null, onAskBoxResult).call();
			}
			
			new PlayUISoundCommand(UISoundDef.BUTTON_CLICK).call();
		}
		
		private function onAskBoxResult(flag:int):void
		{
//			if(flag == BoxFlagDef.OK)
//			{
//				readyAckCommand = new PrewarReadyAckCommand();
//				readyAckCommand.addEventListener(CommandEvent.FAILD, onReadyFail);
//				readyAckCommand.addEventListener(CommandEvent.FINISH, onReadyFinish);
//				readyAckCommand.call();
//			}
		}
		
		private function onReadyFinish(evt:CommandEvent):void
		{
			var selfPrewarPlayer:PrewarPlayerInfo;
			
			readyAckCommand = evt.currentTarget as PrewarReadyAckCommand;
			readyAckCommand.removeEventListener(CommandEvent.FAILD, onReadyFail);
			readyAckCommand.removeEventListener(CommandEvent.FINISH, onReadyFinish);
			
			for each(selfPrewarPlayer in _prewarModel.prewarPlayers)
			{
				if(selfPrewarPlayer.isSelf)
				{
					break;
				}
			}
			
			selfPrewarPlayer.status = StatusDef.READY;
			
			_readyBtn.enabled = false;
			_packageView.close();
			_troopView.updateReady();
			
			refresh();
		}
		
		private function onReadyFail(evt:CommandEvent):void
		{
			readyAckCommand = evt.currentTarget as PrewarReadyAckCommand;
			readyAckCommand.removeEventListener(CommandEvent.FAILD, onReadyFail);
			readyAckCommand.removeEventListener(CommandEvent.FINISH, onReadyFinish);
		}
		
		public function set isCaptain(value:Boolean):void
		{
			_isCaptain = value;
			updateCanStandList();
		}
		
		public function updateCanStandList():void
		{
			var canStandList:Array;
			var player0Exist:Boolean;
			var player1Exist:Boolean;
			var player2Exist:Boolean;
			
			_teamTToMBtn.visible = true;
			_teamMToTBtn.visible = true;
			_teamBToMBtn.visible = true;
			_teamMToBBtn.visible = true;
			
			player0Exist = _prewarModel.getPrewarPlayeByPos(0) != null;
			player1Exist = _prewarModel.getPrewarPlayeByPos(2) != null;
			player2Exist = _prewarModel.getPrewarPlayeByPos(4) != null;
			
			if(!_isCaptain)
			{
				_teamTToMBtn.visible = false;
				_teamMToTBtn.visible = false;
				_teamBToMBtn.visible = false;
				_teamMToBBtn.visible = false;
				return ;
			}
			
			canStandList = _prewarModel.canStandList;
			if(canStandList.indexOf(0) != -1)
			{
				_teamBToMBtn.disable = !player1Exist;
				_teamTToMBtn.disable = !player2Exist;
			}
			else
			{
				_teamBToMBtn.disable = true;
				_teamTToMBtn.disable = true;
			}
			
			if(canStandList.indexOf(1) != -1)
			{
				_teamMToBBtn.disable = !player0Exist;
			}
			else
			{
				_teamMToBBtn.disable = true;
			}
			
			if(canStandList.indexOf(2) != -1)
			{
				_teamMToTBtn.disable = !player0Exist;
			}
			else
			{
				_teamMToBBtn.disable = true;
			}
		}
		
		private function updateCaptainOption():void
		{
			var prewarPlayer0:PrewarPlayerInfo;
			var prewarPlayer1:PrewarPlayerInfo;
			var prewarPlayer2:PrewarPlayerInfo;
			
			prewarPlayer0 = _prewarModel.getPrewarPlayeByPos(0);
			if(prewarPlayer0)
			{
				if(prewarPlayer0.type == PlayerType.PLAYER)
				{
					_teamMToBBtn.disable = false;
					_teamMToTBtn.disable = false;
				}
				else
				{
					_teamMToBBtn.disable = true;
					_teamMToTBtn.disable = true;
				}
			}
			else
			{
				_teamMToBBtn.visible = false;
				_teamMToTBtn.visible = false;
			}
			
			prewarPlayer1 = _prewarModel.getPrewarPlayeByPos(1);
			if(prewarPlayer1)
			{
				if(prewarPlayer1.type == PlayerType.PLAYER)
				{
					_teamBToMBtn.disable = false;
				}
				else
				{
					_teamBToMBtn.disable = true;
				}
			}
			else
			{
				_teamBToMBtn.visible = false;
			}
			
			prewarPlayer2 = _prewarModel.getPrewarPlayeByPos(2);
			if(prewarPlayer1 && prewarPlayer1.type == PlayerType.PLAYER)
			{
				if(prewarPlayer1.type == PlayerType.PLAYER)
				{
					_teamTToMBtn.disable = false;
				}
				else
				{
					_teamTToMBtn.disable = true;
				}
			}
			else
			{
				_teamTToMBtn.visible = false;
			}
		}
		
		/**
		 * 拖拽处理
		 */
		private function dragHandler(e:NinjaEvent):void 
		{
			e.stopPropagation();
			
			var pos:Point;
			
			var list:Array = e.data as Array;
			var info:NinjaArrangeInfo = list[0] as NinjaArrangeInfo;
			var ninjaTroopView:NinjaTroopView;
			
			ninjaTroopView = _troopView.getMainTroopView();
			if (e.type == NinjaEvent.START_DRAG_NINJA)
			{
				if (list[1] is TroopNinja)
				{
					_dragTarget = list[1] as TroopNinja;
					_dragTarget.mouseEnabled = false;
					_dragTarget.mouseChildren = false;
					_dragTarget.x = _dragNinjaContainer.mouseX;
					_dragTarget.y = _dragNinjaContainer.mouseY;
					_dragNinjaContainer.addChild(_dragTarget);
				}
				else
				{
					_dragTarget = new TroopNinja();
					_dragTarget.map = ninjaTroopView.map;
					_dragTarget.mouseEnabled = false;
					_dragTarget.mouseChildren = false;
					_dragTarget.x = _dragNinjaContainer.mouseX;
					_dragTarget.y = _dragNinjaContainer.mouseY;
					_dragNinjaContainer.addChild(_dragTarget);
				}
				
				_dragTarget.data = info;
				_dragTarget.state = NinjaDockStateDef.WARNING;	
				ninjaTroopView.dragTarget = _dragTarget;
				_dragTarget.startDrag(false);
				SimpleClipboard.set(DataDef.NINJA, list);
				
				removeMouseListener();
			}
			else
				if (e.type == NinjaEvent.STOP_DRAG_NINJA)
				{
					ninjaTroopView.dragTarget = null;
					_dragTarget.stopDrag();
					
					pos = _dragTarget.parent.localToGlobal(new Point(_dragTarget.x, _dragTarget.y));
					pos = globalToLocal(pos);
					
					_dragTarget.x = pos.x;
					_dragTarget.y = pos.y;
					addChild(_dragTarget);
					
					if (ninjaTroopView.hitTestObject(_dragTarget))
					{
						if (ninjaTroopView.potential && _dragTarget.qualified)
						{
							moveNinjaToBattle(_dragTarget, ninjaTroopView.potential.id);
						}
						else
						{
							_dragTarget.parent && _dragTarget.parent.removeChild(_dragTarget);
							
							_troopView.data = _prewarModel;
							_packageView.data  = _prewarModel;
						}
					}
					else
						if (_packageView.hitTestObject(_dragTarget))
						{
							moveNinjaToPackage(_dragTarget);
						}
						else
						{
							_dragTarget.parent && _dragTarget.parent.removeChild(_dragTarget);
							refresh();
						}
					
					addMouseListener();
					_dragTarget.data = null;
					_dragTarget = null;
				}
		}
		
		/**
		 * 把忍者放到背包
		 */
		private function moveNinjaToPackage(target:TroopNinja):void
		{
			var battleModel:BattleInfo;
			var list:Array = SimpleClipboard.get(DataDef.NINJA) as Array;
			var info:NinjaArrangeInfo = list[0];
			
			battleModel = ApplicationData.singleton.getModel(ModelDef.BATTLE) as BattleInfo;
			
			if (list[1] is TroopNinja)
			{
				var formationType:int;
				if(battleModel.type == FightStartType.FIGHT_START_TYPE_EXPEDITION)
				{
					formationType = FormationType.EXPEDITION_FORMATION;
				}
				else
				{
					formationType = FormationType.DEFAULT_FORMATION;
				}
				
				var operate:OperateFormationCommand = new OperateFormationCommand(1, info.sequence, info.location, formationType);
				operate.addEventListener(CommandEvent.FINISH, function(e:Event):void
				{
					e.currentTarget.removeEventListener(e.type, arguments.callee);
					operateFormationResult(target, operate);
				});
				
				operate.call();
			}
			else
			{
				refresh();
				target.parent && target.parent.removeChild(target);
			}
		}
		
		/**
		 * 忍者上阵操作
		 */
		private function moveNinjaToBattle(target:TroopNinja, location:uint):void
		{
			var formationType:int;
			var battleModel:BattleInfo;
			var operateFormationCommand:OperateFormationCommand;
			
			battleModel = ApplicationData.singleton.getModel(ModelDef.BATTLE) as BattleInfo;
			
			if(battleModel.type == FightStartType.FIGHT_START_TYPE_EXPEDITION)
			{
				formationType = FormationType.EXPEDITION_FORMATION;
			}
			else
			{
				formationType = FormationType.DEFAULT_FORMATION;
			}
			
			operateFormationCommand = new OperateFormationCommand(0, target.data.sequence, location, formationType);
			operateFormationCommand.addEventListener(CommandEvent.FINISH, function(e:Event):void
			{
				e.currentTarget.removeEventListener(e.type, arguments.callee);
				operateFormationResult(target, operateFormationCommand);
			});
			
			operateFormationCommand.call();
		}		
		
		private function operateFormationResult(target:TroopNinja, command:OperateFormationCommand):void
		{
			var sourceType:int;
			var battleModel:BattleInfo;
			var prewarPlayer:PrewarPlayerInfo;
			
			target.parent && target.parent.removeChild(target);
			battleModel = ApplicationData.singleton.getModel(ModelDef.BATTLE) as BattleInfo;
			
			if(battleModel.type == FightStartType.FIGHT_START_TYPE_EXPEDITION)
			{
				sourceType = NinjaSourceType.NINJA_SOURCE_TYPE_EXPEDITION;
			}
			else
			{
				sourceType = NinjaSourceType.NINJA_SOURCE_TYPE_DEFAULT;
			}
			
			if (command.errorCode)
			{
				_troopView.data = _prewarModel;
				return;
			}
			
			if(selfFormation && command.formation)
			{
				command.formation.maxFormationNum = selfFormation.maxFormationNum;
			}
			new UpdateSelfFormationCommand(command.formation).call();
			
			refresh();
			
			var requestFormationTroopCommand:RequestFormationTroopCommand = new RequestFormationTroopCommand(sourceType, RequestFormationTroopCommand.PACKAGE);
			requestFormationTroopCommand.addEventListener(CommandEvent.FINISH, function(e:Event):void
			{
				e.currentTarget.removeEventListener(e.type, arguments.callee);
				getNinjaListResult(requestFormationTroopCommand);
			});
			
			requestFormationTroopCommand.call();
		}
		
		private function getNinjaListResult(requestFormationTroopCommand:RequestFormationTroopCommand):void
		{
			new UpdateSelfNinjaListCommand(requestFormationTroopCommand.packageNinjas).call();
			
			var getSkillCommand:GetMajorRoleSkillCommand;
			
			getSkillCommand = new GetMajorRoleSkillCommand();
			getSkillCommand.addEventListener(CommandEvent.FINISH, onGetMajorSkillResult);
			getSkillCommand.addEventListener(CommandEvent.FAILD, onGetMajorSkillResult);
			getSkillCommand.call();
			
			refresh();
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
		
		public function addMouseListener():void
		{
			_troopView.addMouseEventListener();
		}
		
		public function removeMouseListener():void
		{
			_troopView.removeMouseEventListener();
		}
		
		/**
		 * 頁面刷新
		 */
		public function refresh():void
		{
			_troopView.data = _prewarModel;
			_packageView.data = _prewarModel;
			_skillView.data = _prewarModel;
			
			if(_selfFormation)
			{
				_view.pkg.battle.text = _selfFormation.arranges.length + "/" + _selfFormation.maxFormationNum;
				//_view.pkg.leadership.text = _selfFormation.leadershipUsed + "/" + _selfFormation.leadershipMax;
			}
			
			updateCanStandList();
			
			if(_dragTarget){_dragTarget.data = null;}
		}
		
		public function destroy():void
		{
			_teamTToMBtn.removeEventListener(MouseEvent.CLICK, onUpdateTeamPosBtnClick);
			_teamMToTBtn.removeEventListener(MouseEvent.CLICK, onUpdateTeamPosBtnClick);
			_teamBToMBtn.removeEventListener(MouseEvent.CLICK, onUpdateTeamPosBtnClick);
			_teamMToBBtn.removeEventListener(MouseEvent.CLICK, onUpdateTeamPosBtnClick);
			
			_view.removeEventListener(NinjaEvent.START_DRAG_NINJA, dragHandler);
			_view.removeEventListener(NinjaEvent.STOP_DRAG_NINJA, dragHandler);
			_packageView.view.removeEventListener(NinjaEvent.START_DRAG_NINJA, dragHandler);
			_packageView.view.removeEventListener(NinjaEvent.STOP_DRAG_NINJA, dragHandler);
			_readyBtn.removeEventListener(MouseEvent.CLICK, onReadyClick);
			_prewarModel.removeEventListener(ModelEvent.UPDATE, onPrewarModelEvent);
			_troopView.destroy();
			_packageView.destroy();
			_skillView.destroy();
			_background.dispose();
			
			_background.dispose();
			
			LayoutManager.singleton.removeItem(this);
			LayerManager.singleton.removeItemToLayer(_dragNinjaContainer);
			
			removeChildren();
		}
	}
	
}