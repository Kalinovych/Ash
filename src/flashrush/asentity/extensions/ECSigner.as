/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions {
import flashrush.asentity.framework.api.asentity;
import flashrush.asentity.framework.core.IComponentObserver;
import flashrush.asentity.framework.entity.Entity;
import flashrush.asentity.framework.entity.api.IEntityObserver;
import flashrush.asentity.framework.utils.BitVec;
import flashrush.asentity.framework.utils.ObjectIndexer;
import flashrush.signatures.api.ISigner;
import flashrush.signatures.bitwise.BitwiseSigner;

use namespace asentity;

public class ECSigner implements IEntityObserver, IComponentObserver {
	
	private var indexMap:ObjectIndexer = new ObjectIndexer();
	
	asentity var signer:ISigner;

	public function ECSigner( signer:ISigner = null ) {
		//this.signer = signer || new BitwiseSigner();
	}

	public function onEntityAdded( entity:Entity ):void {
		//entity.sign = signer.signKeys( entity._components );
	}

	public function onEntityRemoved( entity:Entity ):void {
		//signer.disposeSign( entity.sign );
		entity.componentBits = null;
	}

	public function onComponentAdded( entity:Entity, componentType:Class, component:* ):void {
		//signer.includeTo( componentType, entity.sign );
	}

	public function onComponentRemoved( entity:Entity, componentType:Class, component:* ):void {
		//signer.excludeFrom( componentType, entity.sign );
	}
	
}
}
