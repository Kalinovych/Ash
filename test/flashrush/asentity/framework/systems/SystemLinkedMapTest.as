/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.systems {
import flashrush.asentity.framework.systems.api.ISystem;
import flashrush.utils.getClass;

public class SystemLinkedMapTest {
	private var _systems:SystemLinkedMap;
	
	[Before]
	public function setUp():void {
		_systems = new SystemLinkedMap();
	}
	
	[After]
	public function tearDown():void {
		_systems = null;
	}
	
	[Test]
	public function canStoreTheSystem():void {
		var system:ISystem = new MockSystem();
		var type:Class = getClass( system );
		_systems.put( type, system, 0 );
	}
}
}

import flashrush.asentity.framework.systems.api.ISystem;

class MockSystem implements ISystem {
	public function onAdded():void {
	}
	
	public function onRemoved():void {
	}
	
	public function update( delta:Number ):void {
	}
}

class MockSystem2 implements ISystem {
	public function onAdded():void {
	}
	
	public function onRemoved():void {
	}
	
	public function update( delta:Number ):void {
	}
}