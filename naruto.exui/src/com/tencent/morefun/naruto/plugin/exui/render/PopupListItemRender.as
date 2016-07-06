package com.tencent.morefun.naruto.plugin.exui.render {
 import com.tencent.morefun.naruto.plugin.exui.event.PopupListItemClickedEvent;
 import com.tencent.morefun.naruto.plugin.ui.base.ItemRenderer;
 import com.tencent.morefun.naruto.plugin.ui.components.interfaces.IRender;
 import flash.events.MouseEvent;
 import flash.text.TextField;

    public class PopupListItemRender extends ItemRenderer implements IRender {
		private var m_view:PopupItemUI;
		private var m_tf:TextField;
        public function PopupListItemRender() {
			addChild(m_view = new PopupItemUI());
            super(null);
			init();
        }
		/**
		 * 初始化
		 */
		private function init():void {
			m_view.getChildByName("selectedMC").visible = false;
			this.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			this.addEventListener(MouseEvent.CLICK, onMouseClick);
			m_tf = m_view.getChildByName("tf_name") as TextField;
		}
		
		protected function render():void {
			m_tf.htmlText = "<font color='#cccccc'><a href='event:' ><u><b>"+data+"</b></u></a></font>";
		}
		override public function get data():Object {
			return super.data;
		}
		
		override public function set data(value:Object):void { 
			//this.removeEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			//this.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			if( value != null && value != m_data){
				super.data = value;
				
				render();
				
			}
			
		}
		private function onMouseOver(e:MouseEvent):void{
			m_view.getChildByName("selectedMC").visible = true;
			m_tf.htmlText = "<font color='#ffffff'><a href='event:' ><u><b>"+data+"</b></u></a></font>";
		}
		private function onMouseOut(e:MouseEvent):void{
			m_view.getChildByName("selectedMC").visible = false;
			m_tf.htmlText = "<font color='#cccccc'><a href='event:' ><u><b>"+data+"</b></u></a></font>";
		}
		override public function destroy():void{
			dispose();
			super.destroy();
		}
		public function dispose():void {
			this.removeEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			this.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			this.removeEventListener(MouseEvent.CLICK, onMouseClick);
		}
		override public function get height():Number{
			return 21;
		}
		
		protected function onMouseClick(event:MouseEvent):void
		{
			var evt:PopupListItemClickedEvent = new PopupListItemClickedEvent(PopupListItemClickedEvent.ITEM_CLICKED, true);
			evt.label = String(data);
			this.dispatchEvent(evt);	
		}
//		override public function get width():Number{ 
//			return 106;
//		}
   	}
}
