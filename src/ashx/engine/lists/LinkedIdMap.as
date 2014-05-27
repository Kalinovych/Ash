/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.lists {
import ashx.engine.ecse;

use namespace ecse;

public class LinkedIdMap extends ItemList {
	private var registry:Array = [];

	public function LinkedIdMap() {
	}

	public function put( id:uint, item:* ):Node {
		var node:Node = registry[id];
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
			node = new Node();
		}
		node.id = id;
		node.content = item;
		node.isAttached = true;
		registry[id] = node;
		$addNode( node );
		return node;
	}
	
	public function contains( id:uint ):Boolean {
		return (_nodeOf( id ) != null);
	}

	public function get( id:uint ):* {
		return _valueOf( id );
	}
	
	public function remove( id:uint ):* {
		var node:Node = registry[id];
		if ( node ) {
			registry[id] = undefined;
			node.isAttached = false;
			$removeNode( node );
			return node.content;
		}
		return null;
	}

	public function removeAll():void {
		use namespace ecse;

		for ( var id:uint in registry ) {
			var node:Node = _nodeOf( id );
			_unregisterNodeAt( id );
			node.isAttached = false;
			$removeNode( node );
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
		var node:Node = registry[id];
		return (node ? node.content : null );
	}

	[Inline]
	protected final function _registerNode( id:uint, node:Node ):Node {
		node.id = id;
		registry[id] = node;
		return node;
	}

	[Inline]
	protected final function _unregisterNodeAt( id:uint ):void {
		//delete registry[id];
		registry[id] = undefined;
	}
}
}
