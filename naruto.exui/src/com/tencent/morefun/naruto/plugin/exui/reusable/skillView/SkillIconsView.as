package com.tencent.morefun.naruto.plugin.exui.reusable.skillView
{
	
	
	import com.tencent.morefun.naruto.plugin.ui.components.layouts.SimpleLayout;
	import com.tencent.morefun.naruto.plugin.ui.core.SkillIconsUI;
	import com.tencent.morefun.naruto.plugin.ui.util.DisplayUtils;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import cfgData.dataStruct.NinjaSkillCFG;
	import cfgData.dataStruct.SkillCFG;
	
	import skill.config.NinjaSkillConfig;
	import skill.config.SkillConfig;

	public class SkillIconsView extends Sprite
	{
		public var kathaSkillIcon:SkillIconItemRenderer;
		public var commonSkillIcon:SkillIconItemRenderer;
		public var otherSkillIcons:SimpleLayout;
		private var skillIconsUI:SkillIconsUI;
		
		public function SkillIconsView()
		{		
			skillIconsUI = new SkillIconsUI;
			this.addChild(skillIconsUI);
			
			kathaSkillIcon = new SkillIconItemRenderer(new MovieClip());
			kathaSkillIcon.visible = false;
			kathaSkillIcon.x = skillIconsUI.kathaSkillIconsPos.x;
			kathaSkillIcon.y = skillIconsUI.kathaSkillIconsPos.y;
			skillIconsUI.addChild(kathaSkillIcon);
			
			commonSkillIcon = new SkillIconItemRenderer(new MovieClip());
			commonSkillIcon.x = skillIconsUI.commonSkillIconsPos.x;
			commonSkillIcon.y = skillIconsUI.commonSkillIconsPos.y;
			commonSkillIcon.visible = false;
			this.addChild(commonSkillIcon);
			
			otherSkillIcons = new SimpleLayout(1, 5, -1);
			otherSkillIcons.itemRenderClass = SkillIconItemRenderer;
			otherSkillIcons.x = skillIconsUI.otherSkillIconsPos.x;
			otherSkillIcons.y = skillIconsUI.otherSkillIconsPos.y;
			this.addChild(otherSkillIcons);
		}
		
		public function set data(ninjaSkillCfg:NinjaSkillCFG):void
		{		
			var skillCfg:SkillCFG;
			var skillId:int;
			var showSkillCfgs:Array;
			
			kathaSkillIcon.visible = false;
			
			if (!ninjaSkillCfg) return;
			
			for each (skillId in ninjaSkillCfg.specials)
			{
				skillCfg = SkillConfig.instance.getSkill(skillId);
				if (skillCfg.showIcon)
				{
					kathaSkillIcon.data = skillCfg;
					kathaSkillIcon.visible = true;
					break;
				}
			}
			
			commonSkillIcon.visible = false;
			for each (skillId in ninjaSkillCfg.normals)
			{
				skillCfg = SkillConfig.instance.getSkill(skillId);
				if (skillCfg.showIcon)
				{
					commonSkillIcon.data = skillCfg;
					commonSkillIcon.visible = true;
					break;
				}
			}
			
			showSkillCfgs = NinjaSkillConfig.instance.getSkillCfgsBySkillIDs(ninjaSkillCfg.skills);
			for (var i:int = showSkillCfgs.length-1; i >= 0; i--)
			{
				skillCfg = showSkillCfgs[i] as SkillCFG;
				if (!skillCfg.showIcon)
				{
					showSkillCfgs.splice(i, 1);
				}
			}
			otherSkillIcons.dataProvider = showSkillCfgs;
		}
		
		public function destory():void
		{
			(kathaSkillIcon.parent) && (kathaSkillIcon.parent.removeChild(kathaSkillIcon));
			kathaSkillIcon.destroy();
			kathaSkillIcon = null;
			
			(commonSkillIcon.parent) && (commonSkillIcon.parent.removeChild(commonSkillIcon));
			commonSkillIcon.destroy();
			commonSkillIcon = null;
			
			(otherSkillIcons.parent) && (otherSkillIcons.parent.removeChild(otherSkillIcons));
			otherSkillIcons.dispose();
			otherSkillIcons = null;
			
			(skillIconsUI.parent) && (skillIconsUI.parent.removeChild(skillIconsUI));
			DisplayUtils.clear(skillIconsUI);
			skillIconsUI = null;
		}
	}
}