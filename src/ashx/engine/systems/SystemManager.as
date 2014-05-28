/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.systems {
import ashx.engine.api.ecse;
import ashx.engine.systems.api.ISystem;
import ashx.engine.systems.api.ISystemHandler;
import ashx.engine.systems.api.ISystemManager;
import ashx.lists.LinkedSet;
import ashx.lists.Node;
import ashx.lists.NodeList;

import flash.utils.Dictionary;

use namespace ecse;

public class SystemManager extends NodeList implements ISystemManager {
	protected var nodeBySystemType:Dictionary = new Dictionary();
	protected var handlers:LinkedSet = new LinkedSet();

	public function SystemManager() {
		super();
	}

	public function add( system:ISystem, order:int = 0 ):void {
		var type:Class = system.constructor;
		if ( nodeBySystemType[type] ) {
			remove( type );
		}

		var node:Node = $createNode( system );
		node.order = order;
		nodeBySystemType[type] = node;

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

		// notify observers
		var handlerNode:Node = handlers.$firstNode;
		while ( handlerNode ) {
			var handler:ISystemHandler = handlerNode.content;
			handler.onSystemAdded( system );
			handlerNode = handlerNode.next;
		}
	}

	public function get( systemType:Class ):* {
		var node:Node = nodeBySystemType[systemType];
		return ( node ? node.content : null );
	}

	public function remove( system:* ):* {
		var type:Class = ( system is Class ? system : system.constructor );
		var node:Node = nodeBySystemType[type];
		if ( !node ) {
			return null;
		}

		delete nodeBySystemType[type];
		$removeNode( node );

		var handlerNode:Node = handlers.$firstNode;
		while ( handlerNode ) {
			var handler:ISystemHandler = handlerNode.content;
			handler.onSystemRemoved( system );
			handlerNode = handlerNode.next;
		}

		return node.content;
	}

	public function removeAll():void {
		while ( $firstNode ) {
			remove( $firstNode.content );
		}
	}

	public function registerHandler( handler:ISystemHandler ):void {
		handlers.add( handler );
	}

	public function unregisterHandler( handler:ISystemHandler ):void {
		handlers.remove( handler );
	}
}
}
