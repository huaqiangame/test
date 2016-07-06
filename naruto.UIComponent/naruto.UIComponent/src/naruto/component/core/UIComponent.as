package naruto.component.core
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import naruto.component.utils.MMUtils;
	
	public class UIComponent extends MovieClip
	{
		public static const LIVE_PREVIEW_PARENT:String = "fl.livepreview::LivePreviewParent";
		public static var inCallLaterPhase:Boolean = false;
		
		protected static var checkLivePreviewResult:int = 0; // 缓存 checkLivePreview() 的结果。0：没查询；1：true；2：false
		
		protected var _enabled:Boolean = true;
		protected var _width:Number;
		protected var _height:Number;
		protected var _x:Number;
		protected var _y:Number;
		
		protected var callLaterMethods:Dictionary; // 要延迟执行的函数。function  = true
		protected var invalidHash:Object; // 指示什么类型数据无效了。InvalidationType = true
		protected var startWidth:Number; // 初始宽度
		protected var startHeight:Number; // 初始高度
		
		/**
		 * 额外附加数据。
		 */		
		public var userData:Object;
		
		public function UIComponent()
		{
			super();
			stop();
			this.invalidHash = {};
			this.callLaterMethods = new Dictionary();
			this.configUI();
			this.invalidate(InvalidationType.ALL);
		}
		
		[Inspectable(defaultValue=true, verbose=1)]
		override public function get enabled():Boolean
		{
			return _enabled;
		}
		
		override public function set enabled(value:Boolean):void
		{
			if (value == _enabled)
			{
				return;
			}
			_enabled = value;
			this.invalidate(InvalidationType.STATE);
		}
		
		[Inspectable(defaultValue=true, verbose=1)]
		override public function get visible():Boolean
		{
			return super.visible;
		}
		
		override public function set visible(value:Boolean):void
		{
			if (super.visible == value)
			{
				return;
			}
			super.visible = value;
		}
		
		override public function get width():Number
		{
			return _width;
		}
		
		override public function set width(value:Number):void
		{
			if (_width == value)
			{
				return;
			}
			this.setSize(value, height);
		}
		
		override public function get height():Number
		{
			return _height;
		}
		
		override public function set height(value:Number):void
		{
			if (_height == value)
			{
				return;
			}
			this.setSize(width, value);
		}
		
		public function move(x:Number,y:Number):void
		{
			_x = x;
			_y = y;
			super.x = Math.round(x);
			super.y = Math.round(y);
		}
		
		override public function get x():Number
		{
			return isNaN(_x) ? super.x : _x;
		}
		
		override public function set x(value:Number):void
		{
			this.move(value, _y);
		}
		
		override public function get y():Number
		{
			return isNaN(_y) ? super.y : _y;
		}
		
		override public function set y(value:Number):void
		{
			this.move(_x, value);	
		}
		
		override public function get scaleX():Number
		{
			return this.width / this.startWidth;
		}
		
		override public function set scaleX(value:Number):void
		{
			this.setSize(this.startWidth * value, this.height);
		}
		
		override public function get scaleY():Number
		{
			return this.height / this.startHeight;
		}
		
		override public function set scaleY(value:Number):void
		{
			this.setSize(this.width, this.startHeight * value);
		}
		
		public function setSize(width:Number, height:Number):void
		{
			if (_width == width && _height == height)
			{
				return;
			}
			_width = width;
			_height = height;
			this.invalidate(InvalidationType.SIZE);
		}
		
		protected function getOriginalScaleY():Number
		{
			return super.scaleY;
		}
		
		protected function setOriginalScaleY(value:Number):void
		{
			super.scaleY = value;
		}
		
		protected function getOriginalScaleX():Number
		{
			return super.scaleX;
		}
		
		protected function setOriginalScaleX(value:Number):void
		{
			super.scaleX = value;
		}
		
		protected function getOriginalScaleWidth():Number
		{
			return super.width;
		}
		
		protected function setOriginalScaleWidth(value:Number):void
		{
			super.width = value;
		}
		
		protected function getOriginalScaleHeight():Number
		{
			return super.height;
		}
		
		protected function setOriginalScaleHeight(value:Number):void
		{
			super.height = value;
		}
		
		public function validateAllNow():void
		{
			this.invalidate(InvalidationType.ALL, false);
			this.draw();
		}
		
		public function invalidate(property:String=InvalidationType.ALL, callLater:Boolean=true):void
		{
			this.invalidHash[property] = true;
			if (callLater)
			{
				this.callLater(draw);
			}
		}
		
		public function drawNow():void
		{
			this.draw();
		}
		
		protected function configUI():void
		{
			var r:Number = this.rotation;
			this.rotation = 0;
			this.startWidth = super.width;
			this.startHeight = super.height;
			super.scaleX = 1;
			super.scaleY = 1;
			this.setSize(this.startWidth, this.startHeight);
			this.move(super.x, super.y);
			this.rotation = r;
			
			// 在 Flash IDE 创作时
			if (this.checkLivePreview() && MMUtils.checkFlashProfessional())
			{
				MMUtils.setNarutoComponentExternal();
				MMUtils.addNarutoComponentSWCExternalLibraryPath();
				MMUtils.checkExtensionUpdate();
			}
		}
		
		/**
		 * 检查是否处于实时预览的环境（通常是 Flash Professional 的创作环境）当中。
		 * @return 
		 */		
		protected function checkLivePreview():Boolean
		{
			if (UIComponent.checkLivePreviewResult == 1)
			{
				return true;
			}
			else if (UIComponent.checkLivePreviewResult == 2)
			{
				return false;
			}
			
			if (this.parent == null) { return false; }
			var className:String;
			try 
			{
				className = getQualifiedClassName(this.parent);	
			} catch (e:Error) {}
			var result:Boolean = (className == UIComponent.LIVE_PREVIEW_PARENT);
			UIComponent.checkLivePreviewResult = result ? 1 : 2;
			return result;
		}
		
		protected function isInvalid(property:String, ...properties:Array):Boolean
		{
			if (invalidHash[property] || invalidHash[InvalidationType.ALL]) { return true; }
			while (properties.length > 0)
			{
				if (invalidHash[properties.pop()]) { return true; }
			}
			return false
		}
		
		/**
		 * 已对所有无效类型处理过。
		 */		
		protected function validate():void
		{
			this.invalidHash = {};
		}
		
		/**
		 * 子类需要重写此方法来处理所有无效类型。
		 */		
		protected function draw():void
		{
			this.validate();
		}
		
		protected function callLater(fn:Function):void
		{
			if (UIComponent.inCallLaterPhase) { return; }
			
			this.callLaterMethods[fn] = true;
			if (this.stage)
			{
				try
				{
					this.stage.addEventListener(Event.RENDER, this.callLaterDispatcher, false, 0, true);
					this.stage.invalidate();
				}
				catch (se:SecurityError)
				{
					this.addEventListener(Event.ENTER_FRAME, this.callLaterDispatcher, false, 0, true);
				}
			}
			else
			{
				this.addEventListener(Event.ADDED_TO_STAGE, this.callLaterDispatcher, false, 0, true);
			}
		}
		
		private function callLaterDispatcher(event:Event):void
		{
			if (event.type == Event.ADDED_TO_STAGE)
			{
				try
				{
					this.removeEventListener(Event.ADDED_TO_STAGE, this.callLaterDispatcher);
					this.stage.addEventListener(Event.RENDER, this.callLaterDispatcher, false, 0, true);
					this.stage.invalidate();
					return;
				}
				catch (se1:SecurityError)
				{
					this.addEventListener(Event.ENTER_FRAME, this.callLaterDispatcher, false, 0, true);
				}
			}
			else
			{
				event.target.removeEventListener(Event.RENDER, this.callLaterDispatcher);
				event.target.removeEventListener(Event.ENTER_FRAME, this.callLaterDispatcher);
				try
				{
					if (stage == null)
					{
						this.addEventListener(Event.ADDED_TO_STAGE, this.callLaterDispatcher, false, 0, true);
						return;
					}
				}
				catch (se2:SecurityError){}
			}
			
			UIComponent.inCallLaterPhase = true;
			
			var methods:Dictionary = this.callLaterMethods;
			for (var method:Object in methods)
			{
				method();
				delete(methods[method]);
			}
			UIComponent.inCallLaterPhase = false;
		}
		
		/**
		 * 获得指定的参数的可视对象实例。
		 * @param component
		 * @return 
		 */		
		public function getDisplayObjectInstance(skin:Object):DisplayObject
		{
			var classDef:Object = null;
			if (skin is Class)
			{
				return (new skin()) as DisplayObject; 
			}
			else if (skin is DisplayObject)
			{
				(skin as DisplayObject).x = 0;
				(skin as DisplayObject).y = 0;
				return skin as DisplayObject;
			}
			
			try
			{
				classDef = getDefinitionByName(skin.toString());
			}
			catch(e:Error)
			{
				try
				{
					classDef = loaderInfo.applicationDomain.getDefinition(skin.toString()) as Object;
				}
				catch (e:Error)
				{
				}
			}
			
			if (classDef == null)
			{
				return null;
			}
			return (new classDef()) as DisplayObject;
		}
		
		public function dispose():void
		{
			var methods:Dictionary = this.callLaterMethods;
			for (var method:Object in methods)
			{
				delete(methods[method]);
			}
			this.callLaterMethods = null;
			this.invalidHash = null;
			this.userData = null;
			
			// 移除显示列表
			try
			{
				this.removeChildren();
			}catch(e:Error){}
		}
		
	}
	
}