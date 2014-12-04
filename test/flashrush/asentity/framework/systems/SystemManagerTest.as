/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.systems {
import flashrush.asentity.framework.api.asentity;
import flashrush.asentity.framework.systems.api.ISystemHandler;

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
	
	[Before]
	public function setUp():void {
		manager = new SystemManager();
	}
	
	[After]
	public function tearDown():void {
		manager = null;
	}
	
	[Test]
	public function add_linksSystemInTheManager():void {
		const s:System = new System();
		manager.add( s );
		assertThat( manager.first, sameInstance( s ) );
		assertThat( manager.last, sameInstance( s ) );
	}
	
	[Test]
	public function addedSystems_linkedInAscendingOrder():void {
		const s1:System = new System();
		const s2:System = new System();
		const s3:System = new System();
		manager.add( s1, 10 );
		manager.add( s2, 1 );
		manager.add( s3, 5 );
		
		var s:System = manager.first;
		while ( s.next ) {
			assertThat( s.order, lessThanOrEqualTo( s.next.order ) );
			s = s.next;
		}
	}
	
	
	[Test]
	public function systemsAddedWithSameOrderStoredInOrderTheyAdded():void {
		const s1:System = new System();
		const s2:System = new System();
		const s3:System = new System();
		manager.add( s1, 5 );
		manager.add( s2, 5 );
		manager.add( s3, 5 );
		
		assertThat( manager.first, sameInstance( s1 ) );
		assertThat( manager.first.next, sameInstance( s2 ) );
		assertThat( manager.first.next.next, sameInstance( s3 ) );
	}
	
	[Test]
	public function add_returnReferenceToSystemManager():void {
		const s:System = new System();
		const result:* = manager.add( s );
		assertThat( result, sameInstance( manager ) );
	}
	
	[Test(expects="TypeError")]
	public function addNullThrowsError():void {
		manager.add( null );
	}
	
	[Test]
	public function add_callsSystemOnAdded():void {
		const system:System = strict( System );
		mock( system ).method( "onAdded" ).noArgs().once();
		manager.add( system );
		verify( system );
	}
	
	
	[Test(expects="ArgumentError")]
	public function addingSystemThatAlreadyAdded_throwsError():void {
		const s:System = new System();
		manager.add( s );
		manager.add( s );
	}
	
	[Test]
	public function remove_unlinksTheSystemFromManager():void {
		const s:System = new System();
		manager.add( s );
		manager.remove( s );
		assertThat( manager.first, nullValue() );
	}
	
	[Test]
	public function remove_updatesSystemCounter():void {
		const s1:System = new System();
		const s2:System = new System();
		manager.add( s1 );
		manager.add( s2 );
		manager.remove( s1 );
		assertEquals( 1, manager.numSystems );
		manager.remove( s2 );
		assertEquals( 0, manager.numSystems );
	}
	
	[Test(expects="TypeError")]
	public function removeNull_throwsError():void {
		manager.remove( null );
	}
	
	[Test(expects="ArgumentError")]
	public function removingNotContainedSystem_throwsError():void {
		const s:System = new System();
		manager.remove( s );
	}
	
	[Test]
	public function remove_callsSystemOnRemoved():void {
		const system:System = strict( System );
		mock( system ).method( "onAdded" );
		mock( system ).method( "onRemoved" ).noArgs().once();
		manager.add( system );
		manager.remove( system );
		//verify( system );
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
	public function registerSystemHandler():void {
		const handler:ISystemHandler = nice(ISystemHandler);
		manager.registerHandler(handler);
	}
	
	
	[Test]
	public function registeredHandlerNotifiedSystemAdded():void {
		const s:System = new System();
		const h:ISystemHandler = strict(ISystemHandler);
		
		mock(h).method("onSystemAdded").args(s).once();
		
		manager.registerHandler(h);
		manager.add(s);
		
		verify(h);
	}
	
	[Test]
	public function registeredHandlerNotifiedSystemRemoved():void {
		const s:System = new System();
		const h:ISystemHandler = strict(ISystemHandler);
		
		mock(h).method("onSystemRemoved").args(s).once();
		
		manager.add(s);
		manager.registerHandler(h);
		manager.remove(s);
		
		verify(h);
	}
	
	
}
}
