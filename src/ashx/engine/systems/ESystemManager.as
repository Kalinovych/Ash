/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.systems {
import ashx.engine.ecse;
import ashx.engine.entity.IEntityHandler;
import ashx.engine.lists.ItemList;
import ashx.engine.lists.LinkedSet;
import ashx.engine.lists.ListBase;
import ashx.engine.lists.Node;

import flash.utils.Dictionary;

use namespace ecse;

public class ESystemManager extends ItemList {
	protected var nodeBySystem:Dictionary = new Dictionary();
	protected var _handlers:LinkedSet;
	
	public function ESystemManager() {
		super();
	}

	public function add( system:ESystem, order:int = 0 ):void {
		if ( nodeBySystem[system] ) {
			remove( system );
		}

		var node:Node = $createNode( system );
		node.order = order;
		nodeBySystem[system] = node;

		// add with order
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

	public function remove( system:ESystem ):void {
		var node:Node = nodeBySystem[system];
		if ( node ) {
			delete nodeBySystem[system];
			$removeNode( node );
		}
	}

	public function get( systemType:Class ):* {
		
	}

	/*ecse function registerHandler( handler:ISystemHandler ):Boolean {
		return _handlers.add( handler );
	}

	ecse function unregisterHandler( handler:ISystemHandler ):Boolean {
		return _handlers.remove( handler );
	}*/
}
}
