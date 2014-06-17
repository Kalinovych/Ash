/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */

package ecs.engine {
import com.flashrush.signals.ISignal;
import com.flashrush.signals.SignalPro;

import ecs.framework.api.ecs_core;
import ecs.framework.entity.Entity;
import ecs.framework.entity.EntityManager;
import ecs.framework.systems.SystemManager;

use namespace ecs_core;

public class ESEngine {
	protected var _onPreUpdate:ISignal = new SignalPro( Number );
	protected var _onUpdate:ISignal = new SignalPro( Number );
	protected var _onPostUpdate:ISignal = new SignalPro( Number );

	protected var _entities:EntityManager;
	protected var _systems:SystemManager;

	public function ESEngine() {
		_entities = new EntityManager();
		_systems = new SystemManager();
	}
	
	/* Entities */
	
	public function addEntity( entity:Entity ):Entity {
		return _entities.add( entity );
	}

	public function hasEntity( id:uint ):Boolean {
		return _entities.has( id );
	}

	public function getEntity( id:uint ):Entity {
		return _entities.get( id );
	}

	public function removeEntity( entity:Entity ):Entity {
		return _entities.remove( entity );
	}

	public function removeAllEntities():void {
		_entities.removeAll();
	}

	ecs_core function get entities():EntityManager {
		return _entities;
	}
	
	/* Systems */
	
	public function addSystem( system:*, order:int ):ESEngine {
		_systems.add( system, order );
	}

	public function getSystem( systemType:Class ):* {
		return _systems.get( systemType );
	}

	public function removeSystem( system:* ):void {
		_systems.remove( system );
	}
	
	/* Processing */
	public function update( deltaTime:Number ):void {
		
	}
}
}
