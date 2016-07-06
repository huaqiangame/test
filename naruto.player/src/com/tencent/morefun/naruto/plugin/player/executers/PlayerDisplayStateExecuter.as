package com.tencent.morefun.naruto.plugin.player.executers
{
	import com.tencent.morefun.naruto.plugin.player.models.PlayerModel;
	import com.tencent.morefun.naruto.util.KeyboardManager;
	
	import base.NarutoExecuter;
	
	import def.ExecuterDef;
	import def.PluginDef;
	
	import user.def.UserInfoChangeReasonDef;
	import user.def.UserInfoKeyDef;
	import user.event.UserInfoEvent;
	
	public class PlayerDisplayStateExecuter extends NarutoExecuter
	{
		public function PlayerDisplayStateExecuter()
		{
			super(PluginDef.PLAYER, ExecuterDef.PLAYER_DISPLAY_STATE);
			
			this.selfInfo.addEventListener(UserInfoEvent.BASE_CHANGED, onSelfInfo);
			
//			KeyboardManager.singleton.addKeyboardListener("hp",function():void{
//				playerModel.selfPlayer.showHpChanged(-Math.random()*100);
//			});
//			KeyboardManager.singleton.addKeyboardListener("mp",function():void{
//				playerModel.selfPlayer.showMpChanged(Math.random()*100);
//			});
		}
		
		protected function onSelfInfo(event:UserInfoEvent):void
		{
			switch(event.changedValueKey)
			{
				case UserInfoKeyDef.HP:
					if(event.changedReason == UserInfoChangeReasonDef.INTERACT_NPC
					|| event.changedReason == UserInfoChangeReasonDef.MAP_PITFALL
					)
					{
						playerModel.selfPlayer.showHpChanged(event.changedValue);
					}
					break;
				case UserInfoKeyDef.MP:
					if(event.changedReason == UserInfoChangeReasonDef.INTERACT_NPC)
					{
						playerModel.selfPlayer.showMpChanged(event.changedValue);
					}
					break;
                case UserInfoKeyDef.STRENGTH:
//                    if (event.changedValue > 0)
//                        playerModel.selfPlayer.showStrengthChanged(event.changedValue);
                    break;
			}
		}
		
		private var _playerModel:PlayerModel;
		private function get playerModel():PlayerModel
		{
			this._playerModel = this._playerModel || plugin.retrieveModel(PlayerModel.NAME) as PlayerModel;
			return this._playerModel;
		}
		
	}
}