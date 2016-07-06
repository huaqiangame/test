package com.tencent.morefun.naruto.plugin.battle.view.fightOver 
{

	import bag.utils.SpecialItemUtils;
	import base.ApplicationData;
	import cfgData.dataStruct.NinjaInfoCFG;
	
	import com.tencent.morefun.framework.base.CommandEvent;
	import com.tencent.morefun.naruto.plugin.battle.command.DestroyBattleCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.GotoNextFightCommand;
	import com.tencent.morefun.naruto.plugin.exui.base.Image;
	
	import def.NinjaAssetDef;
	
	import exam.cmd.GetExamInfoCommand;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import sound.commands.PlayUISoundCommand;
	import sound.def.UISoundDef;
	import ui.battle.ExamFightWinUI;
	
	import user.data.NinjaInfoConfig;
	import user.data.NinjaLevelInfo;

	public class ExamWinView 
	{
		
		private var _nextBt:Sprite;
		private var _getOutBt:Sprite;
		private var _cb_next:Function;
		private var _cb_exit:Function;
		private var _ui:MovieClip;
		private var _cmd:GetExamInfoCommand;
		private var _itemIcons:Vector.<ItemCellView>;
		public function ExamWinView() 
		{
			_ui = new ExamFightWinUI();
			_ui.stop();
			_ui.visible = false;
			
			getExamInfo();
			
		}
		
		private function getExamInfo():void
		{
			_cmd = new GetExamInfoCommand();
			_cmd.addEventListener(CommandEvent.FAILD, onGetExamFaild);
			_cmd.addEventListener(CommandEvent.FINISH, onGetExamComplete);
			_cmd.call();
		}
		
		private function onGetExamComplete(evt:CommandEvent):void
		{
			_cmd.removeEventListener(CommandEvent.FAILD, onGetExamFaild);
			_cmd.removeEventListener(CommandEvent.FINISH, onGetExamComplete);
			
			showResult();
		}
		
		private function onGetExamFaild(evt:CommandEvent):void
		{
			_cmd.removeEventListener(CommandEvent.FAILD, onGetExamFaild);
			_cmd.removeEventListener(CommandEvent.FINISH, onGetExamComplete);
			
			new DestroyBattleCommand(true).call();
		}
		
		private function showResult():void 
		{
			_ui.visible = true;
			_ui.gotoAndPlay(1);
			new PlayUISoundCommand(UISoundDef.BATTLE_WIN).call();
			
			
			_nextBt = _ui.infoPanelUI.nextBt;
			_nextBt.addEventListener(MouseEvent.CLICK, onButtonClick);
			
			_getOutBt = _ui.infoPanelUI.getOutBt;
			_getOutBt.addEventListener(MouseEvent.CLICK, onButtonClick);
			
			_ui.infoPanelUI.exp.text = "";
			_ui.infoPanelUI.copper.text = "";
			
			if(_cmd.data.completeAllLevels)
			{
				_nextBt.visible = false;
			}
			_itemIcons = new Vector.<ItemCellView>;
			for (var i:int = 0; i < 4; i++) 
			{
				var icon:ItemCellView = new ItemCellView(_ui.infoPanelUI["c" + i]);
				_itemIcons.push(icon);
			}
			if (_cmd.awards) {
				for (i = 0; i < _cmd.awards.length; i++) {
					if (SpecialItemUtils.isPlayerExp(_cmd.awards[i].id)) {
						//_ui.infoPanelUI.playerExp.addExpText.htmlText = "<b>+" + _cmd.awards[i].num+ "</b>";
						_ui.infoPanelUI.exp.htmlText = "<b>" + _cmd.awards[i].num+ "</b>";
						_cmd.awards.splice(i, 1);
						i--;
						continue;
					}else if (SpecialItemUtils.isMoney(_cmd.awards[i].id)) {
						_ui.infoPanelUI.copper.htmlText = "<b>" + _cmd.awards[i].num+ "</b>";
						_cmd.awards.splice(i, 1);
						i--;
						continue;
					}
					_itemIcons[i].data = _cmd.awards[i];
					
				}
			}
			
			_ui.infoPanelUI.gateTf.text = "" + (_cmd.data.currentLevel-1);
			
			//fullfillNinjaUI(_ui.infoPanelUI.playerExp);
		}
		
		/*private function fullfillNinjaUI(ui:MovieClip):void
		{
			var img:Image = new Image;
			var ninjaCfgInfo:NinjaInfoCFG = NinjaInfoConfig.getNinjaCfgInfo(ApplicationData.singleton.selfInfo.ninja);
			var ninjaName:String;
			
			img = new Image(50,50);
			ui.imgPos.addChild(img);
			img.load(NinjaAssetDef.getAsset(NinjaAssetDef.HEAD_SMALL, ninjaCfgInfo.id));
			
			ui.ninjaName.htmlText = "<b>" + ApplicationData.singleton.selfInfo.name + "</b>";
			
			ui.level.htmlText = "<b>" + ApplicationData.singleton.selfInfo.level + "</b>";
			
			//var newExp:int = ninjaExpInfo.afterExp;
			//var toNinjaLevelInfo:NinjaLevelInfo = NinjaInfoConfig.getNinjaLevelInfo(ninjaCfgInfo.levelType, ninjaExpInfo.afterLevel);
			var ninjaLevelInfo:NinjaLevelInfo = NinjaInfoConfig.getNinjaLevelInfo(ninjaCfgInfo.levelType, ApplicationData.singleton.selfInfo.level);
			//var upgradeLevel:int = toNinjaLevelInfo.level - ninjaLevelInfo.level;

			setProcessBar(ui.expProc.expProc, ui.expProc.expProcBg, 0, ninjaLevelInfo.upgradeExp, ApplicationData.singleton.selfInfo.exp);
			
			//setProcessBar(ui.addExpProc.expProc, ui.addExpProc.expProcBg, 0, toNinjaLevelInfo.upgradeExp, newExp);
			
			//if ((ninjaExpInfo.afterLevel - ninjaExpInfo.level) > 0 || (ninjaExpInfo.afterExp - ninjaExpInfo.exp) > 0)
			//{
				//doTween(ui, upgradeLevel, toNinjaLevelInfo, newExp);
			//}
			//else
			//{
				//upgradeTweenComplete();
			//}	
		}
		private function setProcessBar(thumb:MovieClip, bg:MovieClip, min:int, max:int, value:int):void
		{
			thumb.width = bg.width * (value - min) / (max - min) ;
		}
		*/
		
		public function destroy():void
		{
			if(_nextBt)
			{
				_nextBt.removeEventListener(MouseEvent.CLICK, onButtonClick);
			}
			
			if(_getOutBt)
			{
				_getOutBt.removeEventListener(MouseEvent.CLICK, onButtonClick);
			}
		}
		
		private function onButtonClick(e:Event):void 
		{
			if (e.currentTarget == _nextBt) {
				new GotoNextFightCommand(_cmd.levelData.battleId).call();
			}else if(e.currentTarget == _getOutBt) {
				new DestroyBattleCommand(true).call();
			}
		}
		
		public function get ui():MovieClip 
		{
			return _ui;
		}															
		public function autoSetNull():void
		{

			_nextBt = null;
			_getOutBt = null;
			_cb_next = null;
			_cb_exit = null;
			_ui = null;
			_cmd = null;
		}
	}

}