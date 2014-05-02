/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.aspects {
import ash.core.Node;
import ash.signals.Signal1;

public class AspectList {
	/**
	 * The first item in the node list, or null if the list contains no nodes.
	 */
	public var head:*;
	/**
	 * The last item in the node list, or null if the list contains no nodes.
	 */
	public var tail:*;

	/**
	 * A signal that is dispatched whenever a node is added to the node list.
	 *
	 * <p>The signal will pass a single parameter to the listeners - the node that was added.</p>
	 */
	public var nodeAdded:Signal1;
	/**
	 * A signal that is dispatched whenever a node is removed from the node list.
	 *
	 * <p>The signal will pass a single parameter to the listeners - the node that was removed.</p>
	 */
	public var nodeRemoved:Signal1;

	/**
	 * List of nodes that was added in the current update
	 */
	public var addedNodes:Vector.<Aspect>;

	/**
	 * List of nodes that was removed in the current update
	 */
	public var removedNodes:Vector.<Aspect>;

	private var _length:int = 0;

	public function AspectList() {
		nodeAdded = new Signal1( Aspect );
		nodeRemoved = new Signal1( Aspect );

		addedNodes = new Vector.<Aspect>();
		removedNodes = new Vector.<Aspect>();
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

	/**
	 * true if the list is empty, false otherwise.
	 */
	public function get empty():Boolean {
		return head == null;
	}

	/**
	 * Swaps the positions of two nodes in the list. Useful when sorting a list.
	 */
	public function swap( node1:Aspect, node2:Aspect ):void {
		if ( node1.prev == node2 ) {
			node1.prev = node2.prev;
			node2.prev = node1;
			node2.next = node1.next;
			node1.next = node2;
		}
		else if ( node2.prev == node1 ) {
			node2.prev = node1.prev;
			node1.prev= node2;
			node1.next = node2.next;
			node2.next = node1;
		}
		else {
			var temp:Node = node1.prev;
			node1.prev = node2.prev;
			node2.prev = temp;
			temp = node1.next;
			node1.next = node2.next;
			node2.next = temp;
		}
		if ( head == node1 ) {
			head = node2;
		}
		else if ( head == node2 ) {
			head = node1;
		}
		if ( tail == node1 ) {
			tail = node2;
		}
		else if ( tail == node2 ) {
			tail = node1;
		}
		if ( node1.prev ) {
			node1.prev.next = node1;
		}
		if ( node2.prev ) {
			node2.prev.next = node2;
		}
		if ( node1.next ) {
			node1.next.prev = node1;
		}
		if ( node2.next ) {
			node2.next.prev = node2;
		}
	}

	/**
	 * Performs an insertion sort on the node list. In general, insertion sort is very efficient with short lists
	 * and with lists that are mostly sorted, but is inefficient with large lists that are randomly ordered.
	 *
	 * <p>The sort function takes two nodes and returns a Number.</p>
	 *
	 * <p><code>function sortFunction( node1 : MockNode, node2 : MockNode ) : Number</code></p>
	 *
	 * <p>If the returned number is less than zero, the first node should be before the second. If it is greater
	 * than zero the second node should be before the first. If it is zero the order of the nodes doesn't matter
	 * and the original order will be retained.</p>
	 *
	 * <p>This insertion sort implementation runs in place so no objects are created during the sort.</p>
	 */
	public function insertionSort( sortFunction:Function ):void {
		if ( head == tail ) {
			return;
		}
		var remains:Aspect = head.next;
		for ( var node:Aspect = remains; node; node = remains ) {
			remains = node.next;
			for ( var other:Aspect = node.prev; other; other = other.prev ) {
				if ( sortFunction( node, other ) >= 0 ) {
					// move node to after other
					if ( node != other.next ) {
						// remove from place
						if ( tail == node ) {
							tail = node.prev;
						}
						node.prev.next = node.next;
						if ( node.next ) {
							node.next.prev = node.prev;
						}
						// insert after other
						node.next = other.next;
						node.prev = other;
						node.next.prev = node;
						other.next = node;
					}
					break; // exit the inner for loop
				}
			}
			if ( !other ) // the node belongs at the start of the list
			{
				// remove from place
				if ( tail == node ) {
					tail = node.prev;
				}
				node.prev.next = node.next;
				if ( node.next ) {
					node.next.prev = node.prev;
				}
				// insert at head
				node.next = head;
				head.prev = node;
				node.prev = null;
				head = node;
			}
		}
	}

	/**
	 * Performs a merge sort on the node list. In general, merge sort is more efficient than insertion sort
	 * with long lists that are very unsorted.
	 *
	 * <p>The sort function takes two nodes and returns a Number.</p>
	 *
	 * <p><code>function sortFunction( node1 : MockNode, node2 : MockNode ) : Number</code></p>
	 *
	 * <p>If the returned number is less than zero, the first node should be before the second. If it is greater
	 * than zero the second node should be before the first. If it is zero the order of the nodes doesn't matter.</p>
	 *
	 * <p>This merge sort implementation creates and uses a single Vector during the sort operation.</p>
	 */
	public function mergeSort( sortFunction:Function ):void {
		if ( head == tail ) {
			return;
		}
		var lists:Vector.<Aspect> = new Vector.<Aspect>;
		// disassemble the list
		var start:Aspect = head;
		var end:Aspect;
		while ( start ) {
			end = start;
			while ( end.next && sortFunction( end, end.next ) <= 0 ) {
				end = end.next;
			}
			var next:Aspect = end.next;
			start.prev = end.next = null;
			lists.push( start );
			start = next;
		}
		// reassemble it in order
		while ( lists.length > 1 ) {
			lists.push( merge( lists.shift(), lists.shift(), sortFunction ) );
		}
		// find the tail
		tail = head = lists[0];
		while ( tail.next ) {
			tail = tail.next;
		}
	}

	private function merge( head1:Aspect, head2:Aspect, sortFunction:Function ):Aspect {
		var node:Aspect;
		var head:Aspect;
		if ( sortFunction( head1, head2 ) <= 0 ) {
			head = node = head1;
			head1 = head1.next;
		}
		else {
			head = node = head2;
			head2 = head2.next;
		}
		while ( head1 && head2 ) {
			if ( sortFunction( head1, head2 ) <= 0 ) {
				node.next = head1;
				head1.prev = node;
				node = head1;
				head1 = head1.next;
			}
			else {
				node.next = head2;
				head2.prev = node;
				node = head2;
				head2 = head2.next;
			}
		}
		if ( head1 ) {
			node.next = head1;
			head1.prev = node;
		}
		else {
			node.next = head2;
			head2.prev = node;
		}
		return head;
	}

	/**
	 * Executes a function on each node in the NodeList.
	 * <code>
	 *     function processNode(node:MyNode):void {
		 *         // your code here
		 *     }
	 *     nodeList.forEach( processNode );
	 * </code>
	 * <code>
	 *     function updateNode(node:MyNode, deltaTime:Number):void {
		 *          // your code here
		 *     }
	 *     nodeList.forEach(updateNode, deltaTime);
	 * </code>
	 * @param callback The function to run on each node in the NodeList.
	 * This function is invoked with one or more arguments:
	 * the current node from the NodeList and other arguments passed in the args parameter:
	 * <code>function callback(node:MyNode):void</code>
	 * <code>function callback(node:MyNode, someValue:SomeType ):void</code>
	 * @param args An optional list of one or more comma-separated values to pass as arguments into callback function call.
	 */
	public function forEach( callback:Function, ...args ):void {
		if ( head ) {
			args.unshift( null );
			for ( var node:Aspect = head; node; node = node.next ) {
				args[0] = node;
				callback.apply( null, args );
			}
		}
	}

	public function get length():int {
		return _length;
	}
}
}
