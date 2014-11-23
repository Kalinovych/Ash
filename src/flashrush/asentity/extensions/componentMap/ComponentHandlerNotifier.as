/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions.componentMap {
import flash.utils.Dictionary;

import flashrush.asentity.extensions.componentMap.api.IComponentHandlerMapping;
import flashrush.asentity.framework.componentManager.IComponentHandler;
import flashrush.asentity.framework.entity.Entity;
import flashrush.collections.LinkedNodeList;
import flashrush.collections.list_internal;

public class ComponentHandlerNotifier implements IComponentHandler {
	private var _mappings:Dictionary = new Dictionary();
	
	public function ComponentHandlerNotifier() {}
	
	public function addMapping( mapping:IComponentHandlerMapping ):void {
		var handlerMappings:LinkedNodeList = (_mappings[mapping.componentType] ||= new LinkedNodeList());
		handlerMappings.add( mapping );
	}
	
	public function removeMapping( mapping:IComponentHandlerMapping ):void {
		var handlerMappings:LinkedNodeList = _mappings[mapping.componentType];
		handlerMappings && handlerMappings.remove( mapping );
	}
	
	public function handleComponentAdded( entity:Entity, componentType:Class, component:* ):void {
		use namespace list_internal;
		
		var handlerMappings:LinkedNodeList = _mappings[componentType];
		if ( handlerMappings ) {
			for ( var mapping:ComponentHandlerMapping = handlerMappings.first; mapping; mapping = mapping.next ) {
				mapping.handler.handleComponentAdded( entity, componentType, component );
			}
		}
	}
	
	public function handleComponentRemoved( entity:Entity, componentType:Class, component:* ):void {
		use namespace list_internal;
		
		var handlerMappings:LinkedNodeList = _mappings[componentType];
		if ( handlerMappings ) {
			for ( var mapping:ComponentHandlerMapping = handlerMappings.first; mapping; mapping = mapping.next ) {
				mapping.handler.handleComponentRemoved( entity, componentType, component );
			}
		}
	}
}
}
