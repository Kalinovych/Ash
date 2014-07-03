/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */

package ecs.engine {
import com.flashrush.signals.ISignal;
import com.flashrush.signals.v2.SignalPro;

import ecs.framework.api.ecs_core;
import ecs.framework.entity.Entity;
import ecs.framework.entity.EntityCollection;
import ecs.framework.systems.SystemCollection;

use namespace ecs_core;

public class ESEngine {
	protected var _onPreUpdate:ISignal = new SignalPro( Number );
	protected var _onUpdate:ISignal = new SignalPro( Number );
	protected var _onPostUpdate:ISignal = new SignalPro( Number );

	protected var _entities:EntityCollection;
	protected var _systems:SystemCollection;

	public function ESEngine() {
		_entities = new EntityCollection();
		_systems = new SystemCollection();
	}

	/* Entities */

	public function addEntity( entity:Entity ):Entity {
		return _entities.add( entity );
	}

	public function containsEntity( entity:Entity ):Boolean {
		return _entities.has( entity );
	}

	public function removeEntity( entity:Entity ):Entity {
		return _entities.remove( entity );
	}

	public function removeAllEntities():void {
		_entities.removeAll();
	}

	public function get entities():EntityCollection {
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

	public function get systems():SystemCollection {
		return _systems;
	}

	/* Processing */
	public function update( deltaTime:Number ):void {
		
	}
}
}
