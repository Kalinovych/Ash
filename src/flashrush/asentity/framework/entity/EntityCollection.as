/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.entity {
import flash.utils.Dictionary;

import flashrush.asentity.framework.api.asentity;
import flashrush.asentity.framework.entity.api.IEntityHandler;
import flashrush.gdf.api.gdf_core;
import flashrush.ds.LinkedSet;
import flashrush.ds.ListBase;
import flashrush.ds.Node;

use namespace asentity;
use namespace gdf_core;

public class EntityCollection extends ListBase /*implements IEntityManager*/ {
	protected var _registry:Dictionary = new Dictionary();
	protected var _handlers:LinkedSet = new LinkedSet();

	public function EntityCollection() {
		super();
	}

	public function add( entity:Entity ):Entity {
		if ( _registry[entity] ) return entity;

		entity._alive = true;
		_registry[entity] = true;
		$attach( entity );

		// (inline) notify handlers
		for ( var node:Node = _handlers.firstNode; node; node = node.next ) {
			var handler:IEntityHandler = node.item;
			handler.handleEntityAdded( entity );
		}

		return entity;
	}

	public function contains( entity:Entity ):Boolean {
		return _registry[entity];
	}

	public function remove( entity:Entity ):Entity {
		if ( !_registry[entity] ) {
			return null;
		}

		entity._alive = false;
		delete _registry[entity];
		$detach( entity );

		// (inline) notify handlers in backward order
		for ( var node:Node = _handlers.firstNode; node; node = node.prev ) {
			var handler:IEntityHandler = node.item;
			handler.handleEntityRemoved( entity );
		}

		return entity;
	}

	public function removeAll():void {
		while ( _firstNode ) {
			var entity:Entity = first;
			remove( entity );
			entity.prev = null;
			entity.next = null;
		}
	}

	public function registerHandler( handler:IEntityHandler ):Boolean {
		return _handlers.add( handler );
	}

	public function unRegisterHandler( handler:IEntityHandler ):Boolean {
		return _handlers.remove( handler );
	}

	[Inline]
	public final function get first():Entity {
		return _firstNode;
	}

	[Inline]
	public final function get last():Entity {
		return _lastNode;
	}

	[Inline]
	public final function get length():uint {
		return _length;
	}

}
}
