/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.engine.core {
import ecs.framework.api.ecs_core;
import ecs.framework.entity.Entity;
import ecs.framework.entity.api.IEntityHandler;
import ecs.framework.systems.SystemList;
import ecs.framework.systems.api.ISystem;
import ecs.framework.systems.api.ISystemHandler;
import ecs.lists.LinkedSet;
import ecs.lists.Node;

use namespace ecs_core;

/**
 * Scoped collection of entities and systems
 */
public class ESCtx {
	ecs_core var entityList:EntityList = new EntityList();
	ecs_core var systemList:SystemList = new SystemList();

	ecs_core var entityHandlers:LinkedSet = new LinkedSet();
	ecs_core var systemHandlers:LinkedSet = new LinkedSet();
	
	public function ESCtx() {
	}

	public function addEntity( entity:Entity ):Entity {
		entityList.attach( entity );
		var node:Node = entityHandlers.$firstNode;
		while ( node ) {
			var handler:IEntityHandler = node.content;
			handler.handleAddedEntity( entity );
			node = node.next;
		}
		return entity;
	}

	public function removeEntity( entity:Entity ):Entity {
		entityList.detach( entity );
		var node:Node = entityHandlers.$lastNode;
		while ( node ) {
			var handler:IEntityHandler = node.content;
			handler.handleRemovedEntity( entity );
			node = node.prev;
		}
		return entity;
	}

	public function addSystem( system:ISystem, order:int = 0 ):* {
		systemList.add( system, order );
		var node:Node = systemHandlers.$firstNode;
		while ( node ) {
			var handler:ISystemHandler = node.content;
			handler.onSystemAdded( system );
			node = node.next;
		}
		return system;
	}

	public function removeSystem( system:ISystem ):* {
		systemList.remove( system );
		var node:Node = systemHandlers.$lastNode;
		while ( node ) {
			var handler:ISystemHandler = node.content;
			handler.onSystemRemoved( system );
			node = node.prev;
		}
		return system;
	}

	ecs_core function registerHandler( handler:* ):Boolean {
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

	ecs_core function unRegisterHandler( handler:* ):void {
		if ( handler is IEntityHandler ) {
			entityHandlers.remove( handler );
		}

		if ( handler is ISystemHandler ) {
			systemHandlers.remove( handler );
		}
	}
}
}
