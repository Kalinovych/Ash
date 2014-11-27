/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.systems {
import flashrush.asentity.framework.systems.api.ISystem;

import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.isFalse;
import org.hamcrest.object.isTrue;
import org.hamcrest.object.nullValue;
import org.hamcrest.object.sameInstance;

public class SystemManagerTest {
	private var _manager:SystemManager;
	
	[Before]
	public function setUp():void {
		_manager = new SystemManager();
	}
	
	[After]
	public function tearDown():void {
		_manager = null;
	}
	
	[Test]
	public function addSystemWithOrder():void {
		_manager.add( new MockSystem(), 0 );
	}
	
	[Test]
	public function retrieveSystemByType():void {
		const system:ISystem = new MockSystem();
		_manager.add( system );
		
		assertThat( _manager.get( MockSystem ), sameInstance( system ) );
	}
	
	[Test]
	public function get_returnNullIfSystemNotAdded():void {
		assertThat( _manager.get( MockSystem ), nullValue() );
	}
	
	[Test]
	public function lengthReturnNumberOfAddedSystems():void {
		_manager.add( new MockSystem() );
		_manager.add( new MockSystem2() );
		assertThat( _manager.length, equalTo( 2 ) );
	}
	
	
	[Test(expects="ArgumentError")]
	public function addingTwoSystemOfTheSameTypeThrowsError():void {
		_manager.add( new MockSystem() );
		_manager.add( new MockSystem() );
	}
	
	
	[Test]
	public function has_returnTrueIfSystemOfTypeAdded():void {
		_manager.add( new MockSystem() );
		_manager.add( new MockSystem2() );
		assertThat( _manager.has( MockSystem ), isTrue() );
		assertThat( _manager.has( MockSystem2 ), isTrue() );
	}
	
	
	[Test]
	public function has_returnFalseIfSystemOfTypeNotAdded():void {
		_manager.add( new MockSystem() );
		assertThat( _manager.has( MockSystem2 ), isFalse() );
	}
	
	
	[Test]
	public function updateSystems():void {
		_manager.add( new MockSystem() );
		_manager.add( new MockSystem2() );
		_manager.update( 0.1 );
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