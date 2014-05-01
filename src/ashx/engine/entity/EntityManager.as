/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.entity {
import ashx.engine.api.IEntityFamiliesManager;
import ashx.engine.ecse;
import ashx.engine.lists.EntityNodeList;

use namespace ecse;

public class EntityManager {
	ecse var mEntities:EntityList = new EntityList();
	ecse var mFamilies:IEntityFamiliesManager;

	public function EntityManager() {

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

	public function removeAllEntities():void {
		mEntities.removeAll();
	}

	public function getEntity( id:uint ):Entity {
		return mEntities.get( id );
	}

	public function getEntities( familyIdentifier:Class ):EntityNodeList {
		mFamilies.getEntities( familyIdentifier );
	}
}
}
