package com.tencent.morefun.naruto.plugin.ui.components.buttons {
    import flash.display.FrameLabel;
    import flash.display.MovieClip;
    import flash.display.Scene;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.utils.Dictionary;
    
    /**
     * 影片剪辑封装成按钮 普通按钮
     * @author:Georgehu
     * @since:2014-01-20
     */
    public class MovieClipButton extends MovieClip {
        /**
         * 正常 1
         */
        protected static const STATE_OUT:String = "out";
        /**
         * over 2
         */
        protected static const STATE_OVER:String = "over";
        /**
         * down 3
         */
        protected static const STATE_DOWN:String = "down";
        /**
         * 可以不用 选择状态就是 down
         */
        protected static const STATE_SELECT:String = "select";
        /**
         *不可以 4
         */
        protected static const STATE_DISABLE:String = "disabled";
        /**
         * 标签 对应的ID
         */
        private var m_labelsToids:Object = {"out":1, "over":2, "down":3, "disabled":4, "select":3};
        protected var _view:MovieClip;
        protected var _enabled:Boolean;
        
        protected var _pressing:Boolean;
        /**
         * 皮肤里的label
         */
        protected var m_dict:Dictionary;
        protected var m_dictLen:int = 0;
        
        protected var _selected:Boolean;
		/**
		 * 可以存放用户自己定义的数据
		 */
		public var data:*;
        
        /**
         * 构造函数
         * create a [MovieClipButton] object
         */
        public function MovieClipButton(view:MovieClip) {
            _view = view;
            
            if(!_view) {
                throw new ArgumentError("[fatalError]button view cannot be null.");
            }
            
			if (view != this)
			{
				if (_view.parent) 
				{
					this.x = _view.x;
					this.y = _view.y;
					
					_view.x = _view.y = 0;
					_view.parent.addChild(this);
				}      
				
				addChild(_view);
			}
            
            mouseChildren = false;
            buttonMode = true;
            
            m_dict = new Dictionary(false);
            m_dictLen = 0;
            
            for each(var label:FrameLabel in(_view.scenes[0] as Scene).labels) {
                if(label.name) {
                    m_dict[label.name] = true;
                    m_dictLen++;
                }
                
            }
            
            this.enabled = true;
            listen();
        }
        
        protected function listen():void {
            addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
            addEventListener(MouseEvent.ROLL_OVER, overHandler);
            addEventListener(MouseEvent.ROLL_OUT, outHandler);
        }
        
        protected function unlisten():void {
            removeEventListener(MouseEvent.MOUSE_DOWN, downHandler);
            removeEventListener(MouseEvent.ROLL_OVER, overHandler);
            removeEventListener(MouseEvent.ROLL_OUT, outHandler);
        }
        
        protected function setButtonState(state:String):void {
            //            if(_dict[state]) {
            //                _view.gotoAndStop(state);
            //                return;
            //            }
            drawMouseState(state);
            return;
            
            switch(state) {
                case STATE_OUT:
                    _view.gotoAndStop(1);
                    break;
                case STATE_OVER:
                    arguments.callee.call(null, STATE_OUT);
                    break;
                case STATE_DOWN:
                    arguments.callee.call(null, STATE_OUT);
                    break;
                case STATE_SELECT:
                    arguments.callee.call(null, STATE_OUT);
                    break;
                case STATE_DISABLE:
                    arguments.callee.call(null, STATE_OUT);
                    break;
            }
        }
        
        protected function drawMouseState(frameLabel:String):void {
            if(m_dictLen == 0) {
                var i:int = m_labelsToids[frameLabel] == undefined ? 1 : m_labelsToids[frameLabel];
                if(_view)_view.gotoAndStop(i);
            } else {
                frameLabel = m_dict[frameLabel] == undefined ? Button.ROLL_OUT : frameLabel;
                _view.gotoAndStop(frameLabel);
            }
        }
        
        protected function overHandler(e:MouseEvent):void {
            if(!_pressing && !_selected) {
                setButtonState(STATE_OVER);
            }
        }
        
        protected function outHandler(e:MouseEvent):void {
            if(!_pressing && !_selected) {
                setButtonState(STATE_OUT);
            }
        }
        
        protected function downHandler(e:MouseEvent):void {
            _pressing = true;
            
            if(!_selected) {
                setButtonState(STATE_DOWN);
            }
            stage.addEventListener(MouseEvent.MOUSE_UP, upHandler);
        }
        
        protected function upHandler(e:MouseEvent):void {
            e.currentTarget.removeEventListener(e.type, arguments.callee);
            
            if(!_selected) {
                setButtonState(e.target == this ? STATE_OVER : STATE_OUT);
            }
            
            _pressing = false;
        }
        
        override public function get enabled():Boolean {
            return _enabled;
        }
        
        override public function set enabled(value:Boolean):void {
            _enabled = value;
            mouseEnabled = _enabled;
            
            _enabled ? listen() : unlisten();
            setButtonState(_enabled ? STATE_OUT : STATE_DISABLE);
        }
		
		public function get view():MovieClip
		{
			return _view;
		}
        
        /**
         * 是否选中
         */
        public function get selected():Boolean {
            return _selected;
        }
        
        public function set selected(value:Boolean):void {
            _selected = value;
            
            buttonMode = !_selected;
            setButtonState(_selected ? STATE_SELECT : STATE_OUT);
        }
		public function dispose():void{
			m_dict = null;
			_view = null;
			unlisten();
			removeChildren();
		}
    }

}
