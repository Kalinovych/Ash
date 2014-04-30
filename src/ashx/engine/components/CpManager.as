/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.components {
import ash.core.Entity;

import ashx.engine.ecse;
import ashx.engine.entity.ECollection;
import ashx.engine.entity.IEntityHandler;
import ashx.engine.lists.ItemNode;
import ashx.engine.lists.LinkedHashSet;

import flash.utils.Dictionary;

use namespace ecse;

public class CpManager implements IEntityHandler, IComponentObserver {
	private var entities:ECollection;
	private var entitiesByComponent:Dictionary/*<LinkedHashSet>*/ = new Dictionary();
	private var handlersByComponent:Dictionary/*<LinkedHashSet>*/ = new Dictionary();

	public function CpManager( entities:ECollection ) {
		this.entities = entities;
		entities.addHandler( this );
	}

	public function addComponentHandler( componentType:Class, handler:IComponentObserver ):void {
		var handlers:LinkedHashSet = handlersByComponent[componentType];
		if ( !handlers ) {
			handlers = new LinkedHashSet();
			handlersByComponent[componentType] = handlers;
		}
		handlers.add( handler );
	}

	public function removeComponentHandler( componentType:Class, handler:IComponentObserver ):void {
		var handlers:LinkedHashSet = handlersByComponent[componentType];
		if ( handlers ) {
			handlers.remove( handler );
		}
	}

	public function onEntityAdded( entity:Entity ):void {
		entity.addComponentObserver( this );

		var components:* = entity.ecse::components;
		for ( var componentType:* in components ) {
			mapEntityToComponent( componentType, entity );
		}
	}

	public function onEntityRemoved( entity:Entity ):void {
		var components:* = entity.ecse::components;
		for ( var componentType:* in components ) {
			unmapEntityFromComponent( componentType, entity );
		}

		entity.removeComponentObserver( this );
	}

	public function onComponentAdded( entity:Entity, component:*, componentType:* ):void {
		mapEntityToComponent( componentType, entity );

		var handlers:LinkedHashSet = handlersByComponent[componentType];
		if ( handlers ) {
			for ( var node:ItemNode = handlers._firstNode; node; node = node.next ) {
				var observer:IComponentObserver = node.item;
				observer.onComponentAdded( entity, component, componentType );
			}
		}
	}

	public function onComponentRemoved( entity:Entity, component:*, componentType:* ):void {
		var handlers:LinkedHashSet = handlersByComponent[componentType];
		if ( handlers ) {
			for ( var node:ItemNode = handlers._firstNode; node; node = node.next ) {
				var observer:IComponentObserver = node.item;
				observer.onComponentRemoved( entity, component, componentType );
			}
		}
		
		unmapEntityFromComponent( componentType, entity );
	}

	protected function mapEntityToComponent( componentType:*, entity:Entity ):void {
		var entities:LinkedHashSet = entitiesByComponent[componentType];
		if ( !entities ) {
			entities = new LinkedHashSet();
			entitiesByComponent[componentType] = entities;
		}
		entities.add( entity );
	}

	protected function unmapEntityFromComponent( componentType:*, entity:Entity ):void {
		var entities:LinkedHashSet = entitiesByComponent[componentType];
		if ( entities ) {
			entities.remove( entity );
		}
	}
}
}
