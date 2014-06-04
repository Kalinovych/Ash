/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.framework.systems {
import ecs.framework.api.ecs_core;
import ecs.framework.systems.api.ISystem;
import ecs.framework.systems.api.ISystemHandler;
import ecs.framework.systems.api.ISystemManager;
import ecs.lists.LinkedSet;
import ecs.lists.Node;
import ecs.lists.NodeList;

import flash.utils.Dictionary;

use namespace ecs_core;

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
		nodeBySystemType[type] = node;
		$addNodeOrdered( node, order );
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
		var systemNode:Node = nodeBySystemType[type];
		if ( !systemNode ) {
			return null;
		}
		
		system = systemNode.content;
		delete nodeBySystemType[type];
		$removeNode( systemNode );
		systemNode.content = null;
		
		// notify observers
		var handlerNode:Node = handlers.$firstNode;
		while ( handlerNode ) {
			var handler:ISystemHandler = handlerNode.content;
			handler.onSystemRemoved( system );
			handlerNode = handlerNode.next;
		}
		
		return system;
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
