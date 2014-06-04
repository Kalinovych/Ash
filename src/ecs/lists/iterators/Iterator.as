/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.lists.iterators {
import ecs.framework.api.ecs_core;
import ecs.lists.Node;
import ecs.lists.NodeList;

use namespace ecs_core;

public class Iterator {
	ecs_core var _factory:*;
	
	//ecs_core var _list:NodeList;
	protected var _node:Node;
	protected var _nextNode:Node;
	protected var _content:*;

	public function Iterator( list:NodeList ) {
		//_list = list;
		_nextNode = list.$firstNode;
	}

	[Inline]
	public final function get current():* {
		return _content;
	}

	public function pickNext():Boolean {
		if ( _nextNode ) {
			_node = _nextNode;
			_nextNode = null;
		}

		if ( _node == null || _node.next == null ) {
			_node = null;
			_content = null;
			return false;
		}

		_node = _node.next;
		_content = _node.content;
		return true;
	}

	public function removeCurrent():* {
		// _nextNode = _node.next;
		// _list.removeNode(_node);
		return _content;
	}

	public function dispose():void {
		//_list = null;
		_node = null;
		_nextNode = null;
		_content = null;

		//_factory && _factory.recycle( this );
	}
}
}
