package com.tencent.morefun.naruto.plugin.exui.cursor
{
 import com.tencent.morefun.naruto.plugin.exui.ui.MultiSellCursorUI;
 import com.tencent.morefun.naruto.plugin.ui.layer.LayerManager;
 import com.tencent.morefun.naruto.plugin.ui.layer.def.LayerDef;
 import flash.display.Sprite;
 import flash.events.MouseEvent;
 import flash.ui.Mouse;
 import crew.utils.CrewUtils;

    public class MultiSellCursor extends Sprite
    {
        private var _ui:MultiSellCursorUI;
        private var _activated:Boolean;

        public function MultiSellCursor()
        {
            this.mouseEnabled = false;
            this.mouseChildren = false;

            _ui = new MultiSellCursorUI();
            _ui.gotoAndStop(1);
            addChild(_ui);

            CrewUtils.model.multiSellActivated = false;
        }

        public function destroy():void
        {
            deactivate();
        }

        public function get activated():Boolean
        {
            return _activated;
        }

        public function activate(x:int, y:int):void
        {
            if (_activated)
                return;

            _ui.x = x;
            _ui.y = y;

            LayerManager.singleton.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            LayerManager.singleton.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
            LayerManager.singleton.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
            LayerManager.singleton.addItemToLayer(this, LayerDef.DRAG_ICON);

            Mouse.hide();
            _activated = true;
            CrewUtils.model.multiSellActivated = true;
        }

        public function deactivate():void
        {
            if (!_activated)
                return;

            _ui.gotoAndStop(1);

            LayerManager.singleton.stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            LayerManager.singleton.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
            LayerManager.singleton.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
            LayerManager.singleton.removeItemToLayer(this);

            Mouse.show();
            _activated = false;
            CrewUtils.model.multiSellActivated = false;
        }

        private function onMouseDown(event:MouseEvent):void
        {
            _ui.gotoAndStop(3);
        }

        private function onMouseUp(event:MouseEvent):void
        {
            _ui.gotoAndStop(1);
        }

        private function onMouseMove(event:MouseEvent):void
        {
            _ui.x = event.stageX;
            _ui.y = event.stageY;
        }
   	}
}