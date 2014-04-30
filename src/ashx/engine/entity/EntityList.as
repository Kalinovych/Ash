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

public class EntityList extends ElementList {
	private var entityById:Array = [];
	private var mHandlers:LinkedHashSet;

	public function EntityList() {
		mHandlers = new LinkedHashSet();
	}

	public function add( id:uint, entity:Entity ):Entity {
		// add the entity node to the list
		var eNode:ItemNode = entityById[id];
		if ( !eNode ) {
			eNode = new ItemNode();
		}
		eNode.id = id;
		eNode.item = entity;
		eNode.isAttached = true;
		entityById[id] = eNode;
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

	public function remove( id:uint ):Entity {
		// remove an entity from list
		var eNode:ItemNode = entityById[id];
		if ( !eNode ) {
			return null;
		}

		var entity:Entity = eNode.item;
		entityById[id] = undefined;
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
			remove( node.id );
			node.prev = null;
			node.next = null;
		}
		entityById.length = 0;
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
		return entityById[id];
	}

	[Inline]
	protected final function _valueOf( id:uint ):* {
		var node:ItemNode = entityById[id];
		return (node ? node.item : null );
	}

	/*[Inline]
	protected final function _createNode( item:* ):ItemNode {
		// TODO: pool
		var node:ItemNode = ( nodePool.length > 0 ? nodePool.pop() : new ItemNode() );
		node.item = item;
		return node
	}*/
}
}
