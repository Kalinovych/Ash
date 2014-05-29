/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.framework.entity {
import ecs.framework.api.ecsf;

import flash.errors.IllegalOperationError;

use namespace ecsf;

public class EntityFactory {
	ecsf var idIndex:uint = 0;

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
