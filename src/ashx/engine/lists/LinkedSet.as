/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.lists {
import ashx.engine.ecse;

import flash.utils.Dictionary;

use namespace ecse;

public class LinkedSet extends ItemList {
	ecse var nodeByItem:Dictionary = new Dictionary();

	public function LinkedSet() {
		super();
	}

	public function add( content:* ):Boolean {
		if ( $contains( content ) ) return false;

		var node:Node = $createNode( content );
		nodeByItem[content] = node;
		node.isAttached = true;
		$addNode( node );
		return true;
	}

	public function remove( content:* ):Boolean {
		var node:Node = $nodeOf( content );
		if ( node == null ) return false;

		delete nodeByItem[content];
		node.isAttached = false;
		$removeNode( node );
		$disposeNode( node, false );
		return true;
	}

	public function removeAll():void {
		while ( _firstNode ) {
			var node:Node = _firstNode;
			_firstNode = node.next;
			node.isAttached = false;
			$disposeNode( node, true );
		}
		nodeByItem = new Dictionary();
	}

	public function contains( content:* ):Boolean {
		return $contains( content );
	}

	[Inline]
	protected final function $contains( content:* ):Boolean {
		return ( nodeByItem[content] != null );
	}

	[Inline]
	protected final function $nodeOf( content:* ):Node {
		return nodeByItem[content];
	}
}
}
