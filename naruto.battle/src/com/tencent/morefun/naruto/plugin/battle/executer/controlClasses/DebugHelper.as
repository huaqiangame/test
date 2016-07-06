package com.tencent.morefun.naruto.plugin.battle.executer.controlClasses 
{
	
	import com.tencent.morefun.framework.base.Command;
	import com.tencent.morefun.naruto.plugin.battle.data.BattleData;
	import com.tencent.morefun.naruto.plugin.battle.data.RecoData;
	import com.tencent.morefun.naruto.plugin.battle.executer.ControlExecuter;
	import com.tencent.morefun.naruto.plugin.battle.notice.SpeedUpNotice;
	import com.tencent.morefun.naruto.plugin.motion.notice.base.BaseNotice;
	import com.tencent.morefun.naruto.plugin.ui.layer.LayoutManager;
	import com.tencent.morefun.naruto.plugin.ui.layer.def.LayerDef;
	import com.tencent.morefun.naruto.plugin.ui.layer.def.LocationDef;
	import com.tencent.morefun.naruto.util.KeyboardManager;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import base.ApplicationData;
	
	import battle.command.StartBattleReplayCommond;
	
	import naruto.battle.BattleUI;
	
	import utils.LocalFile;
	
	public class DebugHelper 
	{
		private var _ctrl:ControlExecuter;
		private var _recoData:RecoData;
		private var _replayData:RecoData;
		private var _ui:BattleUI;
		private var _file:LocalFile;
		
		public function DebugHelper(controlExecuter:ControlExecuter) 
		{
			_ctrl = controlExecuter;
			_ui = new BattleUI();
			LayoutManager.singleton.addItemAndLayout(_ui, LayerDef.DEBUG, LocationDef.TOPLEFT);
			
			_ui.replayer.addEventListener(MouseEvent.CLICK, onBattleReplay);
			_ui.close.addEventListener(MouseEvent.CLICK, onHideDebug);
			_ui.saveReco.addEventListener(MouseEvent.CLICK, onBattleSaveReco);
			_ui.loadAndPlay.addEventListener(MouseEvent.CLICK, browse);
			_ui.quickBt.addEventListener(MouseEvent.CLICK, quick);
			
			_ui.visible = false;
			
			KeyboardManager.singleton.addKeyboardListener("replay", onShowDebug);
			KeyboardManager.singleton.addKeyboardListener("fredniub", hideUI);
			
			_recoData = new RecoData;
			_replayData = new RecoData;
		}
		
		private function quick(e:MouseEvent):void 
		{
			new SpeedUpNotice(1).send();
		}
		
		private function hideUI():void
		{
			_ctrl.hideUI();
		}
		
		private function onHideDebug(e:MouseEvent):void
		{
			_ui.visible = false;
		}
		
		private function onShowDebug():void
		{
			_ui.visible = true;
		}
		
		private function browse(e:Event):void{		//*in mouse event handle process!
			_file = new LocalFile;
			_file.read(onBitmapLoad,null,"nbr");
		}
		private function onBitmapLoad(data:Object):void
		{
			var c:StartBattleReplayCommond = new StartBattleReplayCommond;
			c.recordData = data as ByteArray;
			c.call();
		}
		private function onBattleReplay(e:MouseEvent):void
		{
			_recoData.getRecoBytes().position = 0;
			
			var c:StartBattleReplayCommond = new StartBattleReplayCommond;
			c.recordData = _recoData.getRecoBytes();
			c.call();
		}
		
		private var file:FileReference = new FileReference();
		private function onBattleSaveReco(e:MouseEvent):void
		{
			var bytes:ByteArray;
			var position:Number;
			
			bytes = _recoData.getRecoBytes();
			position = bytes.position;
			bytes.position = 0;
			
			file.save(bytes, "narutoBattleReco.nbr");
			bytes.position = position;
		}
		
		public function dispose():void 
		{
			BattleData.singleton.isReplay = false;
			
			LayoutManager.singleton.addItemAndLayout(_ui, LayerDef.DEBUG, LocationDef.TOPLEFT);
			
			_ui.replayer.removeEventListener(MouseEvent.CLICK, onBattleReplay);
			_ui.close.removeEventListener(MouseEvent.CLICK, onHideDebug);
			_ui.saveReco.removeEventListener(MouseEvent.CLICK, onBattleSaveReco);
			_ui.loadAndPlay.removeEventListener(MouseEvent.CLICK, browse);
			_ui.quickBt.removeEventListener(MouseEvent.CLICK, quick);
			
			_ui.visible = false;
			
			KeyboardManager.singleton.removeKeyboardListener("replay", onShowDebug);
			KeyboardManager.singleton.removeKeyboardListener("fredniub", hideUI);
		}
		/**开启重播*/
		public function startReplay(replayData:ByteArray):void 
		{
			BattleData.singleton.isReplay = true;
			_replayData.reset();
			_replayData.load(replayData);
			
			
			motionPlayerRenderCallBack( -1);//这里调 InitializeBattleCommand，NotifyStartBattleCommand
			_ctrl.motionPlayer.setRendererCallBack(motionPlayerRenderCallBack);
			
			
			var r:Object = _replayData.getStartReco();
			if(r.uin != 0)
			{
				ApplicationData.singleton.selfuin = r.uin;
				ApplicationData.singleton.selfRole = r.role;
				ApplicationData.singleton.selfSrv = r.srv;
			}
			
			BattleData.singleton.fightType = r.type;
		}
		
		/**仅用于重播*/
		private function motionPlayerRenderCallBack(rendererIndex:int):void
		{
			var recoObjs:Array = _replayData.getRecoByRenderIndex(rendererIndex);
			
			if (recoObjs.length == 0) return ;
			
			for(var i:int = 0;i < recoObjs.length;i ++)
			{
				var recoObj:Object = recoObjs[i];
				recoObj = recoObj.noticeOrCommand;
				
				if (recoObj is Command) {
					Command(recoObj).call();
				}else {
					BaseNotice(recoObj).send();
				}
				
			}
		}
		
		/**重设记录*/
		public function resetRecord(obj:Object):void 
		{
			if (BattleData.singleton.isReplay) return;
			
			_recoData.reset();
			_recoData.save(obj);
		}
		/**记录命令或消息*/
		public function record(noticeOrCommand:Object, isRepalyImmediately:Boolean=false):void 
		{
			if (BattleData.singleton.isReplay) return;
			
			var reco:Object = new Object;
			reco.noticeOrCommand = noticeOrCommand;
			if(!isRepalyImmediately){
				reco.rendererIndex = _ctrl.motionPlayer.rendererIndex;
			}else {
				reco.rendererIndex = -1;
			}
			_recoData.save(reco);
		}
		/**是否重播中*/
		public function get replaying():Boolean 
		{
			return BattleData.singleton.isReplay;
		}
		
		public function autoSetNull():void
		{
			
			_ctrl = null;
			_recoData = null;
			_replayData = null;
			_ui = null;
		}
	}
	
}