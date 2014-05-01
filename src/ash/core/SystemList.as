package ash.core {
/**
 * Used internally, this is an ordered list of Systems for use by the engine update loop.
 */
internal class SystemList {
	internal var head:System;
	internal var tail:System;
	internal var length:uint = 0;

	internal function add( system:System ):void {
		if ( !head ) {
			head = tail = system;
			system.next = system.prev = null;
		}
		else {
			for ( var node:System = tail; node; node = node.prev ) {
				if ( node.priority <= system.priority ) {
					break;
				}
			}
			if ( node == tail ) {
				tail.next = system;
				system.prev = tail;
				system.next = null;
				tail = system;
			}
			else if ( !node ) {
				system.next = head;
				system.prev = null;
				head.prev = system;
				head = system;
			}
			else {
				system.next = node.next;
				system.prev = node;
				node.next.prev = system;
				node.next = system;
			}
		}
		++length;
	}

	internal function remove( system:System ):void {
		if ( head == system ) {
			head = head.next;
		}
		
		if ( tail == system ) {
			tail = tail.prev;
		}

		if ( system.prev ) {
			system.prev.next = system.next;
		}

		if ( system.next ) {
			system.next.prev = system.prev;
		}

		--length;
		// N.B. Don't set system.next and system.prev to null because that will break the list iteration if node is the current node in the iteration.
	}

	internal function removeAll():void {
		while ( head ) {
			var system:System = head;
			head = head.next;
			system.prev = null;
			system.next = null;
		}
		tail = null;
		length = 0;
	}

	internal function get( type:Class ):System {
		for ( var system:System = head; system; system = system.next ) {
			if ( system is type ) {
				return system;
			}
		}
		return null;
	}
}
}
