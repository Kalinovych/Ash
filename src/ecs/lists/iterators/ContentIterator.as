/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.lists.iterators {
import ecs.framework.api.ecsf;
import ecs.lists.NodeList;

use namespace ecsf;

/**
 * Node content iterator
 */
public class ContentIterator extends $ContentIterator {
	
	public function ContentIterator( list:NodeList ) {
		super( list );
	}

	[Inline]
	public final function get current():* {
		return _current;
	}

	public function next():* {
		_currentNode = ( _currentNode ? _currentNode.next : _list._firstNode );
		_current = ( _currentNode ? _currentNode.content : null );
		return _current;
	}

	public function first():* {
		_currentNode = _list._firstNode;
		_current = ( _currentNode ? _currentNode.content : null );
		return _current;
	}

	public function last():* {
		_currentNode = _list._lastNode;
		_current = ( _currentNode ? _currentNode.content : null );
		return _current;
	}
}
}
