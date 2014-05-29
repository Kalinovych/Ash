/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.framework.systems {
import ecs.framework.api.ecsf;
import ecs.framework.systems.api.ISystem;
import ecs.lists.Node;
import ecs.lists.NodeList;

import flash.utils.Dictionary;

use namespace ecsf;

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
