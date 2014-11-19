/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.entity {
import flash.errors.IllegalOperationError;

import flashrush.asentity.framework.api.asentity;

use namespace asentity;

public class EntityFactory {
	asentity var idIndex:uint = 0;
	
	public function create():Entity {
		var entity:Entity = new Entity();
		idIndex++;
		entity._id = idIndex;
		return entity;
	}

	public function dispose( entity:Entity ):void {
		if ( entity.alive ) {
			throw new IllegalOperationError( "Can't recycle alive entity" );
		}
	}
}
}
