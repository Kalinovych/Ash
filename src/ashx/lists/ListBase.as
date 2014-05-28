/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.lists {
public class ListBase {
	protected var _firstNode:* = null;
	protected var _lastNode:* = null;
	protected var _length:uint = 0;

	public function ListBase() {
	}

	/**
	 * Adds a node to the end of the list.
	 * @param node The node to add to this list.
	 * @return The node instance passed as node parameter
	 */
	[Inline]
	protected final function $addNode( node:* ):* {
		if ( _firstNode == null ) {
			node.prev = null;
			node.next = null;
			_firstNode = node;
			_lastNode = node;
		} else {
			_lastNode.next = node;
			node.prev = _lastNode;
			node.next = null;
			_lastNode = node;
		}
		++_length;

		return node;
	}

	/**
	 * Adds a node at the start of this list.
	 * @param node The node to add as first(head) node of this list.
	 * @return The node instance passed as node parameter
	 */
	[Inline]
	protected final function $addNodeFirst( node:* ):* {
		if ( _firstNode == null ) {
			node.prev = null;
			node.next = null;
			_firstNode = node;
			_lastNode = node;
		} else {
			_firstNode.prev = node;
			node.next = _firstNode;
			node.prev = null;
			_firstNode = node;
		}
		++_length;

		return node;
	}

	/**
	 * Adds the node before the other node in this list.
	 * @param nodeToAdd New node to add to this list.
	 * @param nodeInList The node in this list that should become as next to new node.
	 * If this parameter is not set, new node will be added as first node of this list.
	 * @return The node instance passed as nodeToAdd parameter
	 */
	[Inline]
	protected final function $addNodeBefore( nodeToAdd:*, nodeInList:* = null ):* {
		// if list is empty or the node need to add before head or nodeInList is not set, add node as first
		if ( _firstNode == null || nodeInList == null/* || nodeInList == _firstNode*/ ) {
			return $addNodeFirst( nodeToAdd );
		}

		/* Here this list contains at least two nodes */

		nodeToAdd.prev = nodeInList.prev;
		nodeToAdd.next = nodeInList;
		nodeInList.prev = nodeToAdd;
		(nodeToAdd.prev) && (nodeToAdd.prev.next = nodeToAdd);
		++_length;

		return nodeToAdd;
	}

	/**
	 * Adds the node after the other node in this list.
	 * @param nodeToAdd New node to add to this list.
	 * @param nodeInList The node in this list that should become as previous to new node.
	 * If this parameter is not set, new node will be added as last node of this list.
	 * @return The node instance passed as nodeToAdd parameter
	 */
	[Inline]
	protected final function $addNodeAfter( nodeToAdd:*, nodeInList:* = null ):* {
		// if list is empty or the node need to add after tail or nodeInList is not set, add node to the end
		if ( _firstNode == null || nodeInList == null /*|| nodeInList == _lastNode*/ ) {
			return $addNode( nodeToAdd );
		}

		/* Here this list contains at least two nodes */

		nodeToAdd.prev = nodeInList;
		nodeToAdd.next = nodeInList.next;
		nodeInList.next = nodeToAdd;
		(nodeToAdd.next) && (nodeToAdd.next.prev = nodeToAdd);
		//nodeToAdd.prev.next = nodeToAdd;
		//nodeToAdd.next.prev = nodeToAdd;
		++_length;

		return nodeToAdd;
	}

	/**
	 * Loop thought this list to find a node with specified index and than to add new node before
	 * Adds a node at the index position specified.
	 * @param node New node to add to this list.
	 * @param index The index position to which the node is added.
	 * If index <= 0 a node added as first node. If index >= list length, a node added to the end.
	 * @return The node instance passed as node parameter
	 */

	[Inline]
	protected final function $addNodeAt( node:*, index:int ):* {
		if ( _firstNode == null || index >= _length ) {
			return $addNode( node );
		}

		if ( index <= 0 ) {
			return $addNodeFirst( node );
		}

		var i:int = 1;
		for ( var nodeInList:* = _firstNode.next; nodeInList; nodeInList = nodeInList.next ) {
			if ( i == index ) {
				return $addNodeBefore( node, nodeInList );
			}
			i++;
		}

		return node;
	}

	/**
	 * Removes the specified node from the list.
	 * The prev and next properties of the removed node is NOT set to null because it can break a loop.
	 * @param node A node to remove.
	 */
	[Inline]
	protected final function $removeNode( node:* ):* {
		if ( node == _firstNode ) {
			_firstNode = _firstNode.next;
		}

		if ( node == _lastNode ) {
			_lastNode = _lastNode.prev;
		}

		if ( node.next ) {
			node.next.prev = node.prev;
		}

		if ( node.prev ) {
			node.prev.next = node.next;
		}
		--_length;
		return node;
	}

	[Inline]
	protected final function $removeFirstNode():* {
		if ( _firstNode ) {
			var node:* = _firstNode;
			_firstNode = _firstNode.next;
			if ( _firstNode ) {
				_firstNode.prev = null;
				node.next = null;
			} else {
				_lastNode = null;
			}
			--_length;
			return node;
		}
		return null;
		//return (_firstNode ? $removeNode( _firstNode ) : null);
	}

	[Inline]
	protected final function $removeLastNode():* {
		if ( _lastNode ) {
			var node:* = _lastNode;
			_lastNode = _lastNode.prev;
			if ( _lastNode ) {
				_lastNode.next = null;
				node.prev = null;
			} else {
				_firstNode = null;
			}
			--_length;
			return node;
		}
		return null;
		//return (_lastNode ? $removeNode( _lastNode ) : null);
	}

	[Inline]
	protected final function $removeAllNodes():void {
		while ( _firstNode ) {
			var node:* = _firstNode;
			_firstNode = _firstNode.next;
			node.prev = null;
			node.next = null;
		}
		_lastNode = null;
		_length = 0;
	}

	[Inline]
	protected final function $disposeBase():void {
		_firstNode = null;
		_lastNode = null;
		_length = NaN;
	}

	/**
	 * Swaps the positions of two nodes in the list. Useful when sorting a list.
	 */
	[Inline]
	protected final function $swap( node1:*, node2:* ):void {
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
			var temp:* = node1.prev;
			node1.prev = node2.prev;
			node2.prev = temp;
			temp = node1.next;
			node1.next = node2.next;
			node2.next = temp;
		}
		if ( _firstNode == node1 ) {
			_firstNode = node2;
		}
		else if ( _firstNode == node2 ) {
			_firstNode = node1;
		}
		if ( _lastNode == node1 ) {
			_lastNode = node2;
		}
		else if ( _lastNode == node2 ) {
			_lastNode = node1;
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
	[Inline]
	protected final function $insertionSort( sortFunction:Function ):void {
		if ( _firstNode == _lastNode ) {
			return;
		}
		var remains:* = _firstNode.next;
		for ( var node:* = remains; node; node = remains ) {
			remains = node.next;
			for ( var other:* = node.prev; other; other = other.prev ) {
				if ( sortFunction( node, other ) >= 0 ) {
					// move node to after other
					if ( node != other.next ) {
						// remove from place
						if ( _lastNode == node ) {
							_lastNode = node.prev;
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
				if ( _lastNode == node ) {
					_lastNode = node.prev;
				}
				node.prev.next = node.next;
				if ( node.next ) {
					node.next.prev = node.prev;
				}
				// insert at head
				node.next = _firstNode;
				_firstNode.prev = node;
				node.prev = null;
				_firstNode = node;
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
	[Inline]
	protected final function $mergeSort( sortFunction:Function ):void {
		if ( _firstNode == _lastNode ) {
			return;
		}
		var lists:Vector.<Object> = new Vector.<Object>;
		// disassemble the list
		var start:* = _firstNode;
		var end:*;
		while ( start ) {
			end = start;
			while ( end.next && sortFunction( end, end.next ) <= 0 ) {
				end = end.next;
			}
			var next:* = end.next;
			start.prev = end.next = null;
			lists.push( start );
			start = next;
		}
		// reassemble it in order
		while ( lists.length > 1 ) {
			lists.push( merge( lists.shift(), lists.shift(), sortFunction ) );
		}
		// find the tail
		_firstNode = lists[0];
		_lastNode = lists[0];
		while ( _lastNode.next ) {
			_lastNode = _lastNode.next;
		}
	}

	protected function merge( head1:*, head2:*, sortFunction:Function ):* {
		var node:*;
		var head:*;
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
	[Inline]
	protected final function $forEach( callback:Function, args:Array = null ):void {
		if ( _firstNode ) {
			if ( args ) {
				args.unshift( null );
			} else {
				args = [null];
			}

			for ( var node:* = _firstNode; node; node = node.next ) {
				args[0] = node;
				callback.apply( null, args );
			}
		}
	}
}
}
