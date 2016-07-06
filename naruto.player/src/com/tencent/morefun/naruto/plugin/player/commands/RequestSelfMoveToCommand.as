package com.tencent.morefun.naruto.plugin.player.commands
{
	import flash.geom.Point;
	
	import player.commands.BasePlayerCommand;
	
	public class RequestSelfMoveToCommand extends BasePlayerCommand
	{
		public var beginPixcel:Point;
		public var moveToPixcels:Array;
		
		public function RequestSelfMoveToCommand(beginPixcel:Point,moveToPixcels:Array)
		{
			super();
			
			this.beginPixcel = beginPixcel;
			this.moveToPixcels = moveToPixcels;
		}
	}
}