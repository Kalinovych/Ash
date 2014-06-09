/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.engine.core.impl {
import ecs.engine.core.ESUnit;
import ecs.engine.core.UnitsCore;
import ecs.engine.core.api.IUnitObserver;
import ecs.framework.entity.Entity;

public class EntityIdMap implements IUnitObserver {
	private var core:UnitsCore;
	private var map:Vector.<Entity> = new <Entity>[];

	public function EntityIdMap( core:UnitsCore ) {
		this.core = core;
		core.register( this );
	}

	public function getById( id:uint ):Entity {
		return ( id < map.length ? map[id] : null );
	}

	public function unitAdded( unit:ESUnit ):void {
		var entity:Entity = unit as Entity;
		var id:uint = entity.id;
		if ( map.length <= id ) {
			map.length += 100;
		}
		map[id] = entity;
	}

	public function unitRemoved( unit:ESUnit ):void {
		var entity:Entity = unit as Entity;
		map[entity.id] = null;
	}
}
}
