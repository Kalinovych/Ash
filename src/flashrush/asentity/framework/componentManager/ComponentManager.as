/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.componentManager {
import flash.utils.Dictionary;

import flashrush.asentity.framework.api.asentity;
import flashrush.asentity.framework.core.EntitySpace;
import flashrush.asentity.framework.entity.Entity;
import flashrush.collections.LinkedSet;
import flashrush.collections.base.LLNodeBase;
import flashrush.collections.list_internal;

use namespace asentity;

/**
 * A space entity component notifier
 */
public class ComponentManager {
	private var _space:EntitySpace;
	private var _handlers:LinkedSet = new LinkedSet();
	
	public function ComponentManager( space:EntitySpace ) {
		_space = space;
	}
	
	public function addEntity( entity:Entity ):void {
		_space.add( entity );
		
		use namespace list_internal;
		
		var node:LLNodeBase;
		var handler:IComponentHandler;
		
		for ( node = _handlers.first; node; node = node.next ) {
			handler = node.item;
			entity.addComponentHandler( handler );
		}
		
		if ( entity.componentCount > 0 ) {
			const components:Dictionary = entity._components;
			for ( var componentType:* in components ) {
				for ( node = _handlers.first; node; node = node.next ) {
					handler = node.item;
					handler.handleComponentAdded( entity, componentType, components[componentType] );
				}
			}
		}
	}
	
	public function removeEntity( entity:Entity ):void {
		_space.remove( entity );
		
		use namespace list_internal;
		
		var node:LLNodeBase;
		var handler:IComponentHandler;
		
		for ( node = _handlers.first; node; node = node.next ) {
			handler = node.item;
			entity.removeComponentHandler( handler );
		}
		
		const components:Dictionary = entity._components;
		for ( var componentType:* in components ) {
			for ( node = _handlers.first; node; node = node.next ) {
				handler = node.item;
				handler.handleComponentRemoved( entity, componentType, components[componentType] );
			}
		}
	}
	
	public function addComponentHandler( handler:IComponentHandler ):void {
		_handlers.add( handler );
		for ( var entity:Entity = _space.firstEntity; entity; entity = entity.next ) {
			entity.addComponentHandler( handler );
		}
	}
	
	public function removeComponentHandler( handler:IComponentHandler ):void {
		_handlers.remove( handler );
		for ( var entity:Entity = _space.firstEntity; entity; entity = entity.next ) {
			entity.removeComponentHandler( handler );
		}
	}
	
	public function removeAllHandlers():void {
		for ( var entity:Entity = _space.firstEntity; entity; entity = entity.next ) {
			_handlers.forEach( entity.removeComponentHandler );
		}
		_handlers.removeAll();
	}
}
}
