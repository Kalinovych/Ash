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

public class EntityCollection {
	ecse var mEntities:LinkedIdMap;
	private var mObservers:LinkedHashSet;

	public function EntityCollection() {
		mEntities = new LinkedIdMap();
		mObservers = new LinkedHashSet();
	}

	public function add( entity:Entity ):Entity {
		var id:* = entity.id;

		if ( mEntities.contains( id ) ) {
			throw new Error( "This list already contains an entity with id \"" + id + "\"" );
		}

		// add an entity to thelist
		mEntities.put( id, entity );

		// notify observers
		for ( var node:ItemNode = mObservers.ecse::_firstNode; node; node = node.next ) {
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
		for ( var node:ItemNode = mObservers.ecse::_lastNode; node; node = node.prev ) {
			var observer:IEntityObserver = node.item;
			observer.onEntityRemoved( entity );
		}

		return entity;
	}

	public function removeAll():void {
		while ( mEntities._firstNode ) {
			remove( mEntities._firstNode.item );
		}
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

	public function get entityCount():uint {
		return mEntities.length;
	}
}
}
