/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.entity {
import ashx.engine.api.ecse;
import ashx.engine.entity.api.IEntityHandler;
import ashx.engine.entity.api.IEntityManager;
import ashx.lists.LinkedSet;
import ashx.lists.ListBase;
import ashx.lists.Node;

use namespace ecse;

public class EntityManager extends ListBase implements IEntityManager {
	protected var _entityById:Vector.<Entity>;
	protected var _capacity:uint;
	protected var _growthValue:uint;
	protected var _entityCount:uint;
	protected var _handlers:LinkedSet;

	public function EntityManager( length:uint = 0, growthValue:uint = 1 ) {
		_entityById = new Vector.<Entity>( length );
		_capacity = length;
		_growthValue = growthValue || 1;
		_handlers = new LinkedSet();
	}

	public function get first():Entity {
		return _firstNode;
	}

	public function get last():Entity {
		return _lastNode;
	}

	public function get entityCount():uint {
		return _length;
	}

	public function add( entity:Entity ):Entity {
		var id:uint = entity._id;
		if ( id < _capacity && _entityById[id] ) {
			return entity;
		}

		if ( id >= _capacity ) {
			_capacity = id + _growthValue;
			_entityById.length = _capacity;
		}

		entity._alive = true;
		_entityById[id] = entity;
		$addNode( entity );
		_entityCount++;

		// notify handlers
		for ( var node:Node = _handlers.$firstNode; node; node = node.next ) {
			var handler:IEntityHandler = node.content;
			handler.onEntityAdded( entity );
		}

		return entity;
	}

	public function has( id:uint ):Boolean {
		return _entityById[id];
	}

	public function get( id:uint ):Entity {
		return _entityById[id];
	}

	public function remove( entity:Entity ):Entity {
		return removeById( entity._id );
	}

	public function removeById( id:uint ):Entity {
		var entity:Entity = _entityById[id];
		if ( !entity ) {
			return null;
		}

		entity._alive = false;
		_entityById[id] = null;
		$removeNode( entity );
		_entityCount--;

		// notify handlers in backward order (?)
		/*for ( var node:ItemNode = mHandlers.ecse::_lastNode; node; node = node.prev ) {
			var handler:IEntityHandler = node.item;
			handler.onEntityRemoved( entity );
		}*/
		for ( var node:Node = _handlers.$firstNode; node; node = node.next ) {
			var handler:IEntityHandler = node.content;
			handler.onEntityRemoved( entity );
		}

		return entity;
	}

	public function removeAll():void {
		while ( _firstNode ) {
			var entity:Entity = first;
			removeById( entity.id );
			entity.prev = null;
			entity.next = null;
		}
		_entityById.length = 0;
	}

	public function registerHandler( handler:IEntityHandler ):Boolean {
		return _handlers.add( handler );
	}

	public function unregisterHandler( handler:IEntityHandler ):Boolean {
		return _handlers.remove( handler );
	}
}
}
