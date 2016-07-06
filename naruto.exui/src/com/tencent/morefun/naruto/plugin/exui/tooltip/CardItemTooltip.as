package com.tencent.morefun.naruto.plugin.exui.tooltip
{

    import com.tencent.morefun.framework.base.CommandEvent;
    import com.tencent.morefun.naruto.plugin.exui.base.Image;
    import com.tencent.morefun.naruto.plugin.ui.DigitItemUI;
    import com.tencent.morefun.naruto.plugin.ui.components.BitmapUint;
    import com.tencent.morefun.naruto.plugin.ui.layer.LayoutManager;
    import com.tencent.morefun.naruto.plugin.ui.tips.BaseTipsView;
    import com.tencent.morefun.naruto.plugin.ui.tooltip.CardItemTooltipUI;
    import com.tencent.morefun.naruto.plugin.ui.tooltip.NinjiaItemTooltipUI;
    
    import flash.display.Bitmap;
    import flash.display.DisplayObject;
    import flash.media.ID3Info;
    import flash.text.TextFormatAlign;
    
    import bag.data.CardItemData;
    import bag.data.ItemData;
    import bag.utils.BagUtils;
    
    import cfgData.dataStruct.NinjaInfoCFG;
    import cfgData.dataStruct.NinjaSkillCFG;
    import cfgData.dataStruct.SkillCFG;
    
    import def.NinjaAssetDef;
    
    import ninja.command.RequestNinjaByIdCommand;
    import ninja.command.RequestNinjaListCommand;
    import ninja.def.NinjaListTypeDef;
    import ninja.model.data.NinjaInfo;
    
    import skill.SkillAssetDef;
    import skill.config.NinjaSkillConfig;
    import skill.config.SkillConfig;
    
    import user.data.NinjaCfgInfo;
    import user.data.NinjaInfoConfig;

    import com.tencent.morefun.naruto.i18n.I18n;
    public class CardItemTooltip extends BaseTipsView
    {
		private static const MAX_SKILL_LEN:int				= 5;
		
        protected static const SPACE_X:int                    =   30;
        protected static const SPACE_Y:int                    =   25;
        protected static const NAME_SPACE_Y:int               =   10;
        protected static const DESCRIPTION_SPACE_Y:int        =   15;
		protected static var ninjareqed:Boolean;
		protected static const leftSpace:int = 8;
		protected static const rightSpace:int = 10;
		protected static const topSpage:int = 11;
		protected static const downSpage:int = 11;

        protected var _ui:CardItemTooltipUI;//有两种tips,类是猫啊什么的不能招募的
        protected var _lineY:int;
		
		protected var _nijiaui:NinjiaItemTooltipUI;//有两种tips,忍者的tips
		
		private var skillItemUIList:Array = [];
		
        public function CardItemTooltip(skinCls:Class=null)
        {
            _ui = new CardItemTooltipUI();
            _ui.mouseEnabled = false;
            _ui.mouseChildren = false;
            _ui.descriptionText.autoSize = TextFormatAlign.LEFT;
            
			_nijiaui = new NinjiaItemTooltipUI();
			_nijiaui.mouseEnabled = false;
			_nijiaui.mouseChildren = false;
			_nijiaui.combatBg.visible = false;
			
			_nijiaui.shiyongText.visible = _nijiaui.shiyongCdText.visible = false;
			
			_nijiaui.skillitem6.visible = false;
			for(var i:int = 1;i <= MAX_SKILL_LEN;i++)
			{
				skillItemUIList.push(_nijiaui['skillitem'+i]);
			}
        }

        override public function destroy():void
        {
			(_nijiaui) && (_nijiaui.parent) && (_nijiaui.parent.removeChild(_nijiaui));
			_nijiaui = null;

			(_ui) && (_ui.parent) && (_ui.parent.removeChild(_ui));
			_ui = null;

			image1.dispose();
            image1 = null;

			image2.dispose();
            image2 = null;

			image3.dispose();
            image3 = null;

			image4.dispose();
            image4 = null;

			image5.dispose();
            image5 = null;

			nijiaImage.dispose();
            nijiaImage = null;

            super.destroy();
        }

        override public function set data(value:Object):void
        {
            if (!(value is CardItemData))
                return;

            var itemData:CardItemData = value as CardItemData;
		
			if(itemData.isNinjable && itemData.id != 20400125 || itemData.isFragment && itemData.id != 20400125){//看下碎片要这么判断
				if(this.contains(_ui)){
					removeChild(_ui);
				}
				addChild(_nijiaui);
				showNinjiaSkill(itemData);
				setHeight();
				_resize();
			}else if(!itemData.isNinjable || itemData.id == 20400125){			
				if(this.contains(_nijiaui)){
					removeChild(_nijiaui);
				}
				addChild(_ui);
				if(itemData.id == 20400125){
					itemData.name = I18n.lang("as_exui_1451031568_1279");
				}
				showName(itemData);
				showDescription(itemData);
				resize();
			}
        }
		
		protected var image1:Image = new Image();
		protected var image2:Image = new Image();
		protected var image3:Image = new Image();
		protected var image4:Image = new Image();
		protected var image5:Image = new Image();
		
		protected var nijiaImage:Image = new Image();
		
		protected var qualityBgDown:Bitmap;
		protected var qualityBgUp:Bitmap;
		protected var _combatUI:BitmapUint = new BitmapUint(DigitItemUI,-6);
		
		protected var itemData:CardItemData;
		protected function showNinjiaSkill(data:ItemData):void
		{
			itemData = data as CardItemData;
			var num:int = 1;
			var ninjaSkillCfg:NinjaSkillCFG = NinjaSkillConfig.instance.getNinjaSkillCfg(itemData.ninjaId);
			var i:int;
			var skillcfg:SkillCFG;
			var ninjiaCFG:NinjaInfoCFG;
			if(ninjaSkillCfg == null){
				return;
			}
			_nijiaui.starLabel.visible = false;//卡牌不显示星级,7.17,10:40,羊羊说的.
			
	
			if(data is CardItemData){
				var carddata:CardItemData = data as CardItemData;
				//var requestninjabyid:RequestNinjaByIdCommand =  new RequestNinjaByIdCommand(carddata.ninjaId);
				//requestninjabyid.addEventListener(CommandEvent.FINISH,finishHandler);
				//requestninjabyid.addEventListener(CommandEvent.FAILD,finishHandler);
				//requestninjabyid.call();
				var requestNinjaListCommand:RequestNinjaListCommand;
				if(!ninjareqed){
					requestNinjaListCommand = new RequestNinjaListCommand(NinjaListTypeDef.ALL,true);
					ninjareqed = true;
				}else{
					requestNinjaListCommand = new RequestNinjaListCommand(NinjaListTypeDef.ALL,false);
					
				}
				
				requestNinjaListCommand.addEventListener(CommandEvent.FINISH,requestNinjaListCommandFinishHandler);
				requestNinjaListCommand.addEventListener(CommandEvent.FAILD,requestNinjaListCommandFinishHandler);
				requestNinjaListCommand.call();
				
				//carddata.cardId == 

				
				ninjiaCFG = NinjaInfoConfig.getNinjaCfgInfo(carddata.ninjaId);
				_nijiaui.propertyTag.gotoAndStop(ninjiaCFG.property);
			}else{
				this._nijiaui.cardtips.txt.text = data.description;//卡牌描述
			}
			
			_nijiaui.nameText.htmlText = "<b><font color='#ffffff'>"+itemData.name+itemData.title+I18n.lang("as_exui_1451031568_1282"); //名字加称号
			nijiaImage.load(NinjaAssetDef.getAsset(NinjaAssetDef.HEAD_WIDE,itemData.ninjaId));
			_nijiaui.ImagePicMc.addChild(nijiaImage);
						
			for(i=1;i<6;i++){
				_nijiaui['skillitem'+i].visible = false;
			}
			
			//for(i=0;i<ninjaSkillCfg.specials.length;i++){
				skillcfg = SkillConfig.instance.getSkill(ninjaSkillCfg.specials[0]);
				if(skillcfg == null){
					return;
				}
				if(_nijiaui['skillitem'+num]){
					if(skillcfg.isImmediately)
					{
						_nijiaui['skillitem'+num].descriptionText.htmlText = "<b>"+skillcfg.name+I18n.lang("as_exui_1451031568_1283")+skillcfg.desc;
					}else{
						_nijiaui['skillitem'+num].descriptionText.htmlText = "<b>"+skillcfg.name+"：</b>"+skillcfg.desc;
					}
					_nijiaui['skillitem'+num].skilltype.gotoAndStop(1);
					this['image'+num].dispose();
					this['image'+num].load(SkillAssetDef.getAsset(SkillAssetDef.SKILL_ICON,skillcfg.id));
					this['image'+num].x = 4;
					this['image'+num].y = 4;
					_nijiaui['skillitem'+num].gems_icon_0.addChild(this['image'+num] as DisplayObject);
					_nijiaui['skillitem'+num].visible = true;
					setskilltype(skillcfg.type1,num);
					num ++;
				}
			//}; //奥义技
			//for(i=0;i<ninjaSkillCfg.normals.length;i++){
				skillcfg = SkillConfig.instance.getSkill(ninjaSkillCfg.normals[2]);
				if(_nijiaui['skillitem'+num]){
					if(skillcfg.isImmediately)
					{
						_nijiaui['skillitem'+num].descriptionText.htmlText = "<b>"+skillcfg.name+I18n.lang("as_exui_1451031568_1284")+skillcfg.desc;
					}else{
						_nijiaui['skillitem'+num].descriptionText.htmlText = "<b>"+skillcfg.name+"：</b>"+skillcfg.desc;
					}
					_nijiaui['skillitem'+num].skilltype.gotoAndStop(2)
					this['image'+num].dispose();
					this['image'+num].load(SkillAssetDef.getAsset(SkillAssetDef.SKILL_ICON,skillcfg.id));
					this['image'+num].x = 4;
					this['image'+num].y = 4;
					_nijiaui['skillitem'+num].gems_icon_0.addChild(this['image'+num] as DisplayObject);
					_nijiaui['skillitem'+num].visible = true;
					setskilltype(skillcfg.type1,num);
					num ++;
				}
			//};  //普通攻击
			for(i=0;i<ninjaSkillCfg.skills.length;i++){
				skillcfg = SkillConfig.instance.getSkill(ninjaSkillCfg.skills[i]);
				if(!skillcfg.showIcon){
					continue;
				}
				if(_nijiaui['skillitem'+num]){
					if(skillcfg.isImmediately)
					{
						_nijiaui['skillitem'+num].descriptionText.htmlText = "<b>"+skillcfg.name+I18n.lang("as_exui_1451031568_1285")+skillcfg.desc;
					}else{
						_nijiaui['skillitem'+num].descriptionText.htmlText = "<b>"+skillcfg.name+"：</b>"+skillcfg.desc;
					}
					_nijiaui['skillitem'+num].skilltype.gotoAndStop(3)
					this['image'+num].dispose();
					this['image'+num].load(SkillAssetDef.getAsset(SkillAssetDef.SKILL_ICON,skillcfg.id));
					this['image'+num].x = 4;
					this['image'+num].y = 4;
					_nijiaui['skillitem'+num].gems_icon_0.addChild(this['image'+num] as DisplayObject);
					_nijiaui['skillitem'+num].visible = true;
					if(skillcfg.type==3||skillcfg.type==4){
						_nijiaui['skillitem'+num].skilltype.gotoAndStop(3);
					};	
					if(skillcfg.type==1){
						_nijiaui['skillitem'+num].skilltype.gotoAndStop(4);
					};
					setskilltype(skillcfg.type1,num);
					num ++;
				}
				updateSkillItemStage(num - 1);
			};  //普通技能

		}
		
		protected function requestNinjaListCommandFinishHandler(event:CommandEvent):void
		{
			event.currentTarget.removeEventListener(CommandEvent.FINISH,requestNinjaListCommandFinishHandler);
			event.currentTarget.removeEventListener(CommandEvent.FAILD,requestNinjaListCommandFinishHandler);
			if(this._nijiaui == null){
				return;
			}
			var cardItemData:CardItemData = itemData as CardItemData;
			
			var ninjaInfos:Vector.<NinjaInfo>;
			var requestNinjaListCommand:RequestNinjaListCommand = event.currentTarget as RequestNinjaListCommand;
			ninjaInfos = requestNinjaListCommand.ninjas[NinjaListTypeDef.ALL];
			if(ninjaInfos){
				var ninjaInfo:NinjaInfo;
				var boo:Boolean = true;
				for each(ninjaInfo in ninjaInfos){
					var ninjiaConfig:NinjaInfoCFG = NinjaInfoConfig.getNinjaCfgInfo(ninjaInfo.id);
					if(ninjiaConfig.risingStarTatter == cardItemData.id){
						this._nijiaui.cardtips.txt.text =  I18n.lang("as_exui_1451031568_1287");
						if(ninjaInfo.starLevel == NinjaInfo.MAX_STAR_LEVEL){
							this._nijiaui.cardtips.visible = true;
							this._nijiaui.cardtips.txt.text =  I18n.lang("as_exui_1451031568_1288");
						}
						boo = false;
						break;
					}
				}
			}
			if(boo){
				this._nijiaui.cardtips.txt.text =  I18n.lang("as_exui_1451031568_1289_0")+cardItemData.cardFragmentNum+I18n.lang("as_exui_1451031568_1289_1");
			}
			
		}
		
/*		protected function finishHandler(event:CommandEvent):void
		{
			event.currentTarget.removeEventListener(CommandEvent.FINISH,finishHandler);
			event.currentTarget.addEventListener(CommandEvent.FAILD,finishHandler);
			if(this._nijiaui == null){
				return;
			}
			var evt:RequestNinjaByIdCommand = event.currentTarget as RequestNinjaByIdCommand;
			if(evt.ninja != null){
				var requestNinjaListCommand:RequestNinjaListCommand = new RequestNinjaListCommand(NinjaListTypeDef.ALL,false);
				requestNinjaListCommand.addEventListener(CommandEvent.FINISH,requestNinjaListCommandFinishHandler);
				requestNinjaListCommand.addEventListener(CommandEvent.FAILD,requestNinjaListCommandFinishHandler);
				requestNinjaListCommand.call();
				//this._nijiaui.cardtips.txt.text =  "已拥有该忍者，使用碎片可进行忍者升星";
				//if(evt.ninja.starLevel == NinjaInfo.MAX_STAR_LEVEL){
					//this._nijiaui.cardtips.visible = false;
				//}
			}else{
				//this._nijiaui.cardtips.txt.text = itemData.description;

			}
		}*/
		
		private function setskilltype(arr:Array,num:int):void
		{
			for(var i:int = 0;i<arr.length;i++){
				if(arr.length == 2){
					_nijiaui['skillitem'+num].typeMc1.visible = true;
					_nijiaui['skillitem'+num].typeMc2.visible = true;
				}else{
					_nijiaui['skillitem'+num].typeMc1.visible = true;
					_nijiaui['skillitem'+num].typeMc2.visible = false;
				}
				_nijiaui['skillitem'+num]['typeMc'+(i+1)].gotoAndStop("label"+arr[i]);
			}
		}
		
		private function updateSkillItemStage(skillLen:int):void
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
		
		private function setHeight():void
		{
			var nowItemShow:uint = 0;
			for(var i:int=1;i<6;i++){
				if(_nijiaui['skillitem'+i].parent){
					nowItemShow++;					
				}
			}
			_nijiaui.bg.height = 150 + nowItemShow*55;
			_nijiaui.bg.x = 0;
			_nijiaui.bg.y = 28;
		}
		
        protected function showName(data:ItemData):void
        {
            _ui.nameText.htmlText = "<b>" + BagUtils.getColoredItemName(data.id) + "</b>";
            _ui.nameText.x = SPACE_X;
            _ui.nameText.y = SPACE_Y;

            _lineY = _ui.nameText.y + _ui.nameText.height + NAME_SPACE_Y;
        }

        protected function showDescription(data:ItemData):void
        {
            var description:String = data != null && data.description != null ? data.description : TooltipConst.UNKNOWN;

            _ui.descriptionText.htmlText = description;
            _ui.descriptionText.x = SPACE_X;
            _ui.descriptionText.y = _lineY +10;
            _lineY = _ui.descriptionText.y + _ui.descriptionText.height + DESCRIPTION_SPACE_Y;
        }


		override protected function resize():void
		{
            var maxWidth:int = _ui.nameText.textWidth;
            maxWidth = maxWidth > _ui.descriptionText.textWidth ? maxWidth : _ui.descriptionText.textWidth;

            _ui.bg.width = maxWidth + SPACE_X * 2;
           // _ui.bg.height = _ui.itemToGet.y + _ui.itemToGet.height + SPACE_Y;
			
			this._ui.texture_left.x = leftSpace;
			this._ui.texture_left.y = topSpage;
			this._ui.texture_right.x = this._ui.bg.width - this._ui.texture_right.width - rightSpace;
			this._ui.texture_right.y = this._ui.bg.height - this._ui.texture_right.height - downSpage;
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
		
		protected function _resize():void
		{
			this._nijiaui.texture_right.x = this._nijiaui.bg.width - this._nijiaui.texture_right.width - 10;
			this._nijiaui.texture_right.y = this._nijiaui.bg.height - this._nijiaui.texture_right.height + 18;
			this._nijiaui.cardtips.y =  this._nijiaui.bg.height - this._nijiaui.cardtips.height + 15;
		}
		
   	}
}