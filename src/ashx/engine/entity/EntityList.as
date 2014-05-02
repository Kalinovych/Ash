/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.entity {
import ashx.engine.ecse;
import ashx.engine.lists.ItemNode;
import ashx.engine.lists.LinkedHashSet;
import ashx.engine.lists.ListBase;

use namespace ecse;

public class EntityList extends ListBase {
	protected var _entityById:Array;
	protected var _handlers:LinkedHashSet;

	public function EntityList() {
		_entityById = [];
		_handlers = new LinkedHashSet();
	}

	public function get first():Entity {
		return _firstNode;
	}

	public function get last():Entity {
		return _lastNode;
	}

	public function add( id:uint, entity:Entity ):Entity {
		if ( _entityById[id] ) {
			return null;
		}

		entity._id = id;
		entity._alive = true;
		_entityById[id] = entity;
		$addNode( entity );

		// notify handlers
		for ( var node:ItemNode = _handlers.$firstNode; node; node = node.next ) {
			var handler:IEntityHandler = node.item;
			handler.onEntityAdded( entity );
		}

		return entity;
	}

	public function contains( id:uint ):Boolean {
		return _entityById[id];
	}

	public function get( id:uint ):Entity {
		return _entityById[id];
	}

	public function remove( id:uint ):Entity {
		var entity:Entity = _entityById[id];
		if ( !entity ) {
			return null;
		}

		entity._alive = false;
		_entityById[id] = null;
		$removeNode( entity );

		// notify handlers in backward order (?)
		/*for ( var node:ItemNode = mHandlers.ecse::_lastNode; node; node = node.prev ) {
			var handler:IEntityHandler = node.item;
			handler.onEntityRemoved( entity );
		}*/
		for ( var node:ItemNode = _handlers.$firstNode; node; node = node.next ) {
			var handler:IEntityHandler = node.item;
			handler.onEntityRemoved( entity );
		}

		return entity;
	}

	public function removeAll():void {
		while ( _firstNode ) {
			var node:ItemNode = _firstNode;
			remove( node.id );
			node.prev = null;
			node.next = null;
		}
		_entityById.length = 0;
	}

	/*public function getIterator():EntityIterator {
		return new EntityIterator( this );
	}*/

	ecse function addHandler( handler:IEntityHandler ):Boolean {
		return _handlers.add( handler );
	}

	ecse function removeHandler( handler:IEntityHandler ):Boolean {
		return _handlers.remove( handler );
	}
}
}
