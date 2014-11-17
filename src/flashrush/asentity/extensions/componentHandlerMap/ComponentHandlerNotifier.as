/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions.componentHandlerMap {
import flash.utils.Dictionary;

import flashrush.asentity.extensions.componentHandlerMap.api.IComponentHandlerMapping;
import flashrush.asentity.framework.componentManager.IComponentHandler;
import flashrush.asentity.framework.entity.Entity;
import flashrush.collections.LinkedSet;
import flashrush.collections.base.LLNodeBase;
import flashrush.collections.list_internal;

public class ComponentHandlerNotifier implements IComponentHandler {
	private var _mappings:Dictionary = new Dictionary();
	
	public function ComponentHandlerNotifier() {
	}
	
	public function addMapping( mapping:IComponentHandlerMapping ):void {
		var handlerMappings:LinkedSet = (_mappings[mapping.componentType] ||= new LinkedSet());
		handlerMappings.add( mapping );
	}
	
	public function removeMapping( mapping:IComponentHandlerMapping ):void {
		var handlerMappings:LinkedSet = _mappings[mapping.componentType];
		handlerMappings && handlerMappings.remove( mapping );
	}
	
	public function handleComponentAdded( entity:Entity, componentType:Class, component:* ):void {
		use namespace list_internal;
		
		var handlerMappings:LinkedSet = _mappings[componentType];
		if ( handlerMappings ) {
			for ( var node:LLNodeBase = handlerMappings.first; node; node = node.next ) {
				var mapping:IComponentHandlerMapping = node.item;
				mapping.handler.handleComponentAdded( entity, componentType, component );
			}
		}
	}
	
	public function handleComponentRemoved( entity:Entity, componentType:Class, component:* ):void {
		use namespace list_internal;
		
		var handlerMappings:LinkedSet = _mappings[componentType];
		if ( handlerMappings ) {
			for ( var node:LLNodeBase = handlerMappings.first; node; node = node.next ) {
				var mapping:IComponentHandlerMapping = node.item;
				mapping.handler.handleComponentRemoved( entity, componentType, component );
			}
		}
	}
}
}
