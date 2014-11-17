/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions.aspects {
import flash.utils.Dictionary;

import flashrush.asentity.framework.api.asentity;
import flashrush.asentity.framework.components.IComponentProcessor;
import flashrush.asentity.framework.entity.Entity;
import flashrush.asentity.framework.entity.api.IEntityProcessor;
import flashrush.collections.LLNode;
import flashrush.collections.LinkedSet;

use namespace asentity;

public class ComponentFamilyManager implements IEntityProcessor, IComponentProcessor {
	private var familiesByType:Dictionary/*<aspectType:Class, LinkedSet<Entity>  >*/ = new Dictionary();
	
	public function ComponentFamilyManager() {}
	
	public function processAddedEntity( entity:Entity ):void {
		entity.addComponentHandler( this );
		
		const components:* = entity._components;
		for ( var componentType:* in components ) {
			processAddedComponent( entity, componentType, components[componentType] );
		}
	}
	
	public function processRemovedEntity( entity:Entity ):void {
		const components:* = entity._components;
		for ( var componentType:* in components ) {
			processRemovedComponent( entity, componentType, components[componentType] );
		}
		
		entity.removeComponentHandler( this );
	}
	
	public function processAddedComponent( entity:Entity, componentType:Class, component:* ):void {
		var handlerList:LinkedSet = familiesByType[componentType];
		if ( handlerList ) {
			for ( var node:LLNode = handlerList.firstNode; node; node = node.nextNode ) {
				var handler:IComponentProcessor = node.item;
				handler.processAddedComponent( entity, componentType, component );
			}
		}
	}
	
	public function processRemovedComponent( entity:Entity, componentType:Class, component:* ):void {
		var handlerList:LinkedSet = familiesByType[componentType];
		if ( handlerList ) {
			for ( var node:LLNode = handlerList.firstNode; node; node = node.nextNode ) {
				var handler:IComponentProcessor = node.item;
				handler.processRemovedComponent( entity, componentType, component );
			}
		}
	}

//-------------------------------------------
// Internals
//-------------------------------------------
	
	[Inline]
	protected final function _processAddedComponent( entity:Entity, componentType:Class, component:* ):void {
		var family:AspectList = familiesByType[componentType];
		if ( !family ) return;
		
		var aspect:Aspect = new Aspect();
		aspect.entity = entity;
		family.add( aspect );
	}
	
	/*protected function appendAspectNode( list:AspectList, node:Aspect ):void {
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
	}*/
}
}
