/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.entity {
import ash.core.Entity;

import ashx.engine.api.IFamiliesManager;
import ashx.engine.ecse;
import ashx.engine.lists.EntityNodeList;

use namespace ecse;

public class EManager {
	ecse var mEntities:ECollection = new ECollection();
	ecse var mFamiliesManager:IFamiliesManager;

	public function EManager() {

	}

	public function addEntity( entity:Entity ):Entity {
		var id:uint = entity.id;

		if ( mEntities.contains( id ) ) {
			throw new Error( "This list already contains an entity with id \"" + id + "\"" );
		}

		return mEntities.add( id, entity );
	}

	public function removeEntity( entity:Entity ):Entity {
		var id:uint = entity.id;

		if ( !mEntities.contains( id ) ) {
			throw new Error( "An entity with id \"" + id + "\" not fount in this manager" );
		}

		return mEntities.remove( id );
	}

	public function getEntity( id:uint ):Entity {
		return mEntities.get( id );
	}

	public function getEntities( familyIdentifier:Class ):EntityNodeList {
		mFamiliesManager.getEntities( familyIdentifier );
	}
}
}
