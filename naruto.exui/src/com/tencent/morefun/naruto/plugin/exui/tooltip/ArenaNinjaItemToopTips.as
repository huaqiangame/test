package com.tencent.morefun.naruto.plugin.exui.tooltip
{

 import majorRole.commands.RequestRefreshTalentSkillCommand;
 import majorRole.def.TalentSkillTypeDef;
 import majorRole.model.ITalentSkillModel;
 import majorRole.model.TalentSkillManager;

    public class ArenaNinjaItemToopTips extends NinjaItemToopTips
    {
        public function ArenaNinjaItemToopTips(skinCls:Class=null)
        {		
			super();
			new RequestRefreshTalentSkillCommand(TalentSkillTypeDef.RANK_BATTLE).call();
		}
		
		override protected function get talentModel():ITalentSkillModel
		{
			return TalentSkillManager.instance.getTalentSkillModel(TalentSkillTypeDef.RANK_BATTLE);
		}
   	}
}