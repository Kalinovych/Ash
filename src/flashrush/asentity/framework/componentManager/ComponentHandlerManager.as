/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.componentManager {
import flash.utils.Dictionary;

import flashrush.asentity.framework.api.asentity;
import flashrush.asentity.framework.components.ComponentHandlerList;
import flashrush.asentity.framework.components.ComponentHandlerNode;
import flashrush.asentity.framework.components.IComponentHandler;
import flashrush.asentity.framework.core.EntitySpace;
import flashrush.asentity.framework.entity.Entity;
import flashrush.collections.LLNode;

use namespace asentity;

/**
 * Helps to subscribe global component handlers directly to all existing entities
 * and auto-subscribe/unsubscribe it to future added.
 */
public class ComponentHandlerManager {
	private var _space:EntitySpace;
	private var _handlers:ComponentHandlerList = new ComponentHandlerList();
	
	public function ComponentHandlerManager( space:EntitySpace ) {
		_space = space;
	}
	
	public function register( handler:IComponentHandler ):void {
		if ( _handlers.add( handler ) ) {
			for ( var entity:Entity = _space.firstEntity; entity; entity = entity.next ) {
				entity.addComponentHandler( handler );
			}
		}
	}
	
	public function unregister( handler:IComponentHandler ):void {
		if ( _handlers.remove( handler ) ) {
			for ( var entity:Entity = _space.firstEntity; entity; entity = entity.next ) {
				entity.removeComponentHandler( handler );
			}
		}
	}
	
	public function unregisterAll():void {
		for ( var entity:Entity = _space.firstEntity; entity; entity = entity.next ) {
			_handlers.forEach( entity.removeComponentHandler );
			/*var node:LLNode = _handlers.firstNode;
			while ( node ) {
				const handler:IComponentHandler = node.item;
				entity.removeComponentHandler( handler );
				node = node.nextNode;
			}*/
		}
		_handlers.removeAll();
	}
	
	public function handleEntityAdded( entity:Entity ):void {
		// register current component handlers in the new entity
		var node:ComponentHandlerNode = _handlers.firstNode;
		while ( node ) {
			entity.addComponentHandler( node.handler );
			node = node.nextNode;
		}
		
		// if the new entity already contains some components
		// notify handlers about each of them
		if ( entity.componentCount > 0 ) {
			const components:Dictionary = entity._components;
			for ( var componentType:* in components ) {
				node = _handlers.firstNode;
				while ( node ) {
					const handler:IComponentHandler = node.handler;
					handler.handleComponentAdded( components[componentType], componentType, entity );
					node = node.nextNode;
				}
			}
		}
	}
	
	public function handleEntityRemoved( entity:Entity ):void {
		// unregister all managed handlers from the removed entity
		var node:ComponentHandlerNode = _handlers.firstNode;
		while ( node ) {
			entity.removeComponentHandler( node.handler );
			node = node.nextNode;
		}
		
		// notify handlers in backward order
		// about each component removed with entity
		const components:Dictionary = entity._components;
		for ( var componentType:* in components ) {
			node = _handlers.lastNode;
			while ( node ) {
				const handler:IComponentHandler = node.handler;
				handler.handleComponentRemoved( components[componentType], componentType, entity );
				node = node.prevNode;
			}
			
		}
	}
	
}
}
