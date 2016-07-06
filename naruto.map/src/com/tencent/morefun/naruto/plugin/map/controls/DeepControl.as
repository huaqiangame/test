package com.tencent.morefun.naruto.plugin.map.controls
{
	import com.tencent.morefun.naruto.model.event.ModelEvent;
	import com.tencent.morefun.naruto.plugin.ui.util.TimerProvider;
	import com.tencent.morefun.naruto.util.def.TimerDef;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import base.ApplicationData;
	
	import battle.data.BattleInfo;
	import battle.def.BattleKeyDef;
	
	import def.ModelDef;
	
	import map.def.MapLayerDef;
	import map.element.IDIYDeepElementProvider;

	public class DeepControl
	{
		private var isStarted:Boolean;
		private var layers:Vector.<Sprite>;
		private var battleModel:BattleInfo;
		
		public function DeepControl(layers:Vector.<Sprite>)
		{
			this.layers = layers;
			
			battleModel = ApplicationData.singleton.getModel(ModelDef.BATTLE) as BattleInfo;
			battleModel.addEventListener(ModelEvent.UPDATE, onUpdate);
		}
		
		private function onUpdate(evt:ModelEvent):void
		{
			switch(evt.key)
			{
				case BattleKeyDef.END:
				case BattleKeyDef.FAIL:
					TimerProvider.addTimeTask(TimerDef.HALF_SECOND,checkDeep);
					break;
				case BattleKeyDef.START:
					updateCheckDeep();
					break;
			}
		}
		
		private function checkDeep():void
		{
			updateDeep(layers[MapLayerDef.BOTTOM_ELEMENT]);
			updateDeep(layers[MapLayerDef.MIDDLE_ELEMENT]);
			updateDeep(layers[MapLayerDef.FRONT_ELEMENT]);
		}
		
		private function updateDeep(layer:Sprite):void
		{
			var diyDeepList:Array;
			var normalDeepList:Array;
			var len:int = layer.numChildren;
			var i:int;
			var dobj:DisplayObject;
			
			diyDeepList = [];
			normalDeepList = [];
			for(i=0;i<len;i++)
			{
				dobj = layer.getChildAt(i);
				
				if(dobj is IDIYDeepElementProvider)
				{
					diyDeepList.push(dobj);
				}
				else
				{
					normalDeepList.push(dobj);
				}
			}
			
			var firstSortList:Array = [];
			var hitResultList:Array = [];
			var hitTest:Boolean;
			var moveItem:DisplayObject;
			var fixItem:DisplayObject;
			
			firstSortList = diyDeepList.concat();
			for(i = 0; i < normalDeepList.length;i ++)
			{
				moveItem = normalDeepList[i];
				hitTest = false;
				for(var j:int = 0;j < diyDeepList.length;j ++)
				{
					fixItem = diyDeepList[j];
					if(moveItem.getBounds(layer).intersects(fixItem.getBounds(layer)))
					{
						hitResultList.push({moveItem:moveItem, fixedItem:fixItem, moveY:moveItem.y, fixY:fixItem.y});
						hitTest = true;
					}
				}
				
				if(hitTest == false)
				{
					normalDeepList.splice(i, 1);
					firstSortList.push(moveItem);
					i --;
				}
			}
			
			firstSortList.sortOn(["y", "name"], [Array.NUMERIC, null]);
			hitResultList.sortOn(["moveY", "name"], [Array.NUMERIC, null]);
			
			var k:int;
			var moveItemIndex:int;
			var fixItemIndex:int;
			var compareResult:int;
			var hitResultObj:Object;
			for(k = 0;k <hitResultList.length;k ++)
			{
				hitResultObj = hitResultList[k];
				
				moveItem = hitResultObj.moveItem;
				fixItem = hitResultObj.fixedItem;
				
				moveItemIndex = firstSortList.indexOf(moveItem);
				if(moveItemIndex != -1)
				{
					firstSortList.splice(moveItemIndex, 1);
				}
				
				fixItemIndex = firstSortList.indexOf(fixItem);
				compareResult = compareDeep(moveItem, fixItem as IDIYDeepElementProvider);
				if(compareResult < 0)
				{
					firstSortList.splice(fixItemIndex, 0, moveItem);
					
					hitResultList.splice(k, 1);
					k --;
				}
				
				
			}
			
			hitResultList.sortOn(["fixY", "moveY", "name"], [Array.NUMERIC, Array.NUMERIC|Array.DESCENDING, null]);
			for(k = 0;k <hitResultList.length;k ++)
			{
				hitResultObj = hitResultList[k];
				
				moveItem = hitResultObj.moveItem;
				fixItem = hitResultObj.fixedItem;
				
				moveItemIndex = firstSortList.indexOf(moveItem);
				if(moveItemIndex != -1)
				{
					firstSortList.splice(moveItemIndex, 1);
				}
				
				fixItemIndex = firstSortList.indexOf(fixItem);
				compareResult = compareDeep(moveItem, fixItem as IDIYDeepElementProvider);
				if(compareResult >= 0)
				{
					firstSortList.splice(fixItemIndex + 1, 0, moveItem);
					
					hitResultList.splice(k, 1);
					k --;
				}
				
				
			}
			
			var middleItemInfo:DisplayObject;
			for(k = 0;k < firstSortList.length;k ++)
			{
				middleItemInfo = firstSortList[k];
				layer.setChildIndex(middleItemInfo, k)
			}
		}
		
		private var moveItemPoint:Point = new Point();
		private function compareDeep(moveItem:DisplayObject, fixedItem:IDIYDeepElementProvider):int
		{
			var groundPoints:Array;
			var fixedItemPoint:Point;
			var nearestPoint:Point;
			var nearestDistance:int;
			
			nearestPoint = new Point();
			
			nearestDistance = int.MAX_VALUE;
			groundPoints = fixedItem.diyDeepElement.deepPoints;
			moveItemPoint.x = moveItem.x;
			moveItemPoint.y = moveItem.y;
			nearestPoint.x = moveItem.x;
			nearestPoint.y = moveItem.y;
			for each(fixedItemPoint in groundPoints)
			{
				if(Point.distance(moveItemPoint,fixedItemPoint) < nearestDistance)
				{
					nearestPoint = fixedItemPoint;
					nearestDistance = Point.distance(moveItemPoint,fixedItemPoint)
				}
			}
			
			if(moveItemPoint.y < nearestPoint.y)
			{
				return -1;
			}
			else if(moveItemPoint.y == nearestPoint.y)
			{
				return 0
			}
			else
			{
				return 1;
			}
		}
		
		public function startup():void
		{
			isStarted = true;
			
			updateCheckDeep();
		}
		
		public function dispose():void
		{
			isStarted = false;
			
			TimerProvider.removeTimeTask(TimerDef.HALF_SECOND,checkDeep);
		}
		
		private function updateCheckDeep():void
		{
			if(isStarted){TimerProvider.addTimeTask(TimerDef.HALF_SECOND,checkDeep);}
		}
		
		public function destroy():void
		{
			dispose();
			layers = null;
		}
	}
}