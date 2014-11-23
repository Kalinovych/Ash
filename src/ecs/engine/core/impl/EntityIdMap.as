/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.engine.core.impl {
import ecs.engine.core.ESContext;

import flashrush.asentity.framework.api.asentity;
import flashrush.asentity.framework.entity.Entity;
import flashrush.asentity.framework.entity.api.IEntityHandler;

use namespace asentity;

public class EntityIdMap implements IEntityHandler {
	private var _context:ESContext;
	private var _map:Vector.<Entity> = new <Entity>[];

	public function EntityIdMap( context:ESContext ) {
		this._context = context;
		context.asentity::registerHandler( this );
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
