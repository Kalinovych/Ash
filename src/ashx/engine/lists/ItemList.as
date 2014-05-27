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
	ecse final function get $firstNode():Node {
		return _firstNode;
	}

	[Inline]
	ecse final function get $lastNode():Node {
		return _lastNode;
	}

	[Inline]
	protected final function $createNode( item:* = null ):Node {
		var node:Node = nodeFactory.get();
		node.content = item;
		return node;
	}

	[Inline]
	protected final function $disposeNode( node:Node, nullLinks:Boolean ):void {
		if (nullLinks) {
			node.prev = null;
			node.next = null;
		}
		node.content = null;
		nodeFactory.recycle( node );
	}
}
}
