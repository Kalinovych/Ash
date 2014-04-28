/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.lists {
import ashx.engine.ecse;

public class LinkedIdMap extends ElementList {
	public var nodePool:Vector.<ItemNode> = new <ItemNode>[];

	private var registry:Array = [];

	public function LinkedIdMap() {
	}

	/*public function put( id:uint, item:* ):ItemNode {
		var node:ItemNode = _nodeOf( id );
		if ( !node ) {
			node = _createNode( item );
			_registerNode( id, node );
			_attachNode( node );
		}
		node.item = item;
		return node;
	}*/

	public function put( id:uint, item:* ):ItemNode {
		var node:ItemNode = registry[id];
		if ( !node ) {
			//node = ( nodePool.length > 0 ? nodePool.pop() : new ItemNode() );
			/*var count:uint = nodePool.length; 
			if (count > 0) {
				--count;
				node = nodePool[count];
				nodePool.length = count;
			} else {
				node = new ItemNode();
			}*/
			node = new ItemNode();
		}
		node.id = id;
		node.item = item;
		node.isAttached = true;
		registry[id] = node;
		addNode( node );
		return node;
	}
	
	public function contains( id:uint ):Boolean {
		return (_nodeOf( id ) != null);
	}

	public function get( id:uint ):* {
		return _valueOf( id );
	}

	/*public function remove( id:uint ):* {
		var node:ItemNode = _nodeOf( id );
		if ( node ) {
			_unregisterNodeAt( id );
			_detachNode( node );
			return node.item;
		}
		return null;
	}*/
	
	public function remove( id:uint ):* {
		var node:ItemNode = registry[id];
		if ( node ) {
			registry[id] = undefined;
			node.isAttached = false;
			removeNode( node );
			return node.item;
		}
		return null;
	}

	public function removeAll():void {
		use namespace ecse;

		for ( var id:uint in registry ) {
			var node:ItemNode = _nodeOf( id );
			_unregisterNodeAt( id );
			_detachNode( node );
			node.prev = null;
			node.next = null;
		}
	}

	[Inline]
	protected final function _nodeOf( id:uint ):* {
		return registry[id];
	}

	[Inline]
	protected final function _valueOf( id:uint ):* {
		var node:ItemNode = registry[id];
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
	protected final function _registerNode( id:uint, node:ItemNode ):ItemNode {
		node.id = id;
		registry[id] = node;
		return node;
	}

	[Inline]
	protected final function _unregisterNodeAt( id:uint ):void {
		//delete registry[id];
		registry[id] = undefined;
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
