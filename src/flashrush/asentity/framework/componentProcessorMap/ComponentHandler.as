/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.componentProcessorMap {
import flashrush.asentity.framework.componentManager.IComponentHandler;
import flashrush.asentity.framework.components.*;

import flash.utils.Dictionary;

import flashrush.asentity.framework.api.asentity;
import flashrush.asentity.framework.entity.Entity;
import flashrush.asentity.framework.entity.api.IEntityProcessor;
import flashrush.collections.LinkedSet;
import flashrush.collections.base.LLNodeBase;
import flashrush.collections.list_internal;

use namespace asentity;

/**
 * A space entity component notifier
 */
public class ComponentHandler implements IEntityProcessor, IComponentHandler {
	private var _mappings:Dictionary/*<Class, LinkedSet>*/ = new Dictionary();
	
	public function ComponentHandler() {}
	
	public function addMapping( mapping:ComponentProcessorMapping ):void {
		
	}
	
//-------------------------------------------
//  IEntityObserver
//-------------------------------------------
	
	/** @private
	 * Called direct from the space
	 */
	public function processAddedEntity( entity:Entity ):void {
		entity.addComponentHandler( this );
		
		const components:Dictionary = entity._components;
		for ( var componentType:* in components ) {
			$processAddedComponent( entity, componentType, components[componentType] );
		}
	}
	
	/** @private */
	public function processRemovedEntity( entity:Entity ):void {
		const components:Dictionary = entity._components;
		for ( var componentType:* in components ) {
			$processRemovedComponent( entity, componentType, components[componentType] );
		}
		
		entity.removeComponentHandler( this );
	}

//-------------------------------------------
//  ComponentObserver
//-------------------------------------------
	
	/** @private */
	public function handleComponentAdded( entity:Entity, componentType:Class, component:* ):void {
		$processAddedComponent( entity, componentType, component );
	}
	
	/** @private */
	public function handleComponentRemoved( entity:Entity, componentType:Class, component:* ):void {
		$processRemovedComponent( entity, componentType, component );
	}
	
//-------------------------------------------
// Protected
//-------------------------------------------
	
	[Inline]
	protected final function $processAddedComponent( entity:Entity, componentType:Class, component:* ):void {
		/*use namespace list_internal;
		
		const observers:LinkedSet = observersMap[componentType];
		if ( observers ) {
			for ( var node:LLNodeBase = observers.first; node; node = node.next ) {
				const observer:IComponentProcessor = node.item;
				observer.processAddedComponent( entity, componentType, component );
			}
		}*/
	}
	
	[Inline]
	protected final function $processRemovedComponent( entity:Entity, componentType:Class, component:* ):void {
		/*use namespace list_internal;
		
		const observers:LinkedSet = observersMap[componentType];
		if ( observers ) {
			for ( var node:LLNodeBase = observers.first; node; node = node.next ) {
				const observer:IComponentProcessor = node.item;
				observer.processRemovedComponent( entity, componentType, component );
			}
		}*/
	}
	
}
}
