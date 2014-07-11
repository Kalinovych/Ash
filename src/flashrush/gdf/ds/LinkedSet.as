/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.gdf.ds {
import flash.utils.Dictionary;

import flashrush.asentity.framework.api.asentity;

use namespace asentity;

/**
 * Linked collection of unique items
 */
public class LinkedSet extends InternalList {
	asentity var nodeByContent:Dictionary = new Dictionary();

	public function LinkedSet() {
		super();
	}

	public function add( item:* ):Boolean {
		if ( $has( item ) ) return false;

		var node:Node = $createNode( item );
		nodeByContent[item] = node;
		$attach( node );
		return true;
	}

	public function remove( item:* ):Boolean {
		var node:Node = $nodeOf( item );
		if ( node == null ) return false;

		delete nodeByContent[item];
		$detach( node );
		disposeNode( node, false );
		return true;
	}

	public function removeAll():void {
		while ( _firstNode ) {
			var node:Node = _firstNode;
			_firstNode = node.next;
			disposeNode( node, true );
		}
		nodeByContent = new Dictionary();
	}

	public function has( item:* ):Boolean {
		return ( nodeByContent[item] != null );
	}

	[Inline]
	protected final function $has( item:* ):Boolean {
		return ( nodeByContent[item] != null );
	}

	[Inline]
	protected final function $nodeOf( item:* ):Node {
		return nodeByContent[item];
	}
}
}
