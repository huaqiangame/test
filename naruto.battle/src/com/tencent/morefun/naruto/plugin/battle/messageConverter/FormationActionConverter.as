package com.tencent.morefun.naruto.plugin.battle.messageConverter
{
	import com.tencent.morefun.naruto.plugin.motion.data.FormatActionInfo;
	import serverProto.fight.ProtoMetaAction;

	public class FormationActionConverter
	{
		public function FormationActionConverter()
		{
		}
		
		public static function convertFormationAction(metaAction:ProtoMetaAction):void
		{
			var formationActionInfo:FormatActionInfo = new FormatActionInfo();
			formationActionInfo.isOver = metaAction.isOver;
			ConverterResultInfo.callCancelSkillCommand(metaAction.abortNinjaAwakenSkill);
			ConverterResultInfo.addFormationAction(formationActionInfo);
		}
																
		public function autoSetNull():void
		{

		}
	}
}