package com.tencent.morefun.naruto.plugin.exui.avatar
{
    import com.tencent.morefun.naruto.plugin.exui.base.Image;
    import com.tencent.morefun.naruto.plugin.exui.base.SWFImage;
    
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
    import flash.events.ErrorEvent;
    import flash.events.Event;

    public class Avatar extends Sprite
    {
        protected var _width:int;
        protected var _height:int;
        protected var _container:Sprite;
        protected var _img:Image;
        protected var _swf:SWFImage;
        protected var _url:String;

        public function Avatar(width:int=0, height:int=0, centerAlign:Boolean = false)
        {
            _width = width;
            _height = height;

            _container = new Sprite();
            _container.mouseChildren = false;
            this.addChild(_container);

            if (_width > 0 && _height > 0)
            {
                var centerX:int = _width / 2;
                var centerY:int = _height / 2;

                _img = new Image(_width, _height, true, centerAlign, true);
                _img.moveLoadingMovie(centerX, centerY);
                _swf = new SWFImage(_width, _height, true, true, centerAlign, true, centerX, centerY);
            }
            else
            {
                _img = new Image(0, 0, true, centerAlign, true);
                _swf = new SWFImage(0, 0, false, true, centerAlign, true);
            }

            _img.addEventListener(Event.COMPLETE, onLoaded);
            _img.addEventListener("LoadError", onError);

            _swf.addEventListener(Event.COMPLETE, onLoaded);
            _swf.addEventListener("LoadError", onError);
        }

        public function destroy():void
        {
            unloadImage();
            unloadSwf();

            _img.removeEventListener(Event.COMPLETE, onLoaded);
            _img.removeEventListener(ErrorEvent.ERROR, onError);
            _img = null;

            _swf.removeEventListener(Event.COMPLETE, onLoaded);
            _swf.removeEventListener(ErrorEvent.ERROR, onError);
            _swf = null;

            if (_container != null && this.contains(_container))
                this.removeChild(_container);

            _container = null;
            _url = null;
        }

        public function load(url:String):void
        {
            loadByType(url);
        }

        public function unload():void
        {
            unloadImage();
            unloadSwf();

            _url = null;
        }

        public function get container():DisplayObjectContainer
        {
            return _container;
        }

        private function loadByType(url:String):void
        {
            if (url == null || url == _url)
                return;

            _url = url;

            var extPos:int = url.lastIndexOf(".");
            var ext:String = (extPos != -1) ? url.substr(extPos + 1) : null;

            if (ext != null)
            {
                if (ext == "png" || ext == "jpg")
                {
                    loadImage(url);
                    unloadSwf();
                }
                else if (ext == "swf")
                {
                    unloadImage();
                    loadSwf(url);
                }
            }
        }

        private function loadImage(url:String):void
        {
            if (_img == null)
                return;

            if (!_container.contains(_img))
                _container.addChild(_img);

            _img.load(url);
        }

        private function unloadImage():void
        {
            if (_img == null)
                return;

            if (_container.contains(_img))
                _container.removeChild(_img);

            _img.dispose();
        }

        private function loadSwf(url:String):void
        {
            if (_swf == null)
                return;

            if (!_container.contains(_swf))
                _container.addChild(_swf);

            _swf.load(url, null, false);
        }

        private function unloadSwf():void
        {
            if (_swf == null)
                return;

            if (_container.contains(_swf))
                _container.removeChild(_swf);

            _swf.unload();
        }

        protected function onLoaded(event:Event):void
        {
            dispatchEvent(event);
        }

        protected function onError(event:Event):void
        {
            dispatchEvent(event);
        }
   }
}