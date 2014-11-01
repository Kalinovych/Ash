/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions.aspects {

/**
 * Internal interface to manage the AspectList items
 */
internal class AspectListBuilder extends AspectList {
	public function AspectListBuilder() {
		super();
	}
	
	public function beginStep():void {
		addedItems.length = 0;
		removedItems.length = 0;
	}
	
	public function add( node:Aspect ):void {
		if ( !first ) {
			first = node;
			last = node;
			node.prev = null;
			node.next = null;
		}
		else {
			last.next = node;
			node.prev = last;
			node.next = null;
			last = node;
		}
		_length++;
		addedItems[addedItems.length] = node;
		OnItemAdded.dispatch( node );
	}
	
	public function remove( node:Aspect ):void {
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
		_length--;
		removedItems[removedItems.length] = node;
		OnItemRemoved.dispatch( node );
		// N.B. Don't set node.next and node.prev to null because that will break the list iteration if node is the current node in the iteration.
	}
	
	public function removeAll():void {
		while ( first ) {
			var node:Aspect = first;
			first = node.next;
			node.prev = null;
			node.next = null;
			OnItemRemoved.dispatch( node );
		}
		last = null;
		_length = 0;
	}
	
}
}
