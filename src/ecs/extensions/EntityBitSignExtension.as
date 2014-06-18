/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.extensions {
import flashrush.signatures.BitSign;
import flashrush.signatures.BitSignManager;

import ecs.engine.components.IComponentObserver;
import ecs.engine.core.ESCtx;
import ecs.framework.api.ecs_core;
import ecs.framework.components.api.IComponentHandler;
import ecs.framework.entity.Entity;
import ecs.framework.entity.api.IEntityHandler;

use namespace ecs_core;

public class EntityBitSignExtension implements IEntityHandler, IComponentHandler,IComponentObserver {
	private var context:ESCtx;
	ecs_core var signManager:BitSignManager;
	ecs_core var signTable:Vector.<BitSign>;

	public function EntityBitSignExtension( context:ESCtx ) {
		this.context = context;
		context.registerHandler( this );

		signManager = new BitSignManager();
		signTable = new Vector.<BitSign>();
	}

	public function handleAddedEntity( entity:Entity ):void {
		var id:uint = entity._id;
		if ( id >= signTable.length ) {
			signTable.length = context.entityList.length;
		}
		signTable[id] = signManager.signKeys( entity._components );
	}

	public function handleRemovedEntity( entity:Entity ):void {
		var sign:BitSign = signTable[entity._id];
		signTable[entity._id] = null;
		signManager.recycleSign( sign );
		
		//entity._sign = null;
	}

	public function onComponentAdded( entity:Entity, componentType:Class, component:* ):void {
	}

	public function onComponentRemoved( entity:Entity, componentType:Class, component:* ):void {
	}

	public function registerHandler( componentType:Class, handler:IComponentHandler ):void {
	}

	public function unregisterHandler( componentType:Class, handler:IComponentHandler ):void {
	}
}
}
