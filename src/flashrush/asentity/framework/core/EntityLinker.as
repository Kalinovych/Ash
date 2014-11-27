/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.core {
import flashrush.asentity.framework.api.asentity;
import flashrush.asentity.framework.entity.Entity;

use namespace asentity;

public class EntityLinker {
	public var first:Entity;
	public var last:Entity;
	public var length:uint = 0;
	
	private var space:EntitySpace;
	
	public function EntityLinker( space:EntitySpace = null ) {
		this.space = space;
	}
	
	public function link( node:Entity ):void {
		node.space = space;
		node.prev = last;
		node.next = null;
		if ( last ) last.next = node;
		else first = node;
		last = node;
		++length;
	}
	
	public function unlink( node:Entity ):void {
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
		
		--length;
	}
	
	public function unlinkAll( eachCallback:Function = null ):void {
		while ( first ) {
			const entity:Entity = first;
			first = first.next;
			if ( first ) first.prev = null;
			entity.next = null;
			--length;
			if ( eachCallback ) eachCallback( entity );
			entity.space = null;
		}
		last = null;
		length = 0;
	}
}
}
