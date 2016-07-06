package com.tencent.morefun.naruto.plugin.exui.reusable.skillView
{
	import com.tencent.morefun.naruto.plugin.exui.base.Image;
	import com.tencent.morefun.naruto.plugin.ui.base.ItemRenderer;
	import com.tencent.morefun.naruto.plugin.ui.components.interfaces.IRender;
	import com.tencent.morefun.naruto.plugin.ui.core.SingleIconUI;
	import com.tencent.morefun.naruto.plugin.ui.tips.TipsManager;
	import com.tencent.morefun.naruto.plugin.ui.util.DisplayUtils;
	
	import flash.display.MovieClip;
	
	import cfgData.dataStruct.SkillCFG;
	
	import def.TipsTypeDef;
	
	import skill.SkillAssetDef;
	import skill.config.SkillDef;

	public class SkillIconItemRenderer extends ItemRenderer implements IRender
	{
		private var icon:Image;
		private var skillDescription:String;
		private var singleIconUI:SingleIconUI;
		
		public function SkillIconItemRenderer(skin:MovieClip = null)
		{
			super(new MovieClip());
			singleIconUI = new SingleIconUI();
			view.addChild(singleIconUI);
			icon = new Image(45,45);
			singleIconUI.imgPos.addChild(icon);
			this.mouseChildren = false;
			this.name = "SkillIcon";
			singleIconUI.key.visible = false;
		}
		
		override public function set data(value:Object):void
		{
			super.data = value;
			var skillCfg:SkillCFG = value as SkillCFG;
			icon.load(SkillAssetDef.getAsset(SkillAssetDef.SKILL_ICON, skillCfg.id));
			this.skillDescription = SkillDef.getTypeString(skillCfg.type) + ":" + skillCfg.name;
			TipsManager.singleton.binding(this, skillCfg, TipsTypeDef.SKILL);
		}
		
		override public function set index(value:int):void
		{
			var keyArr:Array = ["W", "E", "R", "T", "Y"];
			m_index = value;
			singleIconUI.key.text = keyArr[this.index]; 
		}
		
		private function get view():MovieClip
		{
			return m_skin as MovieClip;
		}
		
		override public function destroy():void
		{
			(icon.parent) && (icon.parent.removeChild(icon));
			icon.dispose();
			icon = null;
			
			(singleIconUI.parent) && (singleIconUI.parent.removeChild(singleIconUI));
			DisplayUtils.clear(singleIconUI);
			singleIconUI = null;
			
			TipsManager.singleton.unbinding(this, TipsTypeDef.SKILL);
			
			super.destroy();
		}
		
		public function dispose():void
		{
			destroy();
		}
	}
}