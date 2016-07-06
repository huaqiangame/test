package com.tencent.morefun.naruto.plugin.ui.base
{
	import com.tencent.morefun.naruto.plugin.ui.base.def.ScrollTextType;
	import com.tencent.morefun.naruto.plugin.ui.layer.LayoutManager;
	import com.tencent.morefun.naruto.plugin.ui.layer.def.LayerDef;
	import com.tencent.morefun.naruto.plugin.ui.layer.def.LocationDef;
	import com.tencent.morefun.naruto.plugin.ui.tips.ScrollTipUI;
	import com.tencent.morefun.naruto.plugin.ui.util.DisplayUtils;
	import com.tencent.morefun.naruto.plugin.ui.util.TimerProvider;
	import com.tencent.morefun.naruto.util.DisplayUtil;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import ui.ScrollTips.SakuraScrollBg;

	public class ScrollText extends Sprite
	{
		private static var ms_instance:ScrollText;
		
		private var m_res:ScrollTipUI;
		
		private var m_textFieldList:Array = []
		private var m_waitAppendTextList:Array = [];
		private var m_waitAppendTextTypeList:Array = [];
		private var m_waitAppendTextParamsList:Array = [];
		
		private var m_lastAppendTextField:TextField;
		
		private var m_appendOffset:int;
		private var m_appendSpeed:int;
		
		private var m_defaultTextField:TextField;
		private var m_scrollBg:MovieClip;
		
		private var m_textContainer:Sprite;
		
		public function ScrollText(appendOffset:int = 20, appendSpeed:int = 2)
		{
			var maskSp:Sprite;
			
			super();
			
			m_appendOffset = appendOffset;
			m_appendSpeed = appendSpeed;
			
			m_textContainer = new Sprite();
			addChild(m_textContainer);
			m_res = new ScrollTipUI();
			m_textContainer.addChild(m_res);
			
			m_defaultTextField = m_res["scrollText"];
			
			visible = false;
			
			maskSp = new Sprite();
			maskSp.graphics.beginFill(0x000000);
			maskSp.graphics.drawRect(0, 0, m_res.width, m_res.height);
			maskSp.graphics.endFill();
			m_textContainer.addChild(maskSp);
			
			m_textContainer.mask = maskSp;
		}
		
		public static function get singleton():ScrollText
		{
			if(ms_instance == null)
			{
				ms_instance = new ScrollText();
				LayoutManager.singleton.addItemAndLayout(ms_instance, LayerDef.TIPS, LocationDef.TOPCENTRE, new Point(0, 120));
			}
			
			return ms_instance;
		}
		
		/**
		 * type是走马灯类型，@see ScrollTextType
		 * parmas是针对不同类型的走马灯可能要传递的参数
		 */
		public function addAppendText(value:String, type:int = 1, params:Object = null):void
		{
			m_waitAppendTextList.push(value);
			m_waitAppendTextTypeList.push(type);
			m_waitAppendTextParamsList.push(params);
			
			if(m_waitAppendTextList.length == 1)
			{
				visible = true;
				TimerProvider.addEnterFrameTask(updateTextPosition);
			}
		}
		
		private function checkAndAppendNext():void
		{
			if(m_lastAppendTextField == null)
			{
				appendNext();
				return ;
			}
			
			if(m_res.x + m_res.width - m_lastAppendTextField.x - m_lastAppendTextField.width > m_appendOffset)
			{
				appendNext();
			}
		}
		
		override public function get width():Number
		{
			return m_res["bg"].width;
		}
		
		private function appendNext():void
		{
			var text:String;
			var textField:TextField;
			var type:int;
			var params:Object;
			
			if(m_waitAppendTextList.length != 0)
			{
				textField = new TextField();
				textField.x = m_res.x + m_res.width;
				textField.defaultTextFormat = m_defaultTextField.defaultTextFormat;
				textField.filters = m_defaultTextField.filters;
				textField.autoSize = TextFieldAutoSize.LEFT;
				textField.y = m_defaultTextField.y;
				textField.cacheAsBitmap = true;
				textField.selectable = false;
				text = m_waitAppendTextList.shift();
				type = m_waitAppendTextTypeList.shift();
				params = m_waitAppendTextParamsList.shift();
				textField.htmlText = text;
				m_textContainer.addChild(textField);
				m_textFieldList.push(textField);
				m_lastAppendTextField = textField;
				
				showScrollBg(type, params);
			}
		}
		
		private function showScrollBg(type:int, params:Object):void
		{
			if (type == ScrollTextType.FLY_SAKURA)
			{
				m_scrollBg = new SakuraScrollBg();
				m_scrollBg.x = 215;
				m_scrollBg.y = 33;
				m_scrollBg.mouseChildren = m_scrollBg.mouseEnabled = false;
				m_scrollBg.text.htmlText = "<b>" + params + "</b>";
				addChildAt(m_scrollBg, 0);
			}
		}
		
		private function updateTextPosition():void
		{
			var textField:TextField;
			
			for(var i:int = 0;i < m_textFieldList.length;i ++)
			{
				textField = m_textFieldList[i];
				textField.x -= m_appendSpeed;
				if(textField.x + textField.width <= m_res.x)
				{
					m_textContainer.removeChild(textField);
					if (m_scrollBg)
					{
						(m_scrollBg.parent) && (m_scrollBg.parent.removeChild(m_scrollBg));
						DisplayUtils.clear(m_scrollBg);
						m_scrollBg = null;
					}
					m_textFieldList.splice(i, 1);
					i --;
				}
			}
			
			checkAndAppendNext();
			checkAndStopTimer();
		}
		
		private function checkAndStopTimer():void
		{
			if(m_lastAppendTextField == null)
			{
				return ;
			}
			
			if(m_lastAppendTextField.x + m_lastAppendTextField.width <= m_res.x)
			{
				TimerProvider.removeEnterFrameTask(updateTextPosition);
				visible = false;
			}
		}
		}
}