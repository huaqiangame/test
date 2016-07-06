package com.tencent.morefun.naruto.plugin.ui.base
{
	import com.tencent.morefun.naruto.plugin.ui.util.ExDictionary;

	public class DirectGridStatusMgr
	{
		private var m_status:Array = [];
		private var m_itemClick:Function;
		/**
		 *1 singleSelectedStatus 2mulitSelectedStatus 
		 * @param model
		 * 
		 */		
		public function DirectGridStatusMgr(model:int = 1)
		{
			switch(model)
			{
				case 1:
					m_itemClick = new SingleItemClickHandler().onClick;
					break;
				case 2:
					m_itemClick = new MulitItemClickHandler().onClick;
					break;
			}
		}
		
		public function set status(value:Array):void
		{
			m_status = value;
		}
		
		public function get status():Array
		{
			return m_status;
		}
		
		public function set itemClickHandler(value:Function):void
		{
			m_itemClick = value;
		}
		
		public function get itemClickHandler():Function
		{
			return m_itemClick;
		}
		
		public function itemClick(itemRender:ItemRenderer, itemMap:ExDictionary):void
		{
			m_itemClick(itemRender, itemMap, m_status, true, false);
		}
		}
}

import com.tencent.morefun.naruto.plugin.ui.base.ItemRenderer;
import com.tencent.morefun.naruto.plugin.ui.util.ExDictionary;

class SingleItemClickHandler
{
	public function SingleItemClickHandler()
	{
		
	}
	
	public function onClick(itemRender:ItemRenderer, itemMap:ExDictionary, status:Array, matchValue:Object, noMatchValue:Object):void
	{
		for(var i:int = 0;i < status.length;i ++)
		{
			if(i != itemRender.index)
			{
				status[i] =  noMatchValue;
			}
			else
			{
				status[i] =  matchValue;
			}
		}
	}}

import com.tencent.morefun.naruto.plugin.ui.base.ItemRenderer;
import com.tencent.morefun.naruto.plugin.ui.util.ExDictionary;

class MulitItemClickHandler
{
	public function MulitItemClickHandler()
	{
		
	}
	
	public function onClick(itemRender:ItemRenderer, itemMap:ExDictionary, status:Array, matchValue:Object, noMatchValue:Object):void
	{
		for(var i:int = 0;i < status.length;i ++)
		{
			if(i == itemRender.index)
			{
				status[i] =  (status[i] == matchValue)? noMatchValue:matchValue;
			}
		}
	}}