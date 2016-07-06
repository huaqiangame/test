package com.tencent.morefun.naruto.plugin.battle.messageConverter
{
	import com.tencent.morefun.naruto.plugin.motion.data.BubbleDialogueActionInfo;
	import com.tencent.morefun.naruto.plugin.motion.data.BubbleDialogueData;
	import serverProto.fight.ProtoBubbleDialogue;
	import serverProto.fight.ProtoMetaAction;

	public class BubbleDialogueConverter
	{
		public function BubbleDialogueConverter()
		{
		}
		
		public static function convertBubbleDialogue(metaAction:ProtoMetaAction):void
		{
			var dialogueActions:Array;
			
			var dialogueActionInfo:BubbleDialogueActionInfo;
			var dialogueActionData:BubbleDialogueData;
			
			dialogueActions = metaAction.dialogueAction.bubbleDialogue;
			
			dialogueActionInfo = new BubbleDialogueActionInfo();
			for each(var dialogueAction:ProtoBubbleDialogue in dialogueActions)
			{
				dialogueActionData = new BubbleDialogueData();
				dialogueActionData.dialogue = dialogueAction.dialogue;
				dialogueActionData.existTime = dialogueAction.existTime;
				dialogueActionData.lastTime = dialogueAction.lastTime;
				dialogueActionData.pos = dialogueAction.pos;
				
				dialogueActionInfo.dialogueDataList.push(dialogueActionData);
			}
			
			ConverterResultInfo.callCancelSkillCommand(metaAction.abortNinjaAwakenSkill);
			ConverterResultInfo.addBubbleDialogueAction(dialogueActionInfo);
		}
																
		public function autoSetNull():void
		{

		}
	}
}