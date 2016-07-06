package com.tencent.morefun.naruto.plugin.battle.view
{

	import com.tencent.morefun.naruto.plugin.battle.data.UIPlayerData;
	import com.tencent.morefun.naruto.plugin.battle.event.UIDataEvent;
	import com.tencent.morefun.naruto.plugin.exui.base.Image;
	import com.tencent.morefun.naruto.plugin.ui.tips.TipsManager;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.filters.ColorMatrixFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import def.NinjaAssetDef;
	import def.TipsTypeDef;
	
	import user.data.UserInfo;

	public class MainPlayerView
	{
		private static var disOnlineFilter:ColorMatrixFilter = new ColorMatrixFilter([0.33, 0.33, 0.33, 0, 0,
			0.33, 0.33, 0.33, 0, 0,
			0.33, 0.33, 0.33, 0, 0,
			0, 0, 0, 1, 0]);
		
		private var res:MovieClip;
		
		private var hp:HpBar;
		private var mp:MpBar;
		private var head:Image;
		private var lvText:TextField;
		
		private var player:UIPlayerData;
		
		
		public function MainPlayerView(res:MovieClip)
		{
			hp = new HpBar(res["hp"]);
			mp = new MpBar(res["mp"], res["fire"]);
			
			lvText = res["levelContainer"]["LvNum"];
			
			head = new Image();
			res["head"]["container"].addChild(head);
			head.x = -res["head"]["container"].width / 2;
			head.y = -res["head"]["container"].height / 2;
			
			this.res = res;
			
			var textFormat:TextFormat;
			textFormat = lvText.defaultTextFormat;
			textFormat.bold = true;
			lvText.defaultTextFormat = textFormat;
		}
		
		public function setHpType(value:int):void
		{
			hp.setHpType(value);
		}
		
		public function clearHead():void
		{
			head.dispose();
		}
		
		public function setPlayer(value:UIPlayerData):void
		{
			if(player)
			{
				player.removeEventListener(UIDataEvent.ADD_NINJA, onAddNinja);
				player.removeEventListener(UIDataEvent.BASE_INFO_UPDATE, onPlayerUpdate);
				player.removeEventListener(UIDataEvent.MAIN_NINJA_UPDATE, onMainNinjaUpdate);
				player.removeEventListener(UIDataEvent.ONLINE_INFO_UPDATE, onUpdateOnlineInfo);
				player.removeEventListener(UIDataEvent.UPDATE_ALL, onUpdateAll);
			}
			
			player = value;
			if(player == null)
			{
				hp.zeroValue();
				mp.zeroValue();
				TipsManager.singleton.unbinding(tipsArea, TipsTypeDef.BATTLE_PLAYER);
				return ;
			}
			
			this.lvText.text = value.level.toString();
			if(value.isLeft == false){
				this.levelContainer.scaleX = -1;
			}
			
			update();
			updateHeadImageUrl();
			setOnline(player.isOnline);
			TipsManager.singleton.binding(tipsArea, player, TipsTypeDef.BATTLE_PLAYER);
			
			player.addEventListener(UIDataEvent.ADD_NINJA, onAddNinja);
			player.addEventListener(UIDataEvent.BASE_INFO_UPDATE, onPlayerUpdate);
			player.addEventListener(UIDataEvent.MAIN_NINJA_UPDATE, onMainNinjaUpdate);
			player.addEventListener(UIDataEvent.ONLINE_INFO_UPDATE, onUpdateOnlineInfo);
			player.addEventListener(UIDataEvent.UPDATE_ALL, onUpdateAll);
		}
		
		private function onUpdateAll(evt:UIDataEvent):void
		{
			this.lvText.text = player.level.toString();
			if(player.isLeft == false){
				this.levelContainer.scaleX = -1;
			}
			
			update();
			updateHeadImageUrl();
			setOnline(player.isOnline);
		}
		
		public function getPlayer():UIPlayerData
		{
			return player;
		}
		
		public function destroy():void
		{
			hp.destory();
			mp.destroy();
			
			if(head.parent){head.parent.removeChild(head)};
			head.dispose();
			head = null;
			
			TipsManager.singleton.unbinding(tipsArea, TipsTypeDef.BATTLE_PLAYER);
			if(player != null)
			{
				player.removeEventListener(UIDataEvent.ADD_NINJA, onAddNinja);
				player.removeEventListener(UIDataEvent.BASE_INFO_UPDATE, onPlayerUpdate);
				player.removeEventListener(UIDataEvent.MAIN_NINJA_UPDATE, onMainNinjaUpdate);
				player.removeEventListener(UIDataEvent.ONLINE_INFO_UPDATE, onUpdateOnlineInfo);
				player.removeEventListener(UIDataEvent.UPDATE_ALL, onUpdateAll);
			}
		}
		
		private function onAddNinja(evt:UIDataEvent):void
		{
			updateHeadImageUrl();
		}
		
		private function onMainNinjaUpdate(evt:UIDataEvent):void
		{
			updateHeadImageUrl();
		}
		
		private function onUpdateOnlineInfo(evt:UIDataEvent):void
		{
			setOnline(player.isOnline);
		}
		
		private function setOnline(value:Boolean):void
		{
			if(value == false)
			{
				head.filters = [disOnlineFilter];
			}
			else
			{
				head.filters = [];
			}
		}
		
		private function updateHeadImageUrl():void
		{
			var headId:int;
			var headImageUrl:String;
			
			if((player as UIPlayerData).isLeft == false)
			{
				res["head"]["container"].scaleX = -1;
			}
			
			headId = player.getHeadId();
			if(headId != -1)
			{
				headImageUrl = NinjaAssetDef.getAsset(NinjaAssetDef.HEAD_BIG, player.getHeadId());
				head.load(headImageUrl);
			}
			else
			{
				head.dispose();
			}
		}
		
		private function onPlayerUpdate(evt:UIDataEvent):void
		{
			update();
		}
		
		private function update():void
		{
			hp.update(player.hp, player.hpMax);
			mp.update(Math.max(0, player.mp), player.mpMax);
			
			if((player.hp / player.hpMax) < 0.2 && player.hp != 0 && (player as UIPlayerData).isLeft)
			{
				hp.showWarn();
			}
			else
			{
				hp.hideWarn();
			}
			
			hpText.text = player.hp + "/" + player.hpMax;
			mpText.text = player.mp + "/" + player.mpMax;
		}
		
		private function get levelContainer():DisplayObject
		{
			return res["levelContainer"];
		}
		
		private function get hpText():TextField
		{
			return res["hptxt"]["txt"];
		}
		
		private function  get mpText():TextField
		{
			return res["mptxt"]["txt"];
		}
		
		private function get tipsArea():DisplayObject
		{
			return res["tips"];
		}
																
		public function autoSetNull():void
		{

			disOnlineFilter = null;
			res = null;
			hp = null;
			mp = null;
			head = null;
			lvText = null;
			player = null;
		}
	}
}