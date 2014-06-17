/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.engine.core {
import ecs.engine.core.impl.EntityIdMap;
import ecs.engine.processes.api.IUpdateProcess;
import ecs.extensions.instanceRegistry.InstanceRegistry;
import ecs.extensions.instanceRegistry.InstanceRegistryExtension;
import ecs.framework.api.ecs_core;
import ecs.framework.entity.Entity;
import ecs.framework.systems.System;

use namespace ecs_core;

public class MyGameEngine {
	protected var context:ESCtx = new ESCtx();
	protected var entityMap:EntityIdMap;

	public function MyGameEngine() {
	}

	public function initialize():void {
		entityMap = new EntityIdMap( context );

		var ire:InstanceRegistryExtension = new InstanceRegistryExtension();
		ire.extend( null );

		var instanceRegistry:InstanceRegistry = ire.instanceRegistry;
		instanceRegistry.observe( IUpdateProcess );
	}

	public function createEntity():Entity {
		var entity:Entity = new Entity();
		context.addEntity( entity );
		return entity;
	}

	public function createEntityWith( component:Object, type:Class = null ):Entity {
		var entity:Entity = new Entity();
		entity.add( component, type );
		context.removeEntity( entity );
		return entity;
	}

	public function addEntity( entity:Entity ):void {
		context.addEntity( entity );
	}

	public function getEntity( id:uint ):Entity {
		return entityMap.getById( id );
	}

	public function hasEntity( id:uint ):Boolean {
		return entityMap.getById( id );
	}

	public function removeEntity( id:uint ):Entity {
		var entity:Entity = entityMap.getById( id );
		if ( !entity ) {
			return null;
		}
		context.removeEntity( entity );
	}

	public function removeAllEntities():void {
		const entityList:EntityList = context.entityList;
		while ( entityList.first ) {
			context.removeEntity( entityList.first );
		}
	}

	public function addSystem( system:System, order:int = 0 ):void {
		context.addSystem( system, order );
	}
}
}
