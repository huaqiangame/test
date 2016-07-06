package com.tencent.morefun.naruto.plugin.battle.view
{

	import com.tencent.morefun.naruto.plugin.exui.base.Image;
	import com.tencent.morefun.naruto.plugin.ui.base.BitmapText;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import cfgData.dataStruct.SkillCFG;
	import def.NinjaAssetDef;
	import ui.battle.HitNumber2;
	import ui.battle.SkillPromptViewUI;

	public class MultiBaseSkillPromptView extends Sprite
	{
		private var ninjaId:int;
		private var skillCfg:SkillCFG;
		private var lastSkillCfg:SkillCFG;
		private var res:SkillPromptViewUI;
		
		private var head:Image;
		
		private var mirror:Boolean;
		
		private var _originalWidth:int;
		private var _originalHeight:int;
		
		private var _comboIndex:int;
		
		private var _stateBitmapText:BitmapText;
		private var _comboIndexBitmapText:BitmapText;
		
		private var _isHiding:Boolean;
		
		private var _inited:Boolean;
		
		public function MultiBaseSkillPromptView(ninjaId:int, comboIndex:int, lastSkillCfg:SkillCFG, skillCfg:SkillCFG, mirror:Boolean)
		{
			super();
			
			this.mirror = mirror;
			this.ninjaId = ninjaId;
			this.skillCfg = skillCfg;
			
			this._comboIndex = comboIndex;
			
			initUI();
		}
		
		private function initUI():void
		{
			var stateNum:int;
			var textFormat:TextFormat;
			
			res = new SkillPromptViewUI();
			
			_originalWidth = originalRectangle.width;
			_originalHeight = originalRectangle.height;
			
			if(mirror)
			{
				combo.scaleX = -1;
				state.scaleX = -1;
				skillTextContent.scaleX = -1;
			}
			
			replaceTextField(skillText);
			skillText.text = skillCfg.name;
			skillText.x = -skillText.width / 2;
			
			head = new Image();
			headContainer.addChild(head);
			head.load(NinjaAssetDef.getAsset(NinjaAssetDef.HEAD_WIDE,ninjaId));
			if(mirror)
			{
				head.scaleX = -1;
				head.x = 68;
			}
			
			if(skillCfg.beHitState1 != 0)
			{
				stateContainer.visible = true;
				switch(skillCfg.beHitState1)
				{
					case 1:
						stateLabel.gotoAndStop(1);
						break;
					case 2:
						stateLabel.gotoAndStop(2);
						break;
					case 3:
						stateLabel.gotoAndStop(3);
						break;
					case 4:
						stateLabel.gotoAndStop(4);
						stateNum = skillCfg.beHitState1Param;
						break;
					case 5:
						break;
					case 6:
						break;
					case 7:
						stateLabel.gotoAndStop(7);
						break;
					case 8:
						stateLabel.gotoAndStop(8);
						break;
					case 9:
						break;
					case 10:
						if(skillCfg.beHitState1Param == 3)
						{
							stateLabel.gotoAndStop(9);
						}
						
						if(skillCfg.beHitState1Param == 4)
						{
							stateLabel.gotoAndStop(8);
						}
						break;
					case 11:
						break;
					case 12:
						break;
					case 13:
						break;
					case 14:
						break;
					case 15:
						break;
					break;
				}
			}
			else
			{
				stateContainer.visible = false;
			}
			
			updateComboContainer(_comboIndex);
			updateStateContainer(stateNum);
			
			addChild(res);
			
			res.addEventListener(Event.INIT, onEffectInited);
			res.addEventListener(Event.COMPLETE, onEffectComplete);
		}
		
		private function onEffectInited(evt:Event):void
		{
			_inited = true;
			if(_isHiding)
			{
				hide();
			}
		}
		
		private function onEffectComplete(evt:Event):void
		{
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function replaceTextField(source:TextField):void
		{
			var textFormat:TextFormat;
			var textField:TextField;
			var parent:DisplayObjectContainer;
			
			textField = new TextField();
			textField.defaultTextFormat = source.defaultTextFormat;
			textField.name = source.name;
			textField.x = source.x;
			textField.y = source.y;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.defaultTextFormat.align = TextFormatAlign.CENTER;
			textField.filters = source.filters;
			textFormat = skillText.defaultTextFormat;
			textFormat.bold = true;
			textField.defaultTextFormat = textFormat;
			parent = source.parent;
			parent.removeChild(source);
			parent.addChild(textField);
			parent[textField.name] = textField;
		}
		
		private function updateStateContainer(num:int):void
		{
			if(num != 0)
			{
				_stateBitmapText = new BitmapText(new HitNumber2(),56,82,0,false,"1234567890A");//TODO:bitmap
				_stateBitmapText.scaleX = _stateBitmapText.scaleY = 0.3;
				_stateBitmapText.text = num.toString();
				stateNum.addChild(_stateBitmapText);
				
				stateLabel.x = - ((stateLabel.width + _stateBitmapText.width) / 2);
				stateNum.x = stateLabel.x + stateLabel.width;
			}
			else
			{
				stateLabel.x = -(stateLabel.width / 2);
			}
			
			state.x = state.width / 2;
			stateContainer.x = skillTextContent.x - skillTextContent.width / 2 + 10;
		}
		
		private function updateComboContainer(index:int):void
		{
			if(index == 0)
			{
				comboContainer.visible = false;
			}
			else
			{
				_comboIndexBitmapText = new BitmapText(new HitNumber2(),56,82,0,false,"1234567890A");
				_comboIndexBitmapText.scaleX = _comboIndexBitmapText.scaleY = 0.5;
				_comboIndexBitmapText.text = (index + 1).toString();
				comboNum.addChild(_comboIndexBitmapText);
				
				comboNum.x = - (_comboIndexBitmapText.width + comboLabel.width) / 2;
				comboLabel.x = comboNum.x + comboNum.width;
				combo.x = combo.width / 2;
			}
		}
		
		public function get isHiding():Boolean
		{
			return _isHiding;
		}
		
		public function hide():void
		{
			_isHiding = true;
			if(_inited)
			{
				res.play();
			}
		}
		
		public function destroy():void
		{
			res.removeEventListener(Event.INIT, onEffectInited);
			res.removeEventListener(Event.COMPLETE, onEffectComplete);
			
			if(head.parent)
			{
				head.parent.removeChild(head);
			}
			head.dispose();
			head = null;
			
			if(_stateBitmapText)
			{
				_stateBitmapText.destroy();
			}
			if(_comboIndexBitmapText)
			{
				_comboIndexBitmapText.destroy();
			}
			
			removeChildren();
		}
		
		public function get originalWidth():int
		{
			return _originalWidth;
		}
		
		public function get originalHeight():int
		{
			return _originalHeight;
		}
		
		private function get originalRectangle():MovieClip
		{
			return res["originalRectangle"];
		}
		
		private function get headContainer():MovieClip
		{
			return res["userSkillInfoContent"]["headContainer"];
		}
		
		private function get skillTextContent():MovieClip
		{
			return res["userSkillInfoContent"]["skillTextContent"];
		}
		
		private function get skillText():TextField
		{
			return res["userSkillInfoContent"]["skillTextContent"]["skillText"];
		}
		
		private function get state():MovieClip
		{
			return res["userSkillInfoContent"]["stateContainer"]["state"];
		}
		
		private function get stateContainer():MovieClip
		{
			return res["userSkillInfoContent"]["stateContainer"];
		}
		
		private function get stateLabel():MovieClip
		{
			return res["userSkillInfoContent"]["stateContainer"]["state"]["label"];
		}
		
		private function get stateNum():MovieClip
		{
			return res["userSkillInfoContent"]["stateContainer"]["state"]["num"];
		}
		
		private function get combo():MovieClip
		{
			return res["userSkillInfoContent"]["comboContainer"]["combo"];
		}
		
		private function get comboContainer():MovieClip
		{
			return res["userSkillInfoContent"]["comboContainer"];
		}
		
		private function get comboNum():MovieClip
		{
			return res["userSkillInfoContent"]["comboContainer"]["combo"]["num"];
		}
		
		private function get comboLabel():MovieClip
		{
			return res["userSkillInfoContent"]["comboContainer"]["combo"]["label"];
		}
																
		public function autoSetNull():void
		{

			skillCfg = null;
			lastSkillCfg = null;
			res = null;
			head = null;
			_stateBitmapText = null;
			_comboIndexBitmapText = null;
		}
	}
}