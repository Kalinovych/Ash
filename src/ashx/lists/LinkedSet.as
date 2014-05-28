/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.lists {
import ashx.engine.api.ecse;

import flash.utils.Dictionary;

use namespace ecse;

public class LinkedSet extends NodeList {
	ecse var nodeByContent:Dictionary = new Dictionary();

	public function LinkedSet() {
		super();
	}

	public function add( content:* ):Boolean {
		if ( $has( content ) ) return false;

		var node:Node = $createNode( content );
		nodeByContent[content] = node;
		node.isAttached = true;
		$addNode( node );
		return true;
	}

	public function remove( content:* ):Boolean {
		var node:Node = $nodeOf( content );
		if ( node == null ) return false;

		delete nodeByContent[content];
		node.isAttached = false;
		$removeNode( node );
		disposeNode( node, false );
		return true;
	}

	public function removeAll():void {
		while ( _firstNode ) {
			var node:Node = _firstNode;
			_firstNode = node.next;
			node.isAttached = false;
			disposeNode( node, true );
		}
		nodeByContent = new Dictionary();
	}

	public function has( content:* ):Boolean {
		return $has( content );
	}

	[Inline]
	protected final function $has( content:* ):Boolean {
		return ( nodeByContent[content] != null );
	}

	[Inline]
	protected final function $nodeOf( content:* ):Node {
		return nodeByContent[content];
	}
}
}
