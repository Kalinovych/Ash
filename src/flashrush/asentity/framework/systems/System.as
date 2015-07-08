/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.systems {
import flashrush.asentity.framework.api.asentity;

public/* abstract */class System {
	
	
	public function System() {}
	
	//public function initialize():void {}
	
	public function onAdded():void {}
	
	//public function onEnable():void {}
	
	public function update( delta:Number ):void {}
	
	//public function onDisable():void {}
	
	public function onRemoved():void {}
	
	//public function destroy():void {}
	
//-------------------------------------------
// Internals
//-------------------------------------------
	asentity var manager:SystemManager;//ISystemManager;
	asentity var prev:System;
	asentity var next:System;
	asentity var order:int = 0;
}
}
