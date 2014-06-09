/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.engine {
import ecs.engine.core.UnitsCore;
import ecs.framework.api.ecs_core;
import ecs.framework.entity.Entity;

use namespace ecs_core;

public class EngineWithCore {
	
	ecs_core var core:UnitsCore = new UnitsCore();
	
	public function EngineWithCore() {
	}

	public function addEntity( entity:Entity ):void {
		core.notifyAdded( entity );
	}

	public function addSystem( system:*, order:int ):ESEngine {
		core.notifyAdded( system );
	}
}
}
