/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.framework.entity {
import ecs.framework.api.ecs_core;
import ecs.framework.entity.api.IEntityHandler;
import ecs.lists.LinkedSet;
import ecs.lists.ListBase;
import ecs.lists.Node;

import flash.utils.Dictionary;

use namespace ecs_core;

public class EntityManager extends ListBase /*implements IEntityManager*/ {
	protected var _registry:Dictionary = new Dictionary();
	protected var _handlers:LinkedSet = new LinkedSet();

	public function EntityManager() {
		super();
	}

	public function get entityCount():uint {
		return _length;
	}

	public function add( entity:Entity ):Entity {
		if ( _registry[entity] ) return entity;

		_registry[entity] = true;
		$attach( entity );
		entity._alive = true;

		// notify handlers
		for ( var node:Node = _handlers.$firstNode; node; node = node.next ) {
			var handler:IEntityHandler = node.content;
			handler.handleEntityAdded( entity );
		}

		return entity;
	}

	public function has( entity:Entity ):Boolean {
		return _registry[entity];
	}

	public function remove( entity:Entity ):Entity {
		if ( !_registry[entity] ) {
			return null;
		}

		delete _registry[entity];
		$detach( entity );
		entity._alive = false;

		// notify handlers in backward order
		for ( var node:Node = _handlers.$lastNode; node; node = node.prev ) {
			var handler:IEntityHandler = node.content;
			handler.handleEntityRemoved( entity );
		}

		return entity;
	}

	public function removeAll():void {
		while ( _firstNode ) {
			var entity:Entity = first;
			remove( entity );
			entity.prev = null;
			entity.next = null;
		}
	}

	public function registerHandler( handler:IEntityHandler ):Boolean {
		return _handlers.add( handler );
	}

	public function unregisterHandler( handler:IEntityHandler ):Boolean {
		return _handlers.remove( handler );
	}
	
	[Inline]
	ecs_core final function get first():Entity {
		return _firstNode;
	}

	[Inline]
	ecs_core final function get last():Entity {
		return _lastNode;
	}
}
}
