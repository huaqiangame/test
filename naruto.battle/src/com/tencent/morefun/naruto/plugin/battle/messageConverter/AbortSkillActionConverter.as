package com.tencent.morefun.naruto.plugin.battle.messageConverter
{
	import com.tencent.morefun.naruto.plugin.motion.data.AbortSkillActionInfo;
	import serverProto.fight.ProtoAbortNinjaAwakenSkill;
	import serverProto.fight.ProtoMetaAction;

	public class AbortSkillActionConverter
	{
		public function AbortSkillActionConverter()
		{
			
		}
		
		public static function convertAbortSkillAction(metaAction:ProtoMetaAction):void
		{
			var abortSkillActionInfo:AbortSkillActionInfo;
			
			abortSkillActionInfo = new AbortSkillActionInfo();
			for each(var protoAbortNinjaAwakenSkill:ProtoAbortNinjaAwakenSkill in metaAction.abortNinjaAwakenSkill)
			{
				abortSkillActionInfo.abortPosList.push(protoAbortNinjaAwakenSkill.ninjaPos);
			}
			
			ConverterResultInfo.addAbortSkillAction(abortSkillActionInfo);
		}
																
		public function autoSetNull():void
		{

		}
	}
}