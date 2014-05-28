/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.systems {
import ashx.engine.api.ecse;
import ashx.engine.systems.api.ISystem;
import ashx.lists.Node;
import ashx.lists.NodeList;

import flash.utils.Dictionary;

use namespace ecse;

public class SystemList extends NodeList {
	protected var nodeBySystem:Dictionary = new Dictionary();

	public function SystemList() {
		super();
	}

	public function get firstNode():Node {
		return _firstNode;
	}

	public function get lastNode():Node {
		return _lastNode;
	}

	public function add( system:ISystem, order:int = 0 ):void {
		if ( nodeBySystem[system] ) {
			remove( system );
		}

		var node:Node = $createNode( system );
		node.order = order;
		nodeBySystem[system] = node;

		// add with the order
		var nodeBefore:Node = _lastNode;
		if ( nodeBefore == null || nodeBefore.order <= order ) {
			$addNode( node );
		} else {
			while ( nodeBefore && nodeBefore.order > order ) {
				nodeBefore = nodeBefore.prev;
			}
			if ( nodeBefore ) {
				$addNodeAfter( node, nodeBefore );
			} else {
				$addNodeFirst( node );
			}
		}
	}

	public function remove( system:ISystem ):void {
		var node:Node = nodeBySystem[system];
		if ( node ) {
			delete nodeBySystem[system];
			$removeNode( node );
		}
	}

}
}
