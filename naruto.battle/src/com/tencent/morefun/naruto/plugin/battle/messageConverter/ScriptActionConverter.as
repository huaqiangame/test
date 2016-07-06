package com.tencent.morefun.naruto.plugin.battle.messageConverter
{
	import com.tencent.morefun.naruto.plugin.motion.data.ScriptActionInfo;
	import serverProto.fight.ProtoMetaAction;

	public class ScriptActionConverter
	{
		public function ScriptActionConverter()
		{
		}
		
		/**
		 *解析剧情Action 
		 * @param metaAction
		 * 
		 */		
		public static function convertScript(metaAction:ProtoMetaAction):void
		{
			var scriptActionInfo:ScriptActionInfo = new ScriptActionInfo();
			scriptActionInfo.scriptId = metaAction.scriptAction.scriptId;
			if(metaAction.scriptAction.hasDelayTime)
			{
				scriptActionInfo.delay = metaAction.scriptAction.delayTime;
			}
			scriptActionInfo.isOver = metaAction.isOver;
			
			ConverterResultInfo.callCancelSkillCommand(metaAction.abortNinjaAwakenSkill);
			ConverterResultInfo.addScriptAction(scriptActionInfo);
		}
		
		/**
		 *根据剧情ID给出剧情Action 用在战斗开始资源加载包 
		 * @param scriptId
		 * @return 
		 * 
		 */		
		public static function getScriptInfo(scriptId:int):ScriptActionInfo
		{
			var scriptInfo:ScriptActionInfo;
			
			if(scriptId != 0)
			{
				scriptInfo = new ScriptActionInfo();
				scriptInfo.scriptId = scriptId;
			}
			
			return scriptInfo;
		}
																
		public function autoSetNull():void
		{

		}
	}
}