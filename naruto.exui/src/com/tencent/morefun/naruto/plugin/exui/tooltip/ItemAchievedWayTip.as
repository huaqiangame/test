package com.tencent.morefun.naruto.plugin.exui.tooltip {

 import com.tencent.morefun.naruto.plugin.exui.base.Image;
 import com.tencent.morefun.naruto.plugin.exui.item.ItemIcon;
 import com.tencent.morefun.naruto.plugin.exui.render.ItemAchievedWayRender;
 import com.tencent.morefun.naruto.plugin.ui.components.buttons.MovieClipButton;
 import com.tencent.morefun.naruto.plugin.ui.components.layouts.EasyLayout;
 import com.tencent.morefun.naruto.plugin.ui.layer.LayerManager;
 import com.tencent.morefun.naruto.plugin.ui.layer.LayoutManager;
 import com.tencent.morefun.naruto.plugin.ui.layer.def.LayerDef;
 import com.tencent.morefun.naruto.plugin.ui.tips.BaseTipsView;
 import com.tencent.morefun.naruto.plugin.ui.tooltip.ExclamatoryMarkBTN;
 import com.tencent.morefun.naruto.plugin.ui.tooltip.ItemAchievedWayUI;
 
 import flash.display.DisplayObject;
 import flash.display.DisplayObjectContainer;
 import flash.display.MovieClip;
 import flash.display.Sprite;
 import flash.events.Event;
 import flash.events.MouseEvent;
 import flash.text.TextField;
 import flash.text.TextFormat;
 import flash.utils.ByteArray;
 import flash.utils.Dictionary;
 
 import bag.data.ItemData;
 import bag.utils.BagUtils;
 
 import cfgData.CFGDataEnum;
 import cfgData.CFGDataLibs;
 import cfgData.dataStruct.ItemAchievedWayCFG;
 
 import def.NinjaAssetDef;
 
 import naruto.component.controls.ButtonClose;
 
 import throughTheBeast.data.BeastData;

    import com.tencent.morefun.naruto.i18n.I18n;
    public class ItemAchievedWayTip extends BaseTipsView {
        private static var ms_instance:ItemAchievedWayTip;
        private var m_tipsClsMap:Dictionary = new Dictionary();
        private var m_skin:ItemAchievedWayUI;
        private var _layout:EasyLayout;
        private var m_configArr:Dictionary;   
        
		private var m_tipsItemNameTf:TextField;
		private var m_tipsImg:ItemIcon;
		private var m_tipsCloseBtn:ButtonClose;
		private var m_isShow:Boolean = false;
		private var m_tipsSourceTf:TextField;
		
		private var m_tipsGreenImg:Image;
		
		/**
		 * 记录上一次的点中!的ITEM
		 */
		private var m_lastBindItem:Object ;
		private var m_exclamatoryMarkbtn:MovieClipButton;
		
        public function ItemAchievedWayTip() {
            m_skin = new ItemAchievedWayUI();
            m_skin.mouseEnabled = false;
            //m_skin.mouseChildren = false;
			var textFormat:TextFormat = new flash.text.TextFormat;
			textFormat.bold = true;
			m_tipsSourceTf = m_skin.getChildByName("sourceTF") as TextField;
			m_tipsSourceTf.defaultTextFormat = textFormat;
			m_tipsSourceTf.text = I18n.lang("as_exui_1451031568_1339");
			/**
			 * 普通ITEM
			 */
			m_tipsItemNameTf = (m_skin.getChildByName("itemNormal") as Sprite).getChildByName("nameText") as TextField;
			m_tipsItemNameTf.defaultTextFormat = textFormat;
			m_tipsImg = new ItemIcon();
			m_tipsImg.mouseEnabled = false;
			m_tipsImg.x = 17;
			m_tipsImg.y = 23;
			m_skin.addChild(m_tipsImg);
			/**
			 * 忍者用的
			 */
			m_tipsGreenImg = new Image();
			m_tipsGreenImg.mouseEnabled = false;
			m_tipsGreenImg.x =9;
			m_tipsGreenImg.y = 19;
			m_skin.addChild(m_tipsGreenImg);

			((m_skin.getChildByName("greenNinja") as Sprite).getChildByName("nameText") as TextField).defaultTextFormat = textFormat; 
			((m_skin.getChildByName("greenNinja") as Sprite).getChildByName("nameText2") as TextField).defaultTextFormat =  textFormat;
			(m_skin.getChildByName("greenNinja") as Sprite).parent.addChild(m_skin.getChildByName("greenNinja"));
			
			m_tipsCloseBtn = m_skin.getChildByName("closeBtn") as ButtonClose;
			m_tipsCloseBtn.addEventListener(MouseEvent.CLICK ,onCloseTip);
            /**
             * 列表
             */
            var itemListsContainer:Sprite = new Sprite();
            itemListsContainer.x = 23;
            itemListsContainer.y = 150;
            m_skin.addChild(itemListsContainer);
            _layout = new EasyLayout(ItemAchievedWayRender, 3, 1, 1, 7);
            _layout.x = 8;
            
            itemListsContainer.addChild(_layout);
			
        }
        
        /**
         * 在starup插件里 调用这个 初始化 加载 道具获取途径的配置表
         */
        
        public function initXML(data:XML):void {
            m_configArr = new Dictionary();
            var item:XML;
            var itemData:ItemAchievedWayCFG;
            
            for(var i:int = 0; i < data.row.length(); i++) {
                item = data.row[i];
                itemData = new ItemAchievedWayCFG();
                itemData.id = parseInt(item.@id);
                itemData.name = item.@name.toString();
                itemData.url = item.@url.toString();
				itemData.conditionProtoHudNotify = parseInt(item.@conditionProtoHudNotify);
                m_configArr[int(itemData.id)] = itemData;
            }
        }
        public  function initByteArray(data:ByteArray):void{
			//注册一个数据
			m_configArr = CFGDataLibs.parseData(data,CFGDataEnum.ENUM_ItemAchievedWayCFG);
//			//获取所有数据
//			var a:* =CFGDataLibs.getAllData("ItemAchievedWayCFG");
//			//获取某个数据
//			var b:* = CFGDataLibs.getRowData("ItemAchievedWayCFG",101);
			return;
//			var className :String = getQualifiedClassName(ItemAchievedWayCFG);
//			registerClassAlias("ItemAchievedWayCFG", ItemAchievedWayCFG);
//			
//			//data.uncompress();
//			var stractObjectMap : * = data.readObject();
//			m_configArr = new Dictionary();
//			for each(var obj:ItemAchievedWayCFG in stractObjectMap){
//				m_configArr[obj.id] = obj;
//				//trace(obj);
//			}
			//trace(1);
		}
        public static function get singleton():ItemAchievedWayTip {
            if(ms_instance == null) {
                ms_instance = new ItemAchievedWayTip();
            }
            
            return ms_instance;
        }
        
        /**
         *绑定事件
         * @param displayObj
         * @param data
         * @param tipsType 0 ITEM  1 忍者  皮肤不同
         * @param Offset   point
         * @param
         */
        public function binding(displayObj:DisplayObject, data:Object,tipsType:int=0,Offset:Array=null):void {
			if(data == null || data.achievedWay=="" || data.achievedWay==null){
				unbind(displayObj);
				return;
			}
			if(m_tipsClsMap[displayObj] ) {
				m_tipsClsMap[displayObj] = [data,tipsType,Offset];
				return;
			}
			
			m_tipsClsMap[displayObj] = [data,tipsType,Offset];
            displayObj.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
            displayObj.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
            
            
            //displayObj.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
            
            //
        }
		public function unbind(displayObj:DisplayObject):void{
			removeMark(displayObj as DisplayObjectContainer);
			if(m_tipsClsMap[displayObj]){
				delete m_tipsClsMap[displayObj];
			}
			displayObj.removeEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			displayObj.removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
		}
        private function onClick(event:MouseEvent):void {
            //show tips
			if( !m_tipsClsMap[event.currentTarget.data]){
				removeMark(event.currentTarget.data);
				unbind(event.currentTarget.data);
				return;
			}
			var itemData:Object = m_tipsClsMap[event.currentTarget.data][0];
			var tipsType:int = m_tipsClsMap[event.currentTarget.data][1];
			
			m_skin.getChildByName("itemNormal").visible=(tipsType ==0)?true:false;
			m_skin.getChildByName("greenNinja").visible=(tipsType ==1)?true:false;
			
			if(m_isShow && m_lastBindItem ==event.currentTarget.data ){
//				m_skin.visible = false;
//				m_isShow = false;
//				_layout.removeEventListener("achievedWayClick", onCloseTip  );
//				LayerManager.singleton.stage.removeEventListener(MouseEvent.CLICK,onStageClick);
				onCloseTip();
				return;
			}
			m_skin.visible = true;
			m_isShow = true;
			m_lastBindItem =event.currentTarget.data;
            var nameStr:String;
			if(itemData is BeastData){
				nameStr = itemData.name;
				nameStr = nameStr.replace(I18n.lang("as_exui_1451031568_1340"),"");
			}
			else{
				nameStr = BagUtils.getColoredItemName(itemData.id);
				if(nameStr.indexOf("[")>0){
					nameStr = nameStr.replace("[","\n[");
				}
			}
			
			m_tipsItemNameTf.htmlText = "<b>" + nameStr + "</b>";

            LayerManager.singleton.addItemToLayer(m_skin, LayerDef.INTERACTIVE_TIPS);
            preMove(LayerManager.singleton.stage.mouseX-60 - LayoutManager.stageOffsetX,
                LayerManager.singleton.stage.mouseY+60 - LayoutManager.stageOffsetY);
			//途径的LISTS
			var way:String = itemData.achievedWay;
			//way = "1:2:3";
			var ways:Array = way.split("|");
			
			var randerData:Array = new Array();
			//分析IDS 对应的
			for each (var key:int in ways){
				if(!m_configArr[key])continue;
				m_configArr[key].itemId= (tipsType == 0)?itemData.id:itemData.id;
				m_configArr[key].itemType = itemData.type;
				randerData.push(m_configArr[key]);
			}
			//
			
			m_skin.getChildByName("bg").height = 180+ (16+5)*ways.length;
			m_skin.getChildByName("flowerMc").y = 180-50+ (16+5)*ways.length;
			//(m_skin.getChildByName("bg") as Sprite).mouseEnabled = false;
			_layout.row = ways.length;	
			_layout.dataProvider = randerData;
			_layout.addEventListener("achievedWayClick", onCloseTip ,true );
			LayerManager.singleton.stage.addEventListener(MouseEvent.CLICK,onStageClick,true);
			
			if(tipsType == 0){
				if(itemData is BeastData){
					m_tipsImg.load("assets/bag/item/" + itemData.id + ".png");
				}
				
				else{
					m_tipsImg.loadIconByData(itemData as ItemData);
				}
				
				
			}
			else{
				m_tipsGreenImg.load(NinjaAssetDef.getAsset(NinjaAssetDef.HEAD_WIDE,itemData.id));
				((m_skin.getChildByName("greenNinja") as Sprite).getChildByName("nameText") as TextField).text = itemData.title; 
				((m_skin.getChildByName("greenNinja") as Sprite).getChildByName("nameText2") as TextField).text =  itemData.name;
				//((m_skin.getChildByName("greenNinja") as Sprite).getChildByName("bottomGreen") as Sprite).y = m_skin.getChildByName("bg").height-48-20;
			}
			
			
        }
        
        private function onMouseOver(event:MouseEvent):void {
            //if(event.currentTarget !=event.target) return;
            var displayObj:DisplayObjectContainer = event.currentTarget as DisplayObjectContainer;
            
            if(!displayObj.getChildByName("ExclamatoryMarkbtn")) {
               // trace(111);
                //var exclamatoryMarkbtn:ExclamatoryMarkBTN = new ExclamatoryMarkBTN();
				m_exclamatoryMarkbtn = new MovieClipButton((new ExclamatoryMarkBTN()) as MovieClip);
				m_exclamatoryMarkbtn.data = displayObj;
				m_exclamatoryMarkbtn.addEventListener(MouseEvent.CLICK, onClick);
				
				m_exclamatoryMarkbtn.name = "ExclamatoryMarkbtn";
				if(m_tipsClsMap[event.currentTarget][1] ==0){//item
					m_exclamatoryMarkbtn.x = displayObj.width-m_exclamatoryMarkbtn.width - 6;
					m_exclamatoryMarkbtn.y = 2;
				}
				else{//ninja
					m_exclamatoryMarkbtn.x = displayObj.width-m_exclamatoryMarkbtn.width - 8;
					m_exclamatoryMarkbtn.y = 8;
				
				}
				/**
				 * offset
				 */
				if(m_tipsClsMap[event.currentTarget][2] !=null){
					m_exclamatoryMarkbtn.x = m_exclamatoryMarkbtn.x+m_tipsClsMap[event.currentTarget][2][0];
					m_exclamatoryMarkbtn.y = m_exclamatoryMarkbtn.y +m_tipsClsMap[event.currentTarget][2][1];
				}
				
                displayObj.addChild(m_exclamatoryMarkbtn);
            } else {
                
            }
        }
        
        private function onMouseOut(event:MouseEvent):void {
            //if(event.currentTarget !=event.target) return;
            
            var displayObj:DisplayObjectContainer = event.currentTarget as DisplayObjectContainer;
			removeMark(displayObj);
        }
		private function removeMark(displayObj:DisplayObjectContainer):void{
			
			//trace(222);
			
			//return;
			try {
				var btn:DisplayObject = displayObj.getChildByName("ExclamatoryMarkbtn");
				
				if(btn){
					displayObj.removeChild(btn);
					if(m_exclamatoryMarkbtn!=null){
						m_exclamatoryMarkbtn.removeEventListener(MouseEvent.CLICK, onClick);
						m_exclamatoryMarkbtn.dispose();
					}
					m_exclamatoryMarkbtn = null;
				}
				
			} catch(e:Error) {
			}
		}
        //		private function onFocusOut(event:FocusEvent):void{
        //			//m_tipsClsMap[event.currentTarget as DisplayObject][1]() ;
        //		}
        private function onRemovedFromStage(event:Event):void {
            var displayObj:DisplayObject = event.currentTarget as DisplayObject;
			if(m_tipsClsMap[displayObj]){
	            displayObj.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
	            displayObj.removeEventListener(MouseEvent.CLICK, onClick);
	            delete m_tipsClsMap[displayObj];
				if(m_lastBindItem == displayObj) {
					m_lastBindItem = null;
				}
			}
            
        }
        
        private function updateTip(data:Object):void {
            var itemData:Array = data.achievedWays.split("|");
        
        }
        
        override public function preMove(x:int, y:int):void {
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
        override public function move(x:int, y:int):void {
            if((x + m_skin.width) > LayoutManager.stageWidth) {
                m_skin.x = x - m_skin.width;
            } else {
                m_skin.x = x;
            }
            
            if((y + m_skin.height) > LayoutManager.stageHeight) {
                if((y - m_skin.height) < 0) {
                    m_skin.y = LayoutManager.stageHeight - m_skin.height;
                } else {
                    m_skin.y = y - m_skin.height - 10;
                }
            } else {
                m_skin.y = y + 10;
            }
        }
		private function onCloseTip(e:MouseEvent=null):void{
			
			//m_skin.visible = false;
			LayerManager.singleton.removeItemToLayer(m_skin);//         addItemToLayer(m_skin, LayerDef.TIPS);
			this.m_lastBindItem = null;
			this.m_tipsImg.unload();
			_layout.removeEventListener("achievedWayClick", onCloseTip  );
			LayerManager.singleton.stage.removeEventListener(MouseEvent.CLICK,onStageClick);
			m_skin.visible = false;
			m_isShow = false;
			this.m_tipsGreenImg.dispose();
		}
		private function onStageClick(evt:MouseEvent):void{
			if(!m_isShow || m_exclamatoryMarkbtn == evt.target) return;
            //			var targetDispay:DisplayObject;
            //			
            //			targetDispay = evt.target as DisplayObject;
            //			if(this.m_skin.contains(targetDispay) == false)
            //			{
            //				onCloseTip();
            //			}
//			var point = m_skin.globalToLocal(new Point(evt.stageX, evt.stageX)); 
//			if( point.x<0 ||point.y<0 || point.x>m_skin.width || point.y>m_skin.height){
//				onCloseTip();
//			}
//            var point:Point = m_skin.localToGlobal(new Point(0, 0));
//			if (evt.stageX < (point.x - 20) || 
//				evt.stageX > (point.x + m_skin.width + 20) || 
//				evt.stageY < (point.y - 20) || 
//				evt.stageY > (point.y + m_skin.height + 20))
//			{
//				onCloseTip();
//			}
			
			if(!m_skin.hitTestPoint(evt.stageX, evt.stageY, true))
			{
				onCloseTip();
			}
		}
        //		public function init():void{
        //			LoadManager.getManager().loadTask("config/bag/conf/ItemAchievedWay.xml", onLoadedXML, null);
        //		}		
    /**
     * 解析配置
     */
         //		private function onLoadedXML(data:XML, url:String, param:Object):void{
         //			m_configArr = new Dictionary();
         //			var item:XML;
         //			var itemData:ItemAchievedWayConfig;
         //			for(var i:int = 0 ;i< data.row.length();i++) {
         //				item = data.row[i];
         //				itemData = new ItemAchievedWayConfig();
         //				itemData.id = parseInt(item.@id);
         //				itemData.name = item.@name.toString();
         //				itemData.url = item.@url.toString();
         //				
         //				m_configArr[int(itemData.id)] = itemData;
         //			}
         //			
         //		}
   	}
}
