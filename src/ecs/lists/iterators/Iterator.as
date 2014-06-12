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

	protected var _list:NodeList;
	protected var _node:Node = undefined;
	protected var _content:* = undefined;
	//protected var _nextNode:Node;

	public function Iterator( list:NodeList ) {
		_list = list;
	}

	/**
	 * Return a content of the current node
	 */
	[Inline]
	public final function get current():* {
		return _content;
	}
	
	
	/*
	TODO: What to do if withing iteration loop, current and next nodes will be removed by third party?
	 */
	
	public function pickNext():Boolean {
		var next:Node = (_node && _node.next ? _node.next : ( _node === undefined ? _list.$firstNode : null ) );
		if ( next ) {
			_node = next;
			_content = _node.content;
			return true;
		}
		return false;
	}

	/*public function removeCurrent():* {
		// _nextNode = _node.next;
		// _list.removeNode(_node);
		return _content;
	}*/

	public function dispose():void {
		_list = null;
		_node = null;
		_content = null;
		//_nextNode = null;

		_factory && _factory.recycle( this );
	}
}
}
