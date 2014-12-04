/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.systems {
import flashrush.asentity.framework.api.asentity;
import flashrush.asentity.framework.systems.api.ISystem;
import flashrush.asentity.framework.systems.api.ISystemHandler;
import flashrush.asentity.framework.systems.api.ISystemManager;
import flashrush.collections.LLNode;
import flashrush.collections.LinkedSet;
import flashrush.collections.NodeLinker;

use namespace asentity;

/**
 * Simple node-based system list implementation with observers
 */
public class SystemNodeManager implements ISystemManager {
	private var _linker:NodeLinker = new NodeLinker();
	//private var _nodeMap:Dictionary/*<Class, SystemNode>*/ = new Dictionary();
	private var _handlers:LinkedSet = new LinkedSet();
	
	public function SystemNodeManager() {
		super();
	}
	
	public final function get length():uint {
		return _linker.length;
	}
	
	public final function get firstSystemNode():SystemNode {
		return _linker.first;
	}
	
	public final function get lastSystemNode():SystemNode {
		return _linker.last;
	}
	
	public function add( system:ISystem, order:int = 0 ):void {
		const node:SystemNode = new SystemNode();
		node.system = system;
		node.order = order;
		
		linkNode( node );
		
		notifyHandlersSystemAdded( system );
		
		system.onAdded();
	}
	
	public function remove( system:ISystem ):Boolean {
		var node:SystemNode = firstSystemNode;
		while ( node && node.system != system ) {
			node = node.next;
		}
		
		if ( node ) {
			_linker.unlink( node );
			node.system = null;
		}
		
		system.onRemoved();
		
		notifyHandlersSystemRemoved( system );
		
		return system;
	}
	
	public function removeAll():void {
		while ( _linker.first ) {
			const node:SystemNode = _linker.first;
			remove( node.system );
		}
	}
	
	public function get( systemType:Class ):* {
		var node:SystemNode = firstSystemNode;
		while ( node ) {
			if ( node.system is systemType ) {
				return node.system;
			}
			node = node.next;
		}
		return null;
	}
	
	public function update( delta:Number ):void {
		var node:SystemNode = _linker.first;
		while ( node ) {
			//node.system.update( delta );
			node = node.next;
		}
	}
	
	public function getList( result:Vector.<ISystem> = null ):Vector.<ISystem> {
		if ( result ) {
			result.length = _linker.length;
		} else {
			result = new Vector.<ISystem>( _linker.length );
		}
		var i:int = 0;
		for ( var node:SystemNode = _linker.first; node; node = node.next, ++i ) {
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
	
	private function linkNode( node:SystemNode ):void {
		var prevNode:SystemNode = _linker.last;
		while ( prevNode && prevNode.order > node.order ) {
			prevNode = prevNode.prev;
		}
		
		if ( prevNode ) {
			_linker.linkAfter( node, prevNode );
		} else {
			_linker.linkFirst( node )
		}
	}
	
	private function notifyHandlersSystemAdded( system:ISystem ):void {
		var handlerNode:LLNode = _handlers.firstNode;
		while ( handlerNode ) {
			var handler:ISystemHandler = handlerNode.item;
			handler.onSystemAdded( system );
			handlerNode = handlerNode.nextNode;
		}
	}
	
	private function notifyHandlersSystemRemoved( system:ISystem ):void {
		var handlerNode:LLNode = _handlers.firstNode;
		while ( handlerNode ) {
			var handler:ISystemHandler = handlerNode.item;
			handler.onSystemRemoved( system );
			handlerNode = handlerNode.nextNode;
		}
	}
	
}
}
