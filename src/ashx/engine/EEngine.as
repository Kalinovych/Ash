/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine {
import ashx.engine.entity.Entity;
import ashx.engine.entity.IEntityObserver;
import ashx.engine.lists.ItemNode;
import ashx.engine.lists.LinkedHashSet;
import ashx.engine.lists.LinkedIdMap;

use namespace ecse;

public class EEngine {
	protected var mEntities:LinkedIdMap/*<entityId, Entity>*/;
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

		for ( var node:ItemNode = mEntityObservers.ecse::$firstNode; node; node = node.next ) {
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

		for ( var node:ItemNode = mEntityObservers.ecse::$firstNode; node; node = node.next ) {
			var observer:IEntityObserver = node.item;
			observer.onEntityRemoved( entity );
		}

		return entity;
	}

	public function removeAllEntities():void {
		mEntities.removeAll();
	}

	ecse function addEntityObserver( observer:IEntityObserver ):Boolean {
		return mEntityObservers.add( observer );
	}

	ecse function removeEntityObserver( observer:IEntityObserver ):Boolean {
		return mEntityObservers.remove( observer );
	}
}
}
