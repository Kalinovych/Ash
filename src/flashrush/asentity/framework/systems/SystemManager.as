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
import flashrush.collections.LLNode;
import flashrush.collections.LinkedSet;
import flashrush.collections.NodeLinker;
import flashrush.utils.getClass;
import flashrush.utils.getClassName;

use namespace asentity;

/**
 * Simple node-based system list implementation with observers
 */
public class SystemManager implements ISystemManager {
	private var _list:NodeLinker = new NodeLinker();
	private var _nodeMap:Dictionary/*<Class, SystemNode>*/ = new Dictionary();
	private var _handlers:LinkedSet = new LinkedSet();
	
	public function SystemManager() {
		super();
	}
	
	public function get length():uint {
		return _list.length;
	}
	
	public function add( system:ISystem, order:int = 0 ):void {
		const type:Class = getClass( system );
		
		if ( _nodeMap[type] ) {
			//remove( type );
			throw new ArgumentError( "A system of type " + getClassName( type ) + " already added to the SystemManager" );
		}
		
		storeSystem( type, system, order );
		
		notifyHandlersSystemAdded( system );
		
		system.onAdded();
	}
	
	public function has( systemType:Class ):Boolean {
		return _nodeMap[systemType];
	}
	
	public function get( systemType:Class ):* {
		const node:SystemNode = _nodeMap[systemType];
		return ( node ? node.system : null );
	}
	
	public function remove( systemOrType:* ):ISystem {
		const type:Class = ( systemOrType is Class ? systemOrType : systemOrType.constructor );
		const systemNode:SystemNode = _nodeMap[type];
		if ( !systemNode ) {
			return null;
		}
		
		const system:ISystem = systemNode.system;
		
		delete _nodeMap[type];
		_list.unlink( systemNode );
		systemNode.system = null;
		
		system.onRemoved();
		
		return system;
	}
	
	public function removeAll():void {
		while ( _list.first ) {
			const node:SystemNode = _list.first;
			remove( node.system );
		}
	}
	
	public function update( delta:Number ):void {
		var node:SystemNode = _list.first;
		while ( node ) {
			node.system.update( delta );
			node = node.next;
		}
	}
	
	public function getOrderOf( system:* ):int {
		const type:Class = ( system is Class ? system : system.constructor );
		const systemNode:SystemNode = _nodeMap[type];
		if ( !systemNode ) {
			throw ArgumentError( "The system " + system + " not found!" )
		}
		return systemNode.order;
	}
	
	public function getList( result:Vector.<ISystem> = null ):Vector.<ISystem> {
		if ( result ) {
			result.length = _list.length;
		} else {
			result = new Vector.<ISystem>( _list.length );
		}
		var i:int = 0;
		for ( var node:SystemNode = _list.first; node; node = node.next, ++i ) {
			result[i] = node.system;
		}
		return result;
	}
	
	public function registerHandler( handler:ISystemHandler ):void {
		_handlers.add( handler );
	}
	
	public function unRegisterHandler( handler:ISystemHandler ):void {
		_handlers.remove( handler );
	}
	
	//-------------------------------------------
	// Private
	//-------------------------------------------
	
	private function storeSystem( systemType:Class, system:ISystem, order:int ):void {
		const node:SystemNode = new SystemNode();
		node.system = system;
		node.order = order;
		_nodeMap[systemType] = node;
		linkNode( node );
	}
	
	private function linkNode( node:SystemNode ):void {
		var prevNode:SystemNode = _list.last;
		while ( prevNode && prevNode.order > node.order ) {
			prevNode = prevNode.prev;
		}
		
		if ( prevNode ) {
			_list.linkAfter( node, prevNode );
		} else {
			_list.linkFirst( node )
		}
	}
	
	private function notifyHandlersSystemAdded( system:ISystem ):void {
		var handlerNode:LLNode = _handlers.firstNode;
		while ( handlerNode ) {
			var handler:ISystemHandler = handlerNode.item;
			handler.onSystemRemoved( system );
			handlerNode = handlerNode.nextNode;
		}
	}
	
}
}
