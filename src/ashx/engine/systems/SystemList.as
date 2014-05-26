/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.systems {
import ashx.engine.ecse;
import ashx.engine.lists.ItemList;
import ashx.engine.lists.ItemNode;

import flash.utils.Dictionary;

use namespace ecse;

public class SystemList extends ItemList {
	protected var nodeBySystem:Dictionary = new Dictionary();
	
	public function SystemList() {
		super();
	}

	public function get firstNode():ItemNode {
		return _firstNode;
	}

	public function get lastNode():ItemNode {
		return _lastNode;
	}
	
	public function add( system:ESystem, order:int ):void {
		if ( nodeBySystem[system] ) {
			remove( system );
		}

		var node:ItemNode = $createNode( system );
		node.order = order;
		nodeBySystem[system] = node;

		var nodeBefore:ItemNode = _lastNode;
		if ( nodeBefore == null || nodeBefore.order <= order ) {
			$addNode( node );
		} else {
			while ( nodeBefore.order > order ) {
				nodeBefore = nodeBefore.prev;
			}
			if ( nodeBefore ) {
				$addNodeAfter( node, nodeBefore );
			} else {
				$addNodeFirst( node );
			}
		}
	}

	public function remove( system:ESystem ):void {
		var node:ItemNode = nodeBySystem[system];
		if ( node ) {
			delete nodeBySystem[system];
			$removeNode( node );
		}
	}
	
}
}
