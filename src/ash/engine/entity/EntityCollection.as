/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ash.engine.entity {
import ash.core.Entity;
import ash.engine.ecse;
import ash.engine.lists.ItemNode;
import ash.engine.lists.LinkedHashMap;
import ash.engine.lists.LinkedHashSet;

use namespace ecse;

public class EntityCollection {
	private var mEntities:LinkedHashMap;
	private var mObservers:LinkedHashSet;

	public function EntityCollection() {
		mEntities = new LinkedHashMap();
		mObservers = new LinkedHashSet();
	}

	public function add( entity:Entity ):Entity {
		var id:* = entity.id;

		if ( mEntities.contains( id ) ) {
			throw new Error( "Entity with id \"" + id + "\" already exists in this collection!" );
		}

		mEntities.put( id, entity );

		for (var node:ItemNode = mObservers.ecse::_firstNode; node; node = node.next) {
			var observer:IEntityObserver = node.item;
			observer.onEntityAdded( entity );
		}

		return entity;
	}

	public function removeEntity( entity:Entity ):Entity {
		var id:* = entity.id;

		if ( !mEntities.contains( id ) ) {
			throw new Error( "Entity with id \"" + id + "\" not fount in this collection" );
		}

		mEntities.remove( id );
		
		for (var node:ItemNode = mObservers.ecse::_firstNode; node; node = node.next) {
			var observer:IEntityObserver = node.item;
			observer.onEntityRemoved( entity );
		}

		return entity;
	}

	public function getIterator():EntityIterator {
		return new EntityIterator( mEntities );
	}

	public function addObserver( observer:IEntityObserver ):Boolean {
		return mObservers.add( observer );
	}

	public function removeObserver( observer:IEntityObserver ):Boolean {
		return mObservers.remove( observer );
	}
}
}
