/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ash.engine {
import ash.core.Entity;
import ash.engine.entity.IEntityObserver;
import ash.engine.lists.ItemNode;
import ash.engine.lists.LinkedHashSet;
import ash.engine.lists.LinkedIdMap;

public class EEngine {
	protected var mEntities:LinkedIdMap;
	protected var mEntityObservers:LinkedHashSet;

	public function EEngine() {
		mEntities = new LinkedIdMap();
		mEntityObservers = new LinkedHashSet();
	}

	public function addEntity( entity:Entity ):Entity {
		var id:uint = entity.id;

		if ( mEntities.contains( id ) ) {
			throw new Error( "Entity with id \"" + id + "\" already exists in this collection!" );
		}

		mEntities.put( id, entity );

		for ( var node:ItemNode = mEntityObservers.ecse::_firstNode; node; node = node.next ) {
			var observer:IEntityObserver = node.item;
			observer.onEntityAdded( entity );
		}

		return entity;
	}

	public function removeEntity( entity:Entity ):Entity {
		var id:uint = entity.id;

		if ( !mEntities.contains( id ) ) {
			throw new Error( "Entity with id \"" + id + "\" not fount in this collection" );
		}

		mEntities.remove( id );

		for ( var node:ItemNode = mEntityObservers.ecse::_firstNode; node; node = node.next ) {
			var observer:IEntityObserver = node.item;
			observer.onEntityRemoved( entity );
		}

		return entity;
	}

	public function removeAllEntities():void {
		mEntities.removeAll();
	}

	public function addEntityObserver( observer:IEntityObserver ):Boolean {
		return mEntityObservers.add( observer );
	}

	public function removeEntityObserver( observer:IEntityObserver ):Boolean {
		return mEntityObservers.remove( observer );
	}
}
}
