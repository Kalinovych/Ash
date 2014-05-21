/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.lists {
import ashx.engine.ecse;

import flash.utils.Dictionary;

use namespace ecse;

public class LinkedMap extends ItemList {
	ecse var nodeByKey:Dictionary = new Dictionary();

	public function LinkedMap() {
	}

	public function put( key:*, item:* ):ItemNode {
		var node:ItemNode = $nodeOf( key );
		if ( !node ) {
			node = $createNode( item );
			nodeByKey[key] = node;
			node.isAttached = true;
			$addNode( node );
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
		var node:ItemNode = $nodeOf( key );
		if ( node ) {
			delete nodeByKey[key];
			node.isAttached = false;
			$removeNode( node );
			return node.item;
		}
		return null;
	}

	public function removeAll():void {
		while ( _firstNode ) {
			var node:ItemNode = _firstNode;
			_firstNode = node.next;
			node.isAttached = false;
			$disposeNode( node, true );
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
		var node:ItemNode = nodeByKey[key];
		return (node ? node.item : null );
	}
}
}
