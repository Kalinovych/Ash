/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */

package ashx.engine {
import ash.core.Entity;

import ashx.engine.aspects.AspectsManager;
import ashx.engine.entity.EntityCollection;

use namespace ecse;

public class ECSEngine {
	ecse var mEntities:EntityCollection;
	ecse var mAspects:AspectsManager;

	public function ECSEngine() {
		mEntities = new EntityCollection();
		mAspects = new AspectsManager( mEntities );
	}

	public function addEntity( entity:Entity ):Entity {
		mEntities.add( entity );
	}
}
}
