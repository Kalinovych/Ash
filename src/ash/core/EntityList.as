package ash.core {
import ashx.engine.api.ecse;
import ashx.engine.entity.Entity;

/**
 * An internal class for a linked list of entities. Used inside the framework for
 * managing the entities.
 */
	
use namespace ecse;

internal class EntityList {
	internal var head:Entity;
	internal var tail:Entity;
	internal var length:uint = 0;

	internal function add( entity:Entity ):void {
		if ( !head ) {
			head = tail = entity;
			entity.next = entity.prev = null;
		}
		else {
			tail.next = entity;
			entity.prev = tail;
			entity.next = null;
			tail = entity;
		}
		++length;
	}

	internal function remove( entity:Entity ):void {
		if ( head == entity ) {
			head = head.next;
		}

		if ( tail == entity ) {
			tail = tail.prev;
		}

		if ( entity.prev ) {
			entity.prev.next = entity.next;
		}

		if ( entity.next ) {
			entity.next.prev = entity.prev;
		}
		
		--length;
		// N.B. Don't set node.next and node.prev to null because that will break the list iteration if node is the current node in the iteration.
	}

	internal function removeAll():void {
		while ( head ) {
			var entity:Entity = head;
			head = head.next;
			entity.prev = null;
			entity.next = null;
		}
		tail = null;
		length = 0;
	}
}
}
