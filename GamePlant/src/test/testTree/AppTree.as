/**
 * Created by Administrator on 2016/7/7 0007.
 */
package test.testTree
{
	import com.tencent.morefun.naruto.plugin.ui.base.Tree;
	import com.tencent.morefun.naruto.plugin.ui.base.event.TreeEvent;
	import com.test.McTree;

	import flash.display.Sprite;

	public class AppTree extends Sprite
	{
		public static const TITLE:String = "Tree";

		private var tree:Tree;

		public function AppTree()
		{
			super();

			tree = new Tree(20, MyTreeRender, McTree, true);
			this.addChild(tree);

			tree.createNode("1", {"name": "10级宝石"}, null, 0, false);
			tree.createNode("3", {name: "绿宝石", level: 1}, "1", 0, true);
			tree.createNode("4", {name: "蓝宝石", level: 1}, "1", 1, true);
			tree.createNode("5", {name: "紫宝石", level: 1}, "1", 2, true);
			tree.createNode("6", {name: "橙宝石", level: 1}, "1", 3, true);
			tree.createNode("7", {name: "红宝石", level: 1}, "1", 4, true);

			tree.multiSelectedEnable = false;
			tree.addEventListener(TreeEvent.NODE_CLICK, onTreeClick);
			tree.addEventListener(TreeEvent.TREE_UPDATE, onTreeUpdate);
		}

		private function onTreeUpdate(event:TreeEvent):void
		{

		}

		private function onTreeClick(event:TreeEvent):void
		{
			tree.setSelected(event.nodeId);
		}
	}
}
