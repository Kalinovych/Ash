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
	
	public var space:Space;
	
	public function EntityList( space:Space = null ) {
		this.space = space;
	}
	
	public function add( node:Entity ):void {
		node._space = space;
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
		
		node._space = null;
		
		length--;
	}
	
	public function removeAll( eachCallback:Function = null ):void {
		while ( first ) {
			var node:Entity = first;
			first = first.next;
			node.next = null;
			eachCallback && eachCallback( node );
			node._space = null;
		}
		last = null;
		length = 0;
	}
}
}
