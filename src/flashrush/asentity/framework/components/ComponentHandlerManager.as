/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.components {
import flash.utils.Dictionary;

import flashrush.asentity.framework.api.asentity;
import flashrush.asentity.framework.core.EntitySpace;
import flashrush.asentity.framework.entity.Entity;

use namespace asentity;

/**
 * Helps to subscribe component handlers directly to each existing entity
 * and auto-subscribe/unsubscribe to each added/removed entity.
 */
public class ComponentHandlerManager implements IComponentHandlerManager {
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
		// add registered handlers to the new entity
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
					node.handler.handleComponentAdded( components[componentType], componentType, entity );
					node = node.nextNode;
				}
			}
		}
	}
	
	public function handleEntityRemoved( entity:Entity ):void {
		var node:ComponentHandlerNode;
		
		// notify handlers in backward order
		// about each component removed with entity
		const components:Dictionary = entity._components;
		for ( var componentType:* in components ) {
			node = _handlers.lastNode;
			while ( node ) {
				node.handler.handleComponentRemoved( components[componentType], componentType, entity );
				node = node.prevNode;
			}
			
		}
		
		// remove registered handlers from the removed entity
		node = _handlers.firstNode;
		while ( node ) {
			entity.removeComponentHandler( node.handler );
			node = node.nextNode;
		}
		
	}
	
}
}
