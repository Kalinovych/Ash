/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.engine.components {
import flash.utils.Dictionary;

import flashrush.asentity.framework.api.asentity;
import flashrush.asentity.framework.components.api.IComponentHandler;
import flashrush.asentity.framework.entity.Entity;
import flashrush.asentity.framework.entity.EntityCollection;
import flashrush.asentity.framework.entity.api.IEntityHandler;
import flashrush.gdf.api.gdf_core;
import flashrush.ds.LinkedSet;
import flashrush.ds.Node;

use namespace asentity;
use namespace gdf_core;

/**
 * Global observer of components
 */
public class ComponentObserver implements IComponentObserver, IEntityHandler, IComponentHandler {
	private var entities:EntityCollection;
	private var handlersByComponent:Dictionary/*<Class, LinkedSet>*/ = new Dictionary();

	public function ComponentObserver( entities:EntityCollection ) {
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

	public function unRegisterHandler( componentType:Class, handler:IComponentHandler ):void {
		var handlerList:LinkedSet = handlersByComponent[componentType];
		if ( handlerList ) {
			handlerList.remove( handler );
		}
	}

	/** @private */
	public function handleEntityAdded( entity:Entity ):void {
		entity.addComponentHandler( this );
		//entity.componentHandler = this;
		
		var components:* = entity._components;
		for ( var componentType:* in components ) {
			onComponentAdded( entity, components[componentType], componentType );
		}
	}

	/** @private */
	public function handleEntityRemoved( entity:Entity ):void {
		var components:* = entity._components;
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
			for ( var node:Node = handlerList.firstNode; node; node = node.next ) {
				var handler:IComponentHandler = node.item;
				handler.onComponentAdded( entity, componentType, component );
			}
		}
	}

	/** @private */
	public function onComponentRemoved( entity:Entity, componentType:Class, component:* ):void {
		var handlerList:LinkedSet = handlersByComponent[component];
		if ( handlerList ) {
			for ( var node:Node = handlerList.firstNode; node; node = node.next ) {
				var handler:IComponentHandler = node.item;
				handler.onComponentRemoved( entity, componentType, component );
			}
		}
	}
}
}
