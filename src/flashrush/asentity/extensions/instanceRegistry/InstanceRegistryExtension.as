/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions.instanceRegistry {
import ecs.engine.ESContext;

import flashrush.asentity.framework.api.asentity;
import flashrush.asentity.framework.components.api.IComponentHandler;
import flashrush.asentity.framework.entity.Entity;
import flashrush.asentity.framework.entity.api.IEntityHandler;
import flashrush.asentity.framework.systems.api.ISystem;
import flashrush.asentity.framework.systems.api.ISystemHandler;

use namespace asentity;

public class InstanceRegistryExtension implements IEntityHandler, IComponentHandler, ISystemHandler {
	asentity var instanceRegistry:InstanceRegistry;
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

	public function handleEntityAdded( entity:Entity ):void {
		if ( observeEntities ) {
			instanceRegistry.handleAdded( entity );
		}
		if ( observeComponents ) {
			for each( var component:* in entity._components ) {
				instanceRegistry.handleAdded( component );
			}
		}
	}

	public function handleEntityRemoved( entity:Entity ):void {
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
