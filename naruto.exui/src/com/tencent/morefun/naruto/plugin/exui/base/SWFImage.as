package com.tencent.morefun.naruto.plugin.exui.base
{
	import com.tencent.morefun.framework.loader.LoaderAssist;
	import com.tencent.morefun.framework.loader.LoaderEvent;
	import com.tencent.morefun.framework.loader.mission.LoaderMission;
	import com.tencent.morefun.framework.log.logger;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import ui.naruto.LoadingUI;

	public class SWFImage extends Sprite
	{
		public static var missionMap:Dictionary = new Dictionary();
		public static var releaseMissionList:Dictionary = new Dictionary(true);
		public static var loader:LoaderAssist = new LoaderAssist("Image");
		
		protected static var urlRefMap:Dictionary = new Dictionary();
		
		protected var m_width:int;
		protected var m_height:int;
		protected var m_isResetSize:Boolean;
		protected var m_content:MovieClip;
		protected var m_content_url:String;
		protected var m_url:String;
		protected var m_def:String;
		protected var m_isLoaded:Boolean;
		protected var m_missionList:Array = [];
		protected var m_useCache:Boolean;
		protected var m_isPlaying:Boolean;
		protected var m_curDomain:Boolean;
		
		protected var m_isLoadStarted:Boolean;
		protected var m_centerAlign:Boolean;
		
		protected var m_loader:LoaderAssist;
		
		protected var m_loadingUI:LoadingUI;
		protected var m_showLoadingMC:Boolean;
		protected var m_loadingMCX:int;
		protected var m_loadingMCY:int;
		
		private static var index:int;
		private  var m_index:int;
		
		/**
		 *当 isResetSize 为true时图片加载完成后会自动设置成 width 和 height指定的尺寸
		 * @param width
		 * @param height
		 * @param isResetSize
		 * 
		 */		
		public function SWFImage(width:int = 0, height:int = 0, isResetSize:Boolean = false, useCache:Boolean = false, centerAlign:Boolean = false,showLoadingMC:Boolean = false,loadingMCX:int = 0,loadingMCY:int = 0)
		{
			super();
			
			m_loader = loader;
			m_isResetSize = isResetSize;
			m_centerAlign = centerAlign;
			m_loader.traceFunction = logger.output;
			
			m_width = width;
			m_height = height;
			
			m_useCache = useCache;
			
			m_showLoadingMC = showLoadingMC;
			m_loadingMCX = loadingMCX;
			m_loadingMCY = loadingMCY;
			
			m_index = index ++;
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage, false, 0, true);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFormStage, false, 0, true);
		}
		
		protected var lastUrl:String;
		private function onAddToStage(evt:Event):void
		{
			clearTimeout(stageCheckId);
			load(lastUrl, m_def, m_curDomain);
		}
		
		private function onRemoveFormStage(evt:Event):void
		{
			clearTimeout(stageCheckId);
			stageCheckId = setTimeout(stageCheck, 10000);
		}
		
		public function get url():String
		{
			return m_url;
		}
		
		public function get isLoaded():Boolean
		{
			return m_isLoaded;
		}
		
		public function get isLoadStarted():Boolean
		{
			return m_isLoadStarted;
		}
		
		private function stageCheck():void
		{
			if(!stage)
			{
				unload();
			}
		}
		
		private var stageCheckId:uint;
		public function load(url:String, def:String = null, currDomain:Boolean = true):void
		{
			var lm:LoaderMission;
			
			if(m_url == url || !url)
			{
				return ;
			}
			
			m_def = def;
			m_curDomain = currDomain;
			m_url = getCleanURL(url);
			lastUrl = m_url;
			if(!stage)
			{
				stageCheckId = setTimeout(stageCheck, 10000);
			}
			
			lm = m_loader.getCompleteMission(m_url) as LoaderMission;
			
//			logger.output("[SWFImage]", "m_index", m_index, "load", m_url);
			if(lm == null)
			{
				addLoadEventListener();
				if(m_missionList.indexOf(m_url) == -1)
				{
					m_missionList.push(m_url);
				}
				
				if(m_loader.hasMission(m_url) == false && m_loader.missionIsComplete(m_url) == false)
				{
					lm = new LoaderMission(m_url, url, m_useCache, 0);
					if(!currDomain)
					{
						lm.applicationDomain = new ApplicationDomain();
					}
					m_loader.loadMission(lm);
				}
				
				if (m_showLoadingMC)
				{
//					logger.output("[SWFImage]", "m_index", m_index, "showLoadingMC", m_url);
					m_loadingUI ||= new LoadingUI();
					m_loadingUI.x = m_loadingMCX;
					m_loadingUI.y = m_loadingMCY;
					addChild(m_loadingUI);
				}
			}
			else 
			{
				init(lm.loader);
			}
		}
		
		public function play():void
		{
			m_isPlaying = true;
		}
		
		public function stop():void
		{
			m_isPlaying = false;
		}
		
		private function reset():void
		{
//			logger.output("[SWFImage]", "m_index", m_index, "reset", m_url);
			
			removeContent();
			removeLoadEventListener();
			m_isLoaded = false;
			m_isLoadStarted = false;
			
			if(m_loadingUI && this.contains(m_loadingUI))
			{
                m_loadingUI.gotoAndStop(1);
				removeChild(m_loadingUI);
			}	
		}
		
		public function unload():void
		{
			var tempUrl:String;
			
//			logger.output("[SWFImage]", "m_index", m_index, "unload", m_url);
			clearTimeout(stageCheckId);
			tempUrl = m_content_url;
			removeContent();
			removeLoadEventListener();
			m_isLoaded = false;
			m_isLoadStarted = false;
			m_url = null;
			
			m_content_url = tempUrl;
			if(getRef() == 0)
			{
				m_loader.removeMission(m_content_url,false);
			}
			if(m_loadingUI && this.contains(m_loadingUI))
			{
                m_loadingUI.gotoAndStop(1);
				removeChild(m_loadingUI);
			}	
			m_content_url = null;
		}
		
		protected function showContent():void
		{
			addUrlRef(m_content_url);
			
			if(m_content == null)
			{
				return ;
			}
			
			if(m_isResetSize)
			{
				m_content.width = m_width;
				m_content.height = m_height;
			}
			
			this.centerAlign = m_centerAlign;
			
			addChildAt(m_content, 0);
		}
		
		protected function removeContent():void
		{
			removeUrlRef(m_content_url);
			
			if(m_content == null)
			{
				return ;
			}
			m_content.stop();
			if(contains(m_content))
			{
				removeChild(m_content);
			}
			m_content = null;
			m_content_url = null;
		}
		
		protected function onLoadComplete(evt:LoaderEvent):void
		{
			var lm:LoaderMission;
			
			var missionURL:String = getCleanURL(evt.mission.path);
			
			if(m_missionList.indexOf(missionURL) != -1)
			{
				m_missionList.splice(missionURL, 1);
			}
			
//			logger.output("[SWFImage]", "m_index", m_index, "onMissionComplete", missionURL);
			
			if (missionURL.indexOf(m_url) >= 0)
			{
//				logger.output("[SWFImage]", "m_index", m_index, "onLoadComplete", m_url);
				lm = evt.mission as LoaderMission;
				init(lm.loader);
			}
			
			if(m_missionList.length == 0)
			{
				this.removeLoadEventListener();
			}

            dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function getCleanURL(url:String):String
		{
			url = url.replace("\\","/");
			
			return url? url.split("?").shift() : "";
		}
		
		private function init(loader:Loader):void
		{		
			var refNum:int;
			var contentUrl:String;
			
			//先移除旧的显示内容
			reset();
			if(!m_def)
			{
				createContent(createDisplay(loader));
			}
			else
			{
				createContent(createDisplay(loader, m_def));
			}
			
			//显示新的显示内容
			m_content_url = m_url;
			showContent();
			m_isLoaded = true;
			m_isLoadStarted = true;
			
			if(m_isPlaying)
			{
				m_content.play();
			}
			else
			{
				m_content.stop();
			}
			
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function createDisplay(loader:Loader, def:String = null):MovieClip
		{
			var cls:Class;
			var displayDef:String;
			
			displayDef = def || loader.contentLoaderInfo.applicationDomain.getQualifiedDefinitionNames()[0];
			cls = loader.contentLoaderInfo.applicationDomain.getDefinition(displayDef) as Class;
			return new cls();
		}
		
		private function createContent(display:MovieClip):void
		{
			m_content = display;
		}
		
		protected function onLoadError(evt:LoaderEvent):void
		{
			m_isLoadStarted = false;
			
			var missionURL:String = getCleanURL(evt.mission.path);
			if(m_missionList.indexOf(missionURL) != -1)
			{
				m_missionList.splice(missionURL, 1);
			}
			
//			logger.output("[SWFImage]", "m_index", m_index, "onLoadError", m_url);
			
			if(missionURL == m_url)
			{
				unload();
			}
			
			if(m_missionList.length == 0)
			{
				this.removeLoadEventListener();
			}

            dispatchEvent(new Event("LoadError"));
		}
		
		protected function onLoadProgress(evt:LoaderEvent):void
		{			
			if (getCleanURL(evt.mission.path) == m_url)
			{
				
			}
		}
		
		protected function onLoadStart(evt:LoaderEvent):void
		{
			if (getCleanURL(evt.mission.path) == m_url)
			{
				m_isLoadStarted = true;
			}
		}
		
		protected function addLoadEventListener():void
		{	
//			logger.output("[SWFImage]", "m_index", m_index, "addLoadEventListener", m_url);
			
			m_loader.addEventListener(LoaderEvent.MISSION_COMPLETE, onLoadComplete);
			m_loader.addEventListener(LoaderEvent.MISSION_START, onLoadStart);
			m_loader.addEventListener(LoaderEvent.MISSION_ERROR, onLoadError);
			m_loader.addEventListener(LoaderEvent.MISSION_PROGRESS, onLoadProgress);
		}
		
		protected function removeLoadEventListener():void
		{
//			logger.output("[SWFImage]", "m_index", m_index, "removeLoadEventListener", m_url);
			
			m_loader.removeEventListener(LoaderEvent.MISSION_COMPLETE, onLoadComplete);
			m_loader.removeEventListener(LoaderEvent.MISSION_START, onLoadStart);
			m_loader.removeEventListener(LoaderEvent.MISSION_ERROR, onLoadError);
			m_loader.removeEventListener(LoaderEvent.MISSION_PROGRESS, onLoadProgress);
		}
		
		/**
		 * 是否居中对齐
		 */
		public function get centerAlign():Boolean { return m_centerAlign; }
		public function set centerAlign(value:Boolean):void 
		{
			m_centerAlign = value;
			if (m_content && m_centerAlign)
			{
				m_content.x = m_width - m_content.width >> 1;
				m_content.y = m_height - m_content.height >> 1;
			}
		}
		
		private function addUrlRef(url:String):void
		{
			var refNum:int;
			
			if(url == null)
			{
				return ;
			}
			
//			logger.output("[SWFImage]", "m_index", m_index, "addUrlRef", url);
			
			refNum = urlRefMap[url];
			refNum += 1;
			urlRefMap[url] = refNum;
			
			delete releaseMissionList[url];
		}
		
		private function removeUrlRef(url:String):void
		{
			var refNum:int;
			
			if(url == null)
			{
				return ;
			}
			
//			logger.output("[SWFImage]", "m_index", m_index, "removeUrlRef", url);
			
			refNum = urlRefMap[url];
			refNum -= 1;
			urlRefMap[url] = refNum;
			
			if(refNum == 0)
			{
				releaseMissionList[url] = 1;
			}
		}
		
		private function getRef():int
		{
			return urlRefMap[m_content_url];
		}

        public function get enableLoadingMovie():Boolean
        {
            return m_showLoadingMC;
        }

        public function set enableLoadingMovie(value:Boolean):void 
        {
            m_showLoadingMC = value;
        }
	}
}