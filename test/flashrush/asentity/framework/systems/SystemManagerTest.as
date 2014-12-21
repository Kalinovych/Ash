/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.systems {
import flashrush.asentity.framework.api.asentity;
import flashrush.asentity.framework.systems.api.ISystemHandler;
import flashrush.assert;

import mockolate.mock;
import mockolate.nice;
import mockolate.runner.MockolateRule;
import mockolate.strict;
import mockolate.verify;

import org.flexunit.asserts.assertEquals;
import org.flexunit.asserts.assertNull;
import org.hamcrest.assertThat;
import org.hamcrest.number.lessThanOrEqualTo;
import org.hamcrest.object.nullValue;
import org.hamcrest.object.sameInstance;

use namespace asentity;

public class SystemManagerTest {
	protected var manager:SystemManager;
	
	[Rule]
	public var rule:MockolateRule = new MockolateRule();
	
	[Mock(inject=false)]
	public var systemMock:System;
	
	[Mock(inject=false)]
	public var handlerMock:ISystemHandler;
	
	
	private var system:System;
	private var system2:System;
	private var system3:System;
	
	[Before]
	public function setUp():void {
		manager = new SystemManager();
		system = new System();
		system2 = new System();
		system3 = new System();
	}
	
	[After]
	public function tearDown():void {
		manager = null;
		system = null;
		system2 = null;
		system3 = null;
	}
	
	[Test]
	public function add_linksSystemInTheManager():void {
		assert(manager).instanceOf(SystemManager);
		
		manager.add( system );
		assertThat( manager.first, sameInstance( system ) );
		assertThat( manager.last, sameInstance( system ) );
	}
	
	[Test]
	public function addedSystems_linkedInAscendingOrder():void {
		manager.add( system, 10 );
		manager.add( system2, 1 );
		manager.add( system3, 5 );
		
		var s:System = manager.first;
		while ( s.next ) {
			assertThat( s.order, lessThanOrEqualTo( s.next.order ) );
			s = s.next;
		}
	}
	
	[Test]
	public function systemsAddedWithSameOrderStoredInOrderTheyAdded():void {
		manager.add( system, 5 );
		manager.add( system2, 5 );
		manager.add( system3, 5 );
		
		assertThat( manager.first, sameInstance( system ) );
		assertThat( manager.first.next, sameInstance( system2 ) );
		assertThat( manager.first.next.next, sameInstance( system3 ) );
	}
	
	[Test]
	public function add_returnsReferenceToSelf():void {
		assertThat( manager.add( system ), sameInstance( manager ) );
	}
	
	[Test(expects="TypeError")]
	public function addNullThrowsError():void {
		manager.add( null );
	}
	
	
	[Test(expects="ArgumentError")]
	public function addingSystemThatAlreadyAdded_throwsError():void {
		manager.add( system );
		manager.add( system );
	}
	
	[Test]
	public function remove_unlinksTheSystemFromManager():void {
		manager.add( system );
		manager.remove( system );
		assertThat( manager.first, nullValue() );
	}
	
	[Test]
	public function remove_updatesSystemCounter():void {
		manager.add( system );
		manager.add( system2 );
		manager.remove( system );
		assertEquals( 1, manager.numSystems );
		manager.remove( system2 );
		assertEquals( 0, manager.numSystems );
	}
	
	[Test(expects="TypeError")]
	public function removeNull_throwsError():void {
		manager.remove( null );
	}
	
	[Test(expects="ArgumentError")]
	public function removingNotContainedSystem_throwsError():void {
		manager.remove( system );
	}
	
	[Test]
	public function shouldCallSystems_onAdded_whenSystemAdded():void {
		const system:System = strict( System );
		mock( system ).method( "onAdded" ).noArgs().once();
		manager.add( system );
		verify( system );
	}
	
	[Test]
	public function shouldCallSystems_onRemoved_whenSystemRemoved():void {
		const system:System = strict( System );
		mock( system ).method( "onAdded" );
		mock( system ).method( "onRemoved" ).noArgs().once();
		manager.add( system );
		manager.remove( system );
		verify( system );
	}
	
	[Test]
	public function remove_setsTheSystemManagerToNull():void {
		const s:System = new System();
		manager.add( s );
		manager.removeAll();
		assertNull( s.manager );
	}
	
	[Test]
	public function removeAll_setsFirstAndLastToNull():void {
		manager.add( new System() );
		manager.add( new System() );
		manager.removeAll();
		assertNull( manager.first, manager.last );
	}
	
	[Test]
	public function removeAll_setSystemCounterToZero():void {
		manager.add( new System() );
		manager.add( new System() );
		manager.removeAll();
		assertEquals( 0, manager.numSystems );
	}
	
	
	[Test]
	public function removeAll_setEachSystemManagerPropToNull():void {
		const s:System = new System();
		manager.add( s );
		manager.removeAll();
		assertNull( s.manager );
	}
	
	[Test]
	public function numSystems_returnsNumberOfSystemsAdded():void {
		assertEquals( 0, manager.numSystems );
		const s1:System = new System();
		const s2:System = new System();
		manager.add( s1 );
		assertEquals( 1, manager.numSystems );
		manager.add( s2 );
		assertEquals( 2, manager.numSystems );
	}
	
	[Test]
	public function firstAndLast_returnNullByDefault():void {
		assertThat( manager.first, nullValue() );
		assertThat( manager.last, nullValue() );
	}
	
	[Test]
	public function firstAndLast_sameValueIfOneSystemContained():void {
		const s1:System = new System();
		const s2:System = new System();
		
		manager.add( s1 );
		assertThat( manager.first, sameInstance( s1 ) );
		assertThat( manager.last, sameInstance( s1 ) );
		
		manager.add( s2 );
		manager.remove( s2 );
		
		assertThat( manager.first, sameInstance( s1 ) );
		assertThat( manager.last, sameInstance( s1 ) );
	}
	
	[Test]
	public function firstAndLast_returnDifferentSystemsIfAddedMoreThanOne():void {
		const s1:System = new System();
		const s2:System = new System();
		manager.add( s1 );
		manager.add( s2 );
		assertThat( manager.first, sameInstance( s1 ) );
		assertThat( manager.last, sameInstance( s2 ) );
	}
	
	
	[Test]
	public function systemsCanBeIteratedFromFirstToLast():void {
		const systemList:Vector.<System> = new <System>[
			new System(),
			new System(),
			new System(),
			new System()
		];
		
		var i:int;
		for ( i = 0; i < systemList.length; ++i ) {
			manager.add( systemList[i] );
		}
		
		i = 0;
		for ( var s:System = manager.first; s; s = s.next ) {
			assertThat( s, sameInstance( systemList[i++] ) );
		}
	}
	
	
	[Test]
	public function systemsCanBeIteratedFromLastToFirst():void {
		const systemList:Vector.<System> = new <System>[
			new System(),
			new System(),
			new System(),
			new System()
		];
		
		var i:int;
		for ( i = 0; i < systemList.length; ++i ) {
			manager.add( systemList[i] );
		}
		
		i = systemList.length;
		for ( var s:System = manager.last; s; s = s.prev ) {
			assertThat( s, sameInstance( systemList[--i] ) );
		}
	}
	
	[Test]
	public function canRegisterSystemHandler():void {
		const handler:ISystemHandler = nice(ISystemHandler);
		manager.registerHandler(handler);
	}
	
	[Test]
	public function shouldNotifyHandlersWhenSystemAdded():void {
		const handler:ISystemHandler = strict(ISystemHandler);
		const handler2:ISystemHandler = strict(ISystemHandler);
		
		mock(handler).method("onSystemAdded").args(system).once();
		mock(handler2).method("onSystemAdded").args(system).once();
		
		manager.registerHandler(handler);
		manager.registerHandler(handler2);
		
		manager.add(system);
		
		verify(handler);
		verify(handler2);
	}
	
	[Test]
	public function shouldNotifyHandlersWhenSystemRemoved():void {
		const handler:ISystemHandler = strict(ISystemHandler);
		const handler2:ISystemHandler = strict(ISystemHandler);
		
		mock(handler).method("onSystemRemoved").args(system).once();
		mock(handler2).method("onSystemRemoved").args(system).once();
		
		manager.add(system);
		manager.registerHandler(handler);
		manager.registerHandler(handler2);
		manager.remove(system);
		
		verify(handler);
		verify(handler2);
	}
	
	
}
}
