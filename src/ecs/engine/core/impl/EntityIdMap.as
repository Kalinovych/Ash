/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.engine.core.impl {
import ecs.engine.core.ESCtx;
import ecs.framework.api.ecs_core;
import ecs.framework.entity.Entity;
import ecs.framework.entity.api.IEntityHandler;

use namespace ecs_core;

public class EntityIdMap implements IEntityHandler {
	private var _context:ESCtx;
	private var _map:Vector.<Entity> = new <Entity>[];

	public function EntityIdMap( context:ESCtx ) {
		this._context = context;
		context.ecs_core::registerHandler( this );
	}

	[Inline]
	public final function getById( id:uint ):Entity {
		return ( id < _map.length ? _map[id] : null );
	}

	public function handleEntityAdded( entity:Entity ):void {
		var id:uint = entity.id;
		if ( _map.length <= id ) {
			_map.length += 100;
		}
		_map[id] = entity;
	}

	public function handleEntityRemoved( entity:Entity ):void {
		_map[entity.id] = null;
	}
}
}
