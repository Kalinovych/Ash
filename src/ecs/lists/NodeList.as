/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.lists {
import ecs.framework.api.ecs_core;

use namespace ecs_core;

public class NodeList extends ListBase {
	public static const sharedNodeFactory:ItemNodeFactory = new ItemNodeFactory();

	protected var nodeFactory:ItemNodeFactory;

	public function NodeList() {
		nodeFactory = sharedNodeFactory;
	}

	[Inline]
	ecs_core final function get $length():uint {
		return _length;
	}

	[Inline]
	ecs_core final function get $firstNode():Node {
		return _firstNode;
	}

	[Inline]
	ecs_core final function get $lastNode():Node {
		return _lastNode;
	}

	[Inline]
	protected final function $addNodeOrdered( node:Node, order:int ):Node {
		node.order = order;
		var nodeBefore:Node = _lastNode;
		if ( nodeBefore == null || nodeBefore.order <= order ) {
			$addNode( node );
		} else {
			while ( nodeBefore && nodeBefore.order > order ) {
				nodeBefore = nodeBefore.prev;
			}
			if ( nodeBefore ) {
				$addNodeAfter( node, nodeBefore );
			} else {
				$addNodeFirst( node );
			}
		}
	}
	
	[Inline]
	protected final function $createNode( item:* = null ):Node {
		var node:Node = nodeFactory.get();
		node.content = item;
		return node;
	}

	protected function disposeNode( node:Node, nullLinks:Boolean ):void {
		if ( nullLinks ) {
			node.prev = null;
			node.next = null;
		}
		node.content = null;
		nodeFactory.recycle( node );
	}

}
}
