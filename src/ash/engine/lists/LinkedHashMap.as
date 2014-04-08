/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ash.engine.lists {
import ash.engine.ecse;

import flash.utils.Dictionary;

public class LinkedHashMap extends ElementList {
	ecse var registry:Dictionary = new Dictionary();

	public function LinkedHashMap() {
	}

	public function put( key:Object, item:* ):ItemNode {
		var node:ItemNode = _nodeOf( key );
		if ( !node ) {
			node = _createNode();
			_registerNode( key, item );
			_attachNode( node );
		}
		node.item = item;
		return node;
	}

	public function contains( key:Object ):Boolean {
		return (_nodeOf( key ) != null);
	}

	public function get( key:Object ):* {
		return _valueOf( key );
	}

	public function remove( key:Object ):* {
		var node:ItemNode = _nodeOf( key );
		if ( node ) {
			_unregisterNodeOf( key );
			_detachNode( node );
			return node.item;
		}
		return null;
	}

	[Inline]
	protected final function _nodeOf( key:Object ):* {
		return ecse::registry[key];
	}

	[Inline]
	protected final function _valueOf( key:Object ):* {
		var node:ItemNode = ecse::registry[key];
		return (node ? node.item : null );
	}

	[Inline]
	protected final function _createNode():ItemNode {
		return new ItemNode();
	}

	[Inline]
	protected final function _registerNode( key:Object, node:ItemNode ):ItemNode {
		ecse::registry[key] = node;
		return node;
	}

	[Inline]
	protected final function _unregisterNodeOf( key:Object ):void {
		delete ecse::registry[key];
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
