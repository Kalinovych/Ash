/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ash.engine.entity {
import ash.core.Entity;
import ash.engine.components.IComponentObserver;
import ash.engine.ecse;

import com.flashrush.signatures.BitSignManager;

use namespace ecse;

public class EntitySigner implements IEntityObserver, IComponentObserver {
	private var mSignManager:BitSignManager;

	public function EntitySigner(signManager:BitSignManager) {
		mSignManager = signManager;
	}

	public function onEntityAdded( entity:Entity ):void {
		entity.sign = mSignManager.signKeys( entity.components );
		//entity.addComponentObserver( this );
	}

	public function onEntityRemoved( entity:Entity ):void {
		//entity.removeComponentObserver( this );
		mSignManager.recycleSign( entity.sign );
		entity.sign = null;
	}

	public function onComponentAdded( entity:Entity, component:*, componentType:* ):void {
		entity.sign.add( componentType );
	}

	public function onComponentRemoved( entity:Entity, component:*, componentType:* ):void {
		entity.sign.remove( componentType );
	}

}
}
