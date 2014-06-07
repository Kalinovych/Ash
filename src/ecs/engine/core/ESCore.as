/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.engine.core {
import ecs.framework.api.ecs_core;
import ecs.framework.entity.Entity;
import ecs.framework.entity.api.IEntityHandler;
import ecs.framework.systems.api.ISystem;
import ecs.framework.systems.api.ISystemHandler;
import ecs.lists.LinkedSet;
import ecs.lists.Node;

import flash.utils.Dictionary;

use namespace ecs_core;

public class ESCore {
	ecs_core var entities:CoreUnitList;
	ecs_core var systems:CoreUnitList;
	
	ecs_core var entityHandlers:LinkedSet = new LinkedSet();
	ecs_core var processHandlers:LinkedSet = new LinkedSet();

	public function ESCore() {
	}

	public function attachEntity( entity:CoreUnit ):void {
		
	}
	
	public function addEntity( entity:Entity ):Entity {
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

	public function addProcess( process:ISystem, order:int = 0 ):* {
		var node:Node = processHandlers.$firstNode;
		while ( node ) {
			var handler:ISystemHandler = node.content;
			handler.onSystemAdded( process );
			node = node.next;
		}
		return process;
	}

	public function removeProcess( process:ISystem ):* {
		var node:Node = processHandlers.$lastNode;
		while ( node ) {
			var handler:ISystemHandler = node.content;
			handler.onSystemRemoved( process );
			node = node.prev;
		}
		return process;
	}

	ecs_core function registerHandler( handler:* ):Boolean {
		var registered:Boolean = false;

		if ( handler is IEntityHandler ) {
			registered ||= entityHandlers.add( handler );
		}

		if ( handler is ISystemHandler ) {
			registered ||= processHandlers.add( handler );
		}

		if ( !registered ) {
			trace( this, "[registerProcessor]› WARNING: Processor " + handler + " wasn't registered in the core!" );
		}

		return registered;
	}

	ecs_core function unregisterHandler( handler:* ):void {
		if ( handler is IEntityHandler ) {
			entityHandlers.remove( handler );
		}

		if ( handler is ISystemHandler ) {
			processHandlers.remove( handler );
		}
	}
}
}
