/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.engine.core {
import ecs.framework.api.ecs_core;

use namespace ecs_core;

public class ESUnitList {
	ecs_core var first:ESUnit;
	ecs_core var last:ESUnit;
	ecs_core var length:uint = 0;

	ecs_core function attach( unit:ESUnit ):void {
		if ( !first ) {
			first = unit;
			last = unit;
			unit.prev = null;
			unit.next = null;
		} else {
			last.next = unit;
			unit.prev = last;
			unit.next = null;
			last = unit;
		}
		
		length++;
	}

	ecs_core function detach( unit:ESUnit ):void {
		if ( first == unit ) {
			first = first.next;
		}

		if ( last == unit ) {
			last = last.prev;
		}

		if ( unit.prev ) {
			unit.prev.next = unit.next;
		}

		if ( unit.next ) {
			unit.next.prev = unit.prev;
		}

		length--;
	}

	ecs_core function detachAll():void {
		while ( first ) {
			var unit:ESUnit = first;
			first = first.next;
			unit.prev = null;
			unit.next = null;
		}
		last = null;
		length = 0;
	}
}
}
