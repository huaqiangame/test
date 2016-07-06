package com.tencent.morefun.naruto.plugin.battle.command
{
	import battle.command.BattleCommand;

	public class ShowPrewarChooseCommand extends BattleCommand
	{
		public var choose:int;//0表示不做战前准备直接开打,1表示进入战前准备
		public var isControl:Boolean;
		public var enableChoose:Boolean;//0表示这场战斗没有配战前准备,1表示配了
		public var enableClick:Boolean;//是否可点击
		public function ShowPrewarChooseCommand()
		{
			super();
		}
																
		override public function autoSetNull():void
		{
			if(super.hasOwnProperty("autoSetNull"))
			{
				super["autoSetNull"]();
			}

		}
	}
}