/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.components {
import ash.core.Entity;

import ashx.engine.ecse;
import ashx.engine.entity.EntityList;
import ashx.engine.entity.IEntityHandler;
import ashx.engine.lists.ItemNode;
import ashx.engine.lists.LinkedHashSet;

import flash.utils.Dictionary;

use namespace ecse;

public class CpHandlersManager implements IEntityHandler, IComponentObserver {
	private var entities:EntityList;
	private var observersByComponent:Dictionary/*<LinkedHashSet>*/ = new Dictionary();

	public function CpHandlersManager( entities:EntityList ) {
		this.entities = entities;
		entities.addHandler( this );
	}

	public function addComponentObserver( componentType:Class, observer:IComponentObserver ):void {
		var observerList:LinkedHashSet = observersByComponent[componentType];
		if ( !observerList ) {
			observerList = new LinkedHashSet();
			observersByComponent[componentType] = observerList;
		}
		observerList.add( observer );
	}

	public function removeComponentObserver( componentType:Class, observer:IComponentObserver ):void {
		var observerList:LinkedHashSet = observersByComponent[componentType];
		if ( observerList ) {
			observerList.remove( observer );
		}
	}

	public function onEntityAdded( entity:Entity ):void {
		entity.addComponentObserver( this );

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

		entity.removeComponentObserver( this );
	}

	public function onComponentAdded( entity:Entity, component:*, componentType:* ):void {
		var observerList:LinkedHashSet = observersByComponent[componentType];
		if ( observerList ) {
			for ( var node:ItemNode = observerList._firstNode; node; node = node.next ) {
				var observer:IComponentObserver = node.item;
				observer.onComponentAdded( entity, component, componentType );
			}
		}
	}

	public function onComponentRemoved( entity:Entity, component:*, componentType:* ):void {
		var observerList:LinkedHashSet = observersByComponent[componentType];
		if ( observerList ) {
			for ( var node:ItemNode = observerList._firstNode; node; node = node.next ) {
				var observer:IComponentObserver = node.item;
				observer.onComponentRemoved( entity, component, componentType );
			}
		}
	}
}
}
