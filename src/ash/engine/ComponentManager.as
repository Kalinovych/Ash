/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ash.engine {
import ash.core.Entity;
import ash.engine.components.*;
import ash.engine.entity.EntityManager;
import ash.engine.entity.IEntityObserver;
import ash.engine.lists.LinkedHashSet;

import flash.utils.Dictionary;

use namespace ecse;

/**
 * Groups entities by a component type
 * and allows to engine to retrieve an entities that is holds required component
 */
public class ComponentManager implements IEntityObserver, IComponentObserver {
	private var entitiesByComponent:Dictionary/*<LinkedHashSet>*/ = new Dictionary();
	private var entityManager:EntityManager;

	public function ComponentManager( entityManager:EntityManager ) {
		this.entityManager = entityManager;
		entityManager.addObserver( this );
	}

	public function dispose():void {
		// TODO: implement dispose
	}
	
	public function getEntities( componentType:Class ):LinkedHashSet {
		return entitiesByComponent[componentType];
	}

	/**
	 * @private
	 */
	public function onEntityAdded( entity:Entity ):void {
		entity.addComponentObserver( this );

		var components:* = entity.ecse::components;
		for ( var componentType:* in components ) {
			var component:* = components[componentType];
			onComponentAdded( entity, component, componentType );
		}
	}

	/**
	 * @private
	 */
	public function onEntityRemoved( entity:Entity ):void {
		var components:* = entity.ecse::components;
		for ( var componentType:* in components ) {
			var component:* = components[componentType];
			onComponentRemoved( entity, component, componentType );
		}

		entity.removeComponentObserver( this );
	}

	/**
	 * @private
	 */
	public function onComponentAdded( entity:Entity, component:*, componentType:* ):void {
		var entities:LinkedHashSet = entitiesByComponent[componentType];
		if ( !entities ) {
			entities = new LinkedHashSet();
		}
		entities.add( entity );
	}

	/**
	 * @private
	 */
	public function onComponentRemoved( entity:Entity, component:*, componentType:* ):void {
		var entities:LinkedHashSet = entitiesByComponent[componentType];
		entities.remove( entity );
	}

}
}
