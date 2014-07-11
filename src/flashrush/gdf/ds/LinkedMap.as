/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.gdf.ds {
import flash.utils.Dictionary;

import flashrush.asentity.framework.api.asentity;

use namespace asentity;

/**
 * Linked map of an items with unique key.
 */
public class LinkedMap extends InternalList {
	asentity var nodeByKey:Dictionary = new Dictionary();

	public function LinkedMap() {}

	public function put( key:*, item:* ):Node {
		var node:Node = $nodeOf( key );
		if ( !node ) {
			node = $createNode( item );
			nodeByKey[key] = node;
			$attach( node );
		}
		node.item = item;
		return node;
	}

	public function contains( key:* ):Boolean {
		return (nodeByKey[key] != null);
	}

	public function get( key:* ):* {
		return $valueOf( key );
	}

	public function remove( key:* ):* {
		var node:Node = $nodeOf( key );
		if ( node ) {
			delete nodeByKey[key];
			$detach( node );
			return node.item;
		}
		return null;
	}

	public function removeAll():void {
		while ( _firstNode ) {
			var node:Node = _firstNode;
			_firstNode = node.next;
			disposeNode( node, true );
		}
		nodeByKey = new Dictionary();
	}

	public function dispose():void {
		nodeByKey = null;
		$disposeBase();
	}

	[Inline]
	protected final function $nodeOf( key:* ):* {
		return nodeByKey[key];
	}

	[Inline]
	protected final function $valueOf( key:* ):* {
		var node:Node = nodeByKey[key];
		return (node ? node.item : undefined );
	}
}
}
