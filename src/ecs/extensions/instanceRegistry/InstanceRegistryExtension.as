/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.extensions.instanceRegistry {
import ecs.framework.api.ecs_core;
import ecs.framework.components.api.IComponentHandler;
import ecs.framework.entity.Entity;
import ecs.framework.entity.api.IEntityHandler;
import ecs.framework.systems.api.ISystem;
import ecs.framework.systems.api.ISystemHandler;
import ecs.engine.ESContext;

use namespace ecs_core;

public class InstanceRegistryExtension implements IEntityHandler, IComponentHandler, ISystemHandler {
	protected var instanceRegistry:InstanceRegistry;
	protected var observeComponents:Boolean;
	protected var observeSystems:Boolean;
	protected var observeEntities:Boolean;

	public function InstanceRegistryExtension( observeComponents:Boolean = true, observeSystems:Boolean = true, observeEntities:Boolean = true ) {
		this.observeComponents = observeComponents;
		this.observeSystems = observeSystems;
		this.observeEntities = observeEntities;
	}

	public function extend( context:ESContext ):void {
		if ( !instanceRegistry ) {
			instanceRegistry = new InstanceRegistry();
			context.share( instanceRegistry );
		}

		if ( observeEntities || observeComponents ) {
			context.entities.registerHandler( this );
		}
		if ( observeSystems ) {
			context.systems.registerHandler( this );
		}
	}

	public function onEntityAdded( entity:Entity ):void {
		if ( observeEntities ) {
			instanceRegistry.handleAdded( entity );
		}
		if ( observeComponents ) {
			for each( var component:* in entity._components ) {
				instanceRegistry.handleAdded( component );
			}
		}
	}

	public function onEntityRemoved( entity:Entity ):void {
		if ( observeEntities ) {
			instanceRegistry.handleRemoved( entity );
		}
		if ( observeComponents ) {
			for each( var component:* in entity._components ) {
				instanceRegistry.handleRemoved( component );
			}
		}
	}

	public function onComponentAdded( entity:Entity, componentType:Class, component:* ):void {
		instanceRegistry.handleAdded( component );
	}

	public function onComponentRemoved( entity:Entity, componentType:Class, component:* ):void {
		instanceRegistry.handleRemoved( component );
	}

	public function onSystemAdded( system:ISystem ):void {
		instanceRegistry.handleAdded( system );
	}

	public function onSystemRemoved( system:ISystem ):void {
		instanceRegistry.handleRemoved( system );
	}
}
}
