/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework {
import flashrush.asentity.framework.core.Activity;
import flashrush.asentity.framework.entity.Entity;
import flashrush.asentity.framework.entity.EntityCollection;
import flashrush.signals.Signal1;

public class Space {
	public const OnEntityAdded:Signal1 = new Signal1( Entity );
	public const OnEntityRemoved:Signal1 = new Signal1( Entity );
	
	protected var _entities:EntityCollection = new EntityCollection();
	protected var _activities:Vector.<Activity>;
	
	public function Space() {
		_entities.registerHandler( new EntityRout( OnEntityAdded.dispatch, OnEntityRemoved.dispatch ) );
	}
	
	public function get entities():EntityCollection {
		return _entities;
	}
	
	public function addEntity( entity:Entity ):Entity {
		_entities.add( entity );
		return entity;
	}
	
	public function contains( entity:Entity ):Boolean {
		return _entities.contains( entity );
	}
	
	public function removeEntity( entity:Entity ):Entity {
		_entities.remove( entity );
		return entity;
	}
	
	public function clear():void {
		_entities.removeAll();
	}
	
	public function update( delta:Number ):void {
		for each( var activity:Activity in _activities ) {
			activity.update( delta );
		}
	}
}
}

import flashrush.asentity.framework.entity.Entity;
import flashrush.asentity.framework.entity.api.IEntityHandler;

class EntityRout implements IEntityHandler {
	private var addedCallback:Function;
	private var removedCallback:Function;
	
	public function EntityRout( addedCallback:Function, removedCallback:Function ) {
		this.addedCallback = addedCallback;
		this.removedCallback = removedCallback;
	}
	
	public function handleEntityAdded( entity:Entity ):void {
		addedCallback( entity );
	}
	
	public function handleEntityRemoved( entity:Entity ):void {
		removedCallback( entity );
	}
}