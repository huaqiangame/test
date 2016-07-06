package com.tencent.morefun.naruto.plugin.player.effects
{
	import com.greensock.TweenLite;
	import com.tencent.morefun.naruto.plugin.player.players.BasePlayer;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import ui.newplot.ActorAppearAni2;
	import ui.newplot.ActorAppearAni3;

    import com.tencent.morefun.naruto.i18n.I18n;
	public class EntryEffect
	{
		private var npc:BasePlayer;
		private var apperFun:Function;
		private var doneFun:Function;
		
		public function EntryEffect()
		{
			
		}
		
		public function play(npc:BasePlayer,type:int,apperFun:Function,doneFun:Function=null):void
		{
			this.npc = npc;
			this.apperFun = apperFun;
			this.doneFun = doneFun;
			
			
			if(type == 1)//淡入
			{
				npc.alpha = 0;
				TweenLite.to(npc,1.5,{alpha:1,onComplete:complete});
			}else if(type == 2)//冒烟
			{
				if(npc.parent)
				{
//					npc.alpha = 0;
					var ani2:ActorAppearAni2 = new ActorAppearAni2();
					ani2.addEventListener("appear",onAni);
					ani2.addEventListener("done",onAni);
					ani2.x = npc.x;
					ani2.y = npc.y + 1;
					
					npc.parent.addChild(ani2);
				}else
				{
//					throw new Error("npc入场冒烟特效播放失败");
					apperFun && apperFun();
					complete();
				}
			}else if(type == 3)//水分身
			{
				if(npc.parent)
				{
					npc.alpha = 0;
					var ani3:ActorAppearAni3 = new ActorAppearAni3();
					ani3.addEventListener("appear",onAni);
					ani3.addEventListener("done",onAni);
					ani3.x = npc.x;
					ani3.y = npc.y + 1;
					
					npc.parent.addChild(ani3);
				}else
				{
					throw new Error(I18n.lang("as_player_1451031576_5278"));
				}
			}else
			{
				throw new Error(I18n.lang("as_player_1451031576_5279")+type);
			}
		}
		
		protected function onAni(event:Event):void
		{
			switch(event.type)
			{
				case "appear":
//					npc.alpha = 1;
					apperFun && apperFun();
					break;
				case "done":
					var ani:MovieClip = event.currentTarget as MovieClip;
					ani.removeEventListener("appear",onAni);
					ani.removeEventListener("done",onAni);
					if(ani.parent)
					{
						ani.parent.removeChild(ani);
					}
					complete();
					break;
			}
		}
		
		private function complete(event:Event=null):void
		{
			doneFun && doneFun();
			destroy();
		}
		
		public function destroy():void
		{
			npc = null;
			apperFun = null;
			doneFun = null;
		}
	}
}