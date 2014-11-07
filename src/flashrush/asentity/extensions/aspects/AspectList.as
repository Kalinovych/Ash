/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions.aspects {
import ash.core.Node;
import ash.signals.Signal1;

/**
 *
 */
public class AspectList {
	//-------------------------------------------
	// Events
	//-------------------------------------------
	
	/**
	 * A signal that is dispatched whenever a node is added to the node list.
	 *
	 * <p>The signal will pass a single parameter to the listeners - the node that was added.</p>
	 */
	public const OnItemAdded:Signal1 = new Signal1( Aspect );
	
	/**
	 * A signal that is dispatched whenever a node is removed from the node list.
	 *
	 * <p>The signal will pass a single parameter to the listeners - the node that was removed.</p>
	 */
	public const OnItemRemoved:Signal1 = new Signal1( Aspect );
	
	/**
	 * List of nodes that was added in the current update
	 */
	public const addedItems:Vector.<Aspect> = new Vector.<Aspect>();
	
	/**
	 * List of nodes that was removed in the current update
	 */
	public const removedItems:Vector.<Aspect> = new Vector.<Aspect>();
	
	//-------------------------------------------
	// Properties
	//-------------------------------------------
	
	/**
	 * The first item in the node list, or null if the list contains no nodes.
	 */
	public var first:*;
	/**
	 * The last item in the node list, or null if the list contains no nodes.
	 */
	public var last:*;
	
	internal var _length:int = 0;
	
	/**
	 * @private
	 * Constructor
	 */
	function AspectList() {}
	
	/**
	 * The number of aspects in the list.
	 */
	public final function get length():int {
		return _length;
	}
	
	/**
	 * Determines whether the list is empty or not. false if the list contains at lease one element.
	 */
	public final function get empty():Boolean {
		return (first == null);
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
	 * @param arg An optional advanced one argument that should be passes as second argument to the callback.
	 */
	public function forEach( callback:Function, arg:* = null ):void {
		var aspect:Aspect;
		if ( arg ) {
			for ( aspect = first; aspect; aspect = aspect.next ) {
				callback( aspect, arg );
			}
		} else {
			for ( aspect = first; aspect; aspect = aspect.next ) {
				callback( aspect );
			}
		}
	}
	
	//-------------------------------------------
	// Sorting methods
	//-------------------------------------------
	
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
			node1.prev = node2;
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
		if ( first == node1 ) {
			first = node2;
		}
		else if ( first == node2 ) {
			first = node1;
		}
		if ( last == node1 ) {
			last = node2;
		}
		else if ( last == node2 ) {
			last = node1;
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
		if ( first == last ) {
			return;
		}
		var remains:Aspect = first.next;
		for ( var node:Aspect = remains; node; node = remains ) {
			remains = node.next;
			for ( var other:Aspect = node.prev; other; other = other.prev ) {
				if ( sortFunction( node, other ) >= 0 ) {
					// move node to after other
					if ( node != other.next ) {
						// remove from place
						if ( last == node ) {
							last = node.prev;
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
				if ( last == node ) {
					last = node.prev;
				}
				node.prev.next = node.next;
				if ( node.next ) {
					node.next.prev = node.prev;
				}
				// insert at head
				node.next = first;
				first.prev = node;
				node.prev = null;
				first = node;
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
		if ( first == last ) {
			return;
		}
		var lists:Vector.<Aspect> = new Vector.<Aspect>;
		// disassemble the list
		var start:Aspect = first;
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
		last = first = lists[0];
		while ( last.next ) {
			last = last.next;
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
	
}
}
