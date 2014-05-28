/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.framework.components {
import ashx.engine.api.ecse;
import ashx.engine.components.api.IComponentHandler;
import ashx.engine.entity.Entity;
import ashx.engine.entity.EntityManager;
import ashx.engine.entity.api.IEntityHandler;
import ashx.lists.LinkedSet;
import ashx.lists.Node;

import flash.utils.Dictionary;

use namespace ecse;

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
