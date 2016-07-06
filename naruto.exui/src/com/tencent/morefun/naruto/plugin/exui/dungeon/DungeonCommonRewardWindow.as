package com.tencent.morefun.naruto.plugin.exui.dungeon 
{
	import com.tencent.morefun.naruto.plugin.ui.box.BaseBox;
	import com.tencent.morefun.naruto.plugin.ui.components.layouts.SimpleLayout;
	import com.tencent.morefun.naruto.plugin.ui.fonts.FontStyleMgr;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import bag.data.ItemData;
	
	import serverProto.player.ProtoRewardNotify;
	import serverProto.player.ProtoRewardType;
	
	import ui.plugin.dungeon.reward.DungeonCommonRewardWindowUI;
	
	/**
	 * 窗口关闭时派发事件
	 */
	[Event(name = "close", type = "flash.events.Event")]
	
	/**
	 * ...
	 * @author larryhou
	 * @createTime 2015/4/30 17:28
	 */
	public class DungeonCommonRewardWindow extends BaseBox
	{
		private var _view:DungeonCommonRewardWindowUI;
		private var _layout:SimpleLayout;
		private var _type:uint;
		
		/**
		 * 构造函数
		 * create a [DungeonCommonRewardWindow] object
		 */
		public function DungeonCommonRewardWindow(list:Vector.<ItemData>, type:uint,rep:ProtoRewardNotify) 
		{
			_type = type;
			super(_view = new DungeonCommonRewardWindowUI(), true, true);
			
			var provider:Array = [];
			while (provider.length < list.length)
			{
				provider.push(list[provider.length]);
			}
			
			_view.tgpf.visible = false;
			_view.ckpfBtn.visible = false;
			//_view.tgpf.title.embedFonts = true;
			//_view.tgpf.title.defaultTextFormat = new TextFormat(FontStyleMgr.HYXueJunJ);
			if(type == ProtoRewardType.PROTO_REWARD_TYPE_BEFALL_DUNGEON){
				if(rep.hasScoreInfo){
					_view.ckpfBtn.visible = true;
					_view.tgpf.syxl.text = rep.scoreInfo.hpScore.toString();//剩余血量百分比
					_view.tgpf.shhh.text = rep.scoreInfo.roundScore.toString(); //通关总回合数
					_view.tgpf.swcs.text = rep.scoreInfo.ninjaDeathScore.toString();//忍者死亡次数
					_view.tgpf.zshz.text = rep.scoreInfo.damageScore.toString();//造成总伤害值
					_view.tgpf.zf.text = rep.scoreInfo.totalScore.toString();//总得分
				}else{
					_view.ckpfBtn.visible = false;
				}

			}
			
			var bounds:Rectangle = _view.container.getBounds(_view);
			_layout = new SimpleLayout(1, 1, 5, 0);
			_layout.itemRenderClass = DungeonRewardItem;
			_layout.column = provider.length;
			_layout.dataProvider = provider;
			_view.container.addChild(_layout);
			_layout.x = (bounds.width - _layout.width) / 2;
			_layout.y = (bounds.height - _layout.height) / 2;
			
			addEventListener(Event.ADDED_TO_STAGE, stageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, stageHandler);
			addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		private function clickHandler(e:MouseEvent):void 
		{
			if (e.target == _view.exitBtn)
			{
				close();
			}else if (e.target == _view.ckpfBtn)
			{
				_view.ckpfBtn.visible = false;
				_view.tgpf.visible = true;
			}
		}
		
		private function stageHandler(e:Event):void 
		{
			if (e.type == Event.ADDED_TO_STAGE)
			{
				stage.addEventListener(Event.RESIZE, resizeUpdate);
				resizeUpdate(e);
			}
			else
			{
				stage.removeEventListener(Event.RESIZE, resizeUpdate);
			}
		}
		
		private function resizeUpdate(e:Event):void 
		{
			var point:Point = globalToLocal(new Point());
			graphics.clear();
			graphics.beginFill(0x000000, 0.3);
			graphics.drawRect(point.x, point.y, stage.stageWidth, stage.stageHeight);
			graphics.endFill();
		}
		
		override public function destroy():void 
		{
			_view.parent && _view.parent.removeChild(_view);
			_view = null;
			
			_layout.dispose();
			_layout.parent && _layout.parent.removeChild(_layout);
			_layout = null;
			
			removeEventListener(Event.ADDED_TO_STAGE, stageHandler);
			removeEventListener(Event.REMOVED_FROM_STAGE, stageHandler);
			removeEventListener(MouseEvent.CLICK, clickHandler);
			if (stage)
			{
				stage.removeEventListener(Event.RESIZE, resizeUpdate);
			}
			
			super.destroy();
		}
		
		override public function close():void 
		{
			super.close();
			dispatchEvent(new Event(Event.CLOSE));
		}
		
		public function get type():uint { return _type; }
	}
}
import bag.data.ItemData;
import com.tencent.morefun.naruto.plugin.exui.item.ItemIcon;
import com.tencent.morefun.naruto.plugin.ui.components.interfaces.IRender;
import flash.display.Sprite;

class DungeonRewardItem extends Sprite implements IRender
{
	private var _data:ItemData;
	private var _icon:ItemIcon;
	
	public function DungeonRewardItem()
	{
		addChild(_icon = new ItemIcon());
	}
	
	private function render():void
	{
		_icon.loadIconByData(_data, true, true);
	}
	
	public function dispose():void 
	{
		_icon.destroy();
		_icon.parent && _icon.parent.removeChild(_icon);
		_icon = null;
		_data = null;
	}
	
	/* INTERFACE com.tencent.morefun.naruto.plugin.ui.components.interfaces.IRender */
	
	public function get data():Object { return _data; }
	public function set data(value:Object):void 
	{
		_data = value as ItemData;
		_data && render();
	}	
	
	override public function get height():Number { return 64; }
	override public function get width():Number { return 64; }
}