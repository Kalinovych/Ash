/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.lists.iterators {
import ashx.engine.api.ecse;
import ashx.lists.Node;
import ashx.lists.NodeList;

use namespace ecse;

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