/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.systems {
import flash.utils.Dictionary;

import flashrush.asentity.framework.api.asentity;
import flashrush.asentity.framework.systems.api.ISystem;

use namespace asentity;

public class SystemList {
	private var _list:NodeLinker = new NodeLinker();
	private var _nodeMap:Dictionary = new Dictionary();
	
	public function SystemList() {
		super();
	}
	
	public final function get firstNode():SystemNode {
		return _list.first;
	}
	
	public final function get lastNode():SystemNode {
		return _list.last;
	}
	
	public final function get length():uint {
		return _list.length;
	}
	
	public function addNode( node:SystemNode ):void {
		
	}
	
	public function add( system:ISystem, order:int = 0 ):void {
		if ( _nodeMap[system] ) {
			remove( system );
		}
		
		const node:SystemNode = new SystemNode();
		node.system = system;
		node.order = order;
		
		_nodeMap[system] = node;
		
		var prevNode:SystemNode = _list.last;
		while ( prevNode && prevNode.order > order ) {
			prevNode = prevNode.prev;
		}
		
		if ( prevNode ) {
			_list.linkAfter( node, prevNode );
		} else {
			_list.linkFirst( node )
		}
	}
	
	public function remove( system:ISystem ):void {
		const node:SystemNode = _nodeMap[system];
		if ( node ) {
			delete _nodeMap[system];
			_list.unlink( node );
			node.system = null;
		}
	}
	
	public function removeAll():void {
		_list.unlinkAll(null);
		_nodeMap = new Dictionary();
	}
	
	public function getNode( system:ISystem ):SystemNode {
		return _nodeMap[system];
	}
}
}
