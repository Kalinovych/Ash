/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.componentManager {
import flash.utils.Dictionary;

import flashrush.asentity.framework.api.asentity;
import flashrush.asentity.framework.components.ComponentHandlerList;
import flashrush.asentity.framework.components.IComponentHandler;
import flashrush.asentity.framework.entity.Entity;
import flashrush.asentity.framework.entity.api.IEntityHandler;
import flashrush.collections.LLNode;

use namespace asentity;

/**
 * Handles added/removed entities and register/unregister handlers from it.
 */
internal class ComponentHandlerEntityHandler implements IEntityHandler {
	private var _handlers:ComponentHandlerList;
	
	public function ComponentHandlerEntityHandler( handlers:ComponentHandlerList ) {
		_handlers = handlers;
	}
	
	public function handleEntityAdded( entity:Entity ):void {
		// register current component handlers in the new entity
		var node:LLNode = _handlers.firstNode;
		while ( node ) {
			entity.addComponentHandler( node.item );
			node = node.nextNode;
		}
		
		// if the new entity already contains some components
		// notify handlers about each of them
		if ( entity.componentCount > 0 ) {
			const components:Dictionary = entity._components;
			for ( var componentType:* in components ) {
				node = _handlers.firstNode;
				while ( node ) {
					const handler:IComponentHandler = node.item;
					handler.handleComponentAdded( components[componentType], componentType, entity );
					node = node.nextNode;
				}
				
			}
		}
	}
	
	public function handleEntityRemoved( entity:Entity ):void {
		// unregister all managed handlers from the removed entity
		var node:LLNode = _handlers.firstNode;
		while ( node ) {
			entity.removeComponentHandler( node.item );
			node = node.nextNode;
		}
		
		// notify handlers in backward order
		// about each component removed with entity
		const components:Dictionary = entity._components;
		for ( var componentType:* in components ) {
			node = _handlers.lastNode;
			while ( node ) {
				const handler:IComponentHandler = node.item;
				handler.handleComponentRemoved( components[componentType], componentType, entity );
				node = node.prevNode;
			}
			
		}
	}
	
}
}
