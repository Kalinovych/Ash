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
 * A space entity component notifier
 */
public class ComponentManager implements IComponentNotifier, IEntityObserver, IComponentObserver {
	private var observersMap:Dictionary/*<Class, LinkedSet>*/ = new Dictionary();
	
	public function ComponentManager() {}

//-------------------------------------------
// IComponentNotifier methods
//-------------------------------------------
	
	public function addObserver( componentType:Class, observer:IComponentObserver ):void {
		var componentObservers:LinkedSet = observersMap[componentType];
		if ( !componentObservers ) {
			componentObservers = new LinkedSet();
			observersMap[componentType] = componentObservers;
		}
		componentObservers.add( observer );
	}
	
	public function removeObserver( componentType:Class, observer:IComponentObserver ):void {
		var componentObservers:LinkedSet = observersMap[componentType];
		if ( componentObservers ) {
			componentObservers.remove( observer );
		}
	}

//-------------------------------------------
//  Internals: IEntityObserver
//-------------------------------------------
	
	/** @private */
	public function onEntityAdded( entity:Entity ):void {
		entity.addComponentObserver( this );
		
		const components:Dictionary = entity._components;
		for ( var componentType:* in components ) {
			$processComponentAdded( entity, componentType, components[componentType] );
		}
	}
	
	/** @private */
	public function onEntityRemoved( entity:Entity ):void {
		const components:Dictionary = entity._components;
		for ( var componentType:* in components ) {
			$processComponentRemoved( entity, componentType, components[componentType] );
		}
		
		entity.removeComponentObserver( this );
	}

//-------------------------------------------
//  Internals: IComponentObserver
//-------------------------------------------
	
	/** @private */
	public function onComponentAdded( entity:Entity, componentType:Class, component:* ):void {
		$processComponentAdded( entity, componentType, component );
		/*use namespace list_internal;
		
		const observers:LinkedSet = observersMap[componentType];
		if ( observers ) {
			for ( var node:LLNodeBase = observers.first; node; node = node.next ) {
				const observer:IComponentObserver = node.item;
				observer.onComponentAdded( entity, componentType, component );
			}
		}*/
	}
	
	/** @private */
	public function onComponentRemoved( entity:Entity, componentType:Class, component:* ):void {
		$processComponentRemoved( entity, componentType, component );
		/*use namespace list_internal;
		
		const observers:LinkedSet = observersMap[componentType];
		if ( observers ) {
			for ( var node:LLNodeBase = observers.first; node; node = node.next ) {
				const observer:IComponentObserver = node.item;
				observer.onComponentRemoved( entity, componentType, component );
			}
		}*/
	}
	
	//-------------------------------------------
	// Protected
	//-------------------------------------------
	
	[Inline]
	protected final function $processComponentAdded( entity:Entity, componentType:Class, component:* ):void {
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
	protected final function $processComponentRemoved( entity:Entity, componentType:Class, component:* ):void {
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
