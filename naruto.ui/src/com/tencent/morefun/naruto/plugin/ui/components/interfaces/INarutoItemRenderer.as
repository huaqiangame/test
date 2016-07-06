package com.tencent.morefun.naruto.plugin.ui.components.interfaces
{
    public interface INarutoItemRenderer extends IRender
    {
        function get selected():Boolean;
        function set selected(value:Boolean):void;
        function get dataIndex():int;
    }
}