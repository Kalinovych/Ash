/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.components {
import ashx.engine.ecse;
import ashx.engine.entity.Entity;
import ashx.engine.entity.EntityList;
import ashx.engine.entity.IEntityHandler;
import ashx.engine.lists.ItemNode;
import ashx.engine.lists.LinkedHashSet;

import flash.utils.Dictionary;

use namespace ecse;

/**
 * Global observer of components
 */
public class ComponentObserver implements IComponentObserver, IEntityHandler, IComponentHandler {
	private var entities:EntityList;
	private var handlersByComponent:Dictionary/*<LinkedHashSet>*/ = new Dictionary();

	public function ComponentObserver( entities:EntityList ) {
		this.entities = entities;
		entities.addHandler( this );
	}

	public function addHandler( componentType:Class, handler:IComponentHandler ):void {
		var handlerList:LinkedHashSet = handlersByComponent[componentType];
		if ( !handlerList ) {
			handlerList = new LinkedHashSet();
			handlersByComponent[componentType] = handlerList;
		}
		handlerList.add( handler );
	}

	public function removeHandler( componentType:Class, handler:IComponentHandler ):void {
		var handlerList:LinkedHashSet = handlersByComponent[componentType];
		if ( handlerList ) {
			handlerList.remove( handler );
		}
	}

	public function onEntityAdded( entity:Entity ):void {
		entity.addComponentHandler( this );

		var components:* = entity.ecse::components;
		for ( var componentType:* in components ) {
			onComponentAdded( entity, components[componentType], componentType );
		}
	}

	public function onEntityRemoved( entity:Entity ):void {
		var components:* = entity.ecse::components;
		for ( var componentType:* in components ) {
			onComponentRemoved( entity, components[componentType], componentType );
		}

		entity.removeComponentHandler( this );
	}

	public function onComponentAdded( entity:Entity, component:*, componentType:* ):void {
		var handlerList:LinkedHashSet = handlersByComponent[componentType];
		if ( handlerList ) {
			for ( var node:ItemNode = handlerList.$firstNode; node; node = node.next ) {
				var handler:IComponentHandler = node.item;
				handler.onComponentAdded( entity, component, componentType );
			}
		}
	}

	public function onComponentRemoved( entity:Entity, component:*, componentType:* ):void {
		var handlerList:LinkedHashSet = handlersByComponent[componentType];
		if ( handlerList ) {
			for ( var node:ItemNode = handlerList.$firstNode; node; node = node.next ) {
				var handler:IComponentHandler = node.item;
				handler.onComponentRemoved( entity, component, componentType );
			}
		}
	}
}
}