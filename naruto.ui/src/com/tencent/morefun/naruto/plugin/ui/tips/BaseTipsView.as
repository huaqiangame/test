package com.tencent.morefun.naruto.plugin.ui.tips
{

	import com.tencent.morefun.naruto.plugin.ui.layer.LayoutManager;
	import flash.display.Sprite;

	public class BaseTipsView extends Sprite
	{
		protected var _data:Object;
		protected var _moveX:int;
		protected var _moveY:int;
		
		protected var _isShow:Boolean;

		public function BaseTipsView(skinCls:Class = null)
		{
			super();
		}

        public function destroy():void
        {
        }
		
		public function get isShow():Boolean
		{
			return _isShow;
		}
		
		public function doShow():void
		{
			_isShow = true;
			show();
		}
		
		/**
		 *显示tips 
		 * 
		 */		
		public function show():void
		{
			
		}
		
		public function doHide():void
		{
			_isShow = false;
			hide();
		}
		
		/**
		 *隐藏tips 
		 * 
		 */		
		public function hide():void
		{
			
		}
		
		public function preMove(x:int, y:int):void
		{
			_moveX = x;
			_moveY = y;
			
			move(_moveX, _moveY);
		}
		
		/**
		 *设置位置 
		 * @param x
		 * @param y
		 * 
		 */		
		public function move(x:int, y:int):void
		{
			if((x + this.width) > LayoutManager.stageWidth)
			{
				this.x = x - this.width;
			}
			else
			{
				this.x = x;
			}
			
			if((y + this.height) > LayoutManager.stageHeight)
			{
				if ((y - this.height) < 0)
				{
					this.y = LayoutManager.stageHeight - this.height;
				}
				else
				{
					this.y = y - this.height - 10;
				}
			}
			else
			{
				this.y = y + 10;
			}
		}
		
		/**
		 *设置数据 
		 * @param value
		 * 
		 */		
		public function set data(value:Object):void
		{
			_data = value;
		}
		
		public function get data():Object
		{
			return _data;
		}
		
		/**
		 *更新舞台尺寸 
		 * @param width
		 * @param height
		 * 
		 */	
		public function updateStageSize(width:int, height:int):void
		{
			
		}
		
		protected function resize():void
		{
			
		}
		
		}
}