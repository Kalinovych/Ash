/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.core {
import flash.utils.Dictionary;

import flashrush.asentity.framework.api.asentity;
import flashrush.asentity.framework.entity.Entity;
import flashrush.asentity.framework.entity.api.IEntityObserver;
import flashrush.collections.LinkedSet;
import flashrush.collections.base.LLNodeBase;
import flashrush.collections.list_internal;

use namespace asentity;

/**
 * Single entity component handler for a space.
 */
public class ComponentHandler implements IComponentNotifier, IEntityObserver, IComponentObserver {
	private var observersMap:Dictionary/*<Class, LinkedSet>*/ = new Dictionary();
	
	public function ComponentHandler() {}
	
//-------------------------------------------
// IComponentNotifier methods
//-------------------------------------------
	
	public function addObserver( componentType:Class, observer:IComponentObserver ):void {
		var typeObservers:LinkedSet = observersMap[componentType];
		if ( !typeObservers ) {
			typeObservers = new LinkedSet();
			observersMap[componentType] = typeObservers;
		}
		typeObservers.add( observer );
	}

	public function removeObserver( componentType:Class, observer:IComponentObserver ):void {
		var typeObservers:LinkedSet = observersMap[componentType];
		if ( typeObservers ) {
			typeObservers.remove( observer );
		}
	}

//-------------------------------------------
// Internals
//-------------------------------------------
	
	/** @private */
	public function onEntityAdded( entity:Entity ):void {
		entity.addComponentObserver( this );
		
		const components:* = entity._components;
		for ( var componentType:* in components ) {
			onComponentAdded( entity, componentType, components[componentType] );
		}
	}

	/** @private */
	public function onEntityRemoved( entity:Entity ):void {
		const components:* = entity._components;
		for ( var componentType:* in components ) {
			onComponentRemoved( entity, componentType, components[componentType] );
		}
		
		entity.removeComponentObserver( this );
	}

	/** @private */
	public function onComponentAdded( entity:Entity, componentType:Class, component:* ):void {
		const observers:LinkedSet = observersMap[componentType];
		if ( observers ) {
			for ( var node:LLNodeBase = observers.firstNode; node; node = node.list_internal::next ) {
				var observer:IComponentObserver = node.list_internal::item;
				observer.onComponentAdded( entity, componentType, component );
			}
		}
	}

	/** @private */
	public function onComponentRemoved( entity:Entity, componentType:Class, component:* ):void {
		const observers:LinkedSet = observersMap[componentType];
		if ( observers ) {
			for ( var node:LLNodeBase = observers.firstNode; node; node = node.list_internal::next ) {
				var observer:IComponentObserver = node.list_internal::item;
				observer.onComponentRemoved( entity, componentType, component );
			}
		}
	}
}
}

/*
import flash.utils.Dictionary;

import flashrush.asentity.framework.core.IComponentObserver;
import flashrush.asentity.framework.entity.Entity;
import flashrush.collections.LinkedSet;
import flashrush.collections.base.LLNodeBase;
import flashrush.collections.list_internal;

class ComponentHandler implements IComponentObserver {
	private var observersMap:Dictionary;
	
	public function ComponentHandler( observersMap:Dictionary ) {
		this.observersMap = observersMap;
	}
	
	public function onComponentAdded( entity:Entity, componentType:Class, component:* ):void {
		const observers:LinkedSet = observersMap[componentType];
		if ( observers ) {
			for ( var node:LLNodeBase = observers.firstNode; node; node = node.list_internal::next ) {
				const observer:IComponentObserver = node.list_internal::item;
				observer.onComponentAdded( entity, componentType, component );
			}
		}
	}
	
	public function onComponentRemoved( entity:Entity, componentType:Class, component:* ):void {
		const observers:LinkedSet = observersMap[componentType];
		if ( observers ) {
			for ( var node:LLNodeBase = observers.firstNode; node; node = node.list_internal::next ) {
				const observer:IComponentObserver = node.list_internal::item;
				observer.onComponentRemoved( entity, componentType, component );
			}
		}
	}
}*/