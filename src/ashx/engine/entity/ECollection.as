/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.entity {
import ash.core.Entity;

import ashx.engine.ecse;

import ashx.engine.lists.ElementList;
import ashx.engine.lists.ItemNode;
import ashx.engine.lists.LinkedHashSet;

public class ECollection extends ElementList {
	private var registry:Array = [];
	private var mHandlers:LinkedHashSet;

	public function ECollection() {
		mHandlers = new LinkedHashSet();
	}

	public function add( entity:Entity ):Entity {
		var id:uint = entity.id;

		// add the entity node to the list
		var eNode:ItemNode = registry[id];
		if ( !eNode ) {
			eNode = new ItemNode();
		}
		eNode.id = id;
		eNode.item = entity;
		eNode.isAttached = true;
		registry[id] = eNode;
		addNode( eNode );

		// notify handlers
		for ( var node:ItemNode = mHandlers.ecse::_firstNode; node; node = node.next ) {
			var handler:IEntityHandler = node.item;
			handler.onEntityAdded( entity );
		}

		return entity;
	}

	public function contains( id:uint ):Boolean {
		return (_nodeOf( id ) != null);
	}

	public function get( id:uint ):Entity {
		return _valueOf( id );
	}

	public function remove( entity:Entity ):Entity {
		return removeById(entity.id);
	}

	public function removeById( id:uint ):Entity {
		// remove an entity from list
		var eNode:ItemNode = registry[id];
		if ( !eNode ) {
			return null;
		}
		
		var entity:Entity = eNode.item;
		registry[id] = undefined;
		eNode.isAttached = false;
		removeNode( eNode );

		// notify handlers in backward order (?)
		/*for ( var node:ItemNode = mHandlers.ecse::_lastNode; node; node = node.prev ) {
			var handler:IEntityHandler = node.item;
			handler.onEntityRemoved( entity );
		}*/
		for ( var node:ItemNode = mHandlers.ecse::_firstNode; node; node = node.next ) {
			var handler:IEntityHandler = node.item;
			handler.onEntityRemoved( entity );
		}

		return entity;
	}

	public function removeAll():void {
		while ( _first ) {
			var node:ItemNode = _first;
			removeById( node.id );
			node.prev = null;
			node.next = null;
		}
		registry.length = 0;
	}

	public function getIterator():EntityIterator {
		return new EntityIterator( this );
	}

	public function addHandler( handler:IEntityHandler ):Boolean {
		return mHandlers.add( handler );
	}

	public function removeHandler( handler:IEntityHandler ):Boolean {
		return mHandlers.remove( handler );
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

	/*[Inline]
	protected final function _createNode( item:* ):ItemNode {
		// TODO: pool
		var node:ItemNode = ( nodePool.length > 0 ? nodePool.pop() : new ItemNode() );
		node.item = item;
		return node
	}*/

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
