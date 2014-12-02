/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.systems {
import flashrush.asentity.framework.systems.api.ISystem;
import flashrush.asentity.framework.systems.mocks.MockSystem;
import flashrush.asentity.framework.systems.mocks.MockSystem2;
import flashrush.asentity.framework.systems.mocks.MockSystem3;

import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;
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
	public function addedSystemsLinkedInRightOrder():void {
		const s1:ISystem = new MockSystem();
		const s2:ISystem = new MockSystem2();
		const s3:ISystem = new MockSystem3();
		_manager.add( s3, 10 );
		_manager.add( s1, 5 );
		_manager.add( s2, 5 );
		var node:SystemNode = _manager.firstSystemNode;
		assertThat( node.system, sameInstance( s1 ));
		node = node.next;
		assertThat( node.system, sameInstance( s2 ));
		node = node.next;
		assertThat( node.system, sameInstance( s3 ));
	}
	
	[Test]
	public function retrieveSystemByType():void {
		const system:ISystem = new MockSystem();
		_manager.add( system );
		
		assertThat( _manager.get( MockSystem ), sameInstance( system ) );
	}
	
	[Test]
	public function lengthReturnNumberOfAddedSystems():void {
		_manager.add( new MockSystem() );
		_manager.add( new MockSystem2() );
		assertThat( _manager.length, equalTo( 2 ) );
	}
	
	
	[Test]
	public function sameSystemAddedTwiceStoredTwice():void {
		const s:ISystem = new MockSystem();
		_manager.add( s );
		_manager.add( s );
		assertThat( _manager.length, equalTo( 2 ) );
	}
	
	
	[Test]
	public function get_returnSystemByItType():void {
		const s1:ISystem = new MockSystem();
		const s2:ISystem = new MockSystem2();
		_manager.add( s1 );
		_manager.add( s2 );
		assertThat( _manager.get( MockSystem2 ), sameInstance( s2 ) );
		assertThat( _manager.get( MockSystem ), sameInstance( s1 ) );
	}
	
	[Test]
	public function get_returnNullIfSystemNotAdded():void {
		assertThat( _manager.get( MockSystem ), nullValue() );
	}
	
	[Test]
	public function updateSystems():void {
		_manager.add( new MockSystem() );
		_manager.add( new MockSystem2() );
		_manager.update( 0.1 );
	}
}
}

