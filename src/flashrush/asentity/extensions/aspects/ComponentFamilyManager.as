/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions.aspects {
import flash.utils.Dictionary;

import flashrush.asentity.framework.api.asentity;
import flashrush.asentity.framework.core.IComponentObserver;
import flashrush.asentity.framework.entity.Entity;
import flashrush.asentity.framework.entity.api.IEntityObserver;
import flashrush.collections.LLNode;
import flashrush.collections.LinkedSet;

use namespace asentity;

public class ComponentFamilyManager implements IEntityObserver, IComponentObserver {
	private var familyByType:Dictionary/*<aspectType:Class, LinkedSet<Entity>  >*/ = new Dictionary();
	
	public function ComponentFamilyManager() {}
	
	public function onComponentAdded( entity:Entity, componentType:Class, component:* ):void {
		var handlerList:LinkedSet = familyByType[component];
		if ( handlerList ) {
			for ( var node:LLNode = handlerList.firstNode; node; node = node.nextNode ) {
				var handler:IComponentObserver = node.item;
				handler.onComponentAdded( entity, componentType, component );
			}
		}
	}
	
	public function onComponentRemoved( entity:Entity, componentType:Class, component:* ):void {
		var handlerList:LinkedSet = familyByType[component];
		if ( handlerList ) {
			for ( var node:LLNode = handlerList.firstNode; node; node = node.nextNode ) {
				var handler:IComponentObserver = node.item;
				handler.onComponentRemoved( entity, componentType, component );
			}
		}
	}
	
	public function onEntityAdded( entity:Entity ):void {
		entity.addComponentObserver( this );
		
		const components:* = entity._components;
		for ( var componentType:* in components ) {
			onComponentAdded( entity, components[componentType], componentType );
		}
	}
	
	public function onEntityRemoved( entity:Entity ):void {
		const components:* = entity._components;
		for ( var componentType:* in components ) {
			onComponentRemoved( entity, components[componentType], componentType );
		}
		
		//entity.componentHandler = null;
		entity.removeComponentObserver( this );
	}
	
	[Inline]
	protected final function _processAddedComponent( entity:Entity, componentType:Class, component:* ):void {
		var family:AspectList = familyByType[componentType];
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
