/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */

package ashx.engine {
import ash.core.Entity;

import ashx.engine.aspects.AspectsManager;
import ashx.engine.entity.ECollection;
import ashx.engine.entity.EntityCollection;

use namespace ecse;

public class ECSEngine {
	ecse var mEntities:ECollection;
	ecse var mAspects:AspectsManager;

	public function ECSEngine() {
		mEntities = new ECollection();
		mAspects = new AspectsManager( mEntities );
	}

	public function addEntity( entity:Entity ):Entity {
		var id:* = entity.id;

		if ( mEntities.contains( id ) ) {
			throw new Error( "This list already contains an entity with id \"" + id + "\"" );
		}
		return mEntities.add( entity );
	}

	public function removeEntity( entity:Entity ):Entity {
		return mEntities.remove( entity );
	}
}
}
