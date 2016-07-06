package com.tencent.morefun.naruto.plugin.prewar.executer
{
	import com.tencent.morefun.framework.base.Command;
	import com.tencent.morefun.naruto.model.event.ModelEvent;
	import com.tencent.morefun.naruto.plugin.prewar.command.DisableReadyCommand;
	import com.tencent.morefun.naruto.plugin.prewar.command.UpdateSelfFormationCommand;
	import com.tencent.morefun.naruto.plugin.prewar.command.UpdateSelfNinjaListCommand;
	import com.tencent.morefun.naruto.plugin.prewar.command.UpdateSelfSkillInfoCommand;
	import com.tencent.morefun.naruto.plugin.prewar.data.PrewarModel;
	import com.tencent.morefun.naruto.plugin.prewar.data.PrewarPlayerInfo;
	import com.tencent.morefun.naruto.plugin.prewar.def.PlayerType;
	import com.tencent.morefun.naruto.plugin.prewar.def.StatusDef;
	import com.tencent.morefun.naruto.plugin.prewar.view.PrewarPanel;
	import com.tencent.morefun.naruto.plugin.ui.util.TimerProvider;
	
	import flash.events.Event;
	
	import avmplus.getQualifiedClassName;
	
	import base.NarutoExecuter;
	
	import battle.data.BattleInfo;
	import battle.util.NinjaBattleProtoExecuter;
	
	import def.ExecuterDef;
	import def.ModelDef;
	import def.PluginDef;
	
	import ninja.data.TeamForamtionInfo;
	import ninja.model.data.FormationInfo;
	import ninja.model.data.NinjaArrangeInfo;
	import ninja.model.data.NinjaInfo;
	
	import prewar.command.ExitPrewarCommand;
	import prewar.command.OpenPrewarCommand;
	import prewar.command.PrewarInsertPlayerNoticeCommand;
	import prewar.command.PrewarPlayerExitCommand;
	import prewar.command.PrewarReadyBroadcastCommand;
	
	import serverProto.fight.FightStartType;
	
	import team.data.TeamFormationNinja;
	import team.data.TeamMemberData;
	import team.data.event.TeamMemberDataEvent;
	import team.model.TeamModel;
	
	import user.event.UserInfoEvent;
	
	public class PrewarExecuter extends NarutoExecuter
	{
		private var teamModel:TeamModel;
		private var battleModel:BattleInfo;
		private var prewarModel:PrewarModel;
		private var prewarPanel:PrewarPanel;
		private var optioning:Boolean;
		private var ninjaProtoDeco:NinjaBattleProtoExecuter;
		
		public function PrewarExecuter()
		{
			super(PluginDef.PREWAR, ExecuterDef.PREWAR_LOGIC);
			
			ninjaProtoDeco = new NinjaBattleProtoExecuter();
			
			init();
		}
		
		private function init():void
		{
			teamModel = plugin.retrieveModel(ModelDef.TEAM) as TeamModel;
			battleModel = plugin.retrieveModel(ModelDef.BATTLE) as BattleInfo;
			prewarModel = plugin.retrieveModel(ModelDef.PREWAR) as PrewarModel;
			prewarPanel = new PrewarPanel(prewarModel);
		}
		
		override public function doCommand(command:Command):void
		{
			switch(getQualifiedClassName(command))
			{
				case getQualifiedClassName(OpenPrewarCommand):
					optioning = true;
					startPrewarLogic(command as OpenPrewarCommand);
					break;
				case getQualifiedClassName(ExitPrewarCommand):
					delayDestroyPrewarLogic();
					optioning = false;
					break;
				case getQualifiedClassName(PrewarInsertPlayerNoticeCommand):
					insertPlayer((command as PrewarInsertPlayerNoticeCommand).teamFormationInfo, (command as PrewarInsertPlayerNoticeCommand).canStandList);
					break;
				case getQualifiedClassName(PrewarReadyBroadcastCommand):
					playerReady((command as PrewarReadyBroadcastCommand).teamPos);
					break;
				case getQualifiedClassName(UpdateSelfFormationCommand):
					updateFormationInfo((command as UpdateSelfFormationCommand).formation);
					break;
				case getQualifiedClassName(UpdateSelfNinjaListCommand):
					updateSelfNinjaList((command as UpdateSelfNinjaListCommand).pkgNinjas);
					break;
				case getQualifiedClassName(UpdateSelfSkillInfoCommand):
					updateSelfSkillInfo((command as UpdateSelfSkillInfoCommand).special,  (command as UpdateSelfSkillInfoCommand).normal, (command as UpdateSelfSkillInfoCommand).skills);
					break;
				case getQualifiedClassName(DisableReadyCommand):
					prewarPanel.disableReady();
					break;
				case getQualifiedClassName(PrewarPlayerExitCommand):
					playerExit((command as PrewarPlayerExitCommand).teamPos);
					break;
			}
		}
		
		private function startPrewarLogic(command:OpenPrewarCommand):void
		{
			var teamFormationInfo:TeamForamtionInfo;
			var prewarPlayerInfo:PrewarPlayerInfo;
			
			prewarModel.mp = command.mp;
			prewarModel.backgroundURL = command.backgroundUrl;
			prewarModel.pkgNinjaInfos = command.pkgNinjas;
			prewarModel.canStandList = command.canStandList;
			
			prewarPanel.init();
			prewarPanel.show();
			if(battleModel.type != FightStartType.FIGHT_START_TYPE_EXPEDITION)
			{
				prewarPanel.startCoolDown(command.elapseTime);
			}
			
			teamModel.addEventListener(ModelEvent.UPDATE, onTeamModelUpdate);
			
			for each(teamFormationInfo in command.npcTeamFormationList)
			{
				prewarPlayerInfo = new PrewarPlayerInfo();
				prewarPlayerInfo.type = PlayerType.NPC;
				prewarPlayerInfo.teamPos = teamFormationInfo.teamPos;
				prewarPlayerInfo.formationInfo = teamFormationInfo.formationInfo;
				prewarModel.addPrewarPlayer(prewarPlayerInfo);
			}
			
			for each(teamFormationInfo in command.playerTeamForamtionList)
			{
				prewarPlayerInfo = new PrewarPlayerInfo();
				prewarPlayerInfo.type = PlayerType.PLAYER;
				prewarPlayerInfo.status = StatusDef.OPTION;
				prewarPlayerInfo.teamPos = teamFormationInfo.teamPos;
				prewarPlayerInfo.hotkeyInfo = teamFormationInfo.formationInfo.hotkey;
				prewarPlayerInfo.formationInfo = teamFormationInfo.formationInfo;
				if(prewarPlayerInfo.teamPos == command.selfTeamPos)
				{
					prewarPlayerInfo.isSelf = true;
					prewarPanel.selfTeamPos = prewarPlayerInfo.teamPos;
					prewarPanel.selfFormation = teamFormationInfo.formationInfo;
					prewarPlayerInfo.mp = command.mp;
				}
				prewarModel.addPrewarPlayer(prewarPlayerInfo);
			}
			
			for each(var teamPos:int in command.readyTeamPosList)
			{
				prewarModel.getPrewarPlayeByPos(teamPos).status = StatusDef.READY;
			}
			
			updateMajorSpecialSkill();
			
			prewarPanel.refresh();
			prewarPanel.updateTalent();
			prewarPanel.isCaptain = selfInfo.teamId && selfInfo.isCaptain;
		}
		
		private function onTeamModelUpdate(evt:ModelEvent):void
		{
			switch(evt.key)
			{
//				case TeamModel.KEY_MEMBER_UPDATE:
			}
		}
		
		private function delayDestroyPrewarLogic():void
		{
			if(!optioning){return ;}
			
			prewarPanel.hideBlackMask();
			TimerProvider.addTimeTask(400, destroyPrewarLogic);
		}
		
		private function destroyPrewarLogic():void
		{
			TimerProvider.removeTimeTask(400, destroyPrewarLogic);
			
			prewarPanel.close();
			prewarPanel.destroy();
			
			selfInfo.removeEventListener(UserInfoEvent.FORMATION_UPDATE, onSelfForamtionUpdate);
			
			prewarModel.removeAllPlayer();
		}
		
		private function onAddTeamMember(tmd:TeamMemberData):void
		{
			tmd.addEventListener(UserInfoEvent.FORMATION_UPDATE, onSelfForamtionUpdate);
		}
		
		private function onRemoveTeamMember(tmd:TeamMemberData):void
		{
			tmd.removeEventListener(UserInfoEvent.FORMATION_UPDATE, onSelfForamtionUpdate);
		}
		
		private function onSelfForamtionUpdate(evt:Event):void
		{
			var prewarPlayer:PrewarPlayerInfo;
			
			prewarPlayer = prewarModel.getPrewarPlayeByPos(0);
			prewarPlayer.formationInfo = selfInfo.formationInfo;
		}
		
		private function decoFormationToTeamForamtionNinja(formationInfo:FormationInfo):Vector.<TeamFormationNinja>
		{
			var teamForamtionNinja:TeamFormationNinja;
			var formationNinjas:Vector.<TeamFormationNinja>;
			
			formationNinjas = new Vector.<TeamFormationNinja>();
			
			for each(var arrange:NinjaArrangeInfo in formationInfo.arranges)
			{
				teamForamtionNinja = new TeamFormationNinja();
				teamForamtionNinja.seq = arrange.sequence;
				teamForamtionNinja.ninjaId = arrange.ninjaId;
				teamForamtionNinja.position = arrange.location;
				teamForamtionNinja.hp = arrange.life;
				teamForamtionNinja.maxHp = arrange.lifeMax;
				formationNinjas.push(teamForamtionNinja);
			}
			
			return formationNinjas;
		}
		
		private function onTeamPosUpdate(evt:TeamMemberDataEvent):void
		{
			var tmd:TeamMemberData;
			var newPrewarPlayerInfo:PrewarPlayerInfo;
			var oldPrewarPlayerInfo:PrewarPlayerInfo;
			
			tmd = evt.currentTarget as TeamMemberData;
			newPrewarPlayerInfo = prewarModel.getPrewarPlayeByPos(evt.newIndex);
			if(newPrewarPlayerInfo != null)
			{
				prewarModel.removePrewarPlayer(newPrewarPlayerInfo);
			}
			
			newPrewarPlayerInfo = new PrewarPlayerInfo();
			newPrewarPlayerInfo.teamPos = evt.newIndex;
			oldPrewarPlayerInfo = prewarModel.getPrewarPlayeByPos(evt.oldIndex);
			newPrewarPlayerInfo.uin = tmd.uin;
			newPrewarPlayerInfo.status = oldPrewarPlayerInfo.status;
			newPrewarPlayerInfo.isSelf = oldPrewarPlayerInfo.isSelf;
			newPrewarPlayerInfo.hotkeyInfo = oldPrewarPlayerInfo.hotkeyInfo;
			newPrewarPlayerInfo.formationInfo = oldPrewarPlayerInfo.formationInfo;
			newPrewarPlayerInfo.type = 0;
			if(oldPrewarPlayerInfo.isSelf)
			{
				prewarPanel.selfTeamPos = newPrewarPlayerInfo.teamPos;
			}
			prewarModel.addPrewarPlayer(newPrewarPlayerInfo);
			prewarModel.removePrewarPlayer(oldPrewarPlayerInfo);
		}
		
		private function updateFormationInfo(formationInfo:FormationInfo):void
		{
			var ninjaInfoList:Vector.<NinjaInfo>;
			var selfPrewarPlayer:PrewarPlayerInfo;
			
			for each(selfPrewarPlayer in prewarModel.prewarPlayers)
			{
				if(selfPrewarPlayer.isSelf)
				{
					break;
				}
			}
			
			selfPrewarPlayer.formationInfo = formationInfo;
			selfPrewarPlayer.hotkeyInfo = formationInfo.hotkey;
			prewarPanel.selfFormation = formationInfo;
		}
		
		private function updateSelfNinjaList(pkgNinjas:Vector.<NinjaInfo>):void
		{
			if(pkgNinjas)
			{
				prewarModel.pkgNinjaInfos = ninjaProtoDeco.attachPackageNinjaFormation(pkgNinjas, prewarPanel.selfFormation);
			}
			else
			{
				prewarModel.pkgNinjaInfos = ninjaProtoDeco.attachPackageNinjaFormation(prewarModel.pkgNinjaInfos, prewarPanel.selfFormation);
			}
		}
		
		private function insertPlayer(teamFormationInfo:TeamForamtionInfo, canStandList:Array):void
		{
			var prewarPlayer:PrewarPlayerInfo;
			
			prewarPlayer = new PrewarPlayerInfo();
			prewarPlayer.teamPos = teamFormationInfo.teamPos;
			prewarPlayer.type = PlayerType.PLAYER;
			prewarPlayer.hotkeyInfo = teamFormationInfo.formationInfo.hotkey;
			prewarPlayer.formationInfo = teamFormationInfo.formationInfo;
			prewarPlayer.status = StatusDef.OPTION;
			prewarModel.addPrewarPlayer(prewarPlayer);
			prewarModel.canStandList = canStandList;
			prewarPanel.updateCanStandList();
		}
		
		private function playerReady(teamPos:int):void
		{
			var prewarPlayer:PrewarPlayerInfo;
			
			prewarPlayer = prewarModel.getPrewarPlayeByPos(teamPos);
			prewarPlayer.status = StatusDef.READY;
		}
		
		private function playerExit(teamPos:int):void
		{
			var prewarPlayer:PrewarPlayerInfo;
			
			if(optioning)
			{
				prewarPlayer = prewarModel.getPrewarPlayeByPos(teamPos);
				prewarModel.removePrewarPlayer(prewarPlayer);
			}
		}
		
		private function updateSelfSkillInfo(special:int, normal:int, skills:Array):void
		{
			prewarModel.majorSpecialSkill = special;
			updateMajorSpecialSkill();
		}
		
		private function updateMajorSpecialSkill():void
		{
			var ninjaInfoList:Vector.<NinjaInfo>;
			
			if(!prewarModel.pkgNinjaInfos)
			{
				return ;
			}
			
			ninjaInfoList = prewarModel.pkgNinjaInfos;
			for each(var ninjaInfo:NinjaInfo in ninjaInfoList)
			{
				if(ninjaInfo.sequence == 0)
				{
					ninjaInfo.majorSpecialSkill = prewarModel.majorSpecialSkill;
				}
			}
			
			prewarPanel.refresh();
		}
		
		private function indexTransformPos(index:int):int
		{
			switch(index)
			{
				case 0:
					return 0;
					break;
				case 1:
					return 2;
					break;
				case 2:
					return 4;
					break;
			}
			
			return 0;
		}
	}
}