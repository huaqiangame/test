package com.tencent.morefun.naruto.plugin.exui.render {

 import com.tencent.morefun.naruto.plugin.ui.base.ItemRenderer;
 import com.tencent.morefun.naruto.plugin.ui.components.interfaces.IRender;
 import com.tencent.morefun.naruto.plugin.ui.tooltip.ItemAchievedWayRanderUI;
 import com.tencent.morefun.naruto.util.GameTip;
 
 import flash.events.Event;
 import flash.events.MouseEvent;
 import flash.text.TextField;
 
 import base.ApplicationData;
 
 import hud.utils.HudMenuIconUtils;
 
 import task.commands.HrefEventCommand;

    import com.tencent.morefun.naruto.i18n.I18n;
    public class ItemAchievedWayRender extends ItemRenderer implements IRender {
        private var m_view:ItemAchievedWayRanderUI;
        private var m_titleTf:TextField;
       
        
        public function ItemAchievedWayRender() {
            addChild(m_view = new ItemAchievedWayRanderUI());
            super(null);
            init();
			
        }
        
        /**
         * 初始化
         */
        private function init():void {
			
			
            m_titleTf = m_view.getChildByName("nameText") as TextField;
			
			
        }
        
        protected function render():void {
			if(checkIsOpen()== true){
				m_titleTf.addEventListener(MouseEvent.CLICK,onClick);
				m_titleTf.htmlText = "<a href='event:' ><u>"+data.name+"</u></a>";
			}
			else{
				m_titleTf.removeEventListener(MouseEvent.CLICK,onClick);
				m_titleTf.htmlText = "<font color='#A0A9B0' >"+data.name+"</font>";
			}
			
			//test
			//onClick();
        
        }
        /**
		 * 
		 */
		private function checkIsOpen():Boolean{
			//副本和精英副本要验证具体副本是否可以用
			for each( var key:int in HudMenuIconUtils.protoHudNotify){
				if(key == data.conditionProtoHudNotify){// 大功能已开启
					if(key == 7 || key == 9 ){//副本和精英副本验证
						return checkDungeon(key);
					}
					return true;
				}
			
			}
			return false;
			
		}
		/**
		 * 验证副本 和精英副本 里的具体副本是否可以用 openui,1,2028:1|2|3
		 * 副本9 精英副本7
		 * @functionid 对应 hud 里的功能id
		 */
		private function checkDungeon(functionid:int):Boolean{
			var url:String = data.url;
			var urlArr:Array = url.split(",");
			var ids:Array = (functionid == 9)?HudMenuIconUtils.dungeon:HudMenuIconUtils.elite;
			if(ids.length == 0 ) {
				return false;
			}
			if(urlArr.length<=2){
				return true;
			}
			var params:String = urlArr[2];//2028:10050|100502|100503
			
			var tmp:Array = params.split(":");
			if(tmp.length==1) {
				return true;
			}
			var checkIds:Array = tmp[1].split("|");
			
            for each(var id:int in  checkIds){
				if(ids.indexOf(id)>-1 ){
					return true;
				}
			}
			return false;
		}
        override public function get data():Object {
            return super.data;
        }
        
        override public function set data(value:Object):void {
            if( value != null) {//value != m_data &&
                super.data = value;
                render();
            }
        }
        private function onClick(event:MouseEvent = null):void{
			if(HudMenuIconUtils.sceneType != 1 &&  HudMenuIconUtils.sceneType != 3){
				GameTip.show(I18n.lang("as_exui_1451031568_1257"));
				return;
			}
			var hrefEventCommand:HrefEventCommand ;
			if(data.conditionProtoHudNotify == 8){//商城
				hrefEventCommand = new HrefEventCommand((data.url=="openui,9,1" ||data.url=="openui,9" )?data.url:(data.url+":"+data.itemId));
			}
			else{
				hrefEventCommand = new HrefEventCommand(data.url);
			}
			
			hrefEventCommand.call();
			this.dispatchEvent(new MouseEvent("achievedWayClick") );
			ApplicationData.singleton.dispatchEvent(new Event("ItemAchieveWayTips_ItemClick"));
			
		}
        public function dispose():void {
        
        }
   	}
}
