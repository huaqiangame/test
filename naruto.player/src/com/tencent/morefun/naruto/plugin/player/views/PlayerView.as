package com.tencent.morefun.naruto.plugin.player.views
{
	import com.greensock.TweenLite;
	import com.tencent.morefun.framework.base.CommandEvent;
	import com.tencent.morefun.framework.loader.FileManager;
	import com.tencent.morefun.naruto.effect.shadow.MotionShadow;
	import com.tencent.morefun.naruto.mmefile.render.MmeAsset;
	import com.tencent.morefun.naruto.mmefile.render.MmeAssetRender;
	import com.tencent.morefun.naruto.mmefile.render.MmeAssetRenderEvent;
	import com.tencent.morefun.naruto.plugin.player.players.BasePlayer;
	import com.tencent.morefun.naruto.plugin.player.players.BaseWalkablePlayer;
	import com.tencent.morefun.naruto.plugin.role.HPMPAnimation;
	import com.tencent.morefun.naruto.plugin.ui.base.BackGround;
	import com.tencent.morefun.naruto.plugin.ui.base.def.BackGroundDef;
	import com.tencent.morefun.naruto.plugin.ui.base.def.BackgroundGroupDef;
	import com.tencent.morefun.naruto.plugin.ui.core.CoreBubbleNumBitmapText;
	import com.tencent.morefun.naruto.plugin.ui.util.DisplayUtils;
	import com.tencent.morefun.naruto.plugin.ui.util.SmileyUtils;
	import com.tencent.morefun.naruto.plugin.ui.util.TimerProvider;
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.text.TextFormat;
	
	import base.ApplicationData;
	
	import fl.motion.Animator;
	
	import map.events.MapElementEvent;
	
	import npc.defs.NpcAssetDef;
	
	import player.commands.SelfMoveToPlayerCommand;
	import player.datas.PlayerData;
	import player.events.PlayerDataEvent;
	
	import sound.commands.PlayUISoundCommand;
	import sound.def.UISoundDef;
	
	import ui.command.SetSelectedPlayerCommand;
	import ui.role.CaptainIcon;
	import ui.role.FightingIcon;
	import ui.role.PlayerDialogView;
	
	import utils.PlayerNameUtil;
	
	import world.SceneConfig;
	import world.data.SceneType;
	
	public class PlayerView extends BaseWalkablePlayer
	{
		private static const ADD_STRENGTH_EFFECT_URL:String             =   "flash/player/effect_add_strength.swf";
		private static const ADD_HP_EFFECT_URL:String                   =   "flash/player/effect_addhp.swf";
		private static const ADD_MP_EFFECT_URL:String                   =   "flash/player/effect_addmp.swf";
		private static const LEVEL_UP_EFFECT_URL:String                 =   "flash/player/effect_levelup.swf";
		
		protected var smileyAni:MovieClip;
		protected var _bubbleText:CoreBubbleNumBitmapText;
		protected var ghost:MotionShadow;
		protected var _addHpEffetRenderer:MmeAssetRender;
		protected var _addMpEffetRenderer:MmeAssetRender;
		protected var _levelUpEffetRenderer:MmeAssetRender;
		protected var _addStrengthEffetRenderer:MmeAssetRender;
		protected var _pkEffectRenderer:MmeAssetRender;
		protected var _campGlowRender:MmeAssetRender;
		protected var _allowRender:MmeAssetRender;
		protected var fightingIcon:FightingIcon;
		protected var dialogView:PlayerDialogView;
		
		private static const resRenderer_xml:XML = <Motion duration="8" xmlns="fl.motion.*" xmlns:geom="flash.geom.*" xmlns:filters="flash.filters.*">
			<source>
				<Source frameRate="24" x="-0.05" y="-75" scaleX="1" scaleY="1" rotation="0" elementType="movie clip" instanceName="roleContainer" symbolName="container/roleContainer">
					<dimensions>
						<geom:Rectangle left="0" top="0" width="0" height="0"/>
					</dimensions>
					<transformationPoint>
						<geom:Point x="NaN" y="-Infinity"/>
					</transformationPoint>
				</Source>
			</source>
		
			<Keyframe index="0" tweenSnap="true">
				<tweens>
					<SimpleEase ease="0"/>
				</tweens>
			</Keyframe>
		
			<Keyframe index="1" tweenSnap="true" x="-4.95">
				<color>
					<Color redMultiplier="1" greenMultiplier="1" blueMultiplier="1" alphaMultiplier="1" redOffset="200" greenOffset="0" blueOffset="0" alphaOffset="0"/>
				</color>
				<tweens>
					<SimpleEase ease="0"/>
				</tweens>
			</Keyframe>
		
			<Keyframe index="2" tweenSnap="true" x="5.05">
				<color>
					<Color redMultiplier="1" greenMultiplier="1" blueMultiplier="1" alphaMultiplier="1" redOffset="255" greenOffset="255" blueOffset="255" alphaOffset="0"/>
				</color>
				<tweens>
					<SimpleEase ease="0"/>
				</tweens>
			</Keyframe>
		
			<Keyframe index="3" tweenSnap="true" x="-4.95">
				<color>
					<Color redMultiplier="1" greenMultiplier="1" blueMultiplier="1" alphaMultiplier="1" redOffset="200" greenOffset="180" blueOffset="0" alphaOffset="0"/>
				</color>
				<tweens>
					<SimpleEase ease="0"/>
				</tweens>
			</Keyframe>
		
			<Keyframe index="5" tweenSnap="true" x="3.05">
				<color>
					<Color redMultiplier="1" greenMultiplier="1" blueMultiplier="1" alphaMultiplier="1" redOffset="200" greenOffset="0" blueOffset="0" alphaOffset="0"/>
				</color>
				<tweens>
					<SimpleEase ease="0"/>
				</tweens>
			</Keyframe>
		
			<Keyframe index="7" tweenSnap="true" x="0.05">
				<color>
					<Color/>
				</color>
				<tweens>
					<SimpleEase ease="0"/>
				</tweens>
			</Keyframe>
		</Motion>;
		private var resRenderer_animator:Animator;
		
		public function PlayerView(mmeAsset:MmeAsset)
		{
			super(mmeAsset);
			addEventListener(MapElementEvent.MOUSE_DOWN_ELEMENT,onMouseDown);
			
			BackGround.createGroup(BackgroundGroupDef.PLAYER);
		}
		
		override protected function initUI():void
		{
			super.initUI();
			
			if(data == null){return ;}
			updateDead();
			updateCamp();
			updateCaptainIcon();
			updateFightingIcon();
			
		}
		
		override public function setData(data:PlayerData):void
		{
			super.setData(data);
			
			updateDead();
			updateCamp();
			updateCaptainIcon();
			updateFightingIcon();
		}
		
		override protected function onPropertyUpdate(event:PlayerDataEvent):void
		{
			super.onPropertyUpdate(event);
			switch(event.property)
			{
				case PlayerData.PROPERTY_IS_FIGHTING:
					updateFightingIcon();
					break;
				case PlayerData.PROPERTY_IS_CAPTAIN:
					updateCaptainIcon();
					break;
				case PlayerData.PROPERTY_DEAD:
					updateDead();
					break;
				case PlayerData.PROPERTY_CAMP:
					updateCamp();
					break;
			}
		}
		
		protected function updateCaptainIcon():void
		{
			if(data.isCaptain)
			{
				showCaptainIcon();
			}else
			{
				hideCaptainIcon();
			}
		}
		
		protected function showCaptainIcon():void
		{
			if(captainIcon == null)
			{
				captainIcon = new CaptainIcon();
//				calcCaptainIconPos();
			}
			if(!contains(captainIcon))
			{
				headPosUpdated();
				addChild(captainIcon);
			}
		}
		
		protected function hideCaptainIcon():void
		{
			if(captainIcon)
			{
				if(captainIcon.parent)
				{
					captainIcon.parent.removeChild(captainIcon);
				}
			}
		}
		
		protected function calcCaptainIconPos():void
		{
//			if(captainIcon && headPos)
//			{
//				captainIcon.y = headPos.y - 20;
//			}
		}
		
		protected function updateFightingIcon():void
		{
			if(data.isFighting)
			{
				showFightingAnimation();
			}else
			{
				hideFightingAnimation();
			}
			if(data.isFighting)
			{
				showFightingIcon();
			}else
			{
				hideFightingIcon();
			}
		}
		
		protected function updateDead():void
		{
			if(data.isDead)
			{
				this.filters = [DisplayUtils.disableCM];
			}
			else
			{
				this.filters = [];
			}
		}
		
		protected function updateCamp():void
		{
			if(data.camp != -1)
			{
				campGlowRender.gotoAction("camp_glow", data.camp, true);
				addChildAt(campGlowRender, 0);
				
				if(data.camp != ApplicationData.singleton.selfInfo.camp)
				{
					if(nameTxt)
					{
						var defaultTextFormat:TextFormat = nameTxt.defaultTextFormat;
						defaultTextFormat.color = 0xeb3a37;
						nameTxt.defaultTextFormat = defaultTextFormat;
						this.nameTxt.text = PlayerNameUtil.standardlizeName(data.svrId, data.name);
					}
				}
				else
				{
					if(nameTxt)
					{
						nameTxt.defaultTextFormat = BasePlayer.NAME_TEXT_FORMAT;
						this.nameTxt.text = PlayerNameUtil.standardlizeName(data.svrId, data.name);		
					}
				}
			}
			else
			{
				if(contains(campGlowRender))
				{
					if(nameTxt)
					{
						nameTxt.defaultTextFormat = BasePlayer.NAME_TEXT_FORMAT;
						this.nameTxt.text = PlayerNameUtil.standardlizeName(data.svrId, data.name);
					}
					removeChild(campGlowRender);
				}
			}
		}
		
		protected function showFightingIcon():void
		{
			if(fightingIcon == null)
			{
				fightingIcon = new FightingIcon();
				calcFightingIconPos();
			}
			if(!contains(fightingIcon))
			{
				addChild(fightingIcon);
			}
		}	
		
		protected function hideFightingIcon():void
		{
			if(fightingIcon)
			{
				if(fightingIcon.parent)
				{
					fightingIcon.parent.removeChild(fightingIcon);
				}
			}
		}
		
		public function showFightingAnimation():void
		{
			var sceneId:int = ApplicationData.singleton.globelInfo.sceneToId || ApplicationData.singleton.globelInfo.sceneId;
			if(SceneConfig.getSceneInfo(sceneId) && SceneConfig.getSceneInfo(sceneId).type == SceneType.PVP_BATTLE_FIELD)
			{
				pkEffectRenderer.play("effect_pk", 0, true);
				addChild(_pkEffectRenderer);
				if(resRenderer){resRenderer.visible = false;}
			}
		}
		
		public function hideFightingAnimation():void
		{
			if(_pkEffectRenderer)
			{
				pkEffectRenderer.stop();
				if(this.contains(_pkEffectRenderer)){this.removeChild(_pkEffectRenderer);}
				if(resRenderer){resRenderer.visible = true;}
			}
		}
		
		protected function calcFightingIconPos():void
		{
			if(fightingIcon && headPos)
			{
				fightingIcon.y = headPos.y - 20;
			}
		}
		
		private var moveToPlayerCommand:SelfMoveToPlayerCommand;
		protected function onMouseDown(event:MapElementEvent):void
		{
			if (data == null || data.uin == 0 || ApplicationData.singleton.selfInfo.equeal(data.uin,data.role,data.svrId))
				return;
			
			if(SceneConfig.getSceneInfo(ApplicationData.singleton.globelInfo.sceneId).type == SceneType.PVP_BATTLE_FIELD)//ս����ʾ����
			{
				if(moveToPlayerCommand)
				{
					moveToPlayerCommand.removeEventListener(CommandEvent.FINISH, onMoveToPlayerFinish);
					moveToPlayerCommand.removeEventListener(CommandEvent.FAILD, onMoveToPlayerFinish);
				}
				
				moveToPlayerCommand = new SelfMoveToPlayerCommand(data.uin, data.role, data.svrId);
				moveToPlayerCommand.addEventListener(CommandEvent.FINISH, onMoveToPlayerFinish);
				moveToPlayerCommand.addEventListener(CommandEvent.FAILD, onMoveToPlayerFinish);
				moveToPlayerCommand.call();
			}
			else
			{
				new SetSelectedPlayerCommand(data).call();
			}
		}
		
		private function onMoveToPlayerFinish(evt:CommandEvent):void
		{
			moveToPlayerCommand.removeEventListener(CommandEvent.FINISH, onMoveToPlayerFinish);
			moveToPlayerCommand.removeEventListener(CommandEvent.FAILD, onMoveToPlayerFinish);
		}
		
		override protected function calcHeadPos():void
		{
			super.calcHeadPos();
			
			calcSmileyPos();
			calcFightingIconPos();
			calcCaptainIconPos();
		}
		
		protected function get bubbleText():CoreBubbleNumBitmapText
		{
			if(_bubbleText == null)
			{
				_bubbleText = new CoreBubbleNumBitmapText();
				_bubbleText.mouseChildren = false;
				_bubbleText.mouseEnabled = false;
				_bubbleText.y = - 110;
			}
			return _bubbleText;
		}
		
		public function get campGlowRender():MmeAssetRender
		{
			if(_campGlowRender == null)
			{
				_campGlowRender = new MmeAssetRender(mmeAsset);
				_campGlowRender.addEventListener(MmeAssetRenderEvent.PLAY_END,onEffectRendererPlayEnd);
				_campGlowRender.loadUrl(FileManager.getQualifiedUrl("flash/player/camp_glow.swf"));
			}
			
			return _campGlowRender;
		}
		
		public function get pkEffectRenderer():MmeAssetRender
		{
			if(_pkEffectRenderer == null)
			{
				_pkEffectRenderer = new MmeAssetRender(mmeAsset);
				_pkEffectRenderer.loadUrlAndAutoPlay(FileManager.getQualifiedUrl("flash/player/effect_pk.swf"));
			}
			
			return _pkEffectRenderer;
		}
		
		public function get addHpEffetRenderer():MmeAssetRender
		{
			if(_addHpEffetRenderer == null)
			{
				_addHpEffetRenderer = new MmeAssetRender(mmeAsset);
				_addHpEffetRenderer.addEventListener(MmeAssetRenderEvent.PLAY_END,onEffectRendererPlayEnd);
				
				var url:String = FileManager.getQualifiedUrl(ADD_HP_EFFECT_URL);
				_addHpEffetRenderer.loadUrl(url);
			}
			return _addHpEffetRenderer;
		}
		
		public function get addMpEffetRenderer():MmeAssetRender
		{
			if(_addMpEffetRenderer == null)
			{
				_addMpEffetRenderer = new MmeAssetRender(mmeAsset);
				_addMpEffetRenderer.addEventListener(MmeAssetRenderEvent.PLAY_END,onEffectRendererPlayEnd);
				
				var url:String = FileManager.getQualifiedUrl(ADD_MP_EFFECT_URL);
				_addMpEffetRenderer.loadUrl(url);
			}
			return _addMpEffetRenderer;
		}
		
		private var allowTargetPos:Point = new Point();
		public function setAllowTargetPos(x:int, y:int):void
		{
			allowTargetPos.setTo(x, y);
			if(x!=0 || y!=0)
			{
				if(_allowRender == null)
				{
					_allowRender = new MmeAssetRender(mmeAsset);
					_allowRender.loadUrl(NpcAssetDef.getAsset(91000418,NpcAssetDef.OUTDOOR));
				}
				addChildAt(_allowRender,0);
				TimerProvider.addTimeTask(500,updateAllowDirection);
			}else
			{
				if(_allowRender)
				{
					if(_allowRender.isReady)
					{
						_allowRender.stop();
					}
					if(_allowRender.parent)
					{
						_allowRender.parent.removeChild(_allowRender);
					}
				}
				TimerProvider.removeTimeTask(500,updateAllowDirection);
			}
		}
		
		private function updateAllowDirection():void
		{
			if(_allowRender == null || _allowRender.isReady == false)
			{
				return;
			}
			if(allowTargetPos.x==0 && allowTargetPos.y==0)
			{
				return;
			}
			var angle:Number = Math.atan2(allowTargetPos.y - y, allowTargetPos.x - x);
			var a360:int = angle * 180 / Math.PI;
			a360 = (a360 + 270 + 22)%360;
			var dir:int = a360 / 45;
			_allowRender.play("idle_" + dir, _allowRender.getCurrFrame(), true);
		}
		
		public function showHpChanged(value:int):void
		{
			if(!isInViewPoint)
			{
				return;
			}
			var bubbleAnimationEffect:HPMPAnimation = new HPMPAnimation();
			if(value >= 0)
			{
				//				containerUI["addHpContianer"].addChild(addHpEffetRenderer);
				addChild(addHpEffetRenderer);
				addHpEffetRenderer.play("effect_scene_addhp");
				if(value != 0){
					addChild(bubbleText);
					bubbleText.bubbleNum(value, CoreBubbleNumBitmapText.GREEN, bubbleAnimationEffect)
				};
			}
			else
			{
				resRenderer.x = 0;
				if(resRenderer_animator == null)
				{
					resRenderer_animator = new Animator(resRenderer_xml);
				}
				resRenderer_animator.target = resRenderer;
				resRenderer_animator.play();
				addChild(bubbleText);
				//				containerUI["roleAnimationContainer"].gotoAndPlay("hurt");
				
				BackGround.addBackground(BackgroundGroupDef.PLAYER, BackGroundDef.DANGER_ANIMATION);
				bubbleText.bubbleNum(value, CoreBubbleNumBitmapText.RAD, bubbleAnimationEffect);
			}
		}
		
		public function showMpChanged(value:int):void
		{
			if(!isInViewPoint)
			{
				return;
			}
			var bubbleAnimationEffect:MovieClip = new HPMPAnimation();
			
			//			containerUI["addMpContianer"].addChild(addMpEffetRenderer);
			addChild(addMpEffetRenderer);
			addMpEffetRenderer.play("effect_scene_addmp");
			if (value != 0)
			{
				addChild(bubbleText);
				bubbleText.bubbleNum(value, CoreBubbleNumBitmapText.BLUE, bubbleAnimationEffect)
			}
		}
		
		public function showStrengthChanged(value:int):void
		{
			if(!isInViewPoint)
				return;
			
			//            containerUI.addChild(this.addStrengthEffetRenderer);
			addChild(addStrengthEffetRenderer);
			this.addStrengthEffetRenderer.play("effect_add_strength");
		}
		
		public function get addStrengthEffetRenderer():MmeAssetRender
		{
			if(_addStrengthEffetRenderer == null)
			{
				_addStrengthEffetRenderer = new MmeAssetRender(mmeAsset);
				_addStrengthEffetRenderer.addEventListener(MmeAssetRenderEvent.PLAY_END,onEffectRendererPlayEnd);
				
				var url:String = FileManager.getQualifiedUrl(ADD_STRENGTH_EFFECT_URL);
				_addStrengthEffetRenderer.loadUrl(url);
			}
			
			return _addStrengthEffetRenderer;
		}
		
		public function showLevelUp():void
		{
			if(!isInViewPoint)
				return;
			
			//            containerUI.addChild(this.levelUpEffetRenderer);
			addChild(this.levelUpEffetRenderer);
			this.levelUpEffetRenderer.play("effect_level_up");
			new PlayUISoundCommand(UISoundDef.LEVEL_UP).call();
		}
		
		public function get levelUpEffetRenderer():MmeAssetRender
		{
			if(_levelUpEffetRenderer == null)
			{
				_levelUpEffetRenderer = new MmeAssetRender(mmeAsset);
				_levelUpEffetRenderer.addEventListener(MmeAssetRenderEvent.PLAY_END,onEffectRendererPlayEnd);
				
				var url:String = FileManager.getQualifiedUrl(LEVEL_UP_EFFECT_URL);
				_levelUpEffetRenderer.loadUrl(url);
			}
			
			return _levelUpEffetRenderer;
		}
		
		protected function calcSmileyPos():void
		{
			if(headPos && smileyAni)
			{
				smileyAni.y = headPos.y - smileyAni.height - 20;
			}
		}
		
		public function showSmiley(smiley:int):void
		{
			hideSmiley();
			if(isInViewPoint)
			{
				smileyAni = SmileyUtils.getSmiley(smiley);
				smileyAni.x = -smileyAni.width>>1;
				calcSmileyPos();
				addChild(smileyAni);
				
				var animation:MovieClip = SmileyUtils.getSmileyAnimation(smileyAni);
				animation.addFrameScript(animation.totalFrames - 1, onSmileyAniDone);
				SmileyUtils.playSmiley(smileyAni);
			}
		}
		
		public function showDialog(text:String):void
		{
			var tmpStr:String;
			
			if (!dialogView)
			{
				dialogView = new PlayerDialogView();		
				dialogView.text.mouseEnabled = false;
			}
			
			if (!this.contains(dialogView))
			{
				this.addChild(dialogView);
				if (headPos)
				{
					dialogView.x = headPos.x;
					dialogView.y = headPos.y - 20;
				}
			}
			else
			{
				this.setChildIndex(dialogView, this.numChildren-1);
			}
			
			tmpStr = DisplayUtils.cutStringToByteLength(text, 20, false);
			dialogView.text.text = tmpStr;
			
			if (tmpStr.length <= text.length-1)
			{
				text = text.substr(tmpStr.length);
				tmpStr = DisplayUtils.cutStringToByteLength(text, 20, false);
				dialogView.text.text += tmpStr;
				
				if (tmpStr.length <= text.length-1)
				{
					text = text.substr(tmpStr.length);
					tmpStr = DisplayUtils.cutStringToByteLength(text, 20, true);
					dialogView.text.text += tmpStr;
				}
			}
			
			dialogView.bg.width = Math.max(dialogView.text.textWidth + 13, 40);
			dialogView.bg.height = dialogView.text.textHeight + 13;
			dialogView.bg.x = dialogView.buttomCenterPos.x - dialogView.bg.width / 2;
			dialogView.bg.y = dialogView.buttomCenterPos.y - dialogView.bg.height;
			
			dialogView.text.x = dialogView.buttomCenterPos.x - dialogView.text.textWidth / 2 - 2;
			dialogView.text.y = dialogView.bg.y + dialogView.bg.height / 2 - dialogView.text.textHeight / 2 - 2;
			
			TweenLite.killDelayedCallsTo(hideDialog);
			TweenLite.delayedCall(5, hideDialog);
		}
		
		private function hideDialog():void
		{
			if (dialogView && this.contains(dialogView))
			{
				this.removeChild(dialogView);
			}
		}
		
		public function hideSmiley():void
		{
			if(smileyAni)
			{
				SmileyUtils.stopSmiley(smileyAni);
				if(smileyAni != null && smileyAni.parent != null)
				{
					smileyAni.parent.removeChild(smileyAni);
				}
				smileyAni = null;
			}
		}
		
		protected function onSmileyAniDone():void
		{
			hideSmiley();
		}
		
		override public function dispose():void
		{
			super.dispose();
			TimerProvider.removeTimeTask(500,updateAllowDirection);
			if(nameTxt)
			{
				nameTxt.defaultTextFormat = BasePlayer.NAME_TEXT_FORMAT;
			}
			hideFightingAnimation();
			if(contains(campGlowRender)){removeChild(campGlowRender);}
			
			
		}
		
		override public function destroy(needDispatchEvent:Boolean=true):void
		{
			removeEventListener(MapElementEvent.MOUSE_DOWN_ELEMENT,onMouseDown);
			hideSmiley();
			
			if(_bubbleText)
			{
				if(_bubbleText.parent)
				{
					_bubbleText.parent.removeChild(_bubbleText);
				}
				_bubbleText = null;
			}
			
			if(resRenderer_animator)
			{
				resRenderer_animator.target = null;
				resRenderer_animator = null;
			}
			
			if(_addHpEffetRenderer)
			{
				_addHpEffetRenderer.removeEventListener(MmeAssetRenderEvent.PLAY_END,onEffectRendererPlayEnd);
				_addHpEffetRenderer.destroy();
				_addHpEffetRenderer = null;
			}
			
			if(_addMpEffetRenderer)
			{
				_addMpEffetRenderer.removeEventListener(MmeAssetRenderEvent.PLAY_END,onEffectRendererPlayEnd);
				_addMpEffetRenderer.destroy();
				_addMpEffetRenderer = null;
			}
			
			if(_levelUpEffetRenderer)
			{
				_levelUpEffetRenderer.removeEventListener(MmeAssetRenderEvent.PLAY_END,onEffectRendererPlayEnd);
				_levelUpEffetRenderer.destroy();
				_levelUpEffetRenderer = null;
			}
			
			if(pkEffectRenderer)
			{
				_pkEffectRenderer.removeEventListener(MmeAssetRenderEvent.PLAY_END,onEffectRendererPlayEnd);
				_pkEffectRenderer.destroy();
				_pkEffectRenderer = null;
			}
			
			if(_campGlowRender)
			{
				_campGlowRender.removeEventListener(MmeAssetRenderEvent.PLAY_END,onEffectRendererPlayEnd);
				_campGlowRender.destroy();
				_campGlowRender = null;
			}
			
			if(_allowRender)
			{
				_allowRender.destroy();
				_allowRender = null;
			}
			
			if(fightingIcon)
			{
				if(fightingIcon.parent)
				{
					fightingIcon.parent.removeChild(fightingIcon);
				}
				fightingIcon = null;
			}
			
			if(captainIcon)
			{
				if(captainIcon.parent)
				{
					captainIcon.parent.removeChild(captainIcon);
				}
				captainIcon = null;
			}
			
			if(moveToPlayerCommand)
			{
				moveToPlayerCommand.removeEventListener(CommandEvent.FINISH, onMoveToPlayerFinish);
				moveToPlayerCommand.removeEventListener(CommandEvent.FAILD, onMoveToPlayerFinish);
			}
			
			super.destroy(needDispatchEvent);
		}
	}
}