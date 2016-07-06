package com.tencent.morefun.naruto.plugin.exui.tooltip
{

 import base.ApplicationData;
 
 import cfgData.dataStruct.NinjaSkillCFG;
 import cfgData.dataStruct.SkillCFG;
 
 import com.tencent.morefun.framework.apf.core.facade.Facade;
 import com.tencent.morefun.naruto.plugin.exui.base.Image;
 import com.tencent.morefun.naruto.plugin.ui.DigitItemUI;
 import com.tencent.morefun.naruto.plugin.ui.components.BitmapUint;
 import com.tencent.morefun.naruto.plugin.ui.layer.LayoutManager;
 import com.tencent.morefun.naruto.plugin.ui.tips.BaseTipsView;
 import com.tencent.morefun.naruto.plugin.ui.tooltip.NinjiaItemTooltipUI;
 import com.tencent.morefun.naruto.plugin.ui.tooltip.QualityBg_Down_1;
 import com.tencent.morefun.naruto.plugin.ui.tooltip.QualityBg_Down_2;
 import com.tencent.morefun.naruto.plugin.ui.tooltip.QualityBg_Down_3;
 import com.tencent.morefun.naruto.plugin.ui.tooltip.QualityBg_Down_4;
 import com.tencent.morefun.naruto.plugin.ui.tooltip.QualityBg_Down_5;
 import com.tencent.morefun.naruto.plugin.ui.tooltip.QualityBg_Up_1;
 import com.tencent.morefun.naruto.plugin.ui.tooltip.QualityBg_Up_2;
 import com.tencent.morefun.naruto.plugin.ui.tooltip.QualityBg_Up_3;
 import com.tencent.morefun.naruto.plugin.ui.tooltip.QualityBg_Up_4;
 import com.tencent.morefun.naruto.plugin.ui.tooltip.QualityBg_Up_5;
 import com.tencent.morefun.naruto.util.TimeUtils;
 
 import crew.def.NinjaNameColorDef;
 
 import def.ModelDef;
 import def.NinjaAssetDef;
 
 import flash.display.Bitmap;
 import flash.display.DisplayObject;
 import flash.utils.getTimer;
 
 import majorRole.commands.GetMajorRoleSkillCommand;
 import majorRole.model.ITalentSkillModel;
 import majorRole.model.TalentModel;
 import majorRole.model.TalentSkillManager;
 import majorRole.model.TalentSkillModel;
 
 import ninja.model.data.NinjaInfo;
 
 import skill.SkillAssetDef;
 import skill.config.NinjaSkillConfig;
 import skill.config.SkillConfig;
 
 import utils.PlayerNameUtil;

    import com.tencent.morefun.naruto.i18n.I18n;
    public class NinjaItemToopTips extends BaseTipsView
    {
		private static const MAX_SKILL_LEN:int				= 6;
		
        private static const SPACE_X:int                    =   40;
        private static const SPACE_Y:int                    =   15;
        private static const NAME_SPACE_Y:int               =   10;
        private static const DESCRIPTION_SPACE_Y:int        =   15;
		
		private static const leftSpace:int = 8;
		private static const rightSpace:int = 10;
		private static const topSpage:int = 11;
		private static const downSpage:int = 11;

        protected var _nijiaui:NinjiaItemTooltipUI;
		
		protected var skillItemUIList:Array = [];

        public function NinjaItemToopTips(skinCls:Class=null)
        {		
			_nijiaui = new NinjiaItemTooltipUI();
			_nijiaui.mouseEnabled = false;
			_nijiaui.mouseChildren = false;
			_nijiaui.cardtips.visible = false;
			
			_nijiaui.shiyongText.visible = _nijiaui.shiyongCdText.visible = false;
			
			for(var i:int = 1;i <= MAX_SKILL_LEN;i++)
			{
				skillItemUIList.push(_nijiaui['skillitem'+i]);
			}
            _nijiaui.nameText.width = 220;
			resize();
			new GetMajorRoleSkillCommand().call();
		}
		
		override public function destroy():void
		{
			image1.dispose();
			image2.dispose();
			image3.dispose();
			image4.dispose();
			image5.dispose();
			image6.dispose();
			nijiaImage.dispose();
						
			(_nijiaui) && (_nijiaui.parent) && (_nijiaui.parent.removeChild(_nijiaui));
			_nijiaui = null;
			
			(_combatUI) && (_combatUI.parent) && (_combatUI.parent.removeChild(_combatUI));
			_combatUI = null;
			
			if(qualityBgDown)
			{
				if(qualityBgDown.parent)
				{
					qualityBgDown.parent.removeChild(qualityBgDown);
				}
				qualityBgDown.bitmapData.dispose();
				qualityBgDown.bitmapData = null;
				qualityBgDown = null;
			}
			if(qualityBgUp)
			{
				if(qualityBgUp.parent)
				{
					qualityBgUp.parent.removeChild(qualityBgUp);
				}
				qualityBgUp.bitmapData.dispose();
				qualityBgUp.bitmapData = null;
				qualityBgUp = null;
			}
			skillItemUIList = null;
		}
		
		override public function set data(value:Object):void
		{
			if (!(value is NinjaInfo))
				return;
			
			var itemData:NinjaInfo = value as NinjaInfo;
			addChild(_nijiaui);
			showNinjiaSkill(itemData);
		}
		
		protected var image1:Image = new Image();
		protected var image2:Image = new Image();
		protected var image3:Image = new Image();
		protected var image4:Image = new Image();
		protected var image5:Image = new Image();
		protected var image6:Image = new Image();
		protected var nijiaImage:Image = new Image();
		protected var qualityBgDown:Bitmap;
		protected var qualityBgUp:Bitmap;
		protected var _combatUI:BitmapUint = new BitmapUint(DigitItemUI,-6);
		
		protected function get talentModel():ITalentSkillModel
		{
			if(ninjaData.talentTipsType == 0)
			{
				return Facade.getInstance().getPluginManager().retrieveModel(ModelDef.TALENT) as TalentModel;
			}
			else
			{
				var talentModel:TalentSkillModel;
				talentModel = TalentSkillManager.instance.getTalentSkillModel(ninjaData.talentTipsType);
				if(talentModel.isResponded == false)
				{
					talentModel.requestRefresh();
					return Facade.getInstance().getPluginManager().retrieveModel(ModelDef.TALENT) as TalentModel;
				}
				
				return talentModel;
			}
		}
		
		private var ninjaData:NinjaInfo;
		protected function showNinjiaSkill(data:NinjaInfo):void
		{
			var ninjaSkillCfg:NinjaSkillCFG;
			var num:int = 1;
			var i:int;
			
			ninjaData = data as NinjaInfo;
			if(ninjaData == null){
				return;
			}
			var _starLevel:uint = int(data.starLevel+1);
			nijiaImage.load(NinjaAssetDef.getAsset(NinjaAssetDef.HEAD_WIDE,ninjaData.id));
			_nijiaui.ImagePicMc.addChild(nijiaImage);
			
			_combatUI.value = 0;
			_combatUI.value = ninjaData.combat;
			_nijiaui.shiyongText.visible = _nijiaui.shiyongCdText.visible = false;
			if(ninjaData.combat>0 && !ApplicationData.singleton.isInArena){//如果没有战斗力，就不让它显示。
				_nijiaui.addChild(_combatUI);
				_nijiaui.combatBg.visible = true;
			}else {
				_nijiaui.combatBg.visible = false;
				if(data.tryOutLeftCd>0){
					_nijiaui.shiyongText.visible = _nijiaui.shiyongCdText.visible = true;
					if(data.vipFlag==1){
						_nijiaui.shiyongText.text = I18n.lang("as_exui_1451031568_1342");
					}else{
						_nijiaui.shiyongText.text = I18n.lang("as_exui_1451031568_1343");
					}
					_nijiaui.shiyongCdText.htmlText = I18n.lang("as_exui_1451031568_1344")+TimeUtils.getStandardTimeStr7((data.tryOutLeftCd-getTimer())/1000)+"</font>";
				}
			}

            _nijiaui.combatBg.x = 260;
			_combatUI.x = 280;
			_combatUI.y = 80;
			
			_nijiaui.propertyTag.gotoAndStop(ninjaData.cfg.property);
			
			if (_starLevel > 0)
			{
				_nijiaui.starLabel.visible = true;
				_nijiaui.starLabel.gotoAndStop(_starLevel);
			}
			else
			{
				_nijiaui.starLabel.visible = false;
			}
			
			if(ninjaData.isOtherPlayer)
			{
				//其他忍者
				ninjaSkillCfg =  ninjaData.otherPlayerSkillCfg;
				skillcfg = SkillConfig.instance.getSkill(ninjaSkillCfg.specials[0]);
				if(skillcfg){
					if(_nijiaui['skillitem'+num]){
						if(skillcfg.isImmediately)
						{
							_nijiaui['skillitem'+num].descriptionText.htmlText = "<b>"+skillcfg.name+I18n.lang("as_exui_1451031568_1345")+skillcfg.desc;
						}else{
							_nijiaui['skillitem'+num].descriptionText.htmlText = "<b>"+skillcfg.name+"：</b>"+skillcfg.desc;
						}
						_nijiaui['skillitem'+num].skilltype.gotoAndStop(1);
						setSkillIcon(skillcfg.id,num);
						_nijiaui['skillitem'+num].gems_icon_0.addChild(this['image'+num] as DisplayObject);
						_nijiaui['skillitem'+num].visible = true;
						setskilltype(skillcfg.type1,num);
						num ++;
					}
				}
				for(i=0;i<ninjaSkillCfg.normals.length;i++)
				{
					skillcfg = SkillConfig.instance.getSkill(ninjaSkillCfg.normals[i]);
					if(skillcfg && skillcfg.showIcon){
						if(_nijiaui['skillitem'+num]){
							if(skillcfg.isImmediately)
							{
								_nijiaui['skillitem'+num].descriptionText.htmlText = "<b>"+skillcfg.name+I18n.lang("as_exui_1451031568_1346")+skillcfg.desc;
							}else{
								_nijiaui['skillitem'+num].descriptionText.htmlText = "<b>"+skillcfg.name+"：</b>"+skillcfg.desc;
							}
							_nijiaui['skillitem'+num].skilltype.gotoAndStop(2)
							setSkillIcon(skillcfg.id,num);
							_nijiaui['skillitem'+num].gems_icon_0.addChild(this['image'+num] as DisplayObject);
							_nijiaui['skillitem'+num].visible = true;
							setskilltype(skillcfg.type1,num);
							num ++;
						}
					}
				}
				for(i=0;i<ninjaSkillCfg.skills.length;i++){
					skillcfg = SkillConfig.instance.getSkill(ninjaSkillCfg.skills[i]);
					if(!skillcfg || !skillcfg.showIcon){
						continue;
					}
					
					if(skillcfg && _nijiaui['skillitem'+num]){
						if(skillcfg.isImmediately)
						{
							_nijiaui['skillitem'+num].descriptionText.htmlText = "<b>"+skillcfg.name+I18n.lang("as_exui_1451031568_1347")+skillcfg.desc;
						}else{
							_nijiaui['skillitem'+num].descriptionText.htmlText = "<b>"+skillcfg.name+"：</b>"+skillcfg.desc;
						}
						_nijiaui['skillitem'+num].skilltype.gotoAndStop(3)
						setSkillIcon(skillcfg.id,num);
						_nijiaui['skillitem'+num].gems_icon_0.addChild(this['image'+num] as DisplayObject);
						_nijiaui['skillitem'+num].visible = true;
						setSkillItem(skillcfg.type,num);
						setskilltype(skillcfg.type1,num);
						num ++;
					}
				};  //普通技能
				
/*				skillcfg = SkillConfig.instance.getSkill(talentModel.beast);
				if(skillcfg && _nijiaui['skillitem'+num]){
					_nijiaui['skillitem'+num].descriptionText.htmlText = "<b>"+skillcfg.name+"：</b>"+skillcfg.desc;
					if(skillcfg.type==3||skillcfg.type==4){
						_nijiaui['skillitem'+num].skilltype.gotoAndStop(3);
					};	
					if(skillcfg.type==1){
						_nijiaui['skillitem'+num].skilltype.gotoAndStop(4);
					};
					this['image'+num].dispose();
					this['image'+num].load(SkillAssetDef.getAsset(SkillAssetDef.SKILL_ICON,skillcfg.id));
					this['image'+num].x = 4;
					this['image'+num].y = 4;
					_nijiaui['skillitem'+num].gems_icon_0.addChild(this['image'+num] as DisplayObject);
					_nijiaui['skillitem'+num].visible = true;
					
					setskilltype(skillcfg.type1,num);				
					num ++;
				}*/
				if(ninjaData.cfg){
					setnameText(PlayerNameUtil.standardlizeName(ninjaData.otherPlayerSvrId,ninjaData.otherPlayerName),ninjaData.cfg.title,ninjaData.levelUpgrade);
				}
				updateSkillItemStage(num - 1);
			}else if(ninjaData.sequence == 0)
			{//主角
				skillcfg = SkillConfig.instance.getSkill(talentModel.special);
				if(skillcfg && _nijiaui['skillitem'+num]){
					if(skillcfg.isImmediately)
					{
						_nijiaui['skillitem'+num].descriptionText.htmlText = "<b>"+skillcfg.name+I18n.lang("as_exui_1451031568_1350")+skillcfg.desc;
					}else{
						_nijiaui['skillitem'+num].descriptionText.htmlText = "<b>"+skillcfg.name+"：</b>"+skillcfg.desc;
					}
					_nijiaui['skillitem'+num].skilltype.gotoAndStop(1);
					setSkillIcon(skillcfg.id,num);
					_nijiaui['skillitem'+num].gems_icon_0.addChild(this['image'+num] as DisplayObject);
					_nijiaui['skillitem'+num].visible = true;
					setskilltype(skillcfg.type1,num);
					num ++;
				}
				skillcfg = SkillConfig.instance.getSkill(talentModel.normal);
				if(skillcfg && _nijiaui['skillitem'+num]){
					if(skillcfg.isImmediately)
					{
						_nijiaui['skillitem'+num].descriptionText.htmlText = "<b>"+skillcfg.name+I18n.lang("as_exui_1451031568_1351")+skillcfg.desc;
					}else{
						_nijiaui['skillitem'+num].descriptionText.htmlText = "<b>"+skillcfg.name+"：</b>"+skillcfg.desc;
					}
					_nijiaui['skillitem'+num].skilltype.gotoAndStop(2)
					setSkillIcon(skillcfg.id,num);
					_nijiaui['skillitem'+num].gems_icon_0.addChild(this['image'+num] as DisplayObject);
					_nijiaui['skillitem'+num].visible = true;
					setskilltype(skillcfg.type1,num);
					num ++;
				}
				if(talentModel.skills !=null){
					for(i=0;i<talentModel.skills.length;i++){
						skillcfg = SkillConfig.instance.getSkill(talentModel.skills[i]);
						if(!skillcfg || !skillcfg.showIcon){
							continue;
						}
						
						if(skillcfg && _nijiaui['skillitem'+num]){
							
							if(skillcfg.isImmediately)
							{
								_nijiaui['skillitem'+num].descriptionText.htmlText = "<b>"+skillcfg.name+I18n.lang("as_exui_1451031568_1352")+skillcfg.desc;
							}else{
								_nijiaui['skillitem'+num].descriptionText.htmlText = "<b>"+skillcfg.name+"：</b>"+skillcfg.desc;
							}
							_nijiaui['skillitem'+num].skilltype.gotoAndStop(3)
							setSkillIcon(skillcfg.id,num);
							_nijiaui['skillitem'+num].gems_icon_0.addChild(this['image'+num] as DisplayObject);
							_nijiaui['skillitem'+num].visible = true;
							setSkillItem(skillcfg.type,num);
							setskilltype(skillcfg.type1,num);
							num ++;
						}
					};  //普通技能
				}
				
				
				//通灵兽的技能
				skillcfg = SkillConfig.instance.getSkill(talentModel.beast);
				if(skillcfg && _nijiaui['skillitem'+num]){
					_nijiaui['skillitem'+num].descriptionText.htmlText = "<b>"+skillcfg.name+"：</b>"+skillcfg.desc;
					_nijiaui['skillitem'+num].skilltype.gotoAndStop(4);//通灵也显示,追打,5是通灵
					setSkillIcon(skillcfg.id,num);
					_nijiaui['skillitem'+num].gems_icon_0.addChild(this['image'+num] as DisplayObject);
					_nijiaui['skillitem'+num].visible = true;
					setskilltype(skillcfg.type1,num);				
					num ++;
				}
				if(ninjaData.cfg){
					setnameText(PlayerNameUtil.standardlizeName(ApplicationData.singleton.selfPlayerKey, ApplicationData.singleton.selfInfo.name), ninjaData.cfg.title,ninjaData.levelUpgrade);
				}
				updateSkillItemStage(num - 1);
			}
			else
			{
				//普通忍者
				var skillcfg:SkillCFG;
				ninjaSkillCfg = NinjaSkillConfig.instance.getNinjaSkillCfg(ninjaData.id);
				if(ninjaSkillCfg == null){
					return;
				}
				
				skillcfg = SkillConfig.instance.getSkill(ninjaSkillCfg.specials[0]);
				if(skillcfg){
					if(_nijiaui['skillitem'+num]){
						if(skillcfg.isImmediately)
						{
							_nijiaui['skillitem'+num].descriptionText.htmlText = "<b>"+skillcfg.name+I18n.lang("as_exui_1451031568_1355")+skillcfg.desc;
						}else{
							_nijiaui['skillitem'+num].descriptionText.htmlText = "<b>"+skillcfg.name+"：</b>"+skillcfg.desc;
						}
						_nijiaui['skillitem'+num].skilltype.gotoAndStop(1);
						setSkillIcon(skillcfg.id,num);
						_nijiaui['skillitem'+num].gems_icon_0.addChild(this['image'+num] as DisplayObject);
						_nijiaui['skillitem'+num].visible = true;
						setskilltype(skillcfg.type1,num);
						num ++;
					}
				}

				skillcfg = SkillConfig.instance.getSkill(ninjaSkillCfg.normals[2]);
				if(skillcfg){
					if(_nijiaui['skillitem'+num]){
						if(skillcfg.isImmediately)
						{
							_nijiaui['skillitem'+num].descriptionText.htmlText = "<b>"+skillcfg.name+I18n.lang("as_exui_1451031568_1356")+skillcfg.desc;
						}else{
							_nijiaui['skillitem'+num].descriptionText.htmlText = "<b>"+skillcfg.name+"：</b>"+skillcfg.desc;
						}
						_nijiaui['skillitem'+num].skilltype.gotoAndStop(2);						
						setSkillIcon(skillcfg.id,num);
						_nijiaui['skillitem'+num].gems_icon_0.addChild(this['image'+num] as DisplayObject);
						_nijiaui['skillitem'+num].visible = true;
						setskilltype(skillcfg.type1,num);
						num ++;
					}
				}
				
				for(i=0;i<ninjaSkillCfg.skills.length;i++){
					skillcfg = SkillConfig.instance.getSkill(ninjaSkillCfg.skills[i]);
					if(!skillcfg || !skillcfg.showIcon){
						continue;
					}
					if(_nijiaui['skillitem'+num]){
						if(skillcfg.isImmediately)
						{
							_nijiaui['skillitem'+num].descriptionText.htmlText = "<b>"+skillcfg.name+I18n.lang("as_exui_1451031568_1357")+skillcfg.desc;
						}else{
							_nijiaui['skillitem'+num].descriptionText.htmlText = "<b>"+skillcfg.name+"：</b>"+skillcfg.desc;
						}
						_nijiaui['skillitem'+num].skilltype.gotoAndStop(3);
						setSkillIcon(skillcfg.id,num);
						setSkillItem(skillcfg.type,num);
						setskilltype(skillcfg.type1,num);
						num ++;
					}
				};  //普通技能
				if(ninjaData.cfg){
					setnameText(ninjaData.cfg.name,ninjaData.cfg.title,ninjaData.levelUpgrade);
				}
				updateSkillItemStage(num - 1);
			}
			if (this.qualityBgDown)
			{
				if(!this._nijiaui.contains(qualityBgDown))
				{
					this.qualityBgDown.smoothing = true;
					this._nijiaui.addChildAt(this.qualityBgDown, 1);
				}
			}
			if (this.qualityBgUp)
			{
				if(!this._nijiaui.contains(qualityBgUp))
				{
					this.qualityBgUp.smoothing = true;
					this._nijiaui.addChildAt(this.qualityBgUp, 1);
				}
				
			}
			setHeight();
			resize();
		}
		
		protected function setSkillIcon(id:int,num:int):void
		{
			this['image'+num].dispose();
			this['image'+num].load(SkillAssetDef.getAsset(SkillAssetDef.SKILL_ICON,id));
			this['image'+num].x = 4;
			this['image'+num].y = 4;
		}
		
		
		protected function setSkillItem(type:int,num:int):void
		{
			_nijiaui['skillitem'+num].gems_icon_0.addChild(this['image'+num] as DisplayObject);
			_nijiaui['skillitem'+num].visible = true;
			if(type==3||type==4){
				_nijiaui['skillitem'+num].skilltype.gotoAndStop(3);//被动
			}else if(type==1){
				_nijiaui['skillitem'+num].skilltype.gotoAndStop(4);//追打
			}else if(type==5){
				_nijiaui['skillitem'+num].skilltype.gotoAndStop(4);//通灵也显示追打
				//_nijiaui['skillitem'+num].skilltype.gotoAndStop(5);//通灵
			};
		}
		
		
		protected function setskilltype(arr:Array,num:int):void
		{
			if(arr.length == 0){
				_nijiaui['skillitem'+num].typeMc1.visible = false;
				_nijiaui['skillitem'+num].typeMc2.visible = false;
				return;
			}
			for(var i:int = 0;i<arr.length;i++){
				if(arr.length == 2){
					_nijiaui['skillitem'+num].typeMc1.visible = true;
					_nijiaui['skillitem'+num].typeMc2.visible = true;
				}else{
					_nijiaui['skillitem'+num].typeMc1.visible = true;
					_nijiaui['skillitem'+num].typeMc2.visible = false;
				}
				_nijiaui['skillitem'+num]['typeMc'+(i+1)].gotoAndStop("label"+arr[i]);
				//_nijiaui['skillitem'+num][typeMc2].gotoAndStop(arr[i]);
			}
		}
		
		
		protected function setnameText(name:String,title:String,levelUpgrade:uint):void
		{
			var	str:String = NinjaNameColorDef.getNameAppendStrByStrengthenLevel(levelUpgrade);
			_nijiaui.nameText.htmlText = "<b>"+name+title+str+"</b>"; 
			_nijiaui.nameText.textColor = NinjaNameColorDef.getNameTextColorByStrengthenLevel(levelUpgrade);
			var colorStr:String = NinjaNameColorDef.getNameTextColorNameByStrengthenLevel(levelUpgrade);			
			switch (colorStr)
			{
				case "green":
				{
					qualityBgDown = setQualityBG(qualityBgDown,QualityBg_Down_1);
					qualityBgUp = setQualityBG(qualityBgUp,QualityBg_Up_1);
					break;
				}
				case "blue":
				{
					qualityBgDown = setQualityBG(qualityBgDown,QualityBg_Down_2);
					qualityBgUp = setQualityBG(qualityBgUp,QualityBg_Up_2);
					break;
				}
				case "purple":
				{
					qualityBgDown = setQualityBG(qualityBgDown,QualityBg_Down_3);
					qualityBgUp = setQualityBG(qualityBgUp,QualityBg_Up_3);
					break;
				}
				case "orange":
				{
					qualityBgDown = setQualityBG(qualityBgDown,QualityBg_Down_4);
					qualityBgUp = setQualityBG(qualityBgUp,QualityBg_Up_4);
					break;
				}
				case "red":
				{
					qualityBgDown = setQualityBG(qualityBgDown,QualityBg_Down_5);
					qualityBgUp = setQualityBG(qualityBgUp,QualityBg_Up_5);
					break;
				}
				default:
					break;
			}
		}
		
		protected function updateSkillItemStage(skillLen:int):void
		{
			var i:int;
			
			for(i = 0;i < MAX_SKILL_LEN;i ++)
			{
				if(_nijiaui.contains(skillItemUIList[i]))
				{
					_nijiaui.removeChild(skillItemUIList[i]);
				}
			}
			
			for(i = 0;i < skillLen;i ++)
			{
				_nijiaui.addChild(skillItemUIList[i]);
			}
		}
		
		//奥义普攻追打被动
		protected function setHeight():void
		{
			var nowItemShow:uint = 0;
			for(var i:int=1;i<MAX_SKILL_LEN+1;i++){
				if(_nijiaui['skillitem'+i].parent){
					nowItemShow++;					
				}
			}
			_nijiaui.bg.height = 125 + nowItemShow*55;
			_nijiaui.bg.x = 0;
			_nijiaui.bg.y = 28;
		}
		
		protected function setQualityBG(bitmap:Bitmap, bitmapDataClass:Class):Bitmap
		{
			if(bitmap == null)
			{
				bitmap = new Bitmap();
			}
			if(bitmap.bitmapData == null || !bitmap.bitmapData is bitmapDataClass)
			{
				bitmap.bitmapData = new bitmapDataClass();
			}
			return bitmap;
		}
		
		
		/**
		 *设置位置 
		 * @param x
		 * @param y
		 * 
		 */		
		override public function move(x:int, y:int):void
		{
			if((x + this.width) > LayoutManager.stageWidth)
			{
				this.x = x - this.width;
			}
			else
			{
				this.x = x;
			}
			
			if((y + _nijiaui.bg.height) > LayoutManager.stageHeight)
			{
				if (_nijiaui.bg.height + 25 <= LayoutManager.stageHeight)
				{
					this.y = LayoutManager.stageHeight - _nijiaui.bg.height - 25;
				}
				else
				{
					this.y = y - _nijiaui.bg.height - 25;
				}
			}
			else
			{
				this.y = y - 25;
			}
		}

		override protected function resize():void
		{
			if (this.qualityBgDown)
			{
				this.qualityBgDown.x = this._nijiaui.bg.width - this.qualityBgDown.width - 9;
				this.qualityBgDown.y = this._nijiaui.bg.height - this.qualityBgDown.height + 16;
			}
			if (this.qualityBgUp)
			{
				this.qualityBgUp.x = 8;
				this.qualityBgUp.y = 40;
			}
			this._nijiaui.texture_right.x = this._nijiaui.bg.width - this._nijiaui.texture_right.width-10;
			this._nijiaui.texture_right.y = this._nijiaui.bg.height - this._nijiaui.texture_right.height+20;
        }
   	}
}