/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine {
import ashx.engine.entity.Entity;

import ashx.engine.api.IEntityFamiliesManager;
import ashx.engine.components.*;
import ashx.engine.entity.IEntityObserver;
import ashx.engine.lists.EntityNodeList;
import ashx.engine.lists.LinkedHashSet;

import flash.utils.Dictionary;

use namespace ecse;

/**
 * Groups entities by a component type
 * and allows to engine to retrieve an entities that is holds required component
 */
public class ComponentManager implements IEntityFamiliesManager, IEntityObserver, IComponentHandler {

	protected var entitySetByComponent:Dictionary/*<LinkedHashSet>*/ = new Dictionary();

	public function ComponentManager() {
	}

	public function getEntitiesWith( componentType:Class ):LinkedHashSet {
		return entitySetByComponent[componentType];
	}

	public function getEntities( familyIdentifier:Class ):EntityNodeList {
		return entitySetByComponent[familyIdentifier];
	}
	
	public function dispose():void {
		entitySetByComponent = null;
	}

	/**
	 * @private
	 */
	public function onEntityAdded( entity:Entity ):void {
		entity.addComponentHandler( this );

		var components:* = entity.ecse::components;
		for ( var componentType:* in components ) {
			//var component:* = components[componentType];
			//onComponentAdded( entity, component, componentType );
			mapEntityToComponent( componentType, entity );
		}
	}

	/**
	 * @private
	 */
	public function onEntityRemoved( entity:Entity ):void {
		var components:* = entity.ecse::components;
		for ( var componentType:* in components ) {
			//var component:* = components[componentType];
			//onComponentRemoved( entity, component, componentType );
			unmapEntityFromComponent( componentType, entity );
		}

		entity.removeComponentHandler( this );
	}

	/**
	 * @private
	 */
	public function onComponentAdded( entity:Entity, component:*, componentType:* ):void {
		mapEntityToComponent( componentType, entity );
	}

	/**
	 * @private
	 */
	public function onComponentRemoved( entity:Entity, component:*, componentType:* ):void {
		unmapEntityFromComponent( componentType, entity );
	}

	protected function mapEntityToComponent( componentType:*, entity:Entity ):void {
		var entities:LinkedHashSet = entitySetByComponent[componentType];
		if ( !entities ) {
			entities = new LinkedHashSet();
			entitySetByComponent[componentType] = entities;
		}
		entities.add( entity );
	}

	protected function unmapEntityFromComponent( componentType:*, entity:Entity ):void {
		var entities:LinkedHashSet = entitySetByComponent[componentType];
		if ( entities ) {
			entities.remove( entity );
		}
	}

}
}
