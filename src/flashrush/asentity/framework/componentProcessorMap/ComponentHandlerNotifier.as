/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.componentProcessorMap {
import flash.utils.Dictionary;

import flashrush.asentity.framework.componentManager.IComponentHandler;
import flashrush.asentity.framework.entity.Entity;
import flashrush.collections.LLNode;

import flashrush.collections.LinkedSet;

public class ComponentHandlerNotifier implements IComponentHandler {
	private var _mappings:Dictionary = new Dictionary();
	
	public function ComponentHandlerNotifier() {
	}
	
	public function addMapping( mapping:ComponentHandlerMapping ):void {
		var list:LinkedSet = _mappings[mapping.componentType] ||= new LinkedSet();
		list.add( mapping );
	}
	
	public function handleComponentAdded( entity:Entity, componentType:Class, component:* ):void {
		var handlerMappings:LinkedSet = _mappings[componentType];
		if (handlerMappings) {
			for (var node:LLNode = handlerMappings.firstNode; node; node = node.nextNode) {
				var mapping:ComponentHandlerMapping = node.item;
				mapping.handler.handleComponentAdded( entity, componentType, component );
			}
		}
	}
	
	public function handleComponentRemoved( entity:Entity, componentType:Class, component:* ):void {
	}
}
}
