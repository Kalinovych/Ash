/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.core {

public class ConsistencyLock {
	public var isLocked:Boolean = false;
	
	private var unlockCallbacks:Vector.<Function> = new Vector.<Function>( 1e3, true );
	private var cbCount:uint = 0;
	
	public function ConsistencyLock() {}
	
	/** Registers a callback to be executed once when processing unlocks. */
	public function onUnlocks( callback:Function ):void {
		unlockCallbacks[cbCount++] = callback;
	}
	
	//-------------------------------------------
	// Internals
	//-------------------------------------------
	
	internal function lock():void {
		isLocked = true;
	}
	
	internal function unlock():void {
		isLocked = false;
		for ( var i:int = 0; i < cbCount; i++ ) {
			unlockCallbacks[i]();
		}
		cbCount = 0;
	}
}
}
