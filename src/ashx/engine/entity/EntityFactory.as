/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.entity {
import ashx.engine.api.ecse;

import flash.errors.IllegalOperationError;

use namespace ecse;

public class EntityFactory {
	ecse var idIndex:uint = 0;

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
