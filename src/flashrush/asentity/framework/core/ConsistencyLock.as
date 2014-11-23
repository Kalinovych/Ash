/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.core {

public class ConsistencyLock {
	private var _isLocked:Boolean = false;
	
	private var unlockCallbacks:Vector.<Function> = new Vector.<Function>( 1e2, true );
	private var cbCount:uint = 0;
	
	public function ConsistencyLock() {}
	
	public final function get isLocked():Boolean {
		return _isLocked;
	}
	
	/** Registers a callback to be executed once when processing unlocks. */
	public function onUnlocks( callback:Function ):void {
		unlockCallbacks[cbCount++] = callback;
	}
	
//-------------------------------------------
// Internals
//-------------------------------------------
	
	internal function lock():void {
		_isLocked = true;
	}
	
	internal function unlock():void {
		_isLocked = false;
		for ( var i:int = 0; i < cbCount; i++ ) {
			unlockCallbacks[i]();
		}
		cbCount = 0;
	}
	
}
}
