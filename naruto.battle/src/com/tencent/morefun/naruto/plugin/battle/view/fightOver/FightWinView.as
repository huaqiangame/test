package com.tencent.morefun.naruto.plugin.battle.view.fightOver 
{

	import battle.command.ShowDamageViewCmd;
	import com.tencent.morefun.naruto.plugin.battle.command.DestroyBattleCommand;
	
	import flash.display.MovieClip;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import naruto.component.controls.ButtonNormalBlue;
	
	import sound.commands.PlayUISoundCommand;
	import sound.def.UISoundDef;
	
	import ui.battle.FightWinUI;

	public class FightWinView 
	{
		private var isShowDamage:Boolean;
		
		private var defaultOkButton:ButtonNormalBlue;
		private var okButton:ButtonNormalBlue;
		private var showDamage:ButtonNormalBlue;
		
		private var _ui:MovieClip;
		public function FightWinView(isShowDamage:Boolean) 
		{
			this.isShowDamage = isShowDamage;
			
			_ui = new FightWinUI();
			_ui.gotoAndPlay(1);
			new PlayUISoundCommand(UISoundDef.BATTLE_WIN).call();
			
			_ui.addEventListener(Event.COMPLETE, onShowBtn);
			_ui.addFrameScript(_ui.totalFrames - 1, onPlayEnd);
		}
		
		private function onShowBtn(evt:Event):void
		{
			showDamage = _ui.showDamage;
			okButton = _ui.okButton;
			defaultOkButton = _ui.defaultOkButton;
			
			if(isShowDamage)
			{
				okButton.visible = true;
				showDamage.visible = true;
				defaultOkButton.visible = false;
			}
			else
			{
				okButton.visible = false;
				showDamage.visible = false;
				defaultOkButton.visible = true;
			}
			
			showDamage.addEventListener(MouseEvent.CLICK, onShowDamageClick);
			okButton.addEventListener(MouseEvent.CLICK, onButtonClick);
			defaultOkButton.addEventListener(MouseEvent.CLICK, onButtonClick);
		}
		
		private function onPlayEnd():void
		{
			_ui.stop();
		}
		
		private function onButtonClick(e:Event):void 
		{
			new DestroyBattleCommand(true).call();
		}
		
		private function onShowDamageClick(e:Event):void
		{
			new ShowDamageViewCmd().call();
		}
		
		public function destroy():void
		{
			_ui.removeEventListener(Event.COMPLETE, onShowBtn);
			if(showDamage){showDamage.removeEventListener(MouseEvent.CLICK, onShowDamageClick);}
			
			if(okButton){okButton.removeEventListener(MouseEvent.CLICK, onButtonClick);}
			if(defaultOkButton){defaultOkButton.removeEventListener(MouseEvent.CLICK, onButtonClick);}
		}
		
		public function get ui():MovieClip 
		{
			return _ui;
		}
		
		public function autoSetNull():void
		{

			_ui = null;
		}
	}

}