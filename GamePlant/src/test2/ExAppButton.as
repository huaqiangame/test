/**
 * Created by Administrator on 2016/7/8 0008.
 */
package test2
{
	import com.tencent.morefun.naruto.plugin.ui.base.VBox;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;

	import naruto.component.controls.ButtonNormalBlue;
	import naruto.component.controls.ButtonNormalOrange;
	import naruto.component.controls.ButtonNormalYellow;
	import naruto.component.controls.ComboBoxList_1;
	import naruto.component.controls.ComboBox_1;
	import naruto.component.controls.Icon_VipLevel;
	import naruto.component.controls.Info_1;
	import naruto.component.controls.NumericStepper_1;
	import naruto.component.controls.ScrollBar_2;
	import naruto.component.controls.TabBarButton_1;
	import naruto.component.controls.TitleBar_1;
	import naruto.component.controls.TitleBar_2;
	import naruto.component.controls.TitleBar_3;
	import naruto.component.controls.scrollBar.ScrollBarBinder;

	public class ExAppButton extends Sprite
	{
		public static const TITLE:String = "";

		public function ExAppButton()
		{
			super();

			var combox1:ComboBox_1 = new ComboBox_1();
			this.addChild(combox1);
			combox1.width = 120;
			combox1.data = ["aa", "bb", "cc", "dd"];
			combox1.label = "我是ComboBox_1";

			var datas:Array = ["aa", "bb", "cc", "dd"];
			datas = datas.concat(datas);
			datas = datas.concat(datas);
			datas = datas.concat(datas);

			var comboList:ComboBoxList_1 = new ComboBoxList_1();
			comboList.height = 150;
			comboList.data = datas;
			this.addChild(comboList);
			comboList.x = 150;


			var container:VBox = new VBox();
			container.vergap = 50;
			this.addChild(container);
			container.y = 200;

			var step:NumericStepper_1 = new NumericStepper_1();
			step.min = 1;
			step.max = 5;
			container.addChild(step);

			var tab:TabBarButton_1 = new TabBarButton_1();
			container.addChild(tab);


			var titleBar:TitleBar_1 = new TitleBar_1();
			container.addChild(titleBar);


			var titleBar2:TitleBar_2 = new TitleBar_2();
			container.addChild(titleBar2);

			var titleBar3:TitleBar_3 = new TitleBar_3();
			container.addChild(titleBar3);

			var btnBlue:ButtonNormalBlue = new ButtonNormalBlue();
			container.addChild(btnBlue);
			btnBlue.enabled=false;
			btnBlue.addEventListener(MouseEvent.CLICK, function():void{
				trace("hello,world");
			});

			var btnOrange:ButtonNormalOrange = new ButtonNormalOrange();
			container.addChild(btnOrange);

			var btnYellow:ButtonNormalYellow = new ButtonNormalYellow();
			container.addChild(btnYellow);


			var vipLevel:Icon_VipLevel = new Icon_VipLevel();
			container.addChild(vipLevel);
			vipLevel.vipLevel = 9;

			var info:Info_1 = new Info_1();
			container.addChild(info);
			info.label = "hello,info";
			info.nameText.text = "张三";
			info.value = "111";


			setTimeout(function ():void
			{
				var scroll:ScrollBar_2 = new ScrollBar_2();
				var scroBinder:ScrollBarBinder = new ScrollBarBinder(scroll, container, new Rectangle(0, 0, 300, 200));
				scroll.height = 200;
				addChild(scroll);
				scroll.y = container.y;
				scroll.x = 400;
			}, 1000);


		}
	}
}
