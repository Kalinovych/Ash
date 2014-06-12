/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.lists {
import ecs.framework.api.ecs_core;

import flash.utils.Dictionary;

use namespace ecs_core;

public class LinkedMap extends NodeList {
	ecs_core var nodeByKey:Dictionary = new Dictionary();

	public function LinkedMap() {}

	public function put( key:*, item:* ):Node {
		var node:Node = $nodeOf( key );
		if ( !node ) {
			node = $createNode( item );
			nodeByKey[key] = node;
			$attach( node );
			node.isAttached = true;
		}
		node.content = item;
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
			node.isAttached = false;
			$detach( node );
			return node.content;
		}
		return null;
	}

	public function removeAll():void {
		while ( _firstNode ) {
			var node:Node = _firstNode;
			_firstNode = node.next;
			node.isAttached = false;
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
		return (node ? node.content : undefined );
	}
}
}
