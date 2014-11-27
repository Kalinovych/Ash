/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.systems {
import org.flexunit.asserts.assertEquals;

public class SystemListTest {
	
	private var _list:SystemList;
	
	[Before]
	public function setUp():void {
		_list = new SystemList();
	}
	
	[After]
	public function tearDown():void {
		_list = null;
	}
	
	
	[Test]
	public function lengthReturnCorrectNumberOfSystem():void {
		_list.add(new MockSystem());
		_list.add(new MockSystem());
		assertEquals(_list.length, 2);
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