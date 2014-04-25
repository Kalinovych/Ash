/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ash.engine.lists {
import ash.engine.ecse;

import flash.utils.Dictionary;

use namespace ecse;

public class LinkedHashMap extends ElementList {
	public var nodePool:Vector.<ItemNode> = new <ItemNode>[];
	
	ecse var registry:Dictionary = new Dictionary();

	public function LinkedHashMap() {
	}

	public function put( key:*, item:* ):ItemNode {
		var node:ItemNode = _nodeOf( key );
		if ( !node ) {
			node = _createNode( item );
			_registerNode( key, node );
			_attachNode( node );
		}
		node.item = item;
		return node;
	}

	public function contains( key:* ):Boolean {
		return (_nodeOf( key ) != null);
	}

	public function get( key:* ):* {
		return _valueOf( key );
	}

	public function remove( key:* ):* {
		var node:ItemNode = _nodeOf( key );
		if ( node ) {
			_unregisterNodeOf( key );
			_detachNode( node );
			return node.item;
		}
		return null;
	}
	
	public function removeAll():void {
		use namespace ecse;
		for (var key:* in registry) {
			var node:ItemNode = _nodeOf( key );
			_unregisterNodeOf( key );
			_detachNode( node );
			node.prev = null;
			node.next = null;
		}
	}

	override public function dispose():void {
		registry = null;
		super.dispose();
	}

	[Inline]
	protected final function _nodeOf( key:* ):* {
		return registry[key];
	}

	[Inline]
	protected final function _valueOf( key:* ):* {
		var node:ItemNode = registry[key];
		return (node ? node.item : null );
	}

	[Inline]
	protected final function _createNode( item:* ):ItemNode {
		// TODO: pool
		var node:ItemNode = ( nodePool.length > 0 ? nodePool.pop() : new ItemNode() );
		node.item = item;
		return node
	}

	[Inline]
	protected final function _registerNode( key:*, node:ItemNode ):ItemNode {
		registry[key] = node;
		return node;
	}

	[Inline]
	protected final function _unregisterNodeOf( key:* ):void {
		delete registry[key];
	}

	[Inline]
	protected final function _attachNode( node:ItemNode ):ItemNode {
		node.isAttached = true;
		return super.addNode( node );
	}

	[Inline]
	protected final function _detachNode( node:ItemNode ):ItemNode {
		node.isAttached = false;
		return super.removeNode( node );
	}
}
}
