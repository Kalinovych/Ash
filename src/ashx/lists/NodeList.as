/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.lists {
import ashx.engine.api.ecse;

public class NodeList extends ListBase {
	public static const sharedNodeFactory:ItemNodeFactory = new ItemNodeFactory();
	
	protected var nodeFactory:ItemNodeFactory;
	
	public function NodeList() {
		nodeFactory = sharedNodeFactory;
	}

	[Inline]
	ecse final function get $length():uint {
		return _length;
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

	protected function disposeNode( node:Node, nullLinks:Boolean ):void {
		if (nullLinks) {
			node.prev = null;
			node.next = null;
		}
		node.content = null;
		nodeFactory.recycle( node );
	}
}
}
