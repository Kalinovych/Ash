/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.engine.core {
import ecs.engine.core.impl.EntityIdMap;
import ecs.framework.entity.Entity;

public class MyGameEngine {
	protected var entities:UnitsCore = new UnitsCore();
	protected var systems:UnitsCore = new UnitsCore();
	
	protected var entityMap:EntityIdMap;

	public function MyGameEngine() {
	}

	public function initialize():void {
		entityMap = new EntityIdMap( entities );
	}

	public function createEntity():Entity {
		var entity:Entity = new Entity();
		entities.attach( entity );
		return entity;
	}

	public function createEntityWith( component:Object, type:Class = null ):Entity {
		var entity:Entity = new Entity();
		entity.add( component, type );
		entities.attach( entity );
		return entity;
	}

	/*public function addEntity( entity:Entity ):void {
		entities.attach( entity );
	}*/

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
		entities.detach( entity );
	}

	public function removeAllEntities():void {
		entities.detachAll();
	}
}
}
