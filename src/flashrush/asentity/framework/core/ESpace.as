/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.core {
import ecs.engine.core.EntityList;

import flash.errors.IllegalOperationError;

import flashrush.asentity.framework.api.asentity;
import flashrush.asentity.framework.entity.Entity;
import flashrush.signals.ICallbacks;
import flashrush.signals.Signal1;

use namespace asentity;

public class ESpace {
	/*
		Design:
		
		Requirements:
			- add/remove entities
			- notification about added/removed entities
			//- ability to iterate over the entities
	 */
	
	
	protected var _entities:EntityList = new EntityList();
	protected var componentHandler:ComponentHandler = new ComponentHandler();
	//protected var _activities:Vector.<Activity> = new <Activity>[];
	
	protected var _OnEntityAdded:Signal1 = new Signal1( Entity );
	protected var _OnEntityRemoved:Signal1 = new Signal1( Entity );
	
	public function ESpace() {
		super();
		_entities.space = this;
	}
	
	public final function get OnEntityAdded():ICallbacks {
		return _OnEntityAdded;
	}
	
	public final function get OnEntityRemoved():ICallbacks {
		return _OnEntityRemoved;
	}
	
	public final function get componentNotifier():IComponentNotifier {
		return componentHandler;
	}
	
	asentity final function get entities():EntityList {
		return _entities;
	}
	
	public function addEntity( entity:Entity ):Entity {
		CONFIG::debug{
			if ( entity._space && entity._space != this ) {
				throw new IllegalOperationError( "The entity belongs to an other space and can't be added!" );
			}
		}
		
		if ( !entity._space ) {
			_entities.attach( entity );
			componentHandler.onEntityAdded( entity );
			_OnEntityAdded.dispatch( entity );
		}
		return entity;
	}
	
	public function contains( entity:Entity ):Boolean {
		return (entity._space == this);
	}
	
	public function removeEntity( entity:Entity ):Entity {
		CONFIG::debug{
			if ( entity._space && entity._space != this ) {
				throw new IllegalOperationError( "The entity belongs to an other space and can't be removed from this one." );
			}
		}
		
		if ( entity._space == this ) {
			_entities.detach( entity );
			componentHandler.onEntityRemoved( entity );
			_OnEntityRemoved.dispatch( entity );
		}
		return entity;
	}
	
	public function removeAllEntities():void {
		_entities.detachAll( _OnEntityRemoved.dispatch );
	}
	
	/*public function update( delta:Number ):void {
		for each( var activity:Activity in _activities ) {
			activity.update( delta );
		}
	}*/
}
}
