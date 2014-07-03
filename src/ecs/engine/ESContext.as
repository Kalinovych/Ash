/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.engine {
import ecs.framework.api.ecs_core;
import ecs.framework.entity.Entity;
import ecs.framework.entity.EntityCollection;
import ecs.framework.entity.api.IEntityManager;
import ecs.framework.systems.SystemCollection;
import ecs.framework.systems.api.ISystem;
import ecs.framework.systems.api.ISystemManager;

use namespace ecs_core;

public class ESContext extends ContextBase {
	protected var entities:IEntityManager;
	protected var systems:ISystemManager;

	public function ESContext() {
		initES();
	}

	/* Entities */

	public function addEntity( entity:Entity ):Entity {
		return entities.add( entity );
	}

	public function hasEntity( id:uint ):Boolean {
		return entities.has( id );
	}

	public function getEntity( id:uint ):Entity {
		return entities.get( id );
	}

	public function removeEntity( entity:Entity ):Entity {
		return entities.remove( entity );
	}

	public function removeAllEntities():void {
		entities.removeAll();
	}

	/* Systems */

	public function addSystem( system:ISystem, order:int ):* {
		return systems.add( system, order );
	}

	public function getSystem( systemType:Class ):* {
		return systems.get( systemType );
	}

	public function removeSystem( system:* ):* {
		return systems.remove( system );
	}

	public function removeAllSystems():void {
		systems.removeAll();
	}

	/* ES Framework internal */

	[Inline]
	ecs_core final function get entities():IEntityManager {
		return this.entities;
	}

	[Inline]
	ecs_core final function get systems():ISystemManager {
		return this.systems;
	}

	/* Internal */

	protected function initES():void {
		entities = new EntityCollection();
		systems = new SystemCollection();
	}
	
	// Pure handlers version //
	
	/*public function addEntity( entity:Entity ):Entity {
		var node:Node = entityHandlers.$firstNode;
		while ( node ) {
			var handler:IEntityHandler = node.content;
			handler.onEntityAdded( entity );
			node = node.next;
		}
		return entity;
	}

	public function removeEntity( entity:Entity ):Entity {
		var node:Node = entityHandlers.$lastNode;
		while ( node ) {
			var handler:IEntityHandler = node.content;
			handler.onEntityRemoved( entity );
			node = node.prev;
		}
		return entity;
	}

	public function addSystem( system:ISystem, order:int = 0 ):* {
		var node:Node = systemHandlers.$firstNode;
		while ( node ) {
			var handler:ISystemHandler = node.content;
			handler.onSystemAdded( system );
			node = node.next;
		}
		return system;
	}

	public function removeSystem( system:ISystem ):* {
		var node:Node = systemHandlers.$lastNode;
		while ( node ) {
			var handler:ISystemHandler = node.content;
			handler.onSystemRemoved( system );
			node = node.prev;
		}
		return system;
	}

	ecse function registerHandler( handler:* ):Boolean {
		var registered:Boolean = false;

		if ( handler is IEntityHandler ) {
			registered ||= entityHandlers.add( handler );
		}

		if ( handler is ISystemHandler ) {
			registered ||= systemHandlers.add( handler );
		}

		if ( !registered ) {
			trace( "[ESContext.registerHandler]› WARNING: Handler " + handler + " wasn't registered!" );
		}

		return registered;
	}

	ecse function unregisterHandler( handler:* ):void {
		if ( handler is IEntityHandler ) {
			entityHandlers.remove( handler );
		}

		if ( handler is ISystemHandler ) {
			systemHandlers.remove( handler );
		}
	}*/

}
}
