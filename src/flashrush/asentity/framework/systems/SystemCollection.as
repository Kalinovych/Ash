/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.systems {
import flash.utils.Dictionary;

import flashrush.asentity.framework.api.asentity;
import flashrush.asentity.framework.systems.api.ISystem;
import flashrush.asentity.framework.systems.api.ISystemHandler;
import flashrush.asentity.framework.systems.api.ISystemManager;
import flashrush.gdf.api.gdf_core;
import flashrush.gdf.ds.InternalList;
import flashrush.gdf.ds.LinkedSet;
import flashrush.gdf.ds.Node;

use namespace asentity;
use namespace gdf_core;

/**
 * Simple node-based system list implementation with observers
 */
public class SystemCollection extends InternalList implements ISystemManager {
	protected var _nodeMap:Dictionary/*<SystemClass, Node>*/ = new Dictionary();
	protected var _handlers:LinkedSet = new LinkedSet();

	public function SystemCollection() {
		super();
	}

	public function get length():uint {
		return _length;
	}

	public function add( system:ISystem, order:int = 0 ):void {
		var type:Class = system.constructor;
		if ( _nodeMap[type] ) {
			remove( type );
		}

		var node:Node = $createNode( system );
		_nodeMap[type] = node;
		$attachOrdered( node, order );
		system.onAdded();

		// notify observers
		var handlerNode:Node = _handlers.$firstNode;
		while ( handlerNode ) {
			var handler:ISystemHandler = handlerNode.item;
			handler.onSystemAdded( system );
			handlerNode = handlerNode.next;
		}
	}

	public function get( systemType:Class ):* {
		var node:Node = _nodeMap[systemType];
		return ( node ? node.item : null );
	}

	public function remove( system:* ):* {
		var type:Class = ( system is Class ? system : system.constructor );
		var systemNode:Node = _nodeMap[type];
		if ( !systemNode ) {
			return null;
		}

		system = systemNode.item;
		delete _nodeMap[type];
		$detach( systemNode );
		systemNode.item = null;
		system.onRemoved();

		// notify observers
		var handlerNode:Node = _handlers.$firstNode;
		while ( handlerNode ) {
			var handler:ISystemHandler = handlerNode.item;
			handler.onSystemRemoved( system );
			handlerNode = handlerNode.next;
		}

		return system;
	}

	public function removeAll():void {
		while ( $firstNode ) {
			remove( $firstNode.item );
		}
	}

	public function getList( result:Vector.<ISystem> = null ):Vector.<ISystem> {
		if ( result ) {
			result.length = _length;
		} else {
			result = new Vector.<ISystem>( _length );
		}
		var i:uint = 0;
		for ( var node:Node = _firstNode; node; node = node.next, i++ ) {
			result[i] = node.item
		}
		return result;
	}

	public function registerHandler( handler:ISystemHandler ):void {
		_handlers.add( handler );
	}

	public function unRegisterHandler( handler:ISystemHandler ):void {
		_handlers.remove( handler );
	}
}
}
