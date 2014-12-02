/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.systems.mocks {
import flashrush.asentity.framework.systems.api.ISystem;

public class MockSystem implements ISystem {
	public function onAdded():void {
	}
	
	public function onRemoved():void {
	}
	
	public function update( delta:Number ):void {
	}
	
	public function get order():int {
		return 0;
	}
}
}
