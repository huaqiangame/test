package com.tencent.morefun.naruto.plugin.battle.view
{

	import com.tencent.morefun.framework.loader.FileManager;
	import com.tencent.morefun.naruto.plugin.battle.event.VideoViewEvent;
	import com.tencent.morefun.naruto.plugin.battle.notice.SkillVidoNotice;
	import com.tencent.morefun.naruto.plugin.ui.layer.LayoutManager;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Timer;

	public class VideoView extends Sprite
	{
		private var VIDEO_TIME_OUT:int = 10000;
		
		private var video:Video;
		private var videoMask:Sprite;
		private var netStream:NetStream;
		private var netConnection:NetConnection;
		
		private var url:String;
		private var timeoutTimer:Timer = new Timer(0);
		private var customClient:CustomClient;
		
		private var inited:Boolean = false;
		
		public function VideoView()
		{
			super();
			netConnection = new NetConnection();
			
			videoMask = new Sprite();
			addChild(videoMask);
			
			video = new Video();
			video.width = 1300;
			video.height = 731;
			addChild(video);
			
			customClient = new CustomClient();
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			
			netConnection.addEventListener(NetStatusEvent.NET_STATUS, onNetStatue);
			netConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			netConnection.connect(null);
			
			timeoutTimer.addEventListener(TimerEvent.TIMER, onTimeOut);
			
			customClient.addEventListener(videoEvent.START, onVideoStart);
			customClient.addEventListener(videoEvent.COMPLETE, onVideoComplete);
		}
		
		private function onAddedToStage(evt:Event):void
		{
			stage.addEventListener(Event.RESIZE, onStageResize);
			
			updateMask();
			updateVideoPositon();
		}
		
		private function onRemoveFromStage(evt:Event):void
		{
			stage.removeEventListener(Event.RESIZE, onStageResize);
		}
		
		private function onStageResize(evt:Event):void
		{
			updateMask();
			updateVideoPositon();
		}
		
		public function play(url:String):void
		{
			if(inited == false)
			{
				return ;
			}
			
			timeoutTimer.delay = VIDEO_TIME_OUT;
			
			url = FileManager.getVideoQualifiedUrl(url);
			if(js.available)//TODO:这个干嘛的？
			{
				netStream.play(url);
			}
			else
			{
				netStream.play(url);
			}
			
			timeoutTimer.start();
			
			new SkillVidoNotice(true).send();
		}
		
		private function onNetStatue(event:NetStatusEvent):void
		{
			switch (event.info.code) {
				case "NetConnection.Connect.Success":
					attach();
					break;
				case "NetStream.Play.StreamNotFound":
					trace("Unable to locate video: " + url);
					dipathCompleteEvent();
					break;
			}
		}
		
		private function securityErrorHandler(evt:SecurityErrorEvent):void
		{
//			throw new Error("video error");
			dipathCompleteEvent();
		}
		
		private function attach():void
		{
			inited = true;
			
			netStream = new NetStream(netConnection);
			netStream.client = customClient;
			video.attachNetStream(netStream);
			
			if(url != null)
			{
				play(url);
			}

			netStream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatue);
		}
		
		private function updateMask():void
		{
			videoMask.graphics.beginFill(0x000000);
			videoMask.graphics.drawRect(0, 0, 1300, 825);
			videoMask.graphics.endFill();
		}
		
		private function updateVideoPositon():void
		{
			video.x = LayoutManager.stageWidth / 2 - video.width / 2;
			video.y = LayoutManager.stageHeight / 2 - video.height / 2;
		}
		
		private function onTimeOut(evt:TimerEvent):void
		{
			dipathCompleteEvent();
		}
		
		public function destroy():void
		{
			this.removeChildren();
			
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			
			video.attachNetStream(null);
			video.clear();
			video = null;
			
			netStream.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatue);
			netStream.close(); netStream.dispose();
			netStream = null;
			
			netConnection.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatue);
			netConnection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			netConnection.client = { };
			netConnection.close();
			netConnection = null;
			
			timeoutTimer.reset();
			timeoutTimer.removeEventListener(TimerEvent.TIMER, onTimeOut);
			timeoutTimer = null;
			
			customClient.removeEventListener(videoEvent.START, onVideoStart);
			customClient.removeEventListener(videoEvent.COMPLETE, onVideoComplete);
			customClient = null;
		}
		
		private function onVideoStart(evt:videoEvent):void
		{
			timeoutTimer.delay = evt.duration * 1000;
		}
		
		private function onVideoComplete(evt:videoEvent):void
		{
			dipathCompleteEvent();
		}
		
		private function dipathCompleteEvent():void
		{
			timeoutTimer.stop();
			netStream.close();
			video.clear();
			
			this.dispatchEvent(new VideoViewEvent(VideoViewEvent.VIDEO_COMPLETE));
			new SkillVidoNotice(false).send();
		}
																
		public function autoSetNull():void
		{

			video = null;
			videoMask = null;
			netStream = null;
			netConnection = null;
			url = null;
			timeoutTimer = null;
			customClient = null;
		}
	}
}

import flash.events.Event;
import flash.events.EventDispatcher;

class CustomClient extends EventDispatcher 
{
	public function onMetaData(info:Object):void 
	{
		var event:videoEvent;
		
		event = new videoEvent(videoEvent.START);
		event.duration = info.duration;
		this.dispatchEvent(event);
		trace("metadata: duration=" + info.duration + " width=" + info.width + " height=" + info.height + " framerate=" + info.framerate);
	}
	public function onCuePoint(info:Object):void {
		trace("cuepoint: time=" + info.time + " name=" + info.name + " type=" + info.type);
	}
	
	public function onPlayStatus(info:Object):void
	{
		if(info.code == "NetStream.Play.Complete")
		{
			this.dispatchEvent(new videoEvent(videoEvent.COMPLETE));
		}
	}
	
	public function onXMPData(info:Object):void
	{
		trace(info);
	}

	public function autoSetNull():void
	{

	}
}


class videoEvent extends Event
{
	public static const START:String = "start"
	public static const COMPLETE:String = "complete";
	
	public var duration:Number;
	public function videoEvent(type:String)
	{
		super(type);
	}

	public function autoSetNull():void
	{

	}
}
