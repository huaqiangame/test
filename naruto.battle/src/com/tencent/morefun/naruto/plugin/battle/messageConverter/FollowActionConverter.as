package com.tencent.morefun.naruto.plugin.battle.messageConverter
{
	import com.tencent.morefun.naruto.util.CollectionClearUtil;
	import flash.utils.Dictionary;
	import serverProto.fight.MetaActionType;
	import serverProto.fight.ProtoMetaAction;
	import com.tencent.morefun.naruto.util.CollectionClearUtil
	import com.tencent.morefun.naruto.util.CollectionClearUtil

	public class FollowActionConverter
	{
		private static var followEndActionMap:Dictionary = new Dictionary();
		private static var triggerFollowActionMap:Dictionary = new Dictionary();
		
		public function FollowActionConverter()
		{
		}
		
		public static function converFollowActions(metaActions:Array):void
		{
			for each(var metaAction:ProtoMetaAction in metaActions)
			{
				switch(metaAction.type)
				{
					case MetaActionType.NORMAL_ACTION:
						checkAndSetTrigger(metaAction, metaAction.normalAction.isFollowAction);
						break;
					case MetaActionType.MASTER_ACTION:
						checkAndSetTrigger(metaAction, metaAction.normalAction.isFollowAction);
						break;
					case MetaActionType.ENCHANTMENT_ACITON:
						checkAndSetTrigger(metaAction, false);
						break;
					case MetaActionType.REBIRTH_ACTION:
						checkAndSetTrigger(metaAction, false);
						break;
				}
			}
			
			setFollowEndAction(beforTriggerAttackAction);
		}
		
		public static function getActionIsTriggerFollow(action:ProtoMetaAction):Boolean
		{
			return triggerFollowActionMap[action];
		}
		
		public static function getActionIsFollowEnd(action:ProtoMetaAction):Boolean
		{
			return followEndActionMap[action];
		}
		
		public static function reset():void
		{
			CollectionClearUtil.clearDictionary(followEndActionMap);
			CollectionClearUtil.clearDictionary(triggerFollowActionMap);
		}
		
		private static var beforTriggerAttackAction:ProtoMetaAction;
		private static function checkAndSetTrigger(action:ProtoMetaAction, isFollow:Boolean):void
		{
			if(isFollow == false)
			{
				setFollowEndAction(beforTriggerAttackAction);
			}
			
			if(isFollow == true)
			{
				setTriggerFollowAction(beforTriggerAttackAction);
				beforTriggerAttackAction = action;
			}
			
			beforTriggerAttackAction = action;
		}
		
		private static function setTriggerFollowAction(action:ProtoMetaAction):void
		{
			if(action == null)
			{
				return ;
			}
			
			triggerFollowActionMap[action] = true;
		}
		
		private static function setFollowEndAction(action:ProtoMetaAction):void
		{
			if(action == null)
			{
				return ;
			}
			
			followEndActionMap[action] = true;
		}
																
		public function autoSetNull():void
		{

			followEndActionMap = null;
			triggerFollowActionMap = null;
			beforTriggerAttackAction = null;
		}
	}
}