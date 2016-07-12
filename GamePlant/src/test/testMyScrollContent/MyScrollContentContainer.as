/**
 * Created by Administrator on 2016/7/8 0008.
 */
package test.testMyScrollContent
{
	import com.tencent.morefun.naruto.plugin.ui.base.ScrollContent;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextField;

	public class MyScrollContentContainer extends ScrollContent
	{
		private var container:Sprite;
		private var scrollArea:Rectangle;

		public function MyScrollContentContainer(skin:DisplayObject, width:Number, height:Number, enableMouseWeel:Boolean = true)
		{
			super(skin, width, height, enableMouseWeel);

			container = new Sprite();
			this.addChild(container);
			container.mouseEnabled = false;

			scrollArea = new Rectangle(0, 0, skin.width, skin.height);

			for (var i:int = 0; i < 50; i++)
			{
				var sp:Sprite = createShape(i + 1);
				container.addChild(sp);
				sp.y = 50 * i + 1;
			}
			this.maxVerScrollValue = this.container.height - scrollArea.height;
			this.maxVerScrollValue = Math.max(0, maxVerScrollValue);
		}

		override protected function update(evt:Event):void
		{
			scrollArea.y = this.verticalScrollValue;
			this.container.scrollRect = scrollArea;
		}

		private function createShape(num:int = 0):Sprite
		{
			var sp:Sprite = new Sprite();
			sp.graphics.clear();
			sp.graphics.beginFill(0xffffff * Math.random(), 1);
			sp.graphics.drawRect(0, 0, 400, 50);
			sp.graphics.endFill();
			var tf:TextField = new TextField();
			tf.mouseEnabled = false;
			sp.addChild(tf);
			tf.autoSize = "left";
			tf.text = num + "";
			tf.x = (sp.width - tf.textWidth) >> 1;
			tf.y = (sp.height - tf.textHeight) >> 1;
			return sp;
		}
	}
}
