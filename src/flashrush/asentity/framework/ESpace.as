/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework {
import ecs.engine.core.EntityList;
import ecs.engine.core.LinkedEntityList;

import flash.errors.IllegalOperationError;

import flashrush.asentity.extensions.aspects.AspectManager;
import flashrush.asentity.framework.api.asentity;
import flashrush.asentity.framework.core.Activity;
import flashrush.asentity.framework.entity.Entity;
import flashrush.signals.ICallbacks;
import flashrush.signals.Signal1;

use namespace asentity;

public class ESpace {
	protected var _entities:LinkedEntityList = new LinkedEntityList();
	protected var _list:EntityList = new EntityList( _entities );
	protected var _activities:Vector.<Activity> = new <Activity>[];
	protected var _aspectManager:AspectManager;
	
	protected var _OnEntityAdded:Signal1 = new Signal1( Entity );
	protected var _OnEntityRemoved:Signal1 = new Signal1( Entity );
	
	public function ESpace() {
		super();
		//_aspectManager = new AspectManager( _entities, null );
	}
	
	public final function get OnEntityAdded():ICallbacks {
		return _OnEntityAdded;
	}
	
	public final function get OnEntityRemoved():ICallbacks {
		return _OnEntityRemoved;
	}
	
	public final function get entities():EntityList {
		return _list;
	}
	
	public function addEntity( entity:Entity ):Entity {
		CONFIG::debug{
			if ( entity._space && entity._space != this ) {
				throw new IllegalOperationError( "The entity belongs to an other space and can't be added!" );
			}
		}
		
		if ( !entity._space ) {
			_entities.attach( entity );
			entity._space = this;
		}
		return entity;
	}
	
	public function contains( entity:Entity ):Boolean {
		return (entity._space == this);
	}
	
	public function removeEntity( entity:Entity ):Entity {
		CONFIG::debug{
			if ( entity._space && entity._space != this ) {
				throw new IllegalOperationError( "The entity do not belong to this space" );
			}
		}
		
		if ( entity._space == this ) {
			_entities.detach( entity );
			_OnEntityRemoved.dispatch( entity );
			entity._space = null;
		}
		return entity;
	}
	
	public function removeAllEntities():void {
		_entities.detachAll();
	}
	
	public function update( delta:Number ):void {
		for each( var activity:Activity in _activities ) {
			activity.update( delta );
		}
	}
}
}
