package com.tencent.morefun.naruto.plugin.player.views
{
	import com.greensock.TweenLite;
	import com.tencent.morefun.naruto.plugin.ui.layer.LayoutManager;
	import com.tencent.morefun.naruto.plugin.ui.layer.def.LayerDef;
	import com.tencent.morefun.naruto.plugin.ui.layer.def.LocationDef;
	import com.tencent.morefun.naruto.util.DisplayUtil;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import ui.player.AutoFindingAni;
	
	public class AutoFindingAniView extends Sprite
	{
		private const offsetPoint:Point = new Point(0,100);
		private var ani:AutoFindingAni;
		public function AutoFindingAniView()
		{
			super();
			mouseChildren = false;
			mouseEnabled = false;
		}
		
		public function show():void
		{
			if(ani == null)
			{
				ani = new AutoFindingAni();
				addChild(ani);
			}
			DisplayUtil.startMovieClip(this.ani);
			ani.alpha = 0;
			TweenLite.to(ani,0.2,{alpha:1});
			if(parent == null)
			{
				LayoutManager.singleton.addItemAndLayout(this, LayerDef.TIPS, LocationDef.TOPCENTRE, this.offsetPoint, false);
			}
		}
		
		public function hide():void
		{
			if(ani)
			{
				DisplayUtil.stopMovieClip(this.ani);
				TweenLite.to(ani,0.2,{alpha:0,onComplete:onHideComplete});
			}
		}
		
		private function onHideComplete():void
		{
			if(parent)
			{
				parent.removeChild(this);
			}
		}
	}
}