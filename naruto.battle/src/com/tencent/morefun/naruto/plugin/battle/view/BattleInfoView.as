package com.tencent.morefun.naruto.plugin.battle.view
{
	
	import com.greensock.TweenLite;
	import com.tencent.morefun.naruto.plugin.battle.data.BattleData;
	import com.tencent.morefun.naruto.plugin.battle.data.BattleTypeGroup;
	import com.tencent.morefun.naruto.plugin.battle.data.UIData;
	import com.tencent.morefun.naruto.plugin.motion.IMotionNotifyReceiver;
	import com.tencent.morefun.naruto.plugin.motion.MotionNotifyCenter;
	import com.tencent.morefun.naruto.plugin.motion.notice.MoneyUpdateNotice;
	import com.tencent.morefun.naruto.plugin.motion.notice.NinjaDeadNotice;
	import com.tencent.morefun.naruto.plugin.motion.notice.base.BaseNotice;
	import com.tencent.morefun.naruto.plugin.ui.base.NumberBitmapText;
	import com.tencent.morefun.naruto.plugin.ui.base.NumberBitmapTextStyle;
	import com.tencent.morefun.naruto.plugin.ui.util.DisplayUtils;
	import com.tencent.morefun.naruto.plugin.ui.util.TextFieldUtil;
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.getQualifiedClassName;
	
	
	
	
    import com.tencent.morefun.naruto.i18n.I18n;
	public class BattleInfoView implements IMotionNotifyReceiver
	{
		public var res:MovieClip;
		private var resPosition:Point;
		private var numberBitmap:NumberBitmapText;
		
		public function BattleInfoView(res:MovieClip)
		{
			this.res = res;
			init();
		}
		
		private function init():void
		{
			curFood = 0;
			curMomey = 0;
			
			if(BattleTypeGroup.isShowMoneyType(BattleData.singleton.fightType, BattleData.singleton.subFightType))
			{
				res.gotoAndStop("special_money");
				
				resPosition = new Point(res.x, res.y);
				numberBitmap = new NumberBitmapText(NumberBitmapTextStyle.STYLE_2);
				DisplayUtils.replaceDisplay(res["moneyArea"], numberBitmap);
				numberBitmap.text = "0";
				MotionNotifyCenter.add(this);
				
				return ;
			}
			
			if(BattleTypeGroup.isShowFoodType(BattleData.singleton.fightType, BattleData.singleton.subFightType))
			{
				res.gotoAndStop("special_food");
				
				resPosition = new Point(res.x, res.y);
				numberBitmap = new NumberBitmapText(NumberBitmapTextStyle.STYLE_2);
				DisplayUtils.replaceDisplay(res["foodArea"], numberBitmap);
				numberBitmap.text = "0";
				MotionNotifyCenter.add(this);
				
				return ;
			}
			
			
			res.gotoAndStop("default");
			TextFieldUtil.replaceTextField(describe, TextFieldAutoSize.LEFT, true);
			resPosition = new Point(res.x, res.y);
			describe.wordWrap = false;
			describe.multiline = false;
		}
		
		public function updateMoneyNow():void
		{
			TweenLite.killTweensOf(this);
			if(numberBitmap)
			{
				//				numberBitmap.text = MomeyStringUtil.getMomeyStr(destMoney);
				numberBitmap.text = destMoney.toString();
			}
		}
		
		public var curMomey:int;
		public var destMoney:int;
		public var curFood:int;
		public function receive(notice:BaseNotice):void
		{
			switch(getQualifiedClassName(notice))
			{
				case getQualifiedClassName(MoneyUpdateNotice):
					if(BattleTypeGroup.isShowMoneyType(BattleData.singleton.fightType, BattleData.singleton.subFightType))
					{
						if(UIData.singleton.isOurNinjaPos((notice as MoneyUpdateNotice).pos) == false)
						{
							changedMomey((notice as MoneyUpdateNotice).money);
						}
					}
					break;
				
				case getQualifiedClassName(NinjaDeadNotice):
					if(BattleTypeGroup.isShowFoodType(BattleData.singleton.fightType, BattleData.singleton.subFightType))
					{
						if(UIData.singleton.isOurNinjaPos((notice as NinjaDeadNotice).pos) == false)
						{
							addFood();
						}
					}
					break;
			}
		}
		
		private function changedMomey(money:int):void
		{
			var to:int;
			
			if(money > 0)
			{
				curMomey = destMoney;
				onUpdateMomey();
				
				to  = curMomey + money;
				destMoney = to;
				TweenLite.killTweensOf(this);
				TweenLite.to(this, 0.2, {curMomey:to, onUpdate:onUpdateMomey});
			}
		}
		
		private function addFood():void
		{
			curFood += 2;
			numberBitmap.text = curFood.toString();
		}
		
		private function onUpdateMomey():void
		{
			//			numberBitmap.text = MomeyStringUtil.getMomeyStr(curMomey);
			numberBitmap.text = curMomey.toString();
		}
		
		public function destroy():void
		{
			if(numberBitmap){numberBitmap.destroy();}
			res = null;
		}
		
		public function show():void
		{
			res.visible = true;
		}
		
		public function hide():void
		{
			res.visible = false;	
		}
		
		public function minFrameSizePosition():void
		{
			res.y = resPosition.y;
		}
		
		public function normalFrameSizePosition():void
		{
			res.y = resPosition.y - 40;
		}
		
		public function updateEndInfo(curWave:int, totalWave:int, endCondition:String, endTipsModel:int):void
		{
			if(endTipsModel == 1)
			{
				describe.htmlText = I18n.lang("as_battle_1451031565_372_0") + curWave + "/" + totalWave + I18n.lang("as_battle_1451031565_372_1");
			}
			
			if(endCondition != "")
			{
				describe.htmlText += "\n" + endCondition;
			}
			
			describe.x = (background.width - describe.width) / 2 + 2; 
			describe.y = (background.height - describe.height) / 2 + 5;
		}
		
		public function updateMomeyInfo(value:int):void
		{
			
		}
		
		public function get describe():TextField
		{
			return res["describe"];
		}
		
		public function get background():MovieClip
		{
			return res["background"];
		}
		
		public function autoSetNull():void
		{
			
			res = null;
			resPosition = null;
			numberBitmap = null;
		}
	}
}