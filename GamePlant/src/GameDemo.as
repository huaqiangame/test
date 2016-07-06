/**
 * Created by Administrator on 2016/7/4 0004.
 */
package
{
	import com.tencent.morefun.naruto.plugin.ui.base.HBox;
	import com.tencent.morefun.naruto.plugin.ui.layer.LayerManager;
	import com.tencent.morefun.naruto.plugin.ui.util.TimerProvider;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	import test.testAnyTextIntAnim.AppAnyTextIntAnim;
	import test.testAnyTextRandomIntAnim.AppAnyTextRandomIntAnim;
	import test.testBaseButton.AppBaseButton;
	import test.testBitmapText.AppBitmapText;
	import test.testDropDownList.AppDropDownList;
	import test.testNumberStepper.AppNumberStepper;
	import test.testProgressbar.AppProgressBar;
	import test.testScrollBar.AppScrollBar;

	public class GameDemo extends Sprite
	{
		private var _title:TextField;
		private var _sampleArr:Array = [];
		private var _currentIndex:int = 0;
		private var _container:Sprite;
		private var _leftBtn:Sprite;
		private var _rightBtn:Sprite;
		private var _hBox:HBox;

		public function GameDemo()
		{
			if (stage)
			{
				init();
			} else
			{
				addEventListener(Event.ADDED_TO_STAGE, function ():void
				{
					removeEventListener(Event.ADDED_TO_STAGE, arguments.callee);
					init();
				});
			}
		}

		private function init():void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;

			TimerProvider.initliazed(stage);
			LayerManager.singleton.initialize(stage);

			_sampleArr.push(AppNumberStepper, AppDropDownList, AppProgressBar, AppScrollBar, AppAnyTextIntAnim, AppAnyTextRandomIntAnim, AppBaseButton, AppBitmapText);

			_title = new TextField();
			_title.autoSize = "left";
			_title.width = stage.stageWidth;
			this.addChild(_title);

			_container = new Sprite();
			this.addChild(_container);

			_hBox = new HBox();
			this.addChild(_hBox);

			_leftBtn = getTxtSp("上一个");
			_hBox.addChild(_leftBtn);


			_rightBtn = getTxtSp("下一个");
			_hBox.addChild(_rightBtn);
			_hBox.horgap = 120;

			_hBox.addEventListener(MouseEvent.CLICK, onClick);

			_currentIndex = 0;
			addSample(_sampleArr[_currentIndex]);

			stage.addEventListener(Event.RESIZE, onResize);
			onResize(null);
		}

		private function onClick(event:MouseEvent):void
		{
			var target:Object = event.target;
			if (target == _leftBtn)
			{
				_currentIndex--;
				if (_currentIndex <= 0)
				{
					_currentIndex = 0;
				}
				addSample(_sampleArr[_currentIndex]);

			} else if (target == _rightBtn)
			{
				_currentIndex++;
				if (_currentIndex >= _sampleArr.length - 1)
				{
					_currentIndex = _sampleArr.length - 1;
				}
				addSample(_sampleArr[_currentIndex]);
			}
		}

		private function onResize(event:Event):void
		{
			_title.x = (stage.stageWidth - _title.textWidth) * .5;
			_hBox.x = (stage.stageWidth - _hBox.width) * .5;
			_hBox.y = stage.stageHeight - _hBox.height;
		}

		private function addSample(sampleClass:Class):void
		{
			_container.removeChildren(0);

			var sample:Sprite = new sampleClass();
			_container.addChild(sample);
			updateTitle(sampleClass.TITLE);
			center(sample);
		}

		private function updateTitle(value:String):void
		{
			_title.htmlText = "<font color='#0000ff' size='30'>" + value + "</font>"
		}

		public function center(dis:DisplayObject):void
		{
			dis.x = (stage.stageWidth - dis.width) >> 1;
			dis.y = (stage.stageHeight - dis.height) >> 1;
		}


		private function getTxtSp(value:String):Sprite
		{
			var sp:Sprite = new Sprite();
			sp.buttonMode = true;
			var tf:TextField = new TextField();
			tf.mouseEnabled = false;
			tf.autoSize = "left";
			tf.htmlText = "<font color='#ffffff' size='30'>" + value + "</font>"
			sp.addChild(tf);
			sp.graphics.clear();
			sp.graphics.beginFill(0x0, .5);
			sp.graphics.drawRect(0, 0, sp.width, sp.height);
			sp.graphics.endFill();
			return sp;
		}

	}
}
