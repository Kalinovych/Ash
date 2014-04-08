/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ash.engine.lists {
import flash.utils.Dictionary;

public class LinkedHashSet extends ElementList {
	protected var registry:Dictionary = new Dictionary();

	public function LinkedHashSet() {
	}

	public function add( item:* ):Boolean {
		if ( _nodeOf( item ) ) return false;

		var node:ItemNode = _nodeFor( item );
		registry[item] = node;
		_attachNode( node );
		return true;
	}

	public function remove( item:* ):Boolean {
		var node:ItemNode = _nodeOf( item );
		if ( node == null ) return false;

		delete registry[item];
		_detachNode( node );
		return true;
	}

	public function contains( item:* ):Boolean {
		return _contains( item );
	}

	[Inline]
	protected final function _contains( element:* ):Boolean {
		return ( registry[element] != null );
	}

	[Inline]
	protected final function _nodeFor( item:* ):ItemNode {
		// TODO: pool
		var node:ItemNode = new ItemNode();
		node.item = item;
		return node;
	}

	[Inline]
	protected final function _nodeOf( item:* ):ItemNode {
		return registry[item];
	}

	[Inline]
	protected final function _attachNode( node:ItemNode ):ItemNode {
		node.isAttached = true;
		super.addNode( node );
	}

	[Inline]
	protected final function _detachNode( node:ItemNode ):ItemNode {
		node.isAttached = false;
		super.removeNode( node );
	}

}
}
