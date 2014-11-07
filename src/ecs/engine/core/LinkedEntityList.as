/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.engine.core {
import flashrush.asentity.framework.api.asentity;
import flashrush.asentity.framework.entity.Entity;

use namespace asentity;

public class LinkedEntityList {
	public var first:Entity;
	public var last:Entity;
	public var length:uint = 0;
	
	public function attach( node:Entity ):void {
		node.prev = last;
		node.next = null;
		last ? last.next = node : first = node;
		last = node;
		length++;
	}
	
	public function detach( node:Entity ):void {
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
	
	public function detachAll():void {
		while ( first ) {
			var node:Entity = first;
			first = first.next;
			node.prev = null;
			node.next = null;
		}
		last = null;
		length = 0;
	}
	
	[Inline]
	public final function contains( entity:Entity ):Boolean {
		return (entity.list == this);
	}
}
}
