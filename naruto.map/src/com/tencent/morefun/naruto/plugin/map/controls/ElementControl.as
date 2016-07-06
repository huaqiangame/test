package com.tencent.morefun.naruto.plugin.map.controls
{
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	
	import map.def.MapLayerDef;
	import map.element.BaseMapElement;
	import map.events.MapElementEvent;
	import map.utils.MapTimeTypeUtil;

	public class ElementControl
	{
		private var viewpoint:Rectangle;
		private var frontElements:Vector.<BaseMapElement>;
		private var middleElements:Vector.<BaseMapElement>;
		private var bottomElements:Vector.<BaseMapElement>;
		
//		private var elements:Vector.<Vector.<BaseMapElement>>;
		private var layers:Vector.<Sprite>;
		
		
		public function ElementControl(layers:Vector.<Sprite>)
		{
			this.layers = layers;
			frontElements = new Vector.<BaseMapElement>();
			middleElements = new Vector.<BaseMapElement>();
			bottomElements = new Vector.<BaseMapElement>();
		}
		
		public function setTimeType(type:int):void
		{
			var ct:ColorTransform = MapTimeTypeUtil.getColorTransform(type);
			
			layers[MapLayerDef.FRONT_ELEMENT].transform.colorTransform = ct;
			layers[MapLayerDef.BOTTOM_ELEMENT].transform.colorTransform = ct;
			layers[MapLayerDef.MIDDLE_ELEMENT].transform.colorTransform = ct;
		}
		
		public function update(viewpoint:Rectangle):void
		{
			this.viewpoint = viewpoint;
//			this.viewpoint = viewpoint.clone();
//			this.viewpoint.inflate(100,100);
			
			var ele:BaseMapElement;
			
			for each(ele in middleElements)
			{
				checkInOutViewpoint(ele,layers[MapLayerDef.MIDDLE_ELEMENT]);
			}
			
			for each(ele in frontElements)
			{
				checkInOutViewpoint(ele,layers[MapLayerDef.FRONT_ELEMENT]);
			}
			
			for each(ele in bottomElements)
			{
				checkInOutViewpoint(ele,layers[MapLayerDef.BOTTOM_ELEMENT]);
			}
		}
		
		private function checkInOutViewpoint(ele:BaseMapElement, layer:Sprite):void
		{
			var bound:Rectangle = ele.getBounds(null);
//			bound.x += ele.x;
//			bound.y += ele.y;
			
//			bound.inflate(30,30);
			
			var left:int = bound.left + ele.x;
			var right:int = bound.right + ele.x;
			var top:int = bound.top + ele.y;
			var bottom:int = bound.bottom + ele.y;
			
			if(left < viewpoint.right+100 && top < viewpoint.bottom+100 && right > viewpoint.left-100 && bottom > viewpoint.top-100)
//			if(bound.intersects(viewpoint))
			{
				if(!layer.contains(ele))
				{
					layer.addChild(ele);
					ele.inViewPoint();
				}
				if(ele.needPopupContainer && !layers[MapLayerDef.POPUP].contains(ele.popupContainer))
				{
					layers[MapLayerDef.POPUP].addChild(ele.popupContainer);
				}
			}else
			{
				if(layer.contains(ele))
				{
					layer.removeChild(ele);
					ele.outViewPoint();
				}
				if(ele.needPopupContainer && layers[MapLayerDef.POPUP].contains(ele.popupContainer))
				{
					layers[MapLayerDef.POPUP].removeChild(ele.popupContainer);
				}
			}
		}
		
		public function addElement(value:BaseMapElement,layerIndex:int):void
		{
			var layer:Sprite = layers[layerIndex];
			var elements:Vector.<BaseMapElement>;
			switch(layerIndex)
			{
				case MapLayerDef.FRONT_ELEMENT:
					elements = frontElements;
					break;
				case MapLayerDef.MIDDLE_ELEMENT:
					elements = middleElements;
					break;
				case MapLayerDef.BOTTOM_ELEMENT:
					elements = bottomElements;
					break;
			}
			value.layerIndex = layerIndex;
			addElementEvents(value);
			elements.push(value);
			if(viewpoint)
			{
				checkInOutViewpoint(value,layer);
			}
		}
		
//		直接通过BaseMapElement.destroy()方法来删除地图过犹元素
//		public function removeElement(value:BaseMapElement):void
//		{
//			var ele:BaseMapElement;
//			
//			var i:int = middleElements.indexOf(value);
//			if(i != -1)
//			{
//				ele = middleElements.splice(i,1) as BaseMapElement;
//				if(ele.parent)
//				{
//					ele.parent.removeChild(ele);
//				}
//				ele.destroy();
//				return;
//			}
//			i = middleBottomElements.indexOf(value);
//			if(i != -1)
//			{
//				ele = middleBottomElements.splice(i,1) as BaseMapElement;
//				if(ele.parent)
//				{
//					ele.parent.removeChild(ele);
//				}
//				ele.destroy();
//			}
//		}
		
//		public function removeRoleById(id:int):void
//		{
//			for(var i:int=middleElements.length-1;i>=0;i--)
//			{
//				if(middleElements[i]._info.id == id)
//				{
//					if(layer.contains(middleElements[i]))
//					{
//						layer.removeChild(middleElements[i]);
//					}
//					middleElements.splice(i,1);
//					break;
//				}
//			}
//		}
		
		protected function addElementEvents(ele:BaseMapElement):void
		{
			ele.addEventListener(MapElementEvent.CHANGE_XY,onMapElement);
			ele.addEventListener(MapElementEvent.DESTROY,onMapElement);
		}
		protected function removeElementEvents(ele:BaseMapElement):void
		{
			ele.removeEventListener(MapElementEvent.CHANGE_XY,onMapElement);
			ele.removeEventListener(MapElementEvent.DESTROY,onMapElement);
		}
		protected function onMapElement(event:MapElementEvent):void
		{
			var ele:BaseMapElement = event.currentTarget as BaseMapElement;
			switch(event.type)
			{
				case MapElementEvent.CHANGE_XY:
					if(viewpoint)
					{
						checkInOutViewpoint(ele,layers[ele.layerIndex]);
					}
					break;
				case MapElementEvent.DESTROY:
					removeElement(ele);
					break;
			}
		}
		
		private function removeElement(ele:BaseMapElement):void
		{
			if(ele.parent)
			{
				ele.parent.removeChild(ele);
			}
			
			removeElementEvents(ele);
			var index:int = -1;
			if(ele.layerIndex == MapLayerDef.FRONT_ELEMENT)
			{
				index = frontElements.indexOf(ele);
				if(index!=-1)
				{
					frontElements.splice(index,1);
				}
			}else if(ele.layerIndex == MapLayerDef.MIDDLE_ELEMENT)
			{
				index = middleElements.indexOf(ele);
				if(index!=-1)
				{
					middleElements.splice(index,1);
				}
			}else if(ele.layerIndex == MapLayerDef.BOTTOM_ELEMENT)
			{
				index = bottomElements.indexOf(ele);
				if(index!=-1)
				{
					bottomElements.splice(index,1);
				}
			}
		}
		
		
		public function dispose():void
		{
			var ele:BaseMapElement;
			for each(ele in middleElements)
			{
				if(ele.parent)
				{
					ele.parent.removeChild(ele);
				}
//				ele.destroy();
			}
			middleElements.length = 0;
			
			for each(ele in frontElements)
			{
				if(ele.parent)
				{
					ele.parent.removeChild(ele);
				}
//				ele.destroy();
			}
			frontElements.length = 0;
			
			
			for each(ele in bottomElements)
			{
				if(ele.parent)
				{
					ele.parent.removeChild(ele);
				}
			}
			bottomElements.length = 0;
		}
		
		public function destroy():void
		{
			dispose();
			middleElements = null;
			bottomElements = null;
			frontElements = null;
			layers.length = 0;
			layers = null;
			viewpoint = null;
		}
	}
}