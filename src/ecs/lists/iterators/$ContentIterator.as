/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.lists.iterators {
import ecs.framework.api.ecs_core;
import ecs.lists.Node;
import ecs.lists.NodeList;

use namespace ecs_core;

public class $ContentIterator extends IteratorBase {
	protected var _currentNode:Node;
	protected var _current:*;
	
	public function $ContentIterator( list:NodeList ) {
		super( list );
	}

	[Inline]
	protected final function $next():* {
		_currentNode = ( _currentNode ? _currentNode.next : _list._firstNode );
		_current = ( _currentNode ? _currentNode.content : null );
		return _current;
	}

	[Inline]
	protected final function $first():* {
		_currentNode = _list._firstNode;
		_current = ( _currentNode ? _currentNode.content : null );
		return _current;
	}

	[Inline]
	protected final function $last():* {
		_currentNode = _list._lastNode;
		_current = ( _currentNode ? _currentNode.content : null );
		return _current;
	}
}
}
