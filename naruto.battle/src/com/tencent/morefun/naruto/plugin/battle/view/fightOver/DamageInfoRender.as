package com.tencent.morefun.naruto.plugin.battle.view.fightOver
{
	import com.tencent.morefun.naruto.plugin.battle.view.fightOver.damage.DamageModelDef;
	import com.tencent.morefun.naruto.plugin.battle.view.fightOver.damage.DamageNinjaInfo;
	import com.tencent.morefun.naruto.plugin.ui.util.DisplayUtils;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class DamageInfoRender
	{
		private var res:MovieClip;
		
		private var curModel:int;
		private var damageValueBarMax:int;
		private var headRender:DamageSimpleNinjaRender;
		
		private var damageNinjaInfo:DamageNinjaInfo;
		
		public function DamageInfoRender(res:MovieClip)
		{
			super();
			
			this.res = res;
			initUI();
		}
		
		private function initUI():void
		{
			var defaultTextFormation:TextFormat;
			
			headRender = new DamageSimpleNinjaRender();
			DisplayUtils.replaceDisplay(res["head"], headRender);
			
			defaultTextFormation = damageValue.defaultTextFormat;
			defaultTextFormation.bold = true;
			damageValue.defaultTextFormat = defaultTextFormation;
		}
		
		public function set visible(value:Boolean):void
		{
			res.visible = value;
		}
		
		public function changeModel(model:int):void
		{
			curModel = model;
			update(damageNinjaInfo);
		}
		
		public function update(damageNinjaInfo:DamageNinjaInfo):void
		{
			this.damageNinjaInfo = damageNinjaInfo;
			
			if(damageNinjaInfo == null)
			{
				headRender.data = null;
				return ;
			}
			
			headRender.data = damageNinjaInfo.getNinjaInfo();
			
			if(curModel == DamageModelDef.DAMAGE)
			{
				damageValue.text = damageNinjaInfo.makeDamage.toString();
				damageValueBar.scaleX = damageNinjaInfo.makeDamage / damageNinjaInfo.maxMakeDamage;
			}
			else
			{
				damageValue.text = damageNinjaInfo.affordDamage.toString();
				damageValueBar.scaleX = damageNinjaInfo.affordDamage / damageNinjaInfo.maxAffordDamage;
			}
		}
		
		public function destroy():void
		{
			headRender.destroy();
		}
		
		private function get damageValue():TextField
		{
			return res["damageValue"];
		}
		
		private function get damageValueBar():MovieClip
		{
			return res["damageValueBar"];
		}
	}
}