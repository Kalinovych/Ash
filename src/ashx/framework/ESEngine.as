/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */

package ashx.framework {
import ashx.engine.api.ecse;
import ashx.engine.entity.Entity;
import ashx.engine.entity.EntityManager;
import ashx.engine.systems.SystemManager;

use namespace ecse;

public class ESEngine {
	protected var _entities:EntityManager;
	protected var _systems:SystemManager;

	public function ESEngine() {
		_entities = new EntityManager();
		_systems = new SystemManager();
	}

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

	public function addSystem( system:*, order:int ):ESEngine {
		_systems.add( system, order );
	}
	
	public function getSystem( systemType:Class ):* {
		return _systems.get( systemType );
	}
	
	public function removeSystem( system:* ):void {
		_systems.remove( system );
	}
	

	ecse function get entities():EntityManager {
		return _entities;
	}
}
}
