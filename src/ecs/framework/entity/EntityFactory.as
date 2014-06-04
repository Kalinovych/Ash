/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.framework.entity {
import ecs.framework.api.ecs_core;

import flash.errors.IllegalOperationError;

use namespace ecs_core;

public class EntityFactory {
	ecs_core var idIndex:uint = 0;

	public function EntityFactory() {
	}

	public function create():Entity {
		var entity:Entity = new Entity();
		idIndex++;
		entity._id = idIndex;
		return entity;
	}

	public function dispose( entity:Entity ):void {
		if ( entity._alive ) {
			throw new IllegalOperationError( "Can't recycle alive entity" );
		}
	}
}
}
