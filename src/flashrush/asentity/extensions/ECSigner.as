/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions {
import flashrush.asentity.framework.api.asentity;
import flashrush.asentity.framework.core.IComponentObserver;
import flashrush.asentity.framework.entity.Entity;
import flashrush.asentity.framework.entity.api.IEntityObserver;
import flashrush.signatures.api.ISignature;
import flashrush.signatures.api.ISigner;
import flashrush.signatures.bitwise.BitwiseSigner;

use namespace asentity;

public class ECSigner implements IEntityObserver, IComponentObserver {
	asentity var signer:ISigner;
	/** Signature by an Entity id */
	asentity var signatures:Vector.<ISignature>;

	public function ECSigner( signer:ISigner = null ) {
		this.signer = signer || new BitwiseSigner();
	}

	public function onEntityAdded( entity:Entity ):void {
		entity._sign = signer.signKeys( entity._components );
		/*var id:uint = entity._id;
		if ( id >= signTable.length ) {
			signTable.length = context.entityList.length;
		}
		signTable[id] = signManager.signKeys( entity._components );*/
	}

	public function onEntityRemoved( entity:Entity ):void {
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
