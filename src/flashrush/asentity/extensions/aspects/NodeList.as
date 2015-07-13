/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions.aspects {
import ash.signals.Signal1;

import flashrush.collections.framework.InlineNodeLinker;

/**
 *
 */
public class NodeList {
//-------------------------------------------
// Events
//-------------------------------------------
	
	/**
	 * A signal that is dispatched whenever a node is added to the node list.
	 *
	 * <p>The signal will pass a single parameter to the listeners - the node that was added.</p>
	 */
	public const OnItemAdded:Signal1 = new Signal1( EntityNode );
	
	/**
	 * A signal that is dispatched whenever a node is removed from the node list.
	 *
	 * <p>The signal will pass a single parameter to the listeners - the node that was removed.</p>
	 */
	public const OnItemRemoved:Signal1 = new Signal1( EntityNode );
	
	/**
	 * List of nodes that was added in the current update
	 */
	public const addedItems:Vector.<EntityNode> = new Vector.<EntityNode>();
	
	/**
	 * List of nodes that was removed in the current update
	 */
	public const removedItems:Vector.<EntityNode> = new Vector.<EntityNode>();
	
//-------------------------------------------
// Internal fields
//-------------------------------------------
	
	internal var nodes:InlineNodeLinker = new InlineNodeLinker();
	
//-------------------------------------------
// Constructor
//-------------------------------------------
	
	/**
	 * @private
	 * Constructor
	 */
	function NodeList() {}
	
//-------------------------------------------
// Properties
//-------------------------------------------
	
	public final function get first():* {
		return nodes.first;
	}
	
	public final function get last():* {
		return nodes.last;
	}
	
	/**
	 * The number of aspects in the list.
	 */
	public final function get length():int {
		return nodes.length;
	}
	
	/**
	 * Determines whether the list is empty or not. false if the list contains at lease one element.
	 */
	public final function get empty():Boolean {
		return !nodes.first;
	}
	
//-------------------------------------------
// Public: common methods
//-------------------------------------------
	
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
	public function forEach( callback:Function, arg:* = undefined ):void {
		var aspect:EntityNode;
		if ( arg ) {
			for ( aspect = nodes.first as EntityNode; aspect; aspect = aspect.next ) {
				callback( aspect, arg );
			}
		} else {
			for ( aspect = nodes.first as EntityNode; aspect; aspect = aspect.next ) {
				callback( aspect );
			}
		}
	}
	
//-------------------------------------------
// Public: Sorting methods
//-------------------------------------------
	
	/**
	 * Swaps the positions of two nodes in the list. Useful when sorting a list.
	 */
	public function swap( node1:EntityNode, node2:EntityNode ):void {
		nodes.swap( node1, node2 );
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
		nodes.insertionSort( sortFunction );
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
		nodes.mergeSort( sortFunction );
	}
	
//-------------------------------------------
// Internals
//-------------------------------------------
	
	internal function resetSession():void {
		addedItems.length = 0;
		removedItems.length = 0;
	}
	
	internal function add( node:EntityNode ):void {
		nodes.linkLast( node );
		addedItems[addedItems.length] = node;
		OnItemAdded.dispatch( node );
	}
	
	internal function remove( node:EntityNode ):void {
		nodes.unlink( node );
		removedItems[removedItems.length] = node;
		OnItemRemoved.dispatch( node );
		// N.B. Don't set node.next and node.prev to null
		// because that can break an iteration that uses next/prev properties.
	}
	
	internal function removeAll():void {
		nodes.unlinkAll( OnItemRemoved.dispatch );
	}
}
}