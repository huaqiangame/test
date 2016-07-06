package com.tencent.morefun.naruto.plugin.prewar.view.skill
{
	import com.tencent.morefun.naruto.plugin.exui.base.Image;
	import com.tencent.morefun.naruto.plugin.ui.tips.TipsManager;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	
	import cfgData.dataStruct.NinjaSkillCFG;
	import cfgData.dataStruct.SkillCFG;
	
	import def.NinjaAssetDef;
	import def.TipsTypeDef;
	
	import ninja.model.data.NinjaHotkeyInfo;
	import ninja.model.data.NinjaInfo;
	
	import skill.SkillAssetDef;
	import skill.command.GetNinjaSkillConfigSkillCommnad;
	import skill.command.GetSkillConfigSkillCommand;
	import skill.config.NinjaSkillConfig;
	import skill.config.SkillConfig;
	
	public class SkillItemRender
	{
		private var _view:MovieClip;
		private var _data:NinjaInfo;
		
		private var head:Image;
		private var skillIcon:Image;
		
		private var _hotKeyInfo:NinjaHotkeyInfo;
		
		public function SkillItemRender(view:MovieClip)
		{
			_view = view;
			
			initUI();
		}
		
		public function get hotKeyInfo():NinjaHotkeyInfo
		{
			return _hotKeyInfo;
		}
		
		public function set hotKeyInfo(value:NinjaHotkeyInfo):void
		{
			_hotKeyInfo = value;
			
			if(_data == null || _hotKeyInfo == null)
			{
				return ;
			}
			
			switch(_data.sequence)
			{
				case value.ninjaE:
					_view.hotkey.gotoAndStop("E");
					break;
				case value.ninjaQ:
					_view.hotkey.gotoAndStop("Q");
					break;
				case value.ninjaR:
					_view.hotkey.gotoAndStop("R");
					break;
				case value.ninjaT:
					_view.hotkey.gotoAndStop("T");
					break;
				case value.ninjaW:
					_view.hotkey.gotoAndStop("W");
					break
			}
		}
		
		private function initUI():void
		{
			head = new Image();
			(_view.head["container"] as DisplayObjectContainer).addChild(head);
			
			skillIcon = new Image();
			(_view.skillIcon["container"] as DisplayObjectContainer).addChild(skillIcon);
			
			_view.mp["label"].text = "0";
		}
		
		public function reset():void
		{
			head.dispose();
			skillIcon.dispose();
		}
		
		public function render():void
		{
			var skillCfg:SkillCFG;
			var ninjaSkillInfo:NinjaSkillCFG;
			var ninjaSkillConfig:NinjaSkillConfig;
			var getSkillConfigCommand:GetNinjaSkillConfigSkillCommnad;
			var skillConfig:SkillConfig;
			var getSkillCommand:GetSkillConfigSkillCommand;
			
			reset();
			if(_data == null)
			{
				_view.hotkey.visible = false;
				TipsManager.singleton.unbinding(_view, TipsTypeDef.SKILL);
				return ;
			}
			
			getSkillCommand = new GetSkillConfigSkillCommand();
			getSkillCommand.call();
			skillConfig = getSkillCommand.skillConfig;
			
			_view.hotkey.visible = true;
			if(_data.sequence != 0)
			{
				getSkillConfigCommand = new GetNinjaSkillConfigSkillCommnad();
				getSkillConfigCommand.call();
				ninjaSkillConfig = getSkillConfigCommand.ninjaSkillConfig;
				ninjaSkillInfo = ninjaSkillConfig.getNinjaSkillCfg(_data.id);
				skillIcon.load(SkillAssetDef.getAsset(SkillAssetDef.SKILL_ICON,ninjaSkillInfo.specials[0]));
				
				skillCfg = skillConfig.getSkill(ninjaSkillInfo.specials[0]);
				TipsManager.singleton.binding(_view, skillCfg, TipsTypeDef.SKILL);
				
				_view.mp["label"].text = skillCfg.mp;
			}
			else
			{
				if(_data.majorSpecialSkill != 0)
				{
					skillIcon.load(SkillAssetDef.getAsset(SkillAssetDef.SKILL_ICON,_data.majorSpecialSkill));
					skillCfg = skillConfig.getSkill(_data.majorSpecialSkill);
					
					_view.mp["label"].text = skillCfg.mp;
					TipsManager.singleton.binding(_view, skillCfg, TipsTypeDef.SKILL);
				}
			}
			
			head.load(NinjaAssetDef.getAsset(NinjaAssetDef.HEAD_SMALL,_data.id));
		}
		
		public function get data():NinjaInfo
		{
			return _data;
		}
		public function set data(value:NinjaInfo):void
		{
			_data = value;
			render();
		}
		
		public function destroy():void
		{
			head.dispose();
			skillIcon.dispose();
			TipsManager.singleton.unbinding(_view, TipsTypeDef.SKILL);
		}
	}
}