/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.core {
import flash.errors.IllegalOperationError;

import flashrush.asentity.framework.api.asentity;
import flashrush.asentity.framework.entity.Entity;
import flashrush.signals.ICallbacks;
import flashrush.signals.Signal1;

use namespace asentity;

public class Space {
	protected var _entities:EntityList = new EntityList( this );
	protected var _componentManager:ComponentManager = new ComponentManager();
	
	protected var _OnEntityAdded:Signal1 = new Signal1( Entity );
	protected var _OnEntityRemoved:Signal1 = new Signal1( Entity );
	
	public function Space() {
		super();
	}

//-------------------------------------------
// Properties
//-------------------------------------------
	
	public final function get OnEntityAdded():ICallbacks {
		return _OnEntityAdded;
	}
	
	public final function get OnEntityRemoved():ICallbacks {
		return _OnEntityRemoved;
	}
	
	public final function get firstEntity():Entity {
		return _entities.first;
	}
	
	public final function get lastEntity():Entity {
		return _entities.last;
	}
	
	public final function get entityCount():uint {
		return _entities.length;
	}
	
	public final function get componentNotifier():IComponentNotifier {
		return _componentManager;
	}

//-------------------------------------------
// Public methods
//-------------------------------------------
	
	public function addEntity( entity:Entity ):Entity {
		CONFIG::debug{
			if ( entity._space && entity._space != this ) {
				throw new IllegalOperationError( "The entity belongs to an other space and can't be added!" );
			}
		}
		
		if ( !entity._space ) {
			_entities.add( entity );
			$notifyEntityAdded( entity );
		}
		return entity;
	}
	
	public function containsEntity( entity:Entity ):Boolean {
		return (entity._space == this);
	}
	
	public function removeEntity( entity:Entity ):Entity {
		CONFIG::debug{
			if ( entity._space && entity._space != this ) {
				throw new IllegalOperationError( "The entity belongs to an other space and can't be removed from this one." );
			}
		}
		
		if ( entity._space == this ) {
			_entities.remove( entity );
			$notifyEntityRemoved( entity );
		}
		return entity;
	}
	
	public function removeAllEntities():void {
		_entities.removeAll( $notifyEntityRemoved );
	}
	
//-------------------------------------------
// Internals
//-------------------------------------------
	
	[Inline]
	protected final function $notifyEntityAdded( entity:Entity ):void {
		_componentManager.onEntityAdded( entity );
		_OnEntityAdded.dispatch( entity );
	}
	
	[Inline]
	protected final function $notifyEntityRemoved( entity:Entity ):void {
		_componentManager.onEntityRemoved( entity );
		_OnEntityRemoved.dispatch( entity );
	}
	
	/*public function update( delta:Number ):void {
		for each( var activity:Activity in _activities ) {
			activity.update( delta );
		}
	}*/
}
}
