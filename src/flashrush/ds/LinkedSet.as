/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.ds {
import flash.utils.Dictionary;

import flashrush.asentity.framework.api.asentity;

use namespace asentity;

/**
 * Linked collection of unique items
 */
public class LinkedSet extends InternalList {
	protected var nodeByContent:Dictionary = new Dictionary();

	public function LinkedSet() {
		super();
	}

	[Inline]
	public final function get firstNode():Node {
		return _firstNode;
	}
	
	[Inline]
	public final function get lastNode():Node {
		return _lastNode;
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
			delete nodeByContent[node.item];
			disposeNode( node, true );
		}
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
