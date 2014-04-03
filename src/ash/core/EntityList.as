package ash.core {
/**
 * An internal class for a linked list of entities. Used inside the framework for
 * managing the entities.
 */
internal class EntityList {
	internal var head:Entity;
	internal var tail:Entity;
	internal var length:uint = 0;

	internal function add( entity:Entity ):void {
		if ( !head ) {
			head = tail = entity;
			entity.next = entity.previous = null;
		}
		else {
			tail.next = entity;
			entity.previous = tail;
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
			tail = tail.previous;
		}

		if ( entity.previous ) {
			entity.previous.next = entity.next;
		}

		if ( entity.next ) {
			entity.next.previous = entity.previous;
		}
		
		--length;
		// N.B. Don't set node.next and node.previous to null because that will break the list iteration if node is the current node in the iteration.
	}

	internal function removeAll():void {
		while ( head ) {
			var entity:Entity = head;
			head = head.next;
			entity.previous = null;
			entity.next = null;
		}
		tail = null;
		length = 0;
	}
}
}
