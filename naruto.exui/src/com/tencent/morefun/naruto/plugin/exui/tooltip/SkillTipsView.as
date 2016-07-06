package com.tencent.morefun.naruto.plugin.exui.tooltip 
{

	import com.tencent.morefun.naruto.plugin.exui.base.Image;
	import com.tencent.morefun.naruto.plugin.exui.render.SkillNinJutsuTypeRender;
	import com.tencent.morefun.naruto.plugin.exui.render.SkillType1IconRender;
	import com.tencent.morefun.naruto.plugin.ui.components.layouts.SimpleLayout;
	import com.tencent.morefun.naruto.plugin.ui.layer.LayoutManager;
	import com.tencent.morefun.naruto.plugin.ui.tips.BaseTipsView;
	import com.tencent.morefun.naruto.plugin.ui.tooltip.SkillTipsViewUI;
	
	import flash.display.Sprite;
	
	import cfgData.dataStruct.SkillCFG;
	
	import skill.SkillAssetDef;
	import skill.config.SkillDef;

    import com.tencent.morefun.naruto.i18n.I18n;
	public class SkillTipsView extends BaseTipsView
	{
		private static const leftSpace:int = 8;
		private static const rightSpace:int = 10;
		private static const topSpage:int = 11;
		private static const downSpage:int = 11;
		
		private var _ui:SkillTipsViewUI;
		private var _bg:Sprite;
		private var _img:Image;
		private var type1List:SimpleLayout;
		private var ninJutsuTypeList:SimpleLayout;
		
		public function SkillTipsView(cls:Class) 
		{
			_ui = new SkillTipsViewUI;
			configUI();
			super(null);
		}
		private function configUI():void 
		{
			resetUI();
			addChild(_ui);
			_bg = _ui.bg;
			_img = new Image();
			_img.x = 3;
			_img.y = 4;
			_ui.icon.addChild(_img);
			mouseEnabled = mouseChildren = false;
			
			type1List = new SimpleLayout(1, 7, 0, 0);
			type1List.itemRenderClass = SkillType1IconRender;
			_ui.typeListPos.addChild(type1List);
			
			ninJutsuTypeList = new SimpleLayout(1, 7, 0, 0);
			ninJutsuTypeList.itemRenderClass = SkillNinJutsuTypeRender;
			_ui.typeListPos.addChild(ninJutsuTypeList);
		}
		
		override public function set data(value:Object):void
		{
			var i:int;
			var l:int;
			
			var cfg:SkillCFG = value as SkillCFG;
			resetUI();
			
			_img.load(SkillAssetDef.getAsset(SkillAssetDef.SKILL_ICON, cfg.id));
			
			_ui.nameTf.htmlText = "<b>" + cfg.name + "</b>";
			_ui.xumfaTf.visible = cfg.isImmediately;
			
//			_ui.typeMC.visible = true;
//			_ui.typeMC.gotoAndStop("label"+cfg.type1[0]);
//			
//			l  = cfg.ninJutsuTypeList.length;
//			for(i = 0; i < l; i++){
//				_ui["s" + i].visible = true;
//				_ui["s" + i].gotoAndStop(cfg.ninJutsuTypeList[i]);
//			}
			
			type1List.column = cfg.type1.length;
			type1List.dataProvider = cfg.type1.concat();
			ninJutsuTypeList.dataProvider = cfg.ninJutsuTypeList.concat();
			ninJutsuTypeList.x = type1List.width;
			
			_ui.desTf.htmlText = cfg.desc;
			
			if(cfg.type == 2)
			{
				_ui.t0.htmlText = I18n.lang("as_exui_1451031568_1381_0") + (cfg.cd > 0?cfg.cd + I18n.lang("as_exui_1451031568_1381_1"):I18n.lang("as_exui_1451031568_1381_2")) + "</font>";;
				_ui.t1.htmlText = I18n.lang("as_exui_1451031568_1382_0") + (cfg.enterCd > 0?cfg.enterCd + I18n.lang("as_exui_1451031568_1382_1"):I18n.lang("as_exui_1451031568_1382_2")) + "</font>";
				_ui.t2.htmlText = I18n.lang("as_exui_1451031568_1383_0") + (cfg.mp > 0?cfg.mp:I18n.lang("as_exui_1451031568_1383_1")) + "</font>";
				_ui.t3.htmlText = I18n.lang("as_exui_1451031568_1384") + SkillDef.getExStatesString(cfg.exStates) + "</font>";
				_ui.blackGrdMC.visible = true;
				_bg.height = 274;
			}
			else if (cfg.type == 1)
			{
				_ui.t0.htmlText = I18n.lang("as_exui_1451031568_1385")+ SkillDef.getBeHitState1String(cfg.beHitState1,cfg.beHitState1Param)+"</font>";
				_ui.t1.htmlText = I18n.lang("as_exui_1451031568_1386") + SkillDef.getExStatesString(cfg.exStates) + "</font>";
				
				_bg.height = 258;
			}else
			{
				_ui.t0.htmlText = I18n.lang("as_exui_1451031568_1387") + SkillDef.getExStatesString(cfg.exStates) + "</font>";
				_bg.height = 258;
			}
			
			this._ui.texture_left.x = leftSpace;
			this._ui.texture_left.y = topSpage;
			this._ui.texture_right.x = this._ui.bg.width - this._ui.texture_right.width - rightSpace;
			this._ui.texture_right.y = this._ui.bg.height - this._ui.texture_right.height - downSpage;
		}
		
		override public function move(x:int, y:int):void
		{
			var stageWidth:int;
			var stageHeight:int;
			
			stageWidth = Math.min(stage.stageWidth - LayoutManager.stageOffsetX, LayoutManager.singleton.maxFrameWidth);
			stageHeight = Math.min(stage.stageHeight - LayoutManager.stageOffsetY, LayoutManager.singleton.maxFrameHeight)
			
			if(stage && x + 10 + width < stageWidth)
			{
				this.x = x + 10;
			}
			else
			{
				this.x = x - width;
			}
			
			if(stage && y + 10 + height < stageHeight)
			{
				this.y = y + 10;
			}
			else
			{
				this.y = y - height;
			}
		}
		
		private function resetUI():void 
		{
			var i:int;
			var l:int;	
			
			if(_img)
				_img.dispose();
			_ui.nameTf.text = "";
			_ui.xumfaTf.visible = false;
			
			(type1List) && (type1List.dataProvider = null);
			(ninJutsuTypeList) && (ninJutsuTypeList.dataProvider = null);
			
			_ui.desTf.text = "";
			
			l  = 4;
			for(i = 0; i < l; i++){
				_ui["t"+i].text = "";
			}
			
			_ui.blackGrdMC.visible = false;
		}
		
		override public function destroy():void
		{
			(_img.parent) && (_img.parent.removeChild(_img));
			_img.dispose();
			_img = null;
			
			(type1List.parent) && (type1List.parent.removeChild(type1List));
			type1List.dispose();
			type1List = null;
			
			(ninJutsuTypeList.parent) && (ninJutsuTypeList.parent.removeChild(ninJutsuTypeList));
			ninJutsuTypeList.dispose();
			ninJutsuTypeList = null;
			
			_bg = null;
			
			(_ui.parent) && (_ui.parent.removeChild(_ui));
			_ui = null;
			
			super.destroy();
		}
		
	}

}