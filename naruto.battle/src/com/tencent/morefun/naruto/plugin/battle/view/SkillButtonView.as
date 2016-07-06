package com.tencent.morefun.naruto.plugin.battle.view
{

	import com.tencent.morefun.naruto.plugin.battle.data.BattleData;
	import com.tencent.morefun.naruto.plugin.exui.base.Image;
	import com.tencent.morefun.naruto.util.GameTip;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import def.NinjaAssetDef;
	
	import skill.SkillAssetDef;
	
	import ui.battle.SkillItemViewUI;

    import com.tencent.morefun.naruto.i18n.I18n;
	public class SkillButtonView extends Sprite
	{
		private var viewUI:SkillItemViewUI;
		private var inited:Boolean = false;
		
		private var _died:Boolean;
		private var _lackMp:Boolean;
		private var _controlled:Boolean;
		private var _lock:Boolean;
		private var _syncLock:Boolean;
		private var _mp:int;
		private var _cd:int;
		public var skillCoolDown:int;
//		public var openType:int;

		private var _ninjaId:int;
		private var _ninjaPos:int = -1;
		private var _skillId:int;
		private var _index:int;
		private var _isContractPet:Boolean;
		private var _petLock:Boolean;
		private var clickFun:Function;
		
		private var head:Image;
		private var skillIcon:Image;
		private var stopAlert:Boolean;
		
		public function SkillButtonView(k:String,clickFun:Function, ui:SkillItemViewUI)
		{
			super();
			this.clickFun = clickFun;
			
			viewUI = ui;
			viewUI.gotoAndStop(1);
			
			viewUI.state.stop();
			viewUI.state.visible = false;
			
			viewUI.cd.stop();
			viewUI.cd.visible = false;
			
			var childIndex:int;
			var uiParent:DisplayObjectContainer;
			
			uiParent = viewUI.parent;
			childIndex = viewUI.parent.getChildIndex(viewUI);
			uiParent.removeChild(viewUI);
			uiParent.addChildAt(this, childIndex);
			
			this.x = viewUI.x;
			this.y = viewUI.y;
			viewUI.x = viewUI.y = 0;
			
			// init skill hotkey
			viewUI.hotkey.gotoAndStop(k);
			addChild(viewUI);
			
			mp = 0;
			inited = true;
			mouseChildren = false;
			
			head = new Image();
			(viewUI.head["container"] as DisplayObjectContainer).addChild(head);
			
			skillIcon = new Image();
			(viewUI.skillIcon["container"] as DisplayObjectContainer).addChild(skillIcon);
			
			viewUI["effect"].gotoAndStop("empty");
			
			
			addEventListener(MouseEvent.CLICK, onCLick);
		}
		
		private function onCLick(e:MouseEvent):void 
		{
			if(stopAlert)
			{
				stopAlert = false;
				return ;
			}
			
			if (disabled) {
				if (_cd > 0)
				{
					GameTip.show(I18n.lang("as_battle_1451031565_392"));
					return;
				}
				
				if(_controlled)
				{
					GameTip.show(I18n.lang("as_battle_1451031565_393"));
					return;
				}
				if(_died)
				{
					GameTip.show(I18n.lang("as_battle_1451031565_394"));
					return;
				}
				if(_lackMp)
				{
					GameTip.show(I18n.lang("as_battle_1451031565_395"));
					return;
				}
			}
		}
		
		private function addEvents():void
		{
			addEventListener(MouseEvent.MOUSE_OVER,onMouseEvent);
			addEventListener(MouseEvent.MOUSE_DOWN,onMouseEvent);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
			
			
			viewUI["effect"].addEventListener(Event.COMPLETE, onEffectComplete);
		}
		
		private function removeEvents():void
		{
			removeEventListener(MouseEvent.MOUSE_OVER,onMouseEvent);
			removeEventListener(MouseEvent.MOUSE_DOWN,onMouseEvent);
			removeEventListener(MouseEvent.MOUSE_OUT,onMouseEvent);
			viewUI["effect"].removeEventListener(Event.COMPLETE, onEffectComplete);
			if(stage)
			{
				stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseEvent);
			}
		}
		
		public function showCDEffect():void
		{
			viewUI["effect"].gotoAndStop("cdEffect");
		}
		
		private function onEffectComplete(evt:Event):void
		{
			viewUI["effect"].gotoAndStop("empty");
		}
		
		protected function onMouseEvent(event:MouseEvent):void
		{
			switch(event.type)
			{
				case MouseEvent.MOUSE_OVER:
					if(event.buttonDown)return;
					viewUI.gotoAndStop("mouseover");
					break;
				case MouseEvent.MOUSE_DOWN:
					viewUI.gotoAndStop("mousedown");
					stage.addEventListener(MouseEvent.MOUSE_UP,onMouseEvent);
					break;
				case MouseEvent.MOUSE_UP:
					stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseEvent);
					if(event.target == this)
					{
						stopAlert = BattleData.singleton.guidState == BattleData.GUID_SKILL_REQUEST;
						
						viewUI.gotoAndStop("mouseover");
						clickFun(this);
					}else
					{
						viewUI.gotoAndStop("normal");
					}
					break;
				case MouseEvent.MOUSE_OUT:
					if(event.buttonDown)return;
					viewUI.gotoAndStop("normal");
					break;
			}
			
			updateState();
		}
		
		public function clear():void
		{
			mp = 0;
			
			_index = 0;
			_ninjaId = 0;
			_ninjaPos = -1;
			_skillId = 0;
			_cd = 0;
			_lock = false;
			_died = false;
			_lackMp = false;
			_controlled = false;
			_isContractPet = false;
			
			var label:TextField = viewUI.mp["label"];
			label.textColor = 0xFFFFFF;
			
			viewUI.gotoAndStop("disable");
			
//			openType = 0;
			
			//viewUI.stateTxt.text = "";
			//viewUI.cdTxt.text = "";
			viewUI.state.visible = false;
			viewUI.cd.visible = false;
			viewUI.enableEffectMC.visible = false;
			
			head.dispose();
			skillIcon.dispose();
		}
		
		public function updateBase(ninjaId:int,ninjaPos:int,skillId:int, index:int):void
		{
			_index = index;
			_ninjaId = ninjaId;
			_ninjaPos = ninjaPos;
			_skillId = skillId;
			
			if(ninjaId == -1 || ninjaPos == -1 || skillId == -1)
			{
				return;
			}
			
			head.load(NinjaAssetDef.getAsset(NinjaAssetDef.HEAD_SMALL,ninjaId));
			skillIcon.load(SkillAssetDef.getAsset(SkillAssetDef.SKILL_ICON,skillId));
		}
		
		public function updateNinjaPos(ninjaPos:int):void
		{
			_ninjaPos = ninjaPos;
		}
		
		public function updateNinjaId(ninjaId:int):void
		{
			_ninjaId = ninjaId;
			
			head.load(NinjaAssetDef.getAsset(NinjaAssetDef.HEAD_SMALL,ninjaId));
		}
		
		public function updateState():void
		{
			//viewUI.normalMp.visible = !_lackMp;
			//viewUI.lackMp.visible = _lackMp;
			//viewUI.stateTxt.text = "";
			//viewUI.cdTxt.text = "";
			viewUI.state.visible = false;
			viewUI.cd.visible = false;
			viewUI.enableEffectMC.visible = !disabled;
			
			if(disabled)
			{
				buttonMode = false;
				if (_cd > 0)
				{
					//viewUI.cdTxt.text = _cd.toString();
					viewUI.cd.gotoAndStop(_cd);
					viewUI.cd.visible = true;
				}
				
				if(_controlled)
				{
					//viewUI.stateTxt.text = "控";
					viewUI.state.gotoAndStop(I18n.lang("as_battle_1451031565_396"));
					viewUI.state.visible = true;
				}
				if(_died)
				{
					//viewUI.stateTxt.text = "死";
					viewUI.state.gotoAndStop(I18n.lang("as_battle_1451031565_397"));
					viewUI.state.visible = true;
				}
				
				viewUI.gotoAndStop("disable");
				
				removeEvents();
			}else
			{
				buttonMode = true;
				if(viewUI.currentLabel == "disable")
				{
					viewUI.gotoAndStop("normal");
				}
				
				addEvents();
			}
			
			this.mp = _mp;
		}
		
		public function get disabled():Boolean
		{
			return _cd>0 || _lock || _lackMp || _died || _controlled || !inited || _syncLock || _petLock || _skillId == 0;
		}
		
		public function hideCd():void
		{
			viewUI.cdTxt.visible = false;
		}
		
		public function showCd():void
		{
			viewUI.cdTxt.visible = true;
		}
		
		public function set petLock(value:Boolean):void
		{
			_petLock = value;
		}
		
		public function set syncLock(value:Boolean):void
		{
			_syncLock = value;
		}
		
		public function get syncLock():Boolean
		{
			return _syncLock;
		}

		public function set cd(value:int):void
		{
			_cd = value;
		}
		
		public function get cd():int
		{
			return _cd;
		}

		public function set lock(value:Boolean):void
		{
			_lock = value;
			updateState();
		}
		
		public function get lock():Boolean
		{
			return _lock;
		}

		public function set lackMp(value:Boolean):void
		{
			_lackMp = value;
			this.mp = _mp; // update  textColor
		}
		
		public function get controlled():Boolean
		{
			return _controlled;
		}
		
		public function set controlled(value:Boolean):void
		{
			_controlled = value;
		}

		public function set died(value:Boolean):void
		{
			_died = value;
		}
		
		public function get died():Boolean
		{
			return _died;
		}
		
		public function get guidPos():MovieClip
		{
			return viewUI["guidPos"];
		}

		public function get ninjaId():int
		{
			return _ninjaId;
		}
		
		public function get ninjaPos():int
		{
			return _ninjaPos;
		}

		public function set skillId(value:int):void
		{
			_skillId = value;
			skillIcon.load(SkillAssetDef.getAsset(SkillAssetDef.SKILL_ICON,skillId));
		}
		
		public function get skillId():int
		{
			return _skillId;
		}
		
		public function get index():int
		{
			return _index;
		}
		
		public function set isContractPet(value:Boolean):void
		{
			_isContractPet = value;
		}
		
		public function get isContractPet():Boolean
		{
			return _isContractPet;
		}

		public function get mp():int
		{
			return _mp;
		}

		public function set mp(value:int):void
		{
			_mp = value;
			
			//viewUI.normalMp["mpTxt"].text = _mp;
			//viewUI.lackMp["mpTxt"].text = _mp;
			
			var label:TextField = viewUI.mp["label"];
			
			label.text = _mp.toString();
			label.textColor = _lackMp? 0xB61A1A : 0xFFFFFF;
		}
		
		
		public function destroy():void
		{
			removeEvents();
			if(skillIcon)
			{
				skillIcon.dispose();
				if(skillIcon.parent){skillIcon.parent.removeChild(skillIcon);}
				skillIcon = null;
			}
			if(head)
			{
				head.dispose();
				if(head.parent){head.parent.removeChild(head)};
				head = null;
			}
			
			clickFun = null;
			if(viewUI)
			{
				if(viewUI.parent)
				{
					viewUI.parent.removeChild(viewUI);
				}
				viewUI = null;
			}
			removeEventListener(MouseEvent.CLICK, onCLick);
		}

																
		public function autoSetNull():void
		{

			viewUI = null;
			clickFun = null;
			head = null;
			skillIcon = null;
		}
	}
}