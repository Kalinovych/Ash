/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.systems {
import flash.utils.Dictionary;

import flashrush.asentity.framework.api.asentity;
import flashrush.asentity.framework.systems.api.ISystem;
import flashrush.gdf.api.gdf_core;
import flashrush.ds.InternalList;
import flashrush.ds.Node;

use namespace asentity;
use namespace gdf_core;

public class SystemList extends InternalList {
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
			$attach( node );
		} else {
			while ( nodeBefore && nodeBefore.order > order ) {
				nodeBefore = nodeBefore.prev;
			}
			if ( nodeBefore ) {
				$attachAfter( node, nodeBefore );
			} else {
				$attachFirst( node );
			}
		}
	}

	public function remove( system:ISystem ):void {
		var node:Node = nodeBySystem[system];
		if ( node ) {
			delete nodeBySystem[system];
			$detach( node );
		}
	}

}
}
