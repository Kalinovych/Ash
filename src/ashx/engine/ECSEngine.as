/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */

package ashx.engine {
import ash.core.Entity;

import ashx.engine.api.IEntityFamiliesManager;
import ashx.engine.aspects.AspectFamiliesManager;
import ashx.engine.components.CpHandlersManager;
import ashx.engine.entity.EntityList;
import ashx.engine.lists.EntityNodeList;
import ashx.engine.lists.LinkedHashMap;

use namespace ecse;

public class ECSEngine {
	ecse var mEntities:EntityList;
	ecse var mCpManager:CpHandlersManager;
	ecse var mFamiliesManager:IEntityFamiliesManager;

	ecse var mEntityFamilies:LinkedHashMap/*<EntityNodeList>*/;

	public function ECSEngine() {
		mEntities = new EntityList();
		mCpManager = new CpHandlersManager( mEntities );
		mFamiliesManager = new AspectFamiliesManager( mEntities, mCpManager );
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
		while ( mEntities._firstNode ) {
			removeEntity( mEntities._firstNode.item );
		}
	}

	public function containsEntity( id:uint ):Boolean {
		return mEntities.contains( id );
	}

	public function getEntity( id:uint ):Entity {
		return mEntities.get( id );
	}

	public function getEntities( familyIdentifier:Class = null ):EntityNodeList {
		mFamiliesManager.getEntities( familyIdentifier );
	}
}
}
