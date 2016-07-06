package com.tencent.morefun.naruto.plugin.exui.task
{
	import com.tencent.morefun.framework.base.CommandEvent;
	import com.tencent.morefun.naruto.plugin.exui.item.ItemIcon;
	import com.tencent.morefun.naruto.plugin.ui.tips.TipsManager;
	
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
	public class TaskReward extends TaskRewardSimple
	{
		private var baseGap:int = 120;
		
		public function TaskReward(res:MovieClip,itemUIClass:Class,baseGap:int=120)
		{
			super(res,itemUIClass);
			this.baseGap = baseGap;
			
			TipsManager.singleton.binding(res['exp']['icon'],I18n.lang("as_exui_1451031568_1270"));
			TipsManager.singleton.binding(res['money']['icon'],I18n.lang("as_exui_1451031568_1271"));
			TipsManager.singleton.binding(res['ticket']['icon'],I18n.lang("as_exui_1451031568_1272"));

            res['exp'].txt.width = 200;
            res['money'].txt.width = 100;
            res['ticket'].txt.width = 100;
		}
		
		override public function setTaskInfo(taskInfo:TaskInfo):void
		{
			super.setTaskInfo(taskInfo);
			updateBase();
		}
		
		private function updateBase():void
		{
			res['exp'].visible = false;
			res['money'].visible = false;
			res['ticket'].visible = false;
			
			
			var xx:int = 0;
			if(taskInfo.cfg.rewardExp)
			{
				res['exp'].x = xx;
				res['exp'].txt.htmlText = taskInfo.cfg.rewardExp;
				res['exp'].visible = true;
				
				xx += baseGap;
			}
			
			if(taskInfo.cfg.rewardMoney)
			{
				res['money'].x = xx;
				res['money'].txt.htmlText = taskInfo.cfg.rewardMoney;
				res['money'].visible = true;
				
				xx += baseGap;
			}
			
			if(taskInfo.cfg.rewardTicket)
			{
				res['ticket'].x = xx;
				res['ticket'].txt.htmlText = taskInfo.cfg.rewardTicket;
				res['ticket'].visible = true;
				
				xx += baseGap;
			}
		}

        public function appendStr(expStr:String=null, moneyStr:String=null, dianquanStr:String=null):void
        {
            if (taskInfo == null)
                return;

            if (expStr != null)
            {
                res['exp'].txt.htmlText = taskInfo.cfg.rewardExp + "<font color='#00CE30'>" + expStr + "</font>";
            }

            if (moneyStr != null)
            {
                res['money'].txt.htmlText = taskInfo.cfg.rewardMoney + "<font color='#00CE30'>" + moneyStr + "</font>";
            }

            if (dianquanStr != null)
            {
                res['ticket'].txt.htmlText = taskInfo.cfg.rewardTicket + "<font color='#00CE30'>" + dianquanStr + "</font>";
            }
        }
		
		override public function destroy():void
		{
			TipsManager.singleton.unbinding(res['exp']['icon']);
			TipsManager.singleton.unbinding(res['money']['icon']);
			TipsManager.singleton.unbinding(res['ticket']['icon']);
			super.destroy();
		}
	}
}