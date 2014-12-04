/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.systems {
import flashrush.asentity.framework.api.asentity;

import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;

use namespace asentity;

public class SystemTest {
	
	protected var manager:SystemManager;
	
	[Before]
	public function setUp():void {
		manager = new SystemManager();
	}
	
	[After]
	public function tearDown():void {
		manager = null;
	}
	
	
	[Test]
	public function defaultOrderIsZero():void {
		const system:System = new System();
		manager.add( system );
		assertThat( system.order, equalTo( 0 ) );
	}
	
	[Test]
	public function orderEqualsToSpecifiedWithAdd():void {
		const system:System = new System();
		manager.add( system, 5 );
		assertThat( system.order, equalTo( 5 ) );
	}
}
}
