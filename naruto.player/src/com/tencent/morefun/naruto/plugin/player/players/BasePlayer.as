package com.tencent.morefun.naruto.plugin.player.players
{
	import base.ApplicationData;
	
	import com.tencent.morefun.framework.log.logger;
	import com.tencent.morefun.naruto.mmefile.render.MmeAsset;
	import com.tencent.morefun.naruto.mmefile.render.MmeAssetRender;
	import com.tencent.morefun.naruto.mmefile.render.MmeAssetRenderEvent;
	import com.tencent.morefun.naruto.mmefile.render.datas.PointElementData;
	import com.tencent.morefun.naruto.plugin.player.effects.EntryEffect;
	import com.tencent.morefun.naruto.plugin.player.views.UserTitle;
	import com.tencent.morefun.naruto.plugin.role.LoadingAsset;
	import com.tencent.morefun.naruto.plugin.ui.fonts.FontStyleMgr;
	import com.tencent.morefun.naruto.plugin.ui.util.VipUtil;
	
	import def.NinjaAssetDef;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import majorRole.def.MajorNinjaDef;
	
	import map.element.BaseMapElement;
	import map.events.MapElementEvent;
	
	import naruto.component.controls.Icon_VipLevel;
	
	import player.datas.PlayerData;
	import player.events.PlayerDataEvent;
	
	import ui.player.KnowledgeScoreUI;
	import ui.player.PvpTitle;
	import ui.player.TaskSignAni;
	import ui.role.CaptainIcon;
	
	import utils.PlayerNameUtil;
	
	import world.SceneConfig;
	
    import com.tencent.morefun.naruto.i18n.I18n;
	public class BasePlayer extends BaseMapElement
	{
		protected var data:PlayerData;
		protected var resRenderer:MmeAssetRender;
		protected var currActionName:String = "idle_0";
		protected var headPos:Point;
		protected var nameTxt:TextField;
		protected var pvpTitle:PvpTitle;
		protected var mmeAsset:MmeAsset;
		protected var isDisposed:Boolean;
		protected var _bodyVisible:Boolean = true;
		protected var vipIcon:Icon_VipLevel;
		protected var title:UserTitle;
		protected var taskSignAni:TaskSignAni;
		protected var knowledgeScoreUI:KnowledgeScoreUI;
		public var resNinjaId:int;
		protected var captainIcon:CaptainIcon;
		
		protected static const MOSUE_OVER_FILTER:GlowFilter = new GlowFilter(0xFFFFFF);
		
		private var loadingAsset:LoadingAsset;
		private static const SHADOW_BITMAP_DATA:BitmapData = new PlayerShadow();
		private var shadow:Bitmap;
		
		public function BasePlayer(mmeAsset:MmeAsset)
		{
			super();
			
			this.mmeAsset = mmeAsset;
		}
		
		override protected function onMouseOverElement(event:MapElementEvent):void
		{
			if(resRenderer)
			{
				resRenderer.filters = [mouseOverFilter];
			}
		}
		
		
		override protected function onMouseOutElement(event:MapElementEvent):void
		{
			if(resRenderer)
			{
				resRenderer.filters = null;
			}
		}
		
		override protected function get mouseOverFilter():GlowFilter
		{
			return MOSUE_OVER_FILTER;
		}
		
		protected function onPropertyUpdate(event:PlayerDataEvent):void
		{
			switch(event.property)
			{
				case PlayerData.PROPERTY_VIP_LEVEL:
					if(vipIcon)
					{
						updateVipIconData();
						headPosUpdated();
					}
					break;
				case PlayerData.PROPERTY_LEVEL:
				case PlayerData.PROPERTY_NAME:
					if(nameTxt)
					{
						updateNameText();
					}
					break;
				case PlayerData.PROPERTY_NINJA:
				case PlayerData.PROPERTY_SHOW_NINJA:
				case PlayerData.PROPERTY_FASHION_NINJA:
					if(resRenderer)
					{
						changeNinja();
					}
					break;
				case PlayerData.PROPERTY_WIN_STREAK_TIMES:
					if(pvpTitle)
					{
						updateWinStreakTimesTxt();
					}
					break;
				case PlayerData.PROPERTY_TITLE:
					if (title) 
					{
						title.data = data.title;
						headPosUpdated();
					}
					break;
				case PlayerData.PROPERTY_TASK_SIGN:
					if(taskSignAni)
					{
						updateTaskSignAni();
						headPosUpdated();
					}
					break;
				case PlayerData.PROPERTY_KNOWLEDGE_SCORE:
					if(knowledgeScoreUI)
					{
						updateKnowledgeScoreUI();
						headPosUpdated();
					}
					break;
			}
		}
		
		protected var entryEffect:EntryEffect;
		
		protected function changeNinja():void
		{
			destroyEntryEffect();
			entryEffect = new EntryEffect();
			entryEffect.play(this,2,changeNinja_startLoad);
		}
		
		protected function changeNinja_startLoad():void
		{
			var sceneId:int = ApplicationData.singleton.globelInfo.sceneToId || ApplicationData.singleton.globelInfo.sceneId;
			if(data.showNinja==0 || MajorNinjaDef.isMajorNinjaId(data.showNinja) || SceneConfig.isPvpBattleField(sceneId))
			{
				resRenderer.loadUrl(NinjaAssetDef.getAsset(NinjaAssetDef.AVATAR, data.fashionNinja || data.ninja));
				resNinjaId = data.fashionNinja || data.ninja;
			}else
			{
				resRenderer.loadUrl(NinjaAssetDef.getAsset(NinjaAssetDef.AVATAR, data.showNinja));
				resNinjaId = data.showNinja;
			}
		}
		
		protected function destroyEntryEffect():void
		{
			if(entryEffect)
			{
				entryEffect.destroy();
				entryEffect = null;
			}
		}
		
		public function getData():PlayerData
		{
			return data;
		}
		
		public function setData(data:PlayerData):void
		{
			this.data = data;
			this.data.addEventListener(PlayerDataEvent.PROPERTY_UPDATE,onPropertyUpdate);
			
			if(nameTxt)
			{
				if(data.name)
				{
					updateNameText();
				}
			}
			
			if(pvpTitle)
			{
				if(data.winStreakTimes != -1)
				{
					updateWinStreakTimesTxt();
				}
			}
			
			if(vipIcon)
			{
				updateVipIconData();
			}
			
			if (title)
			{
				title.data = data.title;
			}
			
			if(taskSignAni)
			{
				updateTaskSignAni();
			}
			
			headPosUpdated();
		}
		
		public function destroyData():void
		{
			if(data)
			{
				data.removeEventListener(PlayerDataEvent.PROPERTY_UPDATE,onPropertyUpdate);
				data = null;
			}
		}
		
		protected var inited:Boolean = false;
		
		protected function initUI():void
		{
			if(inited)
			{
				return;
			}
			inited = true;
			initNameTxt();
			initVipIcon();
			initShadow();
			initWinStreakTimesTxt();
			initTaskSignAni();
			initKnowledgeScoreUI();
			// 玩家称号
			if (title == null) 
			{
				addChild(title = new UserTitle());
				title.data = data.title;
				headPosUpdated();
			}
			
			initResRenderer();
		}
		
		protected function initKnowledgeScoreUI():void
		{
			if(knowledgeScoreUI == null)
			{
				knowledgeScoreUI = new KnowledgeScoreUI();
				knowledgeScoreUI.txt.defaultTextFormat = new TextFormat(FontStyleMgr.HYXueJunJ,null,null,true);
				knowledgeScoreUI.txt.embedFonts = true;
				updateKnowledgeScoreUI();
			}
		}
		
		public function updateKnowledgeScoreUI():void
		{
			if(data.knowledgeScore>0)
			{
				if(!contains(knowledgeScoreUI))
				{
					addChild(knowledgeScoreUI);
				}
				knowledgeScoreUI.txt.text = data.knowledgeScore + I18n.lang("as_player_1451031577_5316");
			}else
			{
				if(contains(knowledgeScoreUI))
				{
					removeChild(knowledgeScoreUI);
				}
				knowledgeScoreUI.txt.text = "";
			}
		}
		
		protected function headPosUpdated():void
		{
			if(headPos == null)
			{
				return;
			}
			var tempY:int;
			if(nameTxt && vipIcon)
			{
				var vipIconWidth:int = vipIcon.width;//vipIcon.currentFrame==1?0:vipIcon.width;
				nameTxt.x = headPos.x - (nameTxt.width>>1) + (vipIconWidth>>1);
				tempY = nameTxt.y = headPos.y - nameTxt.height;
				
				vipIcon.x = nameTxt.x - vipIconWidth;
				tempY = vipIcon.y = nameTxt.y + (nameTxt.height>>1) - (vipIcon.height>>1);
			}else if(nameTxt)
			{
				nameTxt.x = headPos.x - (nameTxt.width>>1);
				tempY = nameTxt.y = headPos.y - nameTxt.height;
			}else if(vipIcon)
			{
				vipIcon.x = - vipIcon.width;
				tempY = vipIcon.y = headPos.y;
			}
			
			if(pvpTitle)
			{
				pvpTitle.y = nameTxt.y - pvpTitle.height / 2;
				if(pvpTitle.visible){
					tempY = pvpTitle.y;
				}
			}
			
			if(knowledgeScoreUI)
			{
				knowledgeScoreUI.y = nameTxt.y - knowledgeScoreUI.height;
			}
			
			if (title)
			{
				title.x = headPos.x;
				title.y = nameTxt.y;
				title.visible = true;
				if(title.data){
					if(title.data.image){
						tempY = title.y - 60;
					}else if(title.data.formattedName&&title.data.formattedName.length>0){
						tempY = title.y - 20;
					}
				}
				if(pvpTitle && pvpTitle.visible){
					title.y -= pvpTitle.height;
					tempY = title.y - 60;
				}
				
				if(knowledgeScoreUI && contains(knowledgeScoreUI)){title.y -= knowledgeScoreUI.height;}
			}
			
			if(taskSignAni && taskSignAni.currentFrame != 1)
			{
				taskSignAni.x = headPos.x;
				taskSignAni.y = nameTxt.y;
				tempY=taskSignAni.y - 60;
				if(title)
				{
					title.visible = false;
				}
			}
			
			if(captainIcon){
				captainIcon.y = tempY;
			}
		}
		
		
		private function onEffectEnd(e:MmeAssetRenderEvent):void
		{
			var renderer:MmeAssetRender = e.currentTarget as MmeAssetRender;
			renderer.stop();
			renderer.visible = false;
		}
		
		protected function initResRenderer():void
		{
			if(resRenderer == null)
			{
				resRenderer = new MmeAssetRender(mmeAsset);
				resRenderer.addEventListener(MmeAssetRenderEvent.READY,onResRendererReady);
				resRenderer.addEventListener(MmeAssetRenderEvent.LOAD_ERROR,onResRendererError);
				changeNinja_startLoad();
				if (this._bodyVisible)
				{
					this.addChild(this.resRenderer);
				}
				
				// loading 动画
				if(resRenderer.isReady == false)
				{
					this.loadingAsset = new LoadingAsset();
					this.addChild(this.loadingAsset);
				}
			}
		}
		
		protected function initShadow():void
		{
			if(shadow == null)
			{
				shadow = new Bitmap(SHADOW_BITMAP_DATA);
				shadow.x = -shadow.width>>1;
				shadow.y = -shadow.height>>1;
				addChildAt(shadow, 0);
			}
		}
		
		protected function destroyShadow():void
		{
			if(shadow)
			{
				if(shadow.parent)
				{
					shadow.parent.removeChild(shadow);
				}
				shadow.bitmapData = null;
				shadow = null;
			}
		}
		
		protected function destroyResRenderer():void
		{
			if(resRenderer)
			{
				resRenderer.removeEventListener(MmeAssetRenderEvent.READY,onResRendererReady);
				resRenderer.removeEventListener(MmeAssetRenderEvent.LOAD_ERROR,onResRendererError);
				resRenderer.destroy();
				resRenderer = null;
			}
		}
		
		public static const NAME_TEXT_FORMAT:TextFormat = new TextFormat("SimSun", 13, 0xFFFFFF);
		public static const WIN_STREAK_TIMES_TEXT_FORMAT:TextFormat = new TextFormat(I18n.lang("as_player_1451031577_5317"), 14, 0xFFBA00, true);
		public static const NAME_FILTERS:Array = [new GlowFilter(0x0, 1, 2, 2, 10, 1)];
		public static const WIN_STREAK_TIMES_FILTERS:Array = [new GlowFilter(0x0, 1, 2, 2, 10, 1)];
		
		protected function initWinStreakTimesTxt():void
		{
			if(pvpTitle == null)
			{
				pvpTitle = new PvpTitle();
				pvpTitle.txt.multiline = false;
				pvpTitle.txt.selectable = false;
				pvpTitle.txt.mouseEnabled = false;
				pvpTitle.txt.defaultTextFormat = BasePlayer.WIN_STREAK_TIMES_TEXT_FORMAT;
				addChild(pvpTitle);
				
				if(data.winStreakTimes)
				{
					updateWinStreakTimesTxt();
				}
				
				headPosUpdated();
			}
		}
		
		protected function initNameTxt():void
		{
			if(nameTxt == null)
			{
				nameTxt = new TextField();
				nameTxt.autoSize = TextFieldAutoSize.LEFT;
				nameTxt.multiline = false;
				nameTxt.selectable = false;
				nameTxt.mouseEnabled = false;
				nameTxt.defaultTextFormat = BasePlayer.NAME_TEXT_FORMAT;
				nameTxt.filters = BasePlayer.NAME_FILTERS;
				nameTxt.y = -nameTxt.height;
				addChild(nameTxt);
				
				if(data.name)
				{
					updateNameText();
				}
				
				headPosUpdated();
			}
		}
		
		protected function updateWinStreakTimesTxt():void
		{
			if(data.winStreakTimes >= 3)
			{
				pvpTitle.visible = true;
				pvpTitle.txt.text = data.winStreakTimes + I18n.lang("as_player_1451031577_5318");
			}
			else
			{
				pvpTitle.visible = false;
			}
			headPosUpdated();
		}
		
		protected function updateNameText():void
		{
			if(data.svrId)
			{
				nameTxt.text = PlayerNameUtil.standardlizeName(data.svrId, data.name);
			}else
			{
				nameTxt.text = data.name;
			}
			headPosUpdated();
//			nameTxt.x = -nameTxt.width>>1;
		}
		
		protected function destroyNameTxt():void
		{
			if(nameTxt)
			{
				if(nameTxt.parent)
				{
					nameTxt.parent.removeChild(nameTxt);
				}
				nameTxt = null;
			}
		}
		
		protected function destroyKnowledgeScoreUI():void
		{
			if(knowledgeScoreUI)
			{
				if(knowledgeScoreUI.parent)
				{
					knowledgeScoreUI.parent.removeChild(knowledgeScoreUI);
				}
				knowledgeScoreUI = null;
			}
		}
		
		protected function destroyWinStreakTimesTxt():void
		{
			if(pvpTitle)
			{
				if(pvpTitle.parent)
				{
					pvpTitle.parent.removeChild(pvpTitle);
				}
				pvpTitle = null;
			}
		}
		
		protected function initVipIcon():void
		{
			if(vipIcon == null)
			{
				vipIcon = new Icon_VipLevel();
				updateVipIconData()
				addChild(vipIcon);
				
				headPosUpdated();
			}
		}
		
		protected function updateVipIconData():void
		{
			VipUtil.setOtherInfo(vipIcon, data.vip, data.diamondInfo);
		}
		
		protected function destroyVipIcon():void
		{
			if(vipIcon)
			{
				if(vipIcon.parent)
				{
					vipIcon.parent.removeChild(vipIcon);
				}
				vipIcon = null;
			}
		}
		
		
		protected function initTaskSignAni():void
		{
			if(taskSignAni == null)
			{
				taskSignAni = new TaskSignAni();
				taskSignAni.gotoAndStop(1);
				updateTaskSignAni();
				addChild(taskSignAni);
				
				headPosUpdated();
			}
		}
		
		protected function updateTaskSignAni():void
		{
			taskSignAni.gotoAndStop(data.taskSign);
		}
		
		protected function destroyTaskSignAni():void
		{
			if(taskSignAni)
			{
				taskSignAni.gotoAndStop(1);
				if(taskSignAni.parent)
				{
					taskSignAni.parent.removeChild(taskSignAni);
				}
				taskSignAni = null;
			}
		}
		
		protected function onResRendererReady(e:MmeAssetRenderEvent):void
		{
			calcHeadPos();
			playAction(currActionName, false, true);
			
			// 删除 loading 动画
			if(loadingAsset)
			{
				this.removeChild(this.loadingAsset);
				this.loadingAsset.stop();
				this.loadingAsset = null;
			}
		}
		
		protected function onResRendererError(e:MmeAssetRenderEvent):void
		{
			logger.output("[player]","[PlayerView]",I18n.lang("as_player_1451031577_5319")+data.ninja+"@"+NinjaAssetDef.getAsset(NinjaAssetDef.AVATAR, data.ninja));
		}
		
		protected function calcHeadPos():void
		{
			if(headPos == null)
			{
				headPos = new Point();
			}
			//如果资源里面定义了参考点，那就使用参考点的坐标来
			if(resRenderer.isReady && resRenderer.hasActionName(NinjaAssetDef.AVATAR_POS_ACTION_NAME))
			{
				var ped:PointElementData = resRenderer.getReferPointFromActionByName(NinjaAssetDef.AVATAR_POS_ACTION_NAME,0,NinjaAssetDef.AVATAR_HEAD_POS_NAME);
				if(ped)
				{
					headPos.x = ped.x;
					headPos.y = ped.y;
					headPosUpdated();
					return;
				}
			}
			resRenderer.gotoAction("idle_0",0,true);
			var bound:Rectangle = resRenderer.getBounds(null);
			headPos.y = int(bound.top);
			headPosUpdated();
		}
		
		public function playAction(actionName:String, keepFrame:Boolean, loop:Boolean):void
		{
			currActionName = actionName;
			if (resRenderer && resRenderer.isReady && isDisposed == false)
			{
				var frame:int = 0;
				if (keepFrame)
				{
					frame = Math.max(0, resRenderer.getCurrFrame());
				}
				this.resRenderer.play(currActionName, frame, loop);
				if (!this._bodyVisible)
				{
					this.resRenderer.stop();
				}
			}
		}
		
		override public function hitTestPoint(x:Number, y:Number, shapeFlag:Boolean=false):Boolean
		{
			if(nameTxt && nameTxt.hitTestPoint(x,y,shapeFlag))
			{
				return true;
			}
			if(resRenderer && resRenderer.isReady)
			{
				return resRenderer.hitTestPoint(x,y,true);
			}else
			{
				return super.hitTestPoint(x,y,shapeFlag);
			}
		}
		
		/**
		 * 进入视野 
		 */
		override public function inViewPoint(needDispatchEvent:Boolean=true):void
		{
			super.inViewPoint(false);
			
			initUI();
			
			needDispatchEvent && dispatch(MapElementEvent.IN_VIEWPOINT);
		}
		
		public function resurrect():void
		{
			isDisposed = false;
			playAction("idle_0",false,true);
		}
		
		public function dispose():void
		{
			isDisposed = true;
			if(knowledgeScoreUI && knowledgeScoreUI.parent)
			{
				knowledgeScoreUI.parent.removeChild(knowledgeScoreUI);
			}
			if(pvpTitle){pvpTitle.visible = false;}
			if(resRenderer && resRenderer.isReady)
			{
				resRenderer.stop();
			}
			destroyEntryEffect();
			destroyTaskSignAni();
			//destroy会做一些从地图上消失的操作，，暂时延用destroy事件 
			var event:PlayerDataEvent = new PlayerDataEvent(PlayerDataEvent.DESTROY);
			data.dispatchEvent(event);
			
			destroyData();
			
			dispatch(MapElementEvent.DESTROY);
		}
		
		override public function destroy(needDispatchEvent:Boolean=true):void
		{
			destroyNameTxt();
			destroyVipIcon();
			destroyResRenderer();
			destroyEntryEffect();
			destroyTaskSignAni();
			destroyWinStreakTimesTxt();
			destroyKnowledgeScoreUI();
			
			if (title)
			{
				title.dispose();
				title.parent && title.parent.removeChild(title);
				title = null;
			}
			
			var event:PlayerDataEvent = new PlayerDataEvent(PlayerDataEvent.DESTROY);
			data.dispatchEvent(event);
			
			destroyData();
			
			super.destroy(needDispatchEvent);
		}
		
		override public function setXY(x:int,y:int):void
		{
			super.setXY(x,y);
			data.setPosition(x,y);
		}
		
		override public function getBounds(targetCoordinateSpace:DisplayObject):Rectangle
		{
//			if(__bound==null || resRenderer==null || !resRenderer.isReady || __bound.isEmpty())
//			{
				__bound = super.getBounds(targetCoordinateSpace);
//			}
			return __bound;
		}
		
		public function set bodyVisible(value:Boolean):void
		{
			if (this._bodyVisible != value)
			{
				this._bodyVisible = value;
				if (this.resRenderer)
				{
					if (this._bodyVisible)
					{
						this.addChild(this.resRenderer);
						this.resRenderer.play(this.resRenderer.getCurrActionName(), this.resRenderer.getCurrFrame(), this.resRenderer.getLoop());
					}
					else if (this.contains(this.resRenderer))
					{
						this.removeChild(this.resRenderer);
						this.resRenderer.stop();
					}
				}
				
			}
		}
		
		public function get bodyVisible():Boolean
		{
			return this._bodyVisible;
		}
		
	}
}