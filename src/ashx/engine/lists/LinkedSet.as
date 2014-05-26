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

	public function add( data:* ):Boolean {
		if ( $contains( data ) ) return false;

		var node:ItemNode = $createNode( data );
		nodeByItem[data] = node;
		node.isAttached = true;
		$addNode( node );
		return true;
	}

	public function remove( data:* ):Boolean {
		var node:ItemNode = $nodeOf( data );
		if ( node == null ) return false;

		delete nodeByItem[data];
		node.isAttached = false;
		$removeNode( node );
		$disposeNode( node, false );
		return true;
	}

	public function removeAll():void {
		while ( _firstNode ) {
			var node:ItemNode = _firstNode;
			_firstNode = node.next;
			node.isAttached = false;
			$disposeNode( node, true );
		}
		nodeByItem = new Dictionary();
	}

	public function contains( data:* ):Boolean {
		return $contains( data );
	}

	[Inline]
	protected final function $contains( data:* ):Boolean {
		return ( nodeByItem[data] != null );
	}

	[Inline]
	protected final function $nodeOf( data:* ):ItemNode {
		return nodeByItem[data];
	}
}
}
