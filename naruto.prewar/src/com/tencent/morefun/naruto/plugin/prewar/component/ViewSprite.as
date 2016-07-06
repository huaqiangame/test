package com.tencent.morefun.naruto.plugin.prewar.component
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	/**
	 * 视图容器
	 * @author larryhou
	 * @createTime 2013/9/27 14:58
	 */
	public class ViewSprite extends Sprite
	{
		
		/**
		 * 构造函数
		 * create a [ViewSprite] object
		 */
		public function ViewSprite(view:MovieClip) 
		{
			if (view.parent)
			{
				this.x = view.x;
				this.y = view.y;
				
				view.x = view.y = 0;
				view.parent.addChildAt(this, view.parent.getChildIndex(view));
				addChild(view);
			}
		}
		
	}

}