/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.lists {
import ashx.engine.ecse;

public class ItemList extends ListBase {
	public static const nodeFactory:ItemNodeFactory = new ItemNodeFactory();
	
	public function ItemList() {
	}
	
	[Inline]
	ecse final function get $firstNode():ItemNode {
		return _firstNode;
	}

	[Inline]
	ecse final function get $lastNode():ItemNode {
		return _lastNode;
	}

	[Inline]
	protected final function $createNode( item:* = null ):ItemNode {
		var node:ItemNode = nodeFactory.get();
		node.item = item;
		return node;
	}

	[Inline]
	protected final function $disposeNode( node:ItemNode, nullLinks:Boolean ):void {
		if (nullLinks) {
			node.prev = null;
			node.next = null;
		}
		node.item = null;
		nodeFactory.recycle( node );
	}
}
}
