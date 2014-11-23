/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions.instanceRegistry {
import ecs.engine.core.ESContext;

import flashrush.asentity.framework.api.asentity;
import flashrush.asentity.framework.components.IComponentProcessor;
import flashrush.asentity.framework.entity.Entity;
import flashrush.asentity.framework.entity.api.IEntityHandler;
import flashrush.asentity.framework.systems.api.ISystem;
import flashrush.asentity.framework.systems.api.ISystemHandler;

use namespace asentity;

public class InstanceRegistryExtension implements IEntityHandler, IComponentProcessor, ISystemHandler {
	asentity var registry:InstanceRegistry;
	protected var observeComponents:Boolean;
	protected var observeSystems:Boolean;
	protected var observeEntities:Boolean;

	public function InstanceRegistryExtension( observeComponents:Boolean = true, observeSystems:Boolean = true, observeEntities:Boolean = true ) {
		this.observeComponents = observeComponents;
		this.observeSystems = observeSystems;
		this.observeEntities = observeEntities;
	}

	public function extend( context:ESContext ):void {
		if ( !registry ) {
			registry = new InstanceRegistry();
			context.share( registry );
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
			registry.handleAdded( entity );
		}
		if ( observeComponents ) {
			for each( var component:* in entity._components ) {
				registry.handleAdded( component );
			}
		}
	}

	public function handleEntityRemoved( entity:Entity ):void {
		if ( observeEntities ) {
			registry.handleRemoved( entity );
		}
		if ( observeComponents ) {
			for each( var component:* in entity._components ) {
				registry.handleRemoved( component );
			}
		}
	}

	public function processAddedComponent( entity:Entity, componentType:Class, component:* ):void {
		registry.handleAdded( component );
	}

	public function processRemovedComponent( entity:Entity, componentType:Class, component:* ):void {
		registry.handleRemoved( component );
	}

	public function onSystemAdded( system:ISystem ):void {
		registry.handleAdded( system );
	}

	public function onSystemRemoved( system:ISystem ):void {
		registry.handleRemoved( system );
	}
}
}
