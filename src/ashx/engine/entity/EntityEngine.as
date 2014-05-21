/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.entity {
import ashx.engine.aspects.AspectList;
import ashx.engine.aspects.AspectManager;
import ashx.engine.components.ComponentManager;
import ashx.engine.ecse;
import ashx.engine.lists.ItemList;

use namespace ecse;

//public class EnJinn {
public class EntityEngine {
	ecse var mEntities:EntityManager;
	ecse var mComponents:ComponentManager;
	ecse var mAspects:AspectManager;

	public function EntityEngine() {
		ItemList.nodeFactory.allocate( 10000 );

		mEntities = new EntityManager();
		mComponents = new ComponentManager( mEntities );
		mAspects = new AspectManager( mEntities, mComponents );
	}

	public function add( entity:Entity ):Entity {
		return mEntities.add( entity );
	}

	public function remove( entity:Entity ):Entity {
		return mEntities.remove( entity );
	}

	public function removeAll():void {
		mEntities.removeAll();
	}

	public function get( id:uint ):Entity {
		return mEntities.get( id );
	}

	public function getAspects( familyIdentifier:Class ):AspectList {
		return mAspects.getAspects( familyIdentifier );
	}

	public function dispose():void {
		mEntities.removeAll();
		mEntities = null;
		mComponents = null;
		mAspects = null;
	}
}
}
