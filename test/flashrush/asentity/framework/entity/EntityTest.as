/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.entity {
import flashrush.asentity.framework.entity.mocks.MockComponent;
import flashrush.asentity.framework.entity.mocks.MockComponent2;

import org.flexunit.asserts.assertEquals;
import org.flexunit.asserts.assertFalse;
import org.flexunit.asserts.assertNull;
import org.flexunit.asserts.assertTrue;
import org.hamcrest.assertThat;
import org.hamcrest.object.instanceOf;
import org.hamcrest.object.sameInstance;

public class EntityTest {
	protected var entity:Entity;
	
	[Before]
	public function setUp():void {
		entity = new Entity();
	}
	
	[After]
	public function tearDown():void {
		entity = null;
	}
	
	
	[Test]
	public function add_returns_reference_to_the_entity():void {
		assertEquals( entity, entity.add( new MockComponent() ) );
		assertThat( entity, sameInstance( entity.add( new MockComponent() ) ) )
	}
	
	[Test]
	public function component_is_added_once_for_same_instance():void {
		const c1:MockComponent = new MockComponent();
		entity.add( c1 );
		entity.add( c1 );
		assertEquals( entity.componentCount, 1 );
	}
	
	[Test]
	public function adding_component_of_contained_type_overrides_contained():void {
		const c1:MockComponent = new MockComponent();
		const c2:MockComponent = new MockComponent();
		entity.add( c1 );
		entity.add( c2 );
		assertEquals( entity.componentCount, 1 );
		assertThat( entity.get( MockComponent ), sameInstance( c2 ) );
	}
	
	[Test]
	public function get_returns_component_of_requested_type():void {
		entity.add( new MockComponent() );
		assertThat( entity.get( MockComponent ), instanceOf( MockComponent ) );
	}
	
	[Test]
	public function get_returns_null_if_no_component():void {
		assertNull( entity.get( MockComponent ) );
	}
	
	[Test]
	public function componentCount_is_number_of_contained_components():void {
		assertEquals( entity.componentCount, 0 );
		entity.add( new MockComponent() );
		assertEquals( entity.componentCount, 1 );
		entity.add( new MockComponent2() );
		assertEquals( entity.componentCount, 2 );
	}
	
	
	[Test]
	public function remove_returnNullIfComponentNotFound():void {
		assertNull( entity.remove( MockComponent ) );
	}
	
	[Test]
	public function remove_returnsRemovedComponentInstance():void {
		const c1:MockComponent = new MockComponent();
		entity.add( c1 );
		assertThat( entity.remove( MockComponent ), sameInstance( c1 ) );
	}
	
	
	[Test]
	public function testHas():void {
		assertFalse( entity.has( MockComponent ) );
		entity.add( new MockComponent() );
		assertTrue( entity.has( MockComponent ) );
		assertFalse( entity.has( MockComponent2 ) );
	}
}
}
