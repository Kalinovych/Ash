/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.engine.core {
import flashrush.asentity.framework.api.asentity;
import flashrush.asentity.framework.entity.Entity;
import flashrush.asentity.framework.entity.api.IEntityHandler;
import flashrush.asentity.framework.systems.SystemList;
import flashrush.asentity.framework.systems.api.ISystem;
import flashrush.asentity.framework.systems.api.ISystemHandler;
import flashrush.gdf.api.gdf_core;
import flashrush.ds.LinkedSet;
import flashrush.ds.Node;

use namespace asentity;
use namespace gdf_core;

/**
 * Scoped collection of entities and systems
 */
public class ESContext {
	asentity var entityList:EntityList = new EntityList();
	asentity var systemList:SystemList = new SystemList();

	asentity var entityHandlers:LinkedSet = new LinkedSet();
	asentity var systemHandlers:LinkedSet = new LinkedSet();

	public function ESContext() {
	}

	public function addEntity( entity:Entity ):Entity {
		entityList.attach( entity );
		var node:Node = entityHandlers.firstNode;
		while ( node ) {
			var handler:IEntityHandler = node.item;
			handler.handleEntityAdded( entity );
			node = node.next;
		}
		return entity;
	}

	public function removeEntity( entity:Entity ):Entity {
		entityList.detach( entity );
		var node:Node = entityHandlers.lastNode;
		while ( node ) {
			var handler:IEntityHandler = node.item;
			handler.handleEntityRemoved( entity );
			node = node.prev;
		}
		return entity;
	}

	public function addSystem( system:ISystem, order:int = 0 ):* {
		systemList.add( system, order );
		var node:Node = systemHandlers.firstNode;
		while ( node ) {
			var handler:ISystemHandler = node.item;
			handler.onSystemAdded( system );
			node = node.next;
		}
		return system;
	}

	public function removeSystem( system:ISystem ):* {
		systemList.remove( system );
		var node:Node = systemHandlers.lastNode;
		while ( node ) {
			var handler:ISystemHandler = node.item;
			handler.onSystemRemoved( system );
			node = node.prev;
		}
		return system;
	}

	asentity function registerHandler( handler:* ):Boolean {
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

	asentity function unRegisterHandler( handler:* ):void {
		if ( handler is IEntityHandler ) {
			entityHandlers.remove( handler );
		}

		if ( handler is ISystemHandler ) {
			systemHandlers.remove( handler );
		}
	}
}
}
