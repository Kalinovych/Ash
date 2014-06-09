/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.engine {
import ecs.engine.core.UnitsCore;
import ecs.framework.api.ecs_core;
import ecs.framework.entity.Entity;

use namespace ecs_core;

public class ESContext {
	ecs_core var entitiesCore:UnitsCore = new UnitsCore();
	ecs_core var processesCore:UnitsCore = new UnitsCore();

	public function ESContext() {
		
	}

	public function addEntity( entity:Entity ):void {
		entitiesCore.attach( entity );
	}

	public function removeEntity( entity:Entity ):void {
		entitiesCore.detach( entity );
	}
	
	public function removeAllEntities():void {

	}

}
}
