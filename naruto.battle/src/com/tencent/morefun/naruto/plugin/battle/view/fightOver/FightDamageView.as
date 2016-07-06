package com.tencent.morefun.naruto.plugin.battle.view.fightOver
{
	import com.tencent.morefun.naruto.plugin.battle.view.fightOver.damage.DamageInfo;
	import com.tencent.morefun.naruto.plugin.battle.view.fightOver.damage.DamageModelDef;
	import com.tencent.morefun.naruto.plugin.battle.view.fightOver.damage.DamageNinjaInfo;
	import com.tencent.morefun.naruto.plugin.battle.view.fightOver.damage.DamagePlayerInfo;
	import com.tencent.morefun.naruto.plugin.ui.box.BaseBox;
	import ninja.model.data.NinjaInfo;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import base.ApplicationData;
	
	import naruto.battle.ui.FightDamageStatisticsUI;
	import naruto.component.controls.ButtonNormalBlue;
	import naruto.component.controls.TabBar_1;
	
	public class FightDamageView extends BaseBox
	{
		private var damageInfo:DamageInfo;
		private var ourRenderList:Array = [];
		private var theirRenderList:Array = [];
		private var curModel:int = DamageModelDef.DAMAGE;
		private var _teamListView:DamageTeamListView;
		
		public function FightDamageView()
		{
			super(new FightDamageStatisticsUI(), true, true);
			
			initUI();
		}
		
		public function initUI():void
		{
			this.closeButton = this.content["close"];
			
			tab.addEventListener(Event.CHANGE, onTabChanged);
			ok.addEventListener(MouseEvent.CLICK, onOkClick);
			_teamListView = new DamageTeamListView(this.content["teamListUI"]);
			onTabChanged(null);
		}
		
		private function onTabChanged(evt:Event):void
		{
			var damageInfoRender:DamageInfoRender;
			
			if(tab.selectedIndex == 0)
			{
				curModel = DamageModelDef.DAMAGE;
				ourDamageLabel.gotoAndStop("damage");
				theirDamageLabel.gotoAndStop("damage");
			}
			else
			{
				curModel = DamageModelDef.AFFORD_DAMAGE;
				ourDamageLabel.gotoAndStop("affordDamage");
				theirDamageLabel.gotoAndStop("affordDamage");
			}
			
			_teamListView.changeTab(curModel);
			
		}
		
		public function update(damageInfo:DamageInfo):void
		{
			var i:int = 0;
			var pi:DamagePlayerInfo;
			
			
			this.damageInfo = damageInfo;
			
			if(damageInfo == null){return ;}
			
			var t:Array, m:Array, b:Array;
			
			t = [];
			m = [];
			b = [];
			
			for(i = 0;i < damageInfo.damagePlayerInfos.length;i ++)
			{
				pi = damageInfo.damagePlayerInfos[i];
				if (pi.teamPos == 4 || pi.teamPos == 5) {
					t.push(pi);
				}else if (pi.teamPos == 0 || pi.teamPos == 1) {
					m.push(pi);
				}else if (pi.teamPos == 2 || pi.teamPos == 3) {
					b.push(pi);
				}
			}
			var datas:Array = [];
			if (t.length > 0) {
				datas.push(t);
			}
			if (m.length > 0) {
				datas.push(m);
			}
			if (b.length > 0) {
				datas.push(b);
			}
			_teamListView.setDatas(datas);
			_teamListView.changeTab(curModel);
		}
		
		
		private function onOkClick(evt:MouseEvent):void
		{
			this.close();
		}
		
		override public function destroy():void
		{
			if(content){
				this.close();
				tab.removeEventListener(Event.CHANGE, onTabChanged);
				ok.removeEventListener(MouseEvent.CLICK, onOkClick);
				super.destroy();
			}
			_teamListView.finalize();
		}
		
		public function get tab():TabBar_1
		{
			return this.content["tab"];
		}
		
		public function get ok():ButtonNormalBlue
		{
			return this.content["ok"];
		}
		
		public function get ourDamageLabel():MovieClip
		{
			return this.content["ourDamageLabel"];
		}
		
		public function get theirDamageLabel():MovieClip
		{
			return this.content["theirDamageLabel"];
		}
	}
}