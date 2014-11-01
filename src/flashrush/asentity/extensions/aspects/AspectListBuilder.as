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
		addedNodes.length = 0;
		removedNodes.length = 0;
	}
	
	public function add( node:Aspect ):void {
		if ( !head ) {
			head = node;
			tail = node;
			node.prev = null;
			node.next = null;
		}
		else {
			tail.next = node;
			node.prev = tail;
			node.next = null;
			tail = node;
		}
		_length++;
		addedNodes[addedNodes.length] = node;
		nodeAdded.dispatch( node );
	}
	
	public function remove( node:Aspect ):void {
		if ( head == node ) {
			head = head.next;
		}
		if ( tail == node ) {
			tail = tail.prev;
		}
		
		if ( node.prev ) {
			node.prev.next = node.next;
		}
		
		if ( node.next ) {
			node.next.prev = node.prev;
		}
		_length--;
		removedNodes[removedNodes.length] = node;
		nodeRemoved.dispatch( node );
		// N.B. Don't set node.next and node.prev to null because that will break the list iteration if node is the current node in the iteration.
	}
	
	public function removeAll():void {
		while ( head ) {
			var node:Aspect = head;
			head = node.next;
			node.prev = null;
			node.next = null;
			nodeRemoved.dispatch( node );
		}
		tail = null;
		_length = 0;
	}
	
}
}
