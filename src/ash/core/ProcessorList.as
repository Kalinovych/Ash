/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ash.core {
import flash.utils.Dictionary;

internal class ProcessorList {
	public var _head:ProcessorNode;
	public var _tail:ProcessorNode;
	public var registry:Dictionary;
	public var length:int = 0;

	public function ProcessorList() {
		_head = new ProcessorNode();
		_tail = new ProcessorNode();
		_head.priority = int.MIN_VALUE;
		_tail.priority = int.MAX_VALUE;
		_head.next = _tail;
		_tail.prev = _head;
		registry = new Dictionary();
	}

	public function get head():ProcessorNode {
		return (_head.next == _tail) ? null : _head.next;
	}

	public function get tail():ProcessorNode {
		return (_tail.prev == _head) ? null : _tail.prev;
	}

	public function add( processor:*, priority:int ):ProcessorNode {
		var prev:ProcessorNode = _tail.prev;
		while ( prev != _head && prev.priority > priority ) {
			prev = prev.prev;
		}
		return insertAfter( processor, prev );
	}

	public function getNode( processor:* ):ProcessorNode {
		return registry[processor];
	}

	public function remove( processor:* ):ProcessorNode {
		var node:ProcessorNode = registry[processor];
		if ( node ) removeNode( node );
		return node;
	}

	public function removeNode( node:ProcessorNode ):ProcessorNode {
		if ( node ) {
			node.prev.next = node.next;
			node.next.prev = node.prev;
			node.next = node.prev = null;
			length--;
		}
		return node;
	}

	public function pop():ProcessorNode {
		return (length == 0) ? null : removeNode( _tail.prev );
	}

	public function shift():ProcessorNode {
		return (length == 0) ? null : removeNode( _head.next );
	}

	protected function insertAfter( processor:*, prev:ProcessorNode ):ProcessorNode {
		if ( registry[processor] ) throw new Error( "Processor already in the list" );

		var node:ProcessorNode = makeNode( processor );
		node.prev = prev;
		node.next = prev.next;
		node.prev.next = node;
		node.next.prev = node;

		length++;
		return node;
	}

	protected function insertBefore( processor:*, next:ProcessorNode ):ProcessorNode {
		if ( registry[processor] ) throw new Error( "Processor already in the list" );

		var node:ProcessorNode = makeNode( processor );

		node.prev = next.prev;
		node.next = next;
		node.prev.next = node;
		node.next.prev = node;

		length++;
		return node;
	}

	protected function makeNode( processor:*, priority:int = 0 ):ProcessorNode {
		// TODO: The pool of ProcessorNode
		var node:ProcessorNode = new ProcessorNode();
		node.processor = processor;
		node.priority = priority
		return node;
	}
}
}
