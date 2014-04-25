/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ash.engine.entity {
import ash.core.Entity;
import ash.engine.ComponentManager;
import ash.engine.components.IComponentObserver;
import ash.engine.ecse;
import ash.engine.lists.ItemNode;
import ash.engine.lists.LinkedHashSet;
import ash.engine.lists.LinkedIdMap;

import com.flashrush.signatures.BitSignManager;

use namespace ecse;

public class EntityManager {
	ecse var mEntities:LinkedIdMap;
	//ecse var mSignManager:BitSignManager;
	//ecse var mEntitySigner:EntitySigner;
	ecse var mComponentManager:ComponentManager;

	private var mEntityObservers:LinkedHashSet;
	
	public function EntityManager( customComponentManagerClass:Class = null ) {
		mEntities = new LinkedIdMap();
		//mSignManager = new BitSignManager();
		//mEntitySigner = new EntitySigner( mSignManager );
		mEntityObservers = new LinkedHashSet();
		
		/*if (customComponentManagerClass) {
			mComponentManager = new customComponentManagerClass( this );
		} else {
			mComponentManager = new ComponentManager( this );
		}*/
	}

	public function add( entity:Entity ):Entity {
		var id:* = entity.id;

		if ( mEntities.contains( id ) ) {
			throw new Error( "An entity with id \"" + id + "\" already exists in this manager!" );
		}

		// add an entity to list
		mEntities.put( id, entity );

		// notify signer first
		//mEntitySigner.onEntityAdded( entity );
		
		mComponentManager.onEntityAdded( entity );

		// manual subscribe signer for component observation
		//entity.addComponentObserver( mEntitySigner );

		// notify observers
		for ( var node:ItemNode = mEntityObservers.ecse::_firstNode; node; node = node.next ) {
			var observer:IEntityObserver = node.item;
			observer.onEntityAdded( entity );
		}

		return entity;
	}

	public function get( id:uint ):Entity {
		return mEntities.get( id );
	}

	public function removeEntity( entity:Entity ):Entity {
		var id:* = entity.id;

		if ( !mEntities.contains( id ) ) {
			throw new Error( "An entity with id \"" + id + "\" not fount in this manager" );
		}

		// remove an entity from list
		mEntities.remove( id );

		// remove signer from component observation first,
		// to allow other observers use the sign before it will be disposed by SignManager 
		//entity.removeComponentObserver( mEntitySigner );

		mComponentManager.onEntityRemoved( entity );

		// notify observers in backward order (?)
		for ( var node:ItemNode = mEntityObservers.ecse::_lastNode; node; node = node.prev ) {
			var observer:IEntityObserver = node.item;
			observer.onEntityRemoved( entity );
		}

		// notify signer last
		//mEntitySigner.onEntityRemoved( entity );

		return entity;
	}

	public function getIterator():EntityIterator {
		return new EntityIterator( mEntities );
	}

	public function addObserver( observer:IEntityObserver ):Boolean {
		return mEntityObservers.add( observer );
	}

	public function removeObserver( observer:IEntityObserver ):Boolean {
		return mEntityObservers.remove( observer );
	}
}
}
