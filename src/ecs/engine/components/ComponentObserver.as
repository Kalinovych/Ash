/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.engine.components {
import ecs.framework.api.ecs_core;
import ecs.framework.components.api.IComponentHandler;
import ecs.framework.entity.Entity;
import ecs.framework.entity.EntityManager;
import ecs.framework.entity.api.IEntityHandler;
import ecs.lists.LinkedSet;
import ecs.lists.Node;

import flash.utils.Dictionary;

use namespace ecs_core;

/**
 * Global observer of components
 */
public class ComponentObserver implements IComponentObserver, IEntityHandler, IComponentHandler {
	private var entities:EntityManager;
	private var handlersByComponent:Dictionary/*<LinkedSet>*/ = new Dictionary();

	public function ComponentObserver( entities:EntityManager ) {
		this.entities = entities;
		entities.registerHandler( this );
	}

	public function registerHandler( componentType:Class, handler:IComponentHandler ):void {
		var handlerList:LinkedSet = handlersByComponent[componentType];
		if ( !handlerList ) {
			handlerList = new LinkedSet();
			handlersByComponent[componentType] = handlerList;
		}
		handlerList.add( handler );
	}

	public function unregisterHandler( componentType:Class, handler:IComponentHandler ):void {
		var handlerList:LinkedSet = handlersByComponent[componentType];
		if ( handlerList ) {
			handlerList.remove( handler );
		}
	}

	/** @private */
	public function onEntityAdded( entity:Entity ):void {
		entity.addComponentHandler( this );
		//entity.componentHandler = this;
		
		var components:* = entity.components;
		for ( var componentType:* in components ) {
			onComponentAdded( entity, components[componentType], componentType );
		}
	}

	/** @private */
	public function onEntityRemoved( entity:Entity ):void {
		var components:* = entity.components;
		for ( var componentType:* in components ) {
			onComponentRemoved( entity, components[componentType], componentType );
		}
		
		//entity.componentHandler = null;
		entity.removeComponentHandler( this );
	}

	/** @private */
	public function onComponentAdded( entity:Entity, componentType:Class, component:* ):void {
		var handlerList:LinkedSet = handlersByComponent[component];
		if ( handlerList ) {
			for ( var node:Node = handlerList.$firstNode; node; node = node.next ) {
				var handler:IComponentHandler = node.content;
				handler.onComponentAdded( entity, componentType, component );
			}
		}
	}

	/** @private */
	public function onComponentRemoved( entity:Entity, componentType:Class, component:* ):void {
		var handlerList:LinkedSet = handlersByComponent[component];
		if ( handlerList ) {
			for ( var node:Node = handlerList.$firstNode; node; node = node.next ) {
				var handler:IComponentHandler = node.content;
				handler.onComponentRemoved( entity, componentType, component );
			}
		}
	}
}
}
