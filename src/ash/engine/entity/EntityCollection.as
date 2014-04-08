/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ash.engine.entity {
import ash.core.Entity;
import ash.engine.lists.AnyElementIterator;
import ash.engine.lists.LinkedHashMap;
import ash.engine.lists.LinkedHashSet;

public class EntityCollection {
	private var mEntities:LinkedHashMap;
	private var mHandlers:LinkedHashSet;
	private var mHandlerIterator:AnyElementIterator;

	public function EntityCollection() {
		mEntities = new LinkedHashMap();
		mHandlers = new LinkedHashSet();
		mHandlerIterator = new AnyElementIterator( mHandlers );
	}

	public function add( entity:Entity ):Entity {
		var key:* = entity.id;
		
		if ( mEntities.contains( key ) ) {
			throw new Error( "Entity with id \"" + key + "\" already exists in this collection!" );
		}

		if ( mHandlerIterator.isIterating ) {
			throw new Error( "An entity can't be added to the collection while handling other" );
		}

		mEntities.put( key, entity );

		// hopes that entity should not be removed while iterating added handlers
		while ( mHandlerIterator.next() ) {
			var handler:IEntityHandler = mHandlerIterator.current;
			handler.handleAddedEntity( entity );
		}
		
		return entity;
	}

	public function removeEntity( entity:Entity ):Entity {
		var key:* = entity.id;

		if ( !mEntities.contains( key ) ) {
			throw new Error( "Entity with id \"" + key + "\" not fount in this collection");
		}

		if ( mHandlerIterator.isIterating ) {
			throw new Error( "An entity can't be removed from the collection while handling other" );
		}

		mEntities.remove( key );

		while ( mHandlerIterator.next() ) {
			var handler:IEntityHandler = mHandlerIterator.current;
			handler.handleRemovedEntity( entity );
		}
		
		return entity;
	}

	public function getIterator():EntityIterator {
		return new EntityIterator( mEntities );
	}
	
	public function addHandler( handler:IEntityHandler ):Boolean {
		return mHandlers.add( handler );
	}

	public function removeHandler( handler:IEntityHandler ):Boolean {
		return mHandlers.remove( handler );
	}
}
}
