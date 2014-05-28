/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.extensions.instanceManager {
import ashx.engine.api.ecse;
import ashx.engine.components.api.IComponentHandler;
import ashx.engine.entity.Entity;
import ashx.engine.entity.api.IEntityHandler;
import ashx.engine.systems.api.ISystem;
import ashx.engine.systems.api.ISystemHandler;
import ashx.framework.ESContext;

use namespace ecse;

public class InstanceManagerExtension implements IEntityHandler, IComponentHandler, ISystemHandler {
	protected var instanceManager:InstanceManager;
	protected var observeComponents:Boolean;
	protected var observeSystems:Boolean;
	protected var observeEntities:Boolean;

	public function InstanceManagerExtension( observeComponents:Boolean = true, observeSystems:Boolean = true, observeEntities:Boolean = true ) {
		this.observeComponents = observeComponents;
		this.observeSystems = observeSystems;
		this.observeEntities = observeEntities;
	}

	public function extend( context:ESContext ):void {
		if ( !instanceManager ) {
			instanceManager = new InstanceManager();
			context.share( instanceManager );
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
			instanceManager.handleAdded( entity );
		}
		if ( observeComponents ) {
			for each( var component:* in entity.components ) {
				instanceManager.handleAdded( component );
			}
		}
	}

	public function onEntityRemoved( entity:Entity ):void {
		if ( observeEntities ) {
			instanceManager.handleRemoved( entity );
		}
		if ( observeComponents ) {
			for each( var component:* in entity.components ) {
				instanceManager.handleRemoved( component );
			}
		}
	}

	public function onComponentAdded( entity:Entity, componentType:Class, component:* ):void {
		instanceManager.handleAdded( component );
	}

	public function onComponentRemoved( entity:Entity, componentType:Class, component:* ):void {
		instanceManager.handleRemoved( component );
	}

	public function onSystemAdded( system:ISystem ):void {
		instanceManager.handleAdded( system );
	}

	public function onSystemRemoved( system:ISystem ):void {
		instanceManager.handleRemoved( system );
	}
}
}
