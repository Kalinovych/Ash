/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ash.engine.lists {
import ash.engine.collections.IElementHandler;

import com.flashrush.utils.lists.core.LinkedNodeListBase;

import flash.utils.Dictionary;

public class LinkedHashSet extends LinkedNodeListBase {
	protected var registry:Dictionary = new Dictionary();

	protected var handlers:Array = [];

	public function LinkedHashSet() {
	}

	public function add( item:* ):Boolean {
		if ( _nodeOf( item ) ) return false;
		
		var node:ItemNode = _nodeFor( item );
		registry[item] = node;
		_attachNode( node );
		
		for each( var handler:IElementHandler in handlers ) {
			handler.handleElementAdded( item )
		}
		
		return true;
	}

	public function remove( item:* ):Boolean {
		var node:ItemNode = _nodeOf( item );
		if ( node == null ) return false;

		delete registry[item];
		_detachNode( node );
		
		for each( var handler:IElementHandler in handlers ) {
			handler.handleElementRemoved( item )
		}
	}

	public function contains( item:* ):Boolean {
		return _contains( item );
	}

	public function addHandler( handler:IElementHandler ):void {
		handlers.push( handler );
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
		super.addNode( node );
	}

	[Inline]
	protected final function _detachNode( node:ItemNode ):ItemNode {
		super.removeNode( node );
	}

}
}
