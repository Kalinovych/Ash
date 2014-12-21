/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.entity {
import flash.utils.Dictionary;

import flashrush.asentity.framework.api.asentity;
import flashrush.asentity.framework.entity.api.IEntityHandler;

use namespace asentity;
use namespace gdf_core;

public class EntityCollection extends LinkedListBase {
	protected var registry:Dictionary = new Dictionary();
	protected var handlers:LinkedSet = new LinkedSet();

	public function EntityCollection() {
		super();
	}
	
	public final function get first():Entity {
		return base::first;
	}
	
	public final function get last():Entity {
		return base::last;
	}
	
	public final function get length():uint {
		return base::length;
	}

	public function add( entity:Entity ):Entity {
		if ( registry[entity] ) {
			return entity;
		}

		registry[entity] = true;
		base::linkLast( entity );

		// inline notify handlers
		for ( var node:Node = handlers.firstNode; node; node = node.next ) {
			var handler:IEntityHandler = node.item;
			handler.handleEntityAdded( entity );
		}

		return entity;
	}

	public function contains( entity:Entity ):Boolean {
		return registry[entity];
	}

	public function remove( entity:Entity ):Boolean {
		if ( !registry[entity] ) {
			return false;
		}

		delete registry[entity];
		base::unlink( entity );

		// inline notify handlers in backward order
		for ( var node:Node = handlers.firstNode; node; node = node.prev ) {
			var handler:IEntityHandler = node.item;
			handler.handleEntityRemoved( entity );
		}

		return true;
	}

	public function removeAll():void {
		while ( base::first ) {
			var entity:Entity = base::first;
			remove( entity );
			entity.prev = null;
			entity.next = null;
		}
	}

	public function registerHandler( handler:IEntityHandler ):Boolean {
		return handlers.add( handler );
	}

	public function unRegisterHandler( handler:IEntityHandler ):Boolean {
		return handlers.remove( handler );
	}

}
}
