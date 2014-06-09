/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.engine.core {
import ecs.engine.core.api.IUnitObserver;
import ecs.framework.api.ecs_core;

public class UnitsCore extends ESUnitList{
	//ecs_core var units:ESUnitList = new ESUnitList();
	protected var observers:Vector.<IUnitObserver> = new Vector.<IUnitObserver>();

	public function attach( unit:ESUnit ):void {
		super.attach( unit );
		var len:uint = observers.length;
		var i:uint;
		for ( i = 0; i < len; i++ ) {
			observers[i].unitAdded( unit );
		}
	}

	public function detach( unit:ESUnit ):void {
		super.detach( unit );
		var i:uint = observers.length;
		while ( i > 0 ) {
			i--;
			observers[i].unitRemoved( unit );
		}
	}

	public function detachAll():void {
		while ( super.first ) {
			detach( super.first );
		}
	}

	/*public function notifyAdded( unit:ESUnit ):void {
		var len:uint = observers.length;
		var i:uint;
		for ( i = 0; i < len; i++ ) {
			observers[i].unitAdded( unit );
		}
	}

	public function notifyRemoved( unit:ESUnit ):void {
		var len:uint = observers.length;
		var i:uint;
		for ( i = 0; i < len; i++ ) {
			observers[i].unitRemoved( unit );
		}
	}*/

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
