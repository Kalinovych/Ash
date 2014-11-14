/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.core {
import flash.utils.Dictionary;

import flashrush.asentity.framework.api.asentity;
import flashrush.asentity.framework.entity.Entity;
import flashrush.asentity.framework.entity.api.IEntityObserver;
import flashrush.asentity.framework.entity.api.IEntityObserver;
import flashrush.collections.LinkedSet;
import flashrush.collections.base.LLNodeBase;
import flashrush.collections.list_internal;

use namespace asentity;

/**
 * A space entity component notifier
 */
public class ComponentManager implements IComponentNotifier, IEntityObserver, IComponentObserver {
	private var observersMap:Dictionary/*<Class, LinkedSet>*/ = new Dictionary();
	
	public function ComponentManager() {}

//-------------------------------------------
// IComponentNotifier methods
//-------------------------------------------
	
	public function addComponentHandler( componentType:Class, observer:IComponentObserver ):void {
		var typeObservers:LinkedSet = observersMap[componentType];
		if ( !typeObservers ) {
			typeObservers = new LinkedSet();
			observersMap[componentType] = typeObservers;
		}
		typeObservers.add( observer );
	}
	
	public function removeComponentHandler( componentType:Class, observer:IComponentObserver ):void {
		var typeObservers:LinkedSet = observersMap[componentType];
		if ( typeObservers ) {
			typeObservers.remove( observer );
		}
	}

//-------------------------------------------
//  Internals: IEntityObserver
//-------------------------------------------
	
	/** @private
	 * Called direct from the space
	 */
	public function onEntityAdded( entity:Entity ):void {
		entity.addComponentObserver( this );
		
		const components:Dictionary = entity._components;
		for ( var componentType:* in components ) {
			$processAddedComponent( entity, componentType, components[componentType] );
		}
	}
	
	/** @private */
	public function onEntityRemoved( entity:Entity ):void {
		const components:Dictionary = entity._components;
		for ( var componentType:* in components ) {
			$processRemovedComponent( entity, componentType, components[componentType] );
		}
		
		entity.removeComponentObserver( this );
	}

//-------------------------------------------
//  Internals: IComponentObserver
//-------------------------------------------
	
	/** @private */
	public function onComponentAdded( entity:Entity, componentType:Class, component:* ):void {
		$processAddedComponent( entity, componentType, component );
	}
	
	/** @private */
	public function onComponentRemoved( entity:Entity, componentType:Class, component:* ):void {
		$processRemovedComponent( entity, componentType, component );
	}
	
//-------------------------------------------
// Protected
//-------------------------------------------
	
	[Inline]
	protected final function $processAddedComponent( entity:Entity, componentType:Class, component:* ):void {
		use namespace list_internal;
		
		const observers:LinkedSet = observersMap[componentType];
		if ( observers ) {
			for ( var node:LLNodeBase = observers.first; node; node = node.next ) {
				const observer:IComponentObserver = node.item;
				observer.onComponentAdded( entity, componentType, component );
			}
		}
	}
	
	[Inline]
	protected final function $processRemovedComponent( entity:Entity, componentType:Class, component:* ):void {
		use namespace list_internal;
		
		const observers:LinkedSet = observersMap[componentType];
		if ( observers ) {
			for ( var node:LLNodeBase = observers.first; node; node = node.next ) {
				const observer:IComponentObserver = node.item;
				observer.onComponentRemoved( entity, componentType, component );
			}
		}
	}
	
}
}
