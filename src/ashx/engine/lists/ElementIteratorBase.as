/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.lists {
import ashx.engine.ecse;

public class ElementIteratorBase {
	protected var _elements:ElementList;
	protected var _currentNode:ItemNode;
	protected var _current:*;

	public function ElementIteratorBase( elements:ElementList ) {
		_elements = elements;
	}

	public function get length():int {
		return _elements.length;
	}

	public function get isIterating():Boolean {
		return ( _current != null );
	}

	[Inline]
	protected final function _next():* {
		_currentNode = ( _currentNode ? _currentNode.next : _elements.ecse::_firstNode );
		_current = ( _currentNode ? _currentNode.item : null );
		return _current;
	}

	[Inline]
	protected final function _first():* {
		_currentNode = _elements.ecse::_firstNode;
		_current = ( _currentNode ? _currentNode.item : null );
		return _current;
	}

	[Inline]
	protected final function _last():* {
		_currentNode = _elements.ecse::_lastNode;
		_current = ( _currentNode ? _currentNode.item : null );
		return _current;
	}

	[Inline]
	protected final function _selectElement( node:ItemNode ):* {
		_currentNode = node;
		_current = ( _currentNode ? _currentNode.item : null );
		return _current;
	}
}
}
