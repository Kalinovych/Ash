/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.entity {
import ashx.engine.api.IAspectManager;
import ashx.engine.aspects.AspectList;
import ashx.engine.aspects.AspectsManager;
import ashx.engine.components.ComponentObserver;
import ashx.engine.components.IComponentObserver;
import ashx.engine.ecse;
import ashx.engine.lists.ItemList;

use namespace ecse;

//public class EnJinn {
public class EntityManager {
	ecse var mEntities:EntityList;
	ecse var mComponentObserver:IComponentObserver;
	ecse var mAspects:IAspectManager;

	public function EntityManager() {
		ItemList.nodeFactory.allocate( 10000 );
		
		mEntities = new EntityList();
		initComponentManager();
		initAspectManager();
	}

	protected function initComponentManager():void {
		mComponentObserver = new ComponentObserver( mEntities );
	}

	protected function initAspectManager():void {
		mAspects = new AspectsManager( mEntities, mComponentObserver );
	}

	public function add( entity:Entity ):Entity {
		return mEntities.add( entity );
	}

	public function remove( entity:Entity ):Entity {
		var id:uint = entity.id;

		if ( !mEntities.contains( id ) ) {
			throw new Error( "An entity with id \"" + id + "\" not fount in this manager" );
		}

		return mEntities.remove( id );
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
		mComponentObserver = null;
		mAspects = null;
	}
}
}
