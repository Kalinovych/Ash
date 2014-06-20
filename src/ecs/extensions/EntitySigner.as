/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.extensions {
import ecs.framework.api.ecs_core;
import ecs.framework.components.api.IComponentHandler;
import ecs.framework.entity.Entity;
import ecs.framework.entity.api.IEntityHandler;

import flashrush.signatures.api.ISignature;

import flashrush.signatures.api.ISigner;
import flashrush.signatures.bitwise.BitwiseSigner;

use namespace ecs_core;

public class EntitySigner implements IEntityHandler, IComponentHandler {
	ecs_core var signer:ISigner;
	/** Signature by an Entity id */
	ecs_core var signatures:Vector.<ISignature>;

	public function EntitySigner( signer:ISigner = null ) {
		this.signer = signer || new BitwiseSigner();
	}

	public function handleEntityAdded( entity:Entity ):void {
		entity._sign = signer.signKeys( entity._components );
		/*var id:uint = entity._id;
		if ( id >= signTable.length ) {
			signTable.length = context.entityList.length;
		}
		signTable[id] = signManager.signKeys( entity._components );*/
	}

	public function handleEntityRemoved( entity:Entity ):void {
		signer.disposeSign( entity._sign );
		entity._sign = null;
		/*var sign:BitSign = signTable[entity._id];
		signTable[entity._id] = null;
		signManager.recycleSign( sign );*/

		//entity._sign = null;
	}

	public function onComponentAdded( entity:Entity, componentType:Class, component:* ):void {
		signer.includeTo( componentType, entity._sign );
	}

	public function onComponentRemoved( entity:Entity, componentType:Class, component:* ):void {
		signer.excludeFrom( componentType, entity._sign );
	}
}
}
