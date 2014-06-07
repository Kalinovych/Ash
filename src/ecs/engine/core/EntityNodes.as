/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.engine.core {
import ecs.framework.api.ecs_core;
import ecs.framework.entity.Entity;

use namespace ecs_core;

public class EntityNodes {
	ecs_core var first:Entity;
	ecs_core var last:Entity;
	ecs_core var length:uint = 0;

	ecs_core function attach( node:Entity ):void {
		if ( !first ) {
			first = node;
			last = node;
			node.prev = null;
			node.next = null;
		} else {
			last.next = node;
			node.prev = last;
			node.next = null;
			last = node;
		}
		length++;
	}

	ecs_core function detach( node:Entity ):void {
		if ( first == node ) {
			first = first.next;
		}

		if ( last == node ) {
			last = last.prev;
		}

		if ( node.prev ) {
			node.prev.next = node.next;
		}

		if ( node.next ) {
			node.next.prev = node.prev;
		}

		length--;
	}

	ecs_core function detachAll():void {
		while ( first ) {
			var node:Entity = first;
			first = first.next;
			node.prev = null;
			node.next = null;
		}
		last = null;
		length = 0;
	}
}
}
