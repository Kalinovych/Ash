/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.engine.core {
import ecs.engine.core.api.IUnitObserver;
import ecs.framework.api.ecs_core;

use namespace ecs_core;

public class ESCore {
	ecs_core var units:CoreUnitList = new CoreUnitList();
	ecs_core var observers:Vector.<IUnitObserver> = new Vector.<IUnitObserver>();
	
	public function attach( unit:CoreUnit ):void {
		units.attach( unit );
		var len:uint = observers.length;
		var i:uint;
		for ( i = 0; i < len; i++ ) {
			observers[i].unitAdded( unit );
		}
	}

	public function detach( unit:CoreUnit ):void {
		units.detach( unit );
		var i:uint = observers.length;
		while ( i > 0 ) {
			i--;
			observers[i].unitRemoved( unit );
		}
	}

	public function register( observer:IUnitObserver ):void {
		if ( observers.indexOf( observer ) < 0 ) {
			observers[observers.length] = observer;
		}
	}

	public function unRegister( observer:IUnitObserver ):void {
		var index:int = observers.indexOf( observer );
		if ( index >= 0 ) {
			observers.splice( index, 1 );
		}
	}
}
}
