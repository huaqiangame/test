package naruto.component.controls
{
	import naruto.component.core.InvalidationType;
	import naruto.component.core.UIComponent;
	
	public class AvatarBackground_1 extends UIComponent
	{
		public function AvatarBackground_1()
		{
			super();
		}
		
		protected var _hasAvatar:Boolean = true;
		
		[Inspectable(defaultValue=true, verbose=1)]
		public function get hasAvatar():Boolean
		{
			return _hasAvatar;
		}
		
		public function set hasAvatar(value:Boolean):void
		{
			if (_hasAvatar == value)
			{
				return;
			}
			_hasAvatar = value;
			this.invalidate(InvalidationType.STATE);
		}
		
		override protected function draw():void
		{
			if (this.isInvalid(InvalidationType.STATE))
			{
				this.gotoAndStop(this.hasAvatar ? 1 : 2);
			}
			super.draw();
		}
		
		
		override public function dispose():void
		{
			// 事件
			
			// 置空
			
			super.dispose();
		}
		
	}
}