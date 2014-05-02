/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.lists {
import ashx.engine.ecse;

import flash.utils.Dictionary;

use namespace ecse;

public class LinkedHashSet extends ItemList {
	ecse var nodeByItem:Dictionary = new Dictionary();

	public function LinkedHashSet() {
		super();
	}

	public function add( item:* ):Boolean {
		if ( $contains( item ) ) return false;

		var node:ItemNode = $createNode( item );
		nodeByItem[item] = node;
		node.isAttached = true;
		$addNode( node );
		return true;
	}

	public function remove( item:* ):Boolean {
		var node:ItemNode = $nodeOf( item );
		if ( node == null ) return false;

		delete nodeByItem[item];
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

	public function contains( item:* ):Boolean {
		return $contains( item );
	}

	[Inline]
	protected final function $contains( element:* ):Boolean {
		return ( nodeByItem[element] != null );
	}

	[Inline]
	protected final function $nodeOf( item:* ):ItemNode {
		return nodeByItem[item];
	}
}
}
