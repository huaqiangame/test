package com.tencent.morefun.naruto.plugin.ui.components.layouts
{
    import com.tencent.morefun.naruto.plugin.ui.components.interfaces.INarutoItemRenderer;
    
    import flash.display.MovieClip;
    import flash.events.Event;

    // Register events for upper users~
    [Event (name="rendererEvent", type="flash.events.Event")]

    public class NarutoLayout extends EasyLayout
    {
        private var _selectedIndex:int;
        private var _selectedRenderer:INarutoItemRenderer;

        public function NarutoLayout(rendererClass:Class, row:int, column:int=1, hgap:Number=5, vgap:Number=5, virtical:Boolean=true, scrollerView:MovieClip=null)
        {
            checkRendererClass(rendererClass);
            super(rendererClass, row, column, hgap, vgap, virtical, scrollerView);

            this.addEventListener("rendererEvent", onRendererEvent);
        }

        private function checkRendererClass(rendererClass:Class):void
        {
            var renderer:INarutoItemRenderer = new rendererClass() as INarutoItemRenderer;

            if (renderer == null)
                throw new Error(rendererClass + " must implement INarutoItemRenderer or extend NarutoItemRenderer!");
        }

        override public function dispose():void
        {
            this.removeEventListener("rendererEvent", onRendererEvent);

            super.dispose();
        }

        public function select(index:int):void
        {
            if (_selectedIndex != -1)
            {
                var selectedRenderer:INarutoItemRenderer = getRendererByDataIndex(_selectedIndex);

                if (selectedRenderer != null)
                    selectedRenderer.selected = false;
            }

            var renderer:INarutoItemRenderer = getRendererByDataIndex(index);

            if (renderer != null)
            {
                _selectedIndex = index;
                renderer.selected = true;
            }
        }

        public function get selectedIndex():int
        {
            return _selectedIndex;
        }

        override public function set column(value:uint):void 
        {
            super.column = value;
            refreshSelection();
        }

        override public function set row(value:uint):void
        {
            super.row = value;
            refreshSelection();
        }

        override protected function changeHandler(event:Event):void
        {
            super.changeHandler(event);
            refreshSelection();
        }

        protected function onRendererEvent(event:Event):void
        {
            selectRenderer(event.target as INarutoItemRenderer);
        }

        private function selectRenderer(renderer:INarutoItemRenderer):void
        {
            if (renderer == null)
                return;

            select(renderer.dataIndex);
        }

        private function getRendererByDataIndex(index:int):INarutoItemRenderer
        {
            var len:int = this.renderers.length;
            var rendererIndex:int;

            for (var i:int=0; i<len; ++i)
            {
                if (this.renderers[i].dataIndex == index)
                    return this.layout.getItemAt(i) as INarutoItemRenderer;
            }

            return null;
        }

        private function refreshSelection():void
        {
            var len:int = this.renderers.length;
            var renderer:INarutoItemRenderer;

            for (var i:int=0; i<len; ++i)
            {
                renderer = this.renderers[i].target as INarutoItemRenderer;

                if (renderer != null)
                    renderer.selected = (this.renderers[i].dataIndex == _selectedIndex);
            }
        }
    }
}