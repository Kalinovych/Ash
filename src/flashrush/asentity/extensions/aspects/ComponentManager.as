/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions.aspects {
import flash.utils.Dictionary;

import flashrush.asentity.extensions.aspects.AspectList;

import flashrush.asentity.extensions.aspects.AspectList;

import flashrush.asentity.framework.api.asentity;
import flashrush.asentity.framework.components.api.IComponentHandler;
import flashrush.asentity.framework.entity.Entity;
import flashrush.asentity.framework.entity.api.IEntityHandler;
import flashrush.collections.LLNode;
import flashrush.collections.LinkedSet;

use namespace asentity;

public class ComponentManager implements IEntityHandler, IComponentHandler {
	private var map:Dictionary/*<component:Class, LinkedSet<Entity>  >*/ = new Dictionary();
	
	private var builder:AspectListBuilder = new AspectListBuilder();
	
	public function ComponentManager() {
	}
	
	public function handleEntityAdded( entity:Entity ):void {
		entity.addComponentHandler( this );
		//entity.componentHandler = this;
		
		var components:* = entity._components;
		for ( var componentType:* in components ) {
			onComponentAdded( entity, components[componentType], componentType );
		}
	}
	
	public function handleEntityRemoved( entity:Entity ):void {
		var components:* = entity._components;
		for ( var componentType:* in components ) {
			onComponentRemoved( entity, components[componentType], componentType );
		}
		
		//entity.componentHandler = null;
		entity.removeComponentHandler( this );
	}
	
	public function onComponentAdded( entity:Entity, componentType:Class, component:* ):void {
		var handlerList:LinkedSet = map[component];
		if ( handlerList ) {
			for ( var node:LLNode = handlerList.firstNode; node; node = node.nextNode ) {
				var handler:IComponentHandler = node.item;
				handler.onComponentAdded( entity, componentType, component );
			}
		}
	}
	
	public function onComponentRemoved( entity:Entity, componentType:Class, component:* ):void {
		var handlerList:LinkedSet = map[component];
		if ( handlerList ) {
			for ( var node:LLNode = handlerList.firstNode; node; node = node.nextNode ) {
				var handler:IComponentHandler = node.item;
				handler.onComponentRemoved( entity, componentType, component );
			}
		}
	}
	
	[Inline]
	protected final function _processAddedComponent( entity:Entity, componentType:Class, component:* ):void {
		var aspects:AspectList = map[componentType];
		if ( !aspects ) return;
		
		var aspect:Aspect = new Aspect();
		aspect.entity = entity;
		appendAspectNode( aspects, aspect );
	}
	
	protected function appendAspectNode( list:AspectList, node:Aspect ):void {
		if ( !list.first ) {
			list.first = node;
			list.last = node;
			node.prev = null;
			node.next = null;
		}
		else {
			list.last.next = node;
			node.prev = list.last;
			node.next = null;
			list.last = node;
		}
		list._length++;
		list.addedItems[list.addedItems.length] = node;
		list.OnItemAdded.dispatch( node );
	}
}
}
