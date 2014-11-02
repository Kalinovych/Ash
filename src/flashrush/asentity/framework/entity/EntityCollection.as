/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.entity {
import flash.utils.Dictionary;

import flashrush.asentity.framework.api.asentity;
import flashrush.asentity.framework.entity.api.IEntityHandler;
import flashrush.collections.base.LinkedNodeListBase;
import flashrush.gdf.api.gdf_core;
import flashrush.ds.LinkedSet;
import flashrush.ds.ListBase;
import flashrush.ds.Node;

use namespace asentity;
use namespace gdf_core;

public class EntityCollection extends LinkedNodeListBase {
	protected var _registry:Dictionary = new Dictionary();
	protected var _handlers:LinkedSet = new LinkedSet();

	public function EntityCollection() {
		super();
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

	public function add( entity:Entity ):Entity {
		if ( _registry[entity] ) {
			return entity;
		}

		_registry[entity] = true;
		base::attach( entity );

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

	public function remove( entity:Entity ):Boolean {
		if ( !_registry[entity] ) {
			return false;
		}

		delete _registry[entity];
		base::detach( entity );

		// (inline) notify handlers in backward order
		for ( var node:Node = _handlers.firstNode; node; node = node.prev ) {
			var handler:IEntityHandler = node.item;
			handler.handleEntityRemoved( entity );
		}

		return true;
	}

	public function removeAll():void {
		while ( _firstNode ) {
			var entity:Entity = _firstNode;
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

}
}
