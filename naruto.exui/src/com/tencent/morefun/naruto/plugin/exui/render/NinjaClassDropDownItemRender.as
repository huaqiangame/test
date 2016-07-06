package com.tencent.morefun.naruto.plugin.exui.render
{

	import com.tencent.morefun.naruto.plugin.exui.base.Image;
	import com.tencent.morefun.naruto.plugin.exui.dropDownList.data.NinjaPropertyData;
	import com.tencent.morefun.naruto.plugin.ui.base.ItemRenderer;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import def.NinjaAssetDef;
	
	import ninja.conf.NinjaDefConfig;
	
	import user.def.NinjaPropertyDef;

    import com.tencent.morefun.naruto.i18n.I18n;
	public class NinjaClassDropDownItemRender extends ItemRenderer
	{
		public var isLabel:Boolean;
		private var icon:Image;
		
		public function NinjaClassDropDownItemRender(skin:DisplayObject)
		{
			super(skin);
			view.gotoAndStop(1);
			view.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			view.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			
			icon = new Image(20,20);
			icon.mouseChildren = icon.mouseEnabled = false;
			icon.x = view.iconPos.x;
			icon.y = view.iconPos.y;
			addChild(icon);
		}
		
		private function get view():MovieClip
		{
			return m_skin as MovieClip;
		}
		
		override public function set data(value:Object):void
		{
			m_data = value;
			
			icon.dispose();
			view.lTf.visible = false;
			view.rTf.visible = true;
			
			//因为这里value之前是传一个整形的，但是现在要传一个结构体，为了避免其他地方用到这个类，传的参数是整形，所以这里做一下兼容，整形和结构体都支持
			if ((value is int && value == -1) || (value is NinjaPropertyData && (value as NinjaPropertyData).type == ""))
			{
				if (isLabel) {
					view.lTf.visible = true;
					view.rTf.visible = false;
					view.lTf.text = I18n.lang("as_exui_1451031568_1261");
				}else{
					view.rTf.text = I18n.lang("as_exui_1451031568_1262");
				}
			}
			else
			{
				//因为这里value之前是传一个整形的，但是现在要传一个结构体，为了避免其他地方用到这个类，传的参数是整形，所以这里做一下兼容，整形和结构体都支持
				if (value is NinjaPropertyData)
				{
					view.rTf.text = NinjaDefConfig.getDefName((value as NinjaPropertyData).type, (value as NinjaPropertyData).id);
					icon.load(NinjaAssetDef.getAsset(((value as NinjaPropertyData).type == NinjaDefConfig.CATEGORY)? NinjaAssetDef.NINJA_PROPERTY : NinjaAssetDef.PROPERTY_ICON,(value as NinjaPropertyData).id));
				}
				else
				{
					view.rTf.text = NinjaPropertyDef.getNinjaPropertyName(value as int);
					icon.load(NinjaAssetDef.getAsset(NinjaAssetDef.NINJA_PROPERTY,(value as int)));
				}
			}
			
		}
		
		private function onMouseOver(evt:MouseEvent):void
		{
			view.gotoAndStop(2);
		}
		
		private function onMouseOut(evt:MouseEvent):void
		{
			view.gotoAndStop(1);
		}
		
		override public function destroy():void
		{
			view.removeEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			view.removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			
			super.destroy();
		}
	}
}