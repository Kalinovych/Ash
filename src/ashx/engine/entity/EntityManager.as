/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.entity {
import ash.core.Entity;
import ashx.engine.ecse;
import ashx.engine.lists.ItemNode;
import ashx.engine.lists.LinkedHashSet;
import ashx.engine.lists.LinkedIdMap;

use namespace ecse;

public class EntityManager {
	ecse var mEntities:LinkedIdMap;

	private var mEntityObservers:LinkedHashSet;

	public function EntityManager() {
		mEntities = new LinkedIdMap();
		mEntityObservers = new LinkedHashSet();
	}

	public function add( entity:Entity ):Entity {
		var id:* = entity.id;

		if ( mEntities.contains( id ) ) {
			throw new Error( "An entity with id \"" + id + "\" already exists in this manager!" );
		}

		// add an entity to list
		mEntities.put( id, entity );
		
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

	public function remove( entity:Entity ):Entity {
		var id:* = entity.id;

		if ( !mEntities.contains( id ) ) {
			throw new Error( "An entity with id \"" + id + "\" not fount in this manager" );
		}

		// remove an entity from list
		mEntities.remove( id );

		// notify observers in backward order (?)
		for ( var node:ItemNode = mEntityObservers.ecse::_lastNode; node; node = node.prev ) {
			var observer:IEntityObserver = node.item;
			observer.onEntityRemoved( entity );
		}

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

	public function get entityCount():uint {
		return mEntities.length;
	}
}
}
