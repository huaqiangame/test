package com.tencent.morefun.naruto.plugin.battle.messageConverter
{

	import com.tencent.morefun.naruto.plugin.battle.data.BattleData;
	import com.tencent.morefun.naruto.plugin.battle.data.UIData;
	import com.tencent.morefun.naruto.plugin.battle.data.UINinjaData;
	import com.tencent.morefun.naruto.plugin.battle.data.UIPlayerData;
	import com.tencent.morefun.naruto.plugin.motion.manager.scene.SceneConfig;
	
	import base.ApplicationData;
	
	import serverProto.fight.ProtoNinja;
	import serverProto.fight.ProtoPlayerTeamPos;
	import serverProto.fight.ProtoTeamInfo;

	public class UIInfoConverte
	{
		public function UIInfoConverte()
		{
		}
		
		public static function updateUIData(playerInfo:ProtoPlayerTeamPos):void
		{
			var uiData:UIData;
			var player:UIPlayerData;
			var selfInLeft:Boolean;
			
			uiData = UIData.singleton;
			
			player = uiData.self;
			uiData.removePlayer(player);
			player.mp = playerInfo.kathaValue;
			player.teamId = playerInfo.teamId;
			player.hp = BaseConverter.getTotalNinjaHp(playerInfo.stageInfo.ninja);
			player.hpMax = BaseConverter.getTotalNinjaMaxHp(playerInfo.stageInfo.ninja);
			player.stageNinjaList = BaseConverter.getBaseNinjaInfoList(playerInfo.stageInfo.ninja);
			player.battlePower = playerInfo.combatPower;
			player.contractPetId = playerInfo.contractPetId;
			player.name = playerInfo.playerName;
			player.head = BattleData.singleton.userInfoProxy.ninja;
			
			uiData.self = player;
			uiData.addPlayer(player, true);
			
			selfInLeft = playerIsLeft(playerInfo.teamId);
			uiData.selfInLeft = selfInLeft;
			SceneConfig.selfInLeft = selfInLeft;
		}
		
		public static function convertUIData(playerInfo:ProtoPlayerTeamPos):UIData
		{
			var uiData:UIData;
			var player:UIPlayerData;
			var selfInLeft:Boolean;
			
			uiData = UIData.singleton;
			
			player = new UIPlayerData();
			player.uin = 0;
			player.mp = 0;
			player.teamId = -1;
			player.hp = 0;
			player.hpMax = 0;
			uiData.monster = player;
			
			player = new UIPlayerData();
			player.isLeft = true;
			player.uin = playerInfo.player.uin;
			player.mp = playerInfo.kathaValue;
			player.teamId = playerInfo.teamId;
			player.hp = BaseConverter.getTotalNinjaHp(playerInfo.stageInfo.ninja);
			player.hpMax = BaseConverter.getTotalNinjaMaxHp(playerInfo.stageInfo.ninja);
			player.stageNinjaList = BaseConverter.getBaseNinjaInfoList(playerInfo.stageInfo.ninja);
			player.battlePower = playerInfo.combatPower;
			player.contractPetId = playerInfo.contractPetId;
			player.name = playerInfo.playerName;
			player.head = BattleData.singleton.userInfoProxy.ninja;
			player.level = playerInfo.level;
			
			uiData.self = player;
			uiData.addPlayer(player, true);
			
			selfInLeft = playerIsLeft(playerInfo.teamId);
			uiData.selfInLeft = selfInLeft;
			SceneConfig.selfInLeft = selfInLeft;
			return uiData;
		}
		
		public static function creatWatchUIData(selfIsLeft:Boolean):UIData
		{
			var uiData:UIData;
			var player:UIPlayerData;
			
			uiData = UIData.singleton;
			
			player = new UIPlayerData();
			player.uin = 0;
			player.mp = 0;
			player.teamId = -1;
			player.hp = 0;
			player.hpMax = 0;
			uiData.monster = player;
			
			uiData.selfInLeft = selfIsLeft;
			SceneConfig.selfInLeft = selfIsLeft;
			return uiData;
		}
		
		public static function convertProtoTeamInfosToPlayerDataList(teamInfos:Array):Array
		{
			var player:UIPlayerData;
			var playerDataList:Array = [];
			
			for each(var teamInfo:ProtoTeamInfo in teamInfos)
			{
				player = new UIPlayerData();
				player.teamId = teamInfo.teamId;
				player.mp = teamInfo.kathaValue;
				player.ninjas = UIInfoConverte.converNinjaInfos(teamInfo.ninja);
				playerDataList.push(player);
			}
			
			return playerDataList;
		}
		
		public static function converNinjaInfos(protoNinjas:Array):Array
		{
			var uiNinjaData:UINinjaData;
			var uiNinjaList:Array;
			
			uiNinjaList = [];
			for each(var protoNinja:ProtoNinja in protoNinjas)
			{
				uiNinjaData = new UINinjaData();
				uiNinjaData.pos = protoNinja.pos;
				uiNinjaData.id = protoNinja.id;
				uiNinjaData.hp = protoNinja.hp;
				uiNinjaData.hpMax = protoNinja.maxHp;
				uiNinjaList.push(uiNinjaData);
			}
			
			return uiNinjaList;
		}
		
		private static function playerIsLeft(teamId:int):Boolean
		{
			if(teamId == 0 || teamId == 2 ||teamId == 4)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
																
		public function autoSetNull():void
		{

		}
	}
}