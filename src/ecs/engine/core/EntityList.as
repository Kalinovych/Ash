/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.engine.core {
import flashrush.asentity.framework.api.asentity;
import flashrush.asentity.framework.entity.Entity;

use namespace asentity;

public class EntityList {
	asentity var first:Entity;
	asentity var last:Entity;
	asentity var length:uint = 0;

	asentity function attach( node:Entity ):void {
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

	asentity function detach( node:Entity ):void {
		if ( node == first ) {
			first = first.next;
		}

		if ( node == last ) {
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

	asentity function detachAll():void {
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
