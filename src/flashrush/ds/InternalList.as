/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.ds {

use namespace ds_internal;

public class InternalList extends ListBase {
	public static const sharedNodeFactory:NodeFactory = new NodeFactory( 100, 50 );

	protected var nodeFactory:NodeFactory;

	public function InternalList() {
		super();
		nodeFactory = sharedNodeFactory;
	}

	[Inline]
	ds_internal final function get $firstNode():Node {
		return _firstNode;
	}

	[Inline]
	ds_internal final function get $lastNode():Node {
		return _lastNode;
	}

	[Inline]
	ds_internal final function get $length():uint {
		return _length;
	}

	[Inline]
	ds_internal final function iterator():Iterator {
		//TODO: return _iteratorFactory.get( this );
		return new Iterator( this );
	}

	[Inline]
	protected final function $attachOrdered( node:Node, order:int ):Node {
		node._order = order;

		var nodeBefore:Node = _lastNode;
		if ( nodeBefore == null || nodeBefore.order <= order ) {
			return $attach( node );
		}

		while ( nodeBefore && nodeBefore.order > order ) {
			nodeBefore = nodeBefore.prev;
		}

		if ( nodeBefore ) {
			return $attachAfter( node, nodeBefore );
		}

		return $attachFirst( node );
	}

	[Inline]
	protected final function $createNode( item:* = null ):Node {
		var node:Node = nodeFactory.get();
		node.ds_internal::_item = item;
		return node;
	}

	protected function disposeNode( node:Node, nullLinks:Boolean ):void {
		if ( nullLinks ) {
			node._prev = null;
			node._next = null;
		}
		node.ds_internal::_item = null;
		nodeFactory && nodeFactory.recycle( node );
	}
}
}
