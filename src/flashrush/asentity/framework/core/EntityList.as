/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.core {
import flashrush.asentity.framework.api.asentity;
import flashrush.asentity.framework.entity.Entity;

use namespace asentity;

public class EntityList {
	public var first:Entity;
	public var last:Entity;
	public var length:uint = 0;
	
	public var space:EntitySpace;
	
	public function EntityList( space:EntitySpace = null ) {
		this.space = space;
	}
	
	public function add( node:Entity ):void {
		node.space = space;
		node.prev = last;
		node.next = null;
		last ? last.next = node : first = node;
		last = node;
		length++;
	}
	
	public function remove( node:Entity ):void {
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
		
		node.space = null;
		
		length--;
	}
	
	public function removeAll( eachCallback:Function = null ):void {
		while ( first ) {
			const node:Entity = first;
			first = first.next;
			first.prev = null;
			node.next = null;
			eachCallback && eachCallback( node );
			node.space = null;
		}
		last = null;
		length = 0;
	}
}
}
