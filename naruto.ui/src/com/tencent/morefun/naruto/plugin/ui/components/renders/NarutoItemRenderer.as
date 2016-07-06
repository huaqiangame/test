package com.tencent.morefun.naruto.plugin.ui.components.renders
{
    import com.tencent.morefun.naruto.plugin.ui.components.interfaces.INarutoItemRenderer;
    import com.tencent.morefun.naruto.plugin.ui.components.wrappers.RenderWrapper;
    
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    
    public class NarutoItemRenderer extends Sprite implements INarutoItemRenderer
    {
        private var _data:Object;
        private var _selected:Boolean;

        public function NarutoItemRenderer()
        {
            this.addEventListener(MouseEvent.CLICK, onClick);
        }

        public function dispose():void
        {
            this.removeEventListener(MouseEvent.CLICK, onClick);

            _data = null;
        }

        public function get data():Object
        {
            return _data;
        }

        public function set data(value:Object):void
        {
            _data = value;
        }

        public function get selected():Boolean
        {
            return _selected;
        }

        public function set selected(value:Boolean):void
        {
            _selected = value;
        }

        public function get dataIndex():int
        {
            var wrapper:RenderWrapper = this.parent as RenderWrapper;
            var dataIndex:int = wrapper != null ? wrapper.dataIndex : -1;

            return dataIndex;
        }

        private function onClick(event:MouseEvent):void
        {
            var e:Event = new Event("rendererEvent", true);
            this.dispatchEvent(e);
        }
    }
}