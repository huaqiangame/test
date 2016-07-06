package com.tencent.morefun.naruto.plugin.battle.executer
{
	
	import com.tencent.morefun.framework.base.Command;
	import com.tencent.morefun.framework.base.CommandEvent;
	import com.tencent.morefun.framework.log.logger;
	import com.tencent.morefun.naruto.model.event.ModelEvent;
	import com.tencent.morefun.naruto.plugin.battle.cfg.CustomBattleCfg;
	import com.tencent.morefun.naruto.plugin.battle.cfg.CustomBattleConfig;
	import com.tencent.morefun.naruto.plugin.battle.command.ChangedCustomIDCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.EndGuidCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.HideTargetGuidTipsCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.NinjaEnterCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.NinjaExeuntCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.NotifyKathaSkillCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.NotifyStartBattleCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.NotifyTinyRoundsCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.RequestKathaSkillCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.ResetNinjaCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.ShowGuidSkillCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.ShowNinjaGuidCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.ShowTargetGuidTipsCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.StartGuidCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.UpdateNinjaHpCommand;
	import com.tencent.morefun.naruto.plugin.battle.data.BattleData;
	import com.tencent.morefun.naruto.plugin.battle.notice.ContinueTinyRoundNotice;
	import com.tencent.morefun.naruto.plugin.battle.notice.DoUseKathaSkillNotice;
	import com.tencent.morefun.naruto.plugin.battle.notice.LockAllSkillBtnNotice;
	import com.tencent.morefun.naruto.plugin.battle.notice.RefreshSkillStateNotice;
	import com.tencent.morefun.naruto.plugin.battle.notice.StopTinyRoundNotice;
	import com.tencent.morefun.naruto.plugin.battle.notice.UpdateBattleViewSkillStateNotice;
	import com.tencent.morefun.naruto.plugin.battle.view.ShowPrewarGuidCommand;
	import com.tencent.morefun.naruto.plugin.battle.view.SkillButtonView;
	import com.tencent.morefun.naruto.plugin.battle.view.UpdateGuidSkillStateCommand;
	import com.tencent.morefun.naruto.plugin.motion.IMotionNotifyReceiver;
	import com.tencent.morefun.naruto.plugin.motion.MotionNotifyCenter;
	import com.tencent.morefun.naruto.plugin.motion.manager.FightManagerCenter;
	import com.tencent.morefun.naruto.plugin.motion.manager.ninja.Ninja;
	import com.tencent.morefun.naruto.plugin.motion.manager.ninja.data.NinjaInfo;
	import com.tencent.morefun.naruto.plugin.motion.notice.ChooseNinjaNotice;
	import com.tencent.morefun.naruto.plugin.motion.notice.base.BaseNotice;
	
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	import base.ApplicationData;
	import base.NarutoExecuter;
	
	import battle.data.BattleInfo;
	import battle.def.BattleKeyDef;
	
	import def.ExecuterDef;
	import def.ModelDef;
	import def.PluginDef;
	
	public class GuidExecuter extends NarutoExecuter implements IMotionNotifyReceiver
	{
		private var battleModel:BattleInfo;
		
		public function GuidExecuter()
		{
			super(PluginDef.BATTLE, ExecuterDef.BATTLE_GUID);
			
			battleModel = plugin.retrieveModel(ModelDef.BATTLE) as BattleInfo;
			battleModel.addEventListener(ModelEvent.UPDATE, onModelEvent);
		}
		
		private function onModelEvent(evt:ModelEvent):void
		{
			switch(evt.key)
			{
				case BattleKeyDef.PREWAR_START:
					onPrewarStart();
					break;
			}
		}
		
		private var prewarFlag:Boolean;
		private var stopSkillFlag:Boolean;
		private var tempGuidState:int;
		private function onPrewarStart():void
		{
			prewarFlag = true;
			needChooseNinja = true;
			needAutoUseSkill = true;
			tempGuidState = BattleData.singleton.guidState;
			BattleData.singleton.guidState = BattleData.GUID_SKILL_NONE;
			if(stopSkillFlag){new ContinueTinyRoundNotice().send();}
		}
		
		override public function doCommand(command:Command):void
		{
			switch(getQualifiedClassName(command))
			{
				case getQualifiedClassName(StartGuidCommand):
					startGuild();
					break;
				case getQualifiedClassName(NotifyStartBattleCommand):
					changedCustom((command as NotifyStartBattleCommand).custom.customFightId, (command as NotifyStartBattleCommand).custom.sectionId)
					break;
				
				case getQualifiedClassName(ChangedCustomIDCommand):
					changedCustom((command as ChangedCustomIDCommand).customFightId, (command as ChangedCustomIDCommand).sectionId)
					checkGuid();
					break;
				
				case getQualifiedClassName(UpdateGuidSkillStateCommand):
					checkSkillGuid((command as UpdateGuidSkillStateCommand).skillEnableList, (command as UpdateGuidSkillStateCommand).skillIdList);
					break;
				
				case getQualifiedClassName(NinjaEnterCommand):
					checkTargetGuidByNinjaEnter((command as NinjaEnterCommand).ninjaInfoList);
					break;
				
				case getQualifiedClassName(NinjaExeuntCommand):
					checkTargetGuidByNinjaExeunt((command as NinjaExeuntCommand).ninjaInfoList);
					break;
				
				case getQualifiedClassName(UpdateNinjaHpCommand):
					checkTargetGuidByNinjaHpChanged((command as UpdateNinjaHpCommand).pos, (command as UpdateNinjaHpCommand).value);
					break;
				
				case getQualifiedClassName(NotifyTinyRoundsCommand):
					onTinyRound();
					break;
				
				case getQualifiedClassName(ResetNinjaCommand):
					release();
					break;
				
				case getQualifiedClassName(EndGuidCommand):
					release();
					break;
			}
		}
		
		private function onTinyRound():void
		{
			if(prewarFlag)
			{
				prewarFlag = false;
				BattleData.singleton.guidState = tempGuidState;
				if(stopSkillFlag){new StopTinyRoundNotice().send();}
			}
		}
		
		private function changedCustom(customFightId:int, sectionId:int):void
		{
			var customBattleCfg:CustomBattleCfg;
			
			customBattleCfg = CustomBattleConfig.getCustomBattleCfg(customFightId, sectionId);
			if(customBattleCfg)
			{
				curGuidType = customBattleCfg.guidType;
				curGuidArgs = customBattleCfg.guidArgs;
			}
			
			logger.output("guidType", curGuidType);
		}
		
		private function startGuild():void
		{
			curGuidSkillIndex = -1;
			needChooseNinja = true;
			needAutoUseSkill = true;
			MotionNotifyCenter.add(this);
			checkGuid();
		}
		
		private var curGuidType:int = -1;
		private var curGuidArgs:int = -1;
		private function checkGuid():void
		{
			switch(curGuidType)
			{
				case 1:
					resetSkillGuid();
					break;
				case 2:
					resetSkillGuid();
					break;
				case 3:
					resetTargetNinjaGuid();
					break;
				case 4:
				case 5:
					resetSkillGuid();
					BattleData.singleton.addEventListener(Event.CHANGE, onBattleDataChanged);
					break;
				case 5:
					resetSkillGuid();
					BattleData.singleton.addEventListener(Event.CHANGE, onBattleDataChanged);
					break;
			}
			//			else
			//			{
			//				curGuidType = 3;
			//			}
			
			if(curGuidType == 1 || curGuidType == 2)
			{
				new ShowPrewarGuidCommand().call();
			}
			
			if(curGuidType == 3 || curGuidType == 5)
			{
				new ShowTargetGuidTipsCommand().call();
			}
		}
		
		private function resetSkillGuid():void
		{
			new ShowGuidSkillCommand(-1, -1).call();
		}
		
		private function resetTargetNinjaGuid():void
		{
			targetPos = -1;
			new ShowNinjaGuidCommand(-1).call();
			new HideTargetGuidTipsCommand().call();
		}
		
		private var curSkillBtnView:SkillButtonView;
		private var curGuidSkillIndex:int;
		private function checkSkillGuid(skillEnableList:Array, skillBtnList:Array):void
		{
			var i:int;
			var skillBtnView:SkillButtonView;
			var battleNinja:Ninja;
			
			if(stopSkillAndNinjaMajorSkill())
			{
				for(i = 0;i < skillEnableList.length;i ++)
				{
					skillBtnView = skillBtnList[i] as SkillButtonView;
					curSkillBtnView = skillBtnList[i] as SkillButtonView;
					battleNinja = FightManagerCenter.ninjaMgr.getNinjaByPos(skillBtnView.ninjaPos);
					if(!battleNinja){continue ;}
					if(battleNinja.data.selfTeam && battleNinja.data.ninjaId == BattleData.singleton.userInfoProxy.ninja)
					{
						BattleData.singleton.guidState = BattleData.GUID_SKILL_REQUEST;
						new LockAllSkillBtnNotice(true).send();
						lockSkillUseEffect();
						curGuidSkillIndex = i;
						return;
					}
				}
			}
			
			if(stopSkillAndNinjaMatchSkill())
			{
				for(i = 0;i < skillEnableList.length;i ++)
				{
					skillBtnView = skillBtnList[i] as SkillButtonView;
					curSkillBtnView = skillBtnList[i] as SkillButtonView;
					if(skillEnableList[i] == true && skillBtnView.skillId == curGuidArgs)//21000115
					{
						BattleData.singleton.guidState = BattleData.GUID_CHOOSE_TARGET_REQUEST;
						new LockAllSkillBtnNotice(true).send();
						lockSkillUseEffect();
						curGuidSkillIndex = i;
						return;
					}
				}
			}
			
			if(stopMatchSkill())
			{
				for(i = 0;i < skillEnableList.length;i ++)
				{
					skillBtnView = skillBtnList[i] as SkillButtonView;
					curSkillBtnView = skillBtnList[i] as SkillButtonView;
					if(skillEnableList[i] == true && skillBtnView.skillId == curGuidArgs)//21000115
					{
						BattleData.singleton.guidState = BattleData.GUID_SKILL_REQUEST;
						lockSkillUseEffect();
						curGuidSkillIndex = i;
						new ShowGuidSkillCommand(curGuidType, i).call();
						return;
					}
				}
			}
			
			curSkillBtnView = null;
			
			if(skillMajorSkill())
			{
				for(i = 0;i < skillEnableList.length;i ++)
				{
					skillBtnView = skillBtnList[i] as SkillButtonView;
					battleNinja = FightManagerCenter.ninjaMgr.getNinjaByPos(skillBtnView.ninjaPos);
					if(!battleNinja){continue ;}
					if(battleNinja.data.selfTeam && battleNinja.data.ninjaId == BattleData.singleton.userInfoProxy.ninja)
					{
						if(skillEnableList[i] == true)
						{
							new ShowGuidSkillCommand(curGuidType, i).call();
							return;
						}
					}
				}
			}
			
			if(skillAndNinjaMajorSkill())
			{
				for(i = 0;i < skillEnableList.length;i ++)
				{
					needAutoUseSkill = false;
					skillBtnView = skillBtnList[i] as SkillButtonView;
					battleNinja = FightManagerCenter.ninjaMgr.getNinjaByPos(skillBtnView.ninjaPos);
					if(!battleNinja){continue ;}
					if(battleNinja.data.selfTeam && battleNinja.data.ninjaId == BattleData.singleton.userInfoProxy.ninja)
					{
						if(skillEnableList[i] == true)
						{
							curGuidSkillIndex = i;
							if(!needChooseNinja)
							{
								new ShowGuidSkillCommand(curGuidType, i).call();
							}
							return;
						}
					}
				}
			}
			
			if(guidSkill())
			{
				for(i = 0;i < skillEnableList.length;i ++)
				{
					if(skillEnableList[i] == true)
					{
						new ShowGuidSkillCommand(curGuidType, i).call();
						return;
					}
				}
			}
			
			curGuidSkillIndex = -1;
			new ShowGuidSkillCommand(-1, -1).call();
		}
		
		private function onChooseNinjaComplete():void
		{
			if(curGuidType != 8)
			{
				BattleData.singleton.guidState = BattleData.GUID_SKILL_REQUEST;
			}
			
			if(curGuidSkillIndex != -1){new ShowGuidSkillCommand(curGuidType, curGuidSkillIndex).call();}
			new ShowNinjaGuidCommand(-1).call();
			new LockAllSkillBtnNotice(false).send();
			needChooseNinja = false;
		}
		
		private var skillStateInfoList:Array = [];
		private function lockSkillUseEffect():void
		{
			stopSkillFlag = true;
			new StopTinyRoundNotice().send();
			autoUseSkill(curSkillBtnView);
		}
		
		private function relaseSkillUseEffect():void
		{
			stopSkillFlag = false;
			BattleData.singleton.guidState = BattleData.GUID_SKILL_NONE;
			
			new RefreshSkillStateNotice(skillStateInfoList).send();
			new ContinueTinyRoundNotice().send();
			
			if(fakeCommand)
			{
				fakeCommand.call();
			}
			
			skillStateInfoList.splice(0, skillStateInfoList.length);
		}
		
		public function receive(notice:BaseNotice):void
		{
			switch(getQualifiedClassName(notice))
			{
				case getQualifiedClassName(UpdateBattleViewSkillStateNotice):
					if(BattleData.singleton.guidState == BattleData.GUID_SKILL_REQUEST){skillStateInfoList.push((notice as UpdateBattleViewSkillStateNotice).skillState)}
					break;
				case getQualifiedClassName(DoUseKathaSkillNotice):
					if(BattleData.singleton.guidState == BattleData.GUID_SKILL_REQUEST){relaseSkillUseEffect();}
					break;
				case getQualifiedClassName(ChooseNinjaNotice):
					if(needChooseNinja && (notice as ChooseNinjaNotice).pos == targetPos){onChooseNinjaComplete();}
					break;
			}
		}
		
		private function autoUseSkill(skillBtnView:SkillButtonView):void
		{
			var requestKathaSkillCommand:RequestKathaSkillCommand;
			
			if(skillBtnView == null){return ;}
			
			needAutoUseSkill = false;
			
			if(targetPos == -1)
			{
				requestKathaSkillCommand = new RequestKathaSkillCommand(skillBtnView.ninjaPos,FightManagerCenter.sceneMgr.getSelectedFloorGridPos(),skillBtnView.index);
			}
			else
			{
				requestKathaSkillCommand = new RequestKathaSkillCommand(skillBtnView.ninjaPos,targetPos,skillBtnView.index);
			}
			requestKathaSkillCommand.addEventListener(CommandEvent.FINISH, onReqKathaSkillCommand);
			requestKathaSkillCommand.addEventListener(CommandEvent.FAILD, onReqKathaSkillFaild);
			requestKathaSkillCommand.call();
		}
		
		/**Sever返回的技能键点击后，成功的结果*/
		protected function onReqKathaSkillCommand(event:CommandEvent):void
		{
			var c:RequestKathaSkillCommand = event.currentTarget as RequestKathaSkillCommand;
			c.removeEventListener(CommandEvent.FINISH,onReqKathaSkillCommand);
			c.removeEventListener(CommandEvent.FAILD, onReqKathaSkillFaild);
			
			curSkillBtnView = null;
			needAutoUseSkill = false;
			
			switch(event.type)
			{
				case CommandEvent.FINISH:
					//模拟一个更新command，延迟更新;
					fakeCommand = new NotifyKathaSkillCommand;
					fakeCommand.ninjaPos = c.activePos;
					fakeCommand.skillIndex = c.skillIndex;
					fakeCommand.mp = c.kathaChange;
					fakeCommand.skillState = c.skillStates;
					fakeCommand.dontDelay = true;
					break;
			}
		}
		/**Sever返回的技能键点击后，失败的结果*/
		private function onReqKathaSkillFaild(event:CommandEvent):void
		{
			needAutoUseSkill = true;
			
			var c:RequestKathaSkillCommand = event.currentTarget as RequestKathaSkillCommand;
			c.removeEventListener(CommandEvent.FINISH,onReqKathaSkillCommand);
			c.removeEventListener(CommandEvent.FAILD, onReqKathaSkillFaild);
			
			//			autoUseSkill(curSkillBtnView);
		}
		
		private var targetPos:int = -1;
		private var ninjaInfoList:Array = [];
		private var needAutoUseSkill:Boolean = true;
		private var needChooseNinja:Boolean = true;
		private var fakeCommand:NotifyKathaSkillCommand;
		private function checkTargetGuidByNinjaEnter(ninjaInfoList:Array):void
		{
			for each(var ninjaInfo:NinjaInfo in ninjaInfoList)
			{
				addEnterNinjaInfo(ninjaInfo);
			}
			
			if(!stopSkillAndNinjaMatchNinja() && !guildNinja() && !stopSkillAndNinjaMajorNinja() && !skillAndNinjaMajorNinja())
			{
				return ;
			}
			
			if(targetPos == -1)
			{
				updateTargetPos(getLiveNinjaPos());
			}
		}
		
		private function checkTargetGuidByNinjaExeunt(ninjaInfoList:Array):void
		{
			var updateNinjaTargetPos:Boolean;
			
			for each(var ninjaInfo:NinjaInfo in ninjaInfoList)
			{
				removeEnterNinjaInfo(ninjaInfo.pos);
				
				if(ninjaInfo.pos == targetPos){targetPos = -1;}
			}
			
			if(!stopSkillAndNinjaMatchNinja() && !guildNinja() && !stopSkillAndNinjaMajorNinja() && !skillAndNinjaMajorNinja())
			{
				return ;
			}
			
			if(!hasNinja(targetPos))
			{
				updateTargetPos(getLiveNinjaPos());
			}
		}
		
		private function checkTargetGuidByNinjaHpChanged(pos:int, value:int):void
		{
			var ninjaInfo:NinjaInfo;
			
			ninjaInfo = getNinjaInfo(pos);
			ninjaInfo.hp = value;
			
			if(!stopSkillAndNinjaMatchNinja() && !guildNinja())
			{
				return ;
			}
			
			if(ninjaInfo.pos == targetPos && ninjaInfo.hp == 0)
			{
				updateTargetPos(getLiveNinjaPos());
			}
		}
		
		private function release():void
		{
			targetPos = -1;
			ninjaInfoList.splice(0, ninjaInfoList.length);
			
			BattleData.singleton.removeEventListener(Event.CHANGE, onBattleDataChanged);
		}
		
		private function onBattleDataChanged(evt:Event):void
		{
			if(!needAutoUseSkill || !curSkillBtnView ){return ;}
			
			if(BattleData.singleton.fightState == BattleData.FIGHT_STATE_FIGHTING)
			{
				autoUseSkill(curSkillBtnView);
			}
		}
		
		private function removeEnterNinjaInfo(pos:int):void
		{
			for(var i:int = 0;i < ninjaInfoList.length;i ++)
			{
				if(ninjaInfoList[i].pos == pos)
				{
					ninjaInfoList.splice(i, 1);
				}
			}
		}
		
		private function addEnterNinjaInfo(ninjaInfo:NinjaInfo):void
		{
			ninjaInfoList.push(ninjaInfo);
		}
		
		private function getNinjaInfo(pos:int):NinjaInfo
		{
			for(var i:int = 0;i < ninjaInfoList.length;i ++)
			{
				if(ninjaInfoList[i].pos == pos)
				{
					return ninjaInfoList[i];
				}
			}
			
			return null;
		}
		
		private function hasNinja(pos:int):Boolean
		{
			for(var i:int = 0;i < ninjaInfoList.length;i ++)
			{
				if(ninjaInfoList[i].pos == pos)
				{
					return true;
				}
			}
			
			return false;
		}
		
		private function getLiveNinjaPos():int
		{
			var i:int;
			var ninjaInfo:NinjaInfo;
			
			if(curGuidType == 7)
			{
				for(i = 0;i < ninjaInfoList.length;i ++)
				{
					ninjaInfo = ninjaInfoList[i];
					if(ninjaInfo.hp > 0 && ninjaInfo.pos >= 100 && ninjaInfo.ninjaId == curGuidArgs)
					{
						return ninjaInfo.pos;
					}
					
				}
				
				return -1;
			}
			else
			{
				for(i = 0;i < ninjaInfoList.length;i ++)
				{
					ninjaInfo = ninjaInfoList[i];
					if(ninjaInfo.hp > 0 && ninjaInfo.pos >= 100)
					{
						return ninjaInfo.pos;
					}
				}
				
				return -1;
			}
		}
		
		private function updateTargetPos(pos:int):void
		{
			targetPos = pos;
			new ShowNinjaGuidCommand(targetPos).call();
		}
		
		private function stopSkillAndNinjaMatchSkill():Boolean
		{
			if(curGuidType != 5)
			{
				return false;
			}
			
			if(!needAutoUseSkill)
			{
				return false;
			}
			
			return true;
		}
		
		private function stopSkillAndNinjaMatchNinja():Boolean
		{
			if(curGuidType != 5)
			{
				return false;
			}
			
			if(!needAutoUseSkill)
			{
				return false;
			}
			
			return true;
		}
		
		private function skillAndNinjaMajorSkill():Boolean
		{
			if(curGuidType != 8)
			{
				return false;
			}
			
			return true;
		}
		
		private function skillAndNinjaMajorNinja():Boolean
		{
			if(curGuidType != 8)
			{
				return false;
			}
			
			if(!needChooseNinja)
			{
				return false;
			}
			
			return true;
		}
		
		private function stopSkillAndNinjaMajorSkill():Boolean
		{
			if(curGuidType != 7)
			{
				return false;
			}
			
			if(!needAutoUseSkill)
			{
				return false;
			}
			
			return true;
		}
		
		private function stopSkillAndNinjaMajorNinja():Boolean
		{
			if(curGuidType != 7)
			{
				return false;
			}
			
			if(!needChooseNinja)
			{
				return false;
			}
			
			return true;
		}
		
		private function skillMajorSkill():Boolean
		{
			if(curGuidType != 6)
			{
				return false;
			}
			
			if(!needAutoUseSkill)
			{
				return false;
			}
			
			return true;
		}
		
		private function stopMatchSkill():Boolean
		{
			if(curGuidType != 4)
			{
				return false;
			}
			
			if(!needAutoUseSkill)
			{
				return false;
			}
			
			return true;
		}
		
		private function guidSkill():Boolean
		{
			if(curGuidType != 1 && curGuidType != 2)
			{
				return false;
			}
			
			return true;
		}
		
		private function guildNinja():Boolean
		{
			if(curGuidType != 3)
			{
				return false;
			}
			
			return true;
		}
		
		override public function autoSetNull():void
		{
			if(super.hasOwnProperty("autoSetNull"))
			{
				super["autoSetNull"]();
			}
			
			battleModel = null;
			ninjaInfoList = null;
		}
	}
}