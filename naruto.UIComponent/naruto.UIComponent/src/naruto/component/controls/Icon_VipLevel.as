package naruto.component.controls 
{
	import flash.display.MovieClip;
	import naruto.component.core.InvalidationType;
	import naruto.component.core.UIComponent;
	/**
	 * ...
	 * @author fixer
	 */
	public class Icon_VipLevel extends UIComponent 
	{
		private var _vipLevel:int = 0;
		private var _qq3366Level:int = 0;
		
		private var _diamondType:int = 0;
		private var _diamondLevel:int = 0;
		private var _diamondCommon:Boolean = false;
		private var _diamondSuper:Boolean = false;
		private var _diamondYear:Boolean = false;
		private var _diamondQQ:Boolean = false;
		
		public var vip:MovieClip;
		public var diamondBlue:MovieClip;
		public var diamondYellow:MovieClip;
		public var diamondQQ:MovieClip;
		public var qq3366:MovieClip;
		
		private static const DIAMOND_WIDTH:int = 18;
		
		public function Icon_VipLevel() 
		{
			super();
			vip.stop();
			diamondBlue.stop();
			diamondYellow.stop();
			diamondQQ.stop();
			qq3366.stop();
			setSize(1, 16);
		}
		
		override protected function draw():void 
		{
			if (this.isInvalid(InvalidationType.STATE))
			{
				this.drawState();
			}
			super.draw();
		}
		
		private function drawState():void
		{
			vip.gotoAndStop(1 + vipLevel);
			diamondBlue.gotoAndStop(1);
			diamondYellow.gotoAndStop(1);
			diamondQQ.gotoAndStop(1);
			qq3366.gotoAndStop(qq3366Level?2:1);
			vip.x = 0;
			if (_diamondType == 0 || _diamondLevel == 0)
			{
				if (vipLevel == 0)
				{
					qq3366.x = 0;
				}else
				{
					qq3366.x = DIAMOND_WIDTH;;
				}
				return;
			}
			var mc:MovieClip;
			switch(_diamondType)
			{
				case 0://不显示钻标
					break;
				case 1://蓝钻
					mc = diamondBlue;
					break;
				case 2://黄钻
					mc = diamondYellow;
					break;
				case 3://会员
					mc = diamondQQ;
			}
			if (mc)
			{
				if (diamondSuper)
				{
					if (diamondYear)
					{
						mc.gotoAndStop(31 + _diamondLevel);
						vip.x = DIAMOND_WIDTH * 2;
					}else
					{
						mc.gotoAndStop(21 + _diamondLevel);
						vip.x = DIAMOND_WIDTH;
					}
				}else if (diamondCommon)
				{
					if (diamondYear)
					{
						mc.gotoAndStop(11 + _diamondLevel);
						vip.x = DIAMOND_WIDTH * 2;
					}else
					{
						mc.gotoAndStop(1 + _diamondLevel);
						vip.x = DIAMOND_WIDTH;
					}
				}
			}
			if (vipLevel == 0)
			{
				qq3366.x = vip.x;
			}else
			{
				qq3366.x = vip.x + DIAMOND_WIDTH;
			}
		}
		
		[Inspectable(defaultValue="0",category="Size")]
		public function get vipLevel():int 
		{
			return _vipLevel;
		}
		
		public function set vipLevel(value:int):void 
		{
			if (_vipLevel == value)
			{
				return;
			}
			_vipLevel = value;
			
			invalidate(InvalidationType.STATE);
			calcSize();
		}
		
		[Inspectable(defaultValue="0",category="Size")]
		public function get qq3366Level():int
		{
			return _qq3366Level;
		}
		public function set qq3366Level(value:int):void
		{
			if (_qq3366Level == value)
			{
				return;
			}
			_qq3366Level = value;
			invalidate(InvalidationType.STATE);
			calcSize();
		}
		
		[Inspectable(defaultValue=true, verbose=1)]
		public function get diamondYear():Boolean 
		{
			return _diamondYear;
		}
		
		public function set diamondYear(value:Boolean):void 
		{
			if (_diamondYear == value)
			{
				return;
			}
			_diamondYear = value;
			invalidate(InvalidationType.STATE);
			calcSize();
		}
		
		[Inspectable(defaultValue=true, verbose=1)]
		public function get diamondCommon():Boolean 
		{
			return _diamondCommon;
		}
		
		public function set diamondCommon(value:Boolean):void 
		{
			if(_diamondCommon == value)
			{
				return;
			}
			_diamondCommon = value;
			invalidate(InvalidationType.STATE);
			calcSize();
		}
		
		public function get diamondSuper():Boolean 
		{
			return _diamondSuper;
		}
		
		[Inspectable(defaultValue=true, verbose=1)]
		public function set diamondSuper(value:Boolean):void 
		{
			if (_diamondSuper == value)
			{
				return;
			}
			_diamondSuper = value;
			invalidate(InvalidationType.STATE);
			calcSize();
		}
		
		public function get diamondLevel():int 
		{
			return _diamondLevel;
		}
		
		[Inspectable(defaultValue="0",category="Size")]
		public function set diamondLevel(value:int):void 
		{
			if (_diamondLevel == value)
			{
				return;
			}
			_diamondLevel = value;
			invalidate(InvalidationType.STATE);
			calcSize();
		}
		
		public function get diamondType():int 
		{
			return _diamondType;
		}
		
		[Inspectable(defaultValue="0",category="Size")]
		public function set diamondType(value:int):void 
		{
			if (_diamondType == value)
			{
				return;
			}
			_diamondType = value;
			invalidate(InvalidationType.STATE);
			calcSize();
		}
		
		private function calcSize():void
		{
			var vipWidth:int = vipLevel == 0?1:16;
			var qq3366Width:int = qq3366Level == 0?0:16;
			if (diamondType == 0 || diamondLevel == 0 || !diamondSuper && !diamondCommon)
			{
				setSize(vipWidth + qq3366Width, startHeight);
				return;
			}
			if (diamondType == 1 || diamondType == 2 || diamondType == 3)
			{
				if (diamondYear)
				{
					return setSize(DIAMOND_WIDTH * 2 + vipWidth + qq3366Width, startHeight);
				}else
				{
					return setSize(DIAMOND_WIDTH + vipWidth + qq3366Width, startHeight);
				}
			}
		}
	}

}