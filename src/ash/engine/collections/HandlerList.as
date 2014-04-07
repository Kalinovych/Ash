/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ash.engine.collections {
import flash.utils.Dictionary;

/**
 * @private
 */
internal class HandlerList {
	public var _head:HandlerNode;
	public var _tail:HandlerNode;
	public var registry:Dictionary;
	public var length:int = 0;

	public function HandlerList() {
		_head = new HandlerNode();
		_tail = new HandlerNode();
		_head.priority = int.MIN_VALUE;
		_tail.priority = int.MAX_VALUE;
		_head.next = _tail;
		_tail.prev = _head;
		registry = new Dictionary();
	}

	public function get head():HandlerNode {
		return (_head.next == _tail) ? null : _head.next;
	}

	public function get tail():HandlerNode {
		return (_tail.prev == _head) ? null : _tail.prev;
	}

	public function add( handler:*, priority:int ):HandlerNode {
		var prev:HandlerNode = _tail.prev;
		while ( prev != _head && prev.priority > priority ) {
			prev = prev.prev;
		}
		return insertAfter( handler, prev );
	}

	public function getNode( handler:* ):HandlerNode {
		return registry[handler];
	}

	public function remove( handler:* ):HandlerNode {
		var node:HandlerNode = registry[handler];
		if ( node ) removeNode( node );
		return node;
	}

	public function removeNode( node:HandlerNode ):HandlerNode {
		if ( node ) {
			node.prev.next = node.next;
			node.next.prev = node.prev;
			node.next = node.prev = null;
			length--;
		}
		return node;
	}

	public function pop():HandlerNode {
		return (length == 0) ? null : removeNode( _tail.prev );
	}

	public function shift():HandlerNode {
		return (length == 0) ? null : removeNode( _head.next );
	}

	protected function insertAfter( handler:*, prev:HandlerNode ):HandlerNode {
		if ( registry[handler] ) throw new Error( "Handler already in the list" );

		var node:HandlerNode = makeNode( handler );
		node.prev = prev;
		node.next = prev.next;
		node.prev.next = node;
		node.next.prev = node;

		length++;
		return node;
	}

	protected function insertBefore( handler:*, next:HandlerNode ):HandlerNode {
		if ( registry[handler] ) throw new Error( "Handler already in the list" );

		var node:HandlerNode = makeNode( handler );

		node.prev = next.prev;
		node.next = next;
		node.prev.next = node;
		node.next.prev = node;

		length++;
		return node;
	}

	protected function makeNode( handler:*, priority:int = 0 ):HandlerNode {
		// TODO: The pool of HandlerNode
		var node:HandlerNode = new HandlerNode();
		node.handler = handler;
		node.priority = priority;
		return node;
	}
}
}
