/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */

package ecs.engine {
import com.flashrush.signals.ISignal;

import flashrush.asentity.framework.api.asentity;
import flashrush.asentity.framework.entity.Entity;
import flashrush.asentity.framework.entity.EntityCollection;
import flashrush.asentity.framework.systems.SystemNodeManager;

use namespace asentity;

public class ESEngine {
	protected var _onPreUpdate:ISignal = new SignalPro( Number );
	protected var _onUpdate:ISignal = new SignalPro( Number );
	protected var _onPostUpdate:ISignal = new SignalPro( Number );

	protected var _entities:EntityCollection;
	protected var _systems:SystemNodeManager;

	public function ESEngine() {
		_entities = new EntityCollection();
		_systems = new SystemNodeManager();
	}

	/* Entities */

	public function addEntity( entity:Entity ):Entity {
		return _entities.add( entity );
	}

	public function hasEntity( entity:Entity ):Boolean {
		return _entities.contains( entity );
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

	public function get systems():SystemNodeManager {
		return _systems;
	}

	/* Processing */
	public function update( step:Number ):void {
		_systems.update( step );
	}
}
}
