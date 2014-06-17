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

/**
 * Simple node-based system list implementation with observers
 */
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
		$attachOrdered( node, order );

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

	public function getList( result:Vector.<ISystem> = null ):Vector.<ISystem> {
		if ( result ) {
			result.length = _length;
		} else {
			result = new Vector.<ISystem>( _length );
		}
		var i:uint = 0;
		for ( var node:Node = _firstNode; node; node = node.next, i++ ) {
			result[i] = node.content
		}
		return result;
	}

	public function remove( system:* ):* {
		var type:Class = ( system is Class ? system : system.constructor );
		var systemNode:Node = nodeBySystemType[type];
		if ( !systemNode ) {
			return null;
		}

		system = systemNode.content;
		delete nodeBySystemType[type];
		$detach( systemNode );
		systemNode.content = null;
		system.removed();

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
