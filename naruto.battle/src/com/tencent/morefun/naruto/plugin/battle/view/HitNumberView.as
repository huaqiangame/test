package com.tencent.morefun.naruto.plugin.battle.view
{
	import com.greensock.easing.Linear;
	import com.tencent.morefun.naruto.plugin.ui.base.BitmapText;
	import com.tencent.morefun.naruto.plugin.ui.util.TweenManager;
	
	import flash.display.Sprite;
	import ui.battle.HitNumber1;
	import ui.battle.HitNumber2;
	import ui.battle.HitNumber3;
	import ui.battle.HitNumber4;
	import ui.battle.HitNumberUI;
	
	

	public class HitNumberView extends Sprite
	{
//		public var isLeft:Boolean;
		private var viewUI:HitNumberUI;
		private var value:int;
		private var nums:Array = new Array(4); 
		private var numsIndex:int = 0; 
		
		public function HitNumberView()
		{
			super();
			
			viewUI = new HitNumberUI();
			viewUI.gotoAndStop(1);
//			addChild(viewUI);
			
//			num = new BitmapText(new HitNumber1(),53,77,0,false,"1234567890A");
//			num.text = value.toString();
//			
//			viewUI.num.addChild(num);
			mouseChildren = mouseEnabled = false;
		}
		
		public function setValue(v:int):void
		{
			if(v==this.value)
			{
				return;
			}
			this.value = v;
			this.tov = v;
			if(v<2)
			{
				if(contains(viewUI))
				{
					removeChild(viewUI);
				}
				return;
			}
			update();
			viewUI.gotoAndPlay(1);
		}
		
		public var tov:int;
		
		public function to(toValue:int):void
		{
			var n:int = Math.min(5,toValue - value);
			TweenManager.killTweensOf(this);
			if(n>1)
			{
				setValue(tov+1);
				TweenManager.addTweenTo(this,n*0.1,{tov:toValue,onUpdate:function():void{
					setValue(tov);
				},ease:Linear.easeNone});
			}else
			{
				setValue(toValue);
			}
		}
		
//		public function add(v:int):void
//		{
//			setValue(value + v);
//		}
		
		public function clear():void
		{
			value = 0;
			update();
		}
		
		private function update():void
		{
			if(value==0)
			{
//				this.num.text = "";
				if(contains(viewUI))
				{
					removeChild(viewUI);
				}
			}else
			{
				if(!contains(viewUI))
				{
					addChild(viewUI);
				}
				viewUI.bg1.visible = value<=49;
				viewUI.bg2.visible = value>49;
				viewUI.light.visible = value>49;
				if(value<=3)
				{
					numsIndex = 0;
				}else if(value <= 8)
				{
					numsIndex = 1;
				}else if(value <= 49)
				{
					numsIndex = 2;
				}else
				{
					numsIndex = 3;
				}
				
				if(!nums[numsIndex])
				{
					createNum(numsIndex);
				}
				nums[numsIndex].text = value + "A";
				viewUI.num.removeChildren();
				viewUI.num.addChild(nums[numsIndex]);
				nums[numsIndex].x = -nums[numsIndex].width / 2;
				nums[numsIndex].y = -nums[numsIndex].height / 2;
			}
		}
		
		private function createNum(numsIndex:int):void
		{
			switch(numsIndex)
			{
				case 0:
					nums[numsIndex] = new BitmapText(new HitNumber1(),53,77,0,false,"1234567890A");
					break;
				case 1:
					nums[numsIndex] = new BitmapText(new HitNumber2(),56,82,0,false,"1234567890A");
					break;
				case 2:
					nums[numsIndex] = new BitmapText(new HitNumber3(),60,87,0,false,"1234567890A");
					break;
				case 3:
					nums[numsIndex] = new BitmapText(new HitNumber4(),63,92,0,false,"1234567890A");
					break;
			}
		}
		
		public function destroy():void
		{
			TweenManager.killTweensOf(this);
			viewUI.stop();
			if(viewUI.parent)
			{
				viewUI.parent.removeChild(viewUI);
			}
			viewUI = null;
			
			for each (var num:BitmapText in nums)
			{
				if(num)
				{
					if(num.parent)
					{
						num.parent.removeChild(num);
					}
					num.destroy();
				}
			}
			nums = null;
		}
																
		public function autoSetNull():void
		{

			viewUI = null;
			nums = null;
		}
	}
}