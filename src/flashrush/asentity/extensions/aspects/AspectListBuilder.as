/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions.aspects {

/**
 * Internal interface to manage the AspectList items
 */
internal class AspectListBuilder {
	internal var list:AspectList = new AspectList();
	
	public function AspectListBuilder() {
		super();
	}
	
	public function begin():void {
		this.list = list;
		list.addedItems.length = 0;
		list.removedItems.length = 0;
	}
	
	public function add( node:Aspect ):void {
		if ( !list.first ) {
			list.first = node;
			list.last = node;
			node.prev = null;
			node.next = null;
		}
		else {
			list.last.next = node;
			node.prev = list.last;
			node.next = null;
			list.last = node;
		}
		list._length++;
		list.addedItems[list.addedItems.length] = node;
		list.OnItemAdded.dispatch( node );
	}
	
	public function remove( node:Aspect ):void {
		if ( list.first == node ) {
			list.first = list.first.next;
		}
		if ( list.last == node ) {
			list.last = list.last.prev;
		}
		
		if ( node.prev ) {
			node.prev.next = node.next;
		}
		
		if ( node.next ) {
			node.next.prev = node.prev;
		}
		list._length--;
		list.removedItems[list.removedItems.length] = node;
		list.OnItemRemoved.dispatch( node );
		// N.B. Don't set node.next and node.prev to null because that will break the list iteration if node is the current node in the iteration.
	}
	
	public function removeAll():void {
		while ( list.first ) {
			var node:Aspect = list.first;
			list.first = node.next;
			node.prev = null;
			node.next = null;
			list.OnItemRemoved.dispatch( node );
		}
		list.last = null;
		list._length = 0;
	}
	
}
}
