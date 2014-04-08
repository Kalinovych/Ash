/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ash.engine {
import ash.core.Entity;
import ash.engine.entity.EntityCollection;

public class EEngine {
	private var mEntities:EntityCollection = new EntityCollection();
	
	public function EEngine() {
	}
	
	public function addEntity( entity:Entity ):Entity {
		return mEntities.add( entity );
	}

	public function removeEntity( entity:Entity ):Entity {
		return mEntities.removeEntity( entity );
	}
}
}
