/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.lists {
import ashx.engine.ecse;

public class ElementIteratorBase {
	protected var _list:ItemList;
	protected var _currentNode:Node;
	protected var _current:*;

	public function ElementIteratorBase( list:ItemList ) {
		_list = list;
	}

	public function get length():int {
		return _list.length;
	}

	public function get isIterating():Boolean {
		return ( _current != null );
	}

	[Inline]
	protected final function $next():* {
		_currentNode = ( _currentNode ? _currentNode.next : _list.ecse::$firstNode );
		_current = ( _currentNode ? _currentNode.content : null );
		return _current;
	}

	[Inline]
	protected final function $first():* {
		_currentNode = _list.ecse::$firstNode;
		_current = ( _currentNode ? _currentNode.content : null );
		return _current;
	}

	[Inline]
	protected final function $last():* {
		_currentNode = _list.ecse::$lastNode;
		_current = ( _currentNode ? _currentNode.content : null );
		return _current;
	}

	/**
	 * Makes a node as a current node
	 * @param node
	 * @return
	 */
	[Inline]
	protected final function $selectNode( node:Node ):* {
		_currentNode = node;
		_current = ( _currentNode ? _currentNode.content : null );
		return _current;
	}
}
}
