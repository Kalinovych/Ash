/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */

package ashx.engine {
import ash.core.Entity;

import ashx.engine.api.IFamiliesManager;
import ashx.engine.aspects.AspectFamiliesManager;
import ashx.engine.components.CpManager;
import ashx.engine.entity.ECollection;
import ashx.engine.lists.EntityNodeList;

use namespace ecse;

public class ECSEngine {
	ecse var mEntities:ECollection;
	ecse var mCpManager:CpManager;
	ecse var mFamiliesManager:IFamiliesManager;

	public function ECSEngine() {
		mEntities = new ECollection();
		mCpManager = new CpManager( mEntities );
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
		return (mEntities.contains( id ))
	}

	public function getEntity( id:uint ):Entity {
		return mEntities.get( id );
	}

	public function getEntities( familyIdentifier:Class = null ):EntityNodeList {
		mFamiliesManager.getEntities( familyIdentifier );
	}
}
}
