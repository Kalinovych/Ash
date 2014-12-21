/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions.componentHandlerMap {
import flash.utils.Dictionary;

import flashrush.asentity.framework.components.ComponentHandlerList;
import flashrush.asentity.framework.components.ComponentHandlerNode;
import flashrush.asentity.framework.components.IComponentHandler;
import flashrush.asentity.framework.entity.Entity;

public class ComponentHandlerProcessor implements IComponentHandler {
	private var _handlers:Dictionary = new Dictionary();
	
	public function ComponentHandlerProcessor() {}
	
	public function getHandlerStoreFor( type:Class ):ComponentHandlerList {
		return _handlers[type] || createList( type );
	}
	
	public function handleComponentAdded( component:*, componentType:Class, entity:Entity ):void {
		const handlers:ComponentHandlerList = _handlers[componentType];
		if ( handlers ) {
			for ( var node:ComponentHandlerNode = handlers.firstNode; node; node = node.next ) {
				node.handler.handleComponentAdded( component, componentType, entity );
			}
		}
	}
	
	public function handleComponentRemoved( component:*, componentType:Class, entity:Entity ):void {
		const handlers:ComponentHandlerList = _handlers[componentType];
		if ( handlers ) {
			for ( var node:ComponentHandlerNode = handlers.firstNode; node; node = node.next ) {
				node.handler.handleComponentRemoved( component, componentType, entity );
			}
		}
	}
	
	//-------------------------------------------
	// Private
	//-------------------------------------------
	
	private function createList( type:Class ):ComponentHandlerList {
		const list:ComponentHandlerList = new ComponentHandlerList();
		_handlers[type] = list;
		return list;
	}
}
}
