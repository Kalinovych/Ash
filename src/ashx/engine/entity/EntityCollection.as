/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.entity {
import ashx.engine.entity.Entity;
import ashx.engine.ecse;
import ashx.engine.lists.ElementList;
import ashx.engine.lists.ItemNode;
import ashx.engine.lists.LinkedHashSet;
import ashx.engine.lists.LinkedIdMap;

use namespace ecse;

public class EntityCollection {
	ecse var mEntities:LinkedIdMap;
	private var mHandlers:LinkedHashSet;

	public function EntityCollection() {
		mEntities = new LinkedIdMap();
		mHandlers = new LinkedHashSet();
	}

	public function add( entity:Entity ):Entity {
		var id:* = entity.id;

		if ( mEntities.contains( id ) ) {
			throw new Error( "This list already contains an entity with id \"" + id + "\"" );
		}

		// add an entity to the list
		mEntities.put( id, entity );

		// notify handlers
		for ( var node:ItemNode = mHandlers.ecse::$firstNode; node; node = node.next ) {
			var handler:IEntityHandler = node.item;
			handler.onEntityAdded( entity );
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

		// notify handlers in backward order (?)
		for ( var node:ItemNode = mHandlers.ecse::$lastNode; node; node = node.prev ) {
			var handler:IEntityHandler = node.item;
			handler.onEntityRemoved( entity );
		}

		return entity;
	}

	public function removeAll():void {
		while ( mEntities.$firstNode ) {
			remove( mEntities.$firstNode.item );
		}
	}

	public function getIterator():EntityNodeListIterator {
		return new EntityNodeListIterator( mEntities );
	}

	public function addHandler( observer:IEntityHandler ):Boolean {
		return mHandlers.add( observer );
	}

	public function removeHandler( observer:IEntityHandler ):Boolean {
		return mHandlers.remove( observer );
	}

	public function get length():uint {
		return mEntities.length;
	}
}
}
