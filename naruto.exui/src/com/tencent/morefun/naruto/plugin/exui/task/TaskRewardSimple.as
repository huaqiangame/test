package com.tencent.morefun.naruto.plugin.exui.task
{
	import com.tencent.morefun.framework.base.CommandEvent;
	import com.tencent.morefun.naruto.plugin.exui.item.ItemIcon;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import bag.data.ItemData;
	import bag.utils.BagUtils;
	
	import def.TipsTypeDef;
	
	import reward.cfg.RewardCfg;
	import reward.cfg.RewardItemCfg;
	import reward.cmd.GetRewardCfgCommand;
	
	import task.datas.TaskInfo;

    import com.tencent.morefun.naruto.i18n.I18n;
	public class TaskRewardSimple
	{
		public static var GAP_ITEMS:int = 10;
		public var res:MovieClip;
		
		protected var taskInfo:TaskInfo;
		protected var rewardCfg:RewardCfg;
		protected var itemUIClass:Class;
		protected var _rewardItems:Vector.<ItemData>;
		
		protected var cmd:GetRewardCfgCommand;
		public var onUpdateRewardItemsFun:Function;
		
		public function TaskRewardSimple(res:MovieClip,itemUIClass:Class)
		{
			this.res = res;
			this.itemUIClass = itemUIClass;
		}
		
		public function setTaskInfo(taskInfo:TaskInfo):void
		{
			this.taskInfo = taskInfo;
			updateReward();
		}
		
		protected function updateReward():void
		{
			destroyCMD();
			destroyItems();
			
			if(taskInfo.cfg.reward != 0)
			{
				cmd = new GetRewardCfgCommand(taskInfo.cfg.reward);
				cmd.addEventListener(CommandEvent.FINISH,onGetRewardCfgCommand);
				cmd.addEventListener(CommandEvent.FAILD,onGetRewardCfgCommand);
				cmd.call();
			}
		}
		
		
		protected function onGetRewardCfgCommand(event:CommandEvent):void
		{
			cmd.removeEventListener(CommandEvent.FINISH,onGetRewardCfgCommand);
			cmd.removeEventListener(CommandEvent.FAILD,onGetRewardCfgCommand);
			switch(event.type)
			{
				case CommandEvent.FINISH:
					rewardCfg = cmd.cfg;
					updateRewardItems();
					break;
				case CommandEvent.FAILD:
					var txt:TextField = new TextField();
					txt.y = 50;
					txt.autoSize = "left";
					txt.text = I18n.lang("as_exui_1451031568_1273_0")+taskInfo.cfg.reward+I18n.lang("as_exui_1451031568_1273_1");
					res.items.addChild(txt);
					break;
			}
		}
		
		protected function updateRewardItems():void
		{
			var itemX:int = 0;
			var items:Vector.<ItemData> = new Vector.<ItemData>();
			var item:ItemData;
			
			for each(var itemCfg:RewardItemCfg in rewardCfg.items)
			{
				var rewardItemUI:Sprite = new itemUIClass();
				rewardItemUI.name = "img";
				
				if(rewardItemUI['txt'])
				{
					rewardItemUI['txt'].htmlText = BagUtils.getColoredItemName(itemCfg.itemId);
				}
				rewardItemUI['numTxt'].mouseEnabled = false;
				rewardItemUI['numTxt'].text = itemCfg.num;
				rewardItemUI.x = itemX;;
				res.items.addChild(rewardItemUI);
				
				itemX += rewardItemUI.width + GAP_ITEMS;
				
				var itemIcon:ItemIcon = new ItemIcon();
				
				item = BagUtils.createItemData(itemCfg.itemId, itemCfg.num);
				
				if (itemCfg.itemId != 0)
					itemIcon.loadIcon(itemCfg.itemId, item, TipsTypeDef.BAG_ITEM);
				itemIcon.mouseEnabled = false;
				rewardItemUI['img'].addChild(itemIcon);
				
				items.push(item);
			}
			
			_rewardItems = items;
			if(onUpdateRewardItemsFun != null)
			{
				onUpdateRewardItemsFun();
			}
		}
		
		public function get rewardItems():Vector.<ItemData>
		{
			return _rewardItems;
		}
		
		protected function destroyCMD():void
		{
			if(cmd)
			{
				cmd.removeEventListener(CommandEvent.FINISH,onGetRewardCfgCommand);
				cmd.removeEventListener(CommandEvent.FAILD,onGetRewardCfgCommand);
				cmd = null;
			}
		}
		
		protected function destroyItems():void
		{
			for(var i:int=res.items.numChildren-1;i>=0;i--)
			{
				var dobj:DisplayObject= res.items.getChildAt(i);
				if(dobj.name=="img")
				{
					res.items.removeChild(dobj);
					if(dobj["img"] && dobj["img"].numChildren>0)
					{
						var itemIcon:ItemIcon = dobj["img"].getChildAt(0) as ItemIcon;
						if(itemIcon)
						{
							if(itemIcon.parent)
							{
								itemIcon.parent.removeChild(itemIcon);
							}
							itemIcon.unload();
						}
					}
				}
			}
		}
		
		public function destroy():void
		{
			destroyCMD();
			destroyItems();
			itemUIClass = null;
			rewardCfg = null;
			taskInfo = null;
			res = null;
			onUpdateRewardItemsFun = null;
		}
	}
}