/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.components {
import flash.utils.Dictionary;

import flashrush.asentity.framework.api.asentity;
import flashrush.collections.framework.InlineNodeLinker;

public class ComponentHandlerList {
	private var _list:InlineNodeLinker = new InlineNodeLinker();
	private var _nodes:Dictionary = new Dictionary();
	
	public function ComponentHandlerList() {
	}
	
	public final function get firstNode():ComponentHandlerNode {
		return _list.first;
	}
	
	public final function get lastNode():ComponentHandlerNode {
		return _list.last;
	}
	
	public function add( item:IComponentHandler ):Boolean {
		if (_nodes[item])
			return false;
		
		const node:ComponentHandlerNode = createNode( item );
		_nodes[item] = node;
		_list.linkLast( node );
		return true;
	}
	
	public function remove( item:IComponentHandler ):Boolean {
		const node:ComponentHandlerNode = _nodes[item];
		if (node) {
			deleteNode( node, false );
			return true;
		}
		return false;
	}
	
	asentity function removeAll():void {
		while ( _list.first ) {
			deleteNode( _list.first, true )
		}
	}
	
	public function forEach( callback:Function ):void {
		for ( var node:ComponentHandlerNode = _list.first; node; node = node.next ) {
			callback( node.handler );
		}
	}

//-------------------------------------------
// Private
//-------------------------------------------
	
	[Inline]
	private final function createNode( item:IComponentHandler ):ComponentHandlerNode {
		return new ComponentHandlerNode( item );
	}
	
	[Inline]
	private final function deleteNode( node:ComponentHandlerNode, disposeLinks:Boolean ):void {
		delete _nodes[node.handler];
		_list.unlink( node );
		node.handler = null;
		if (disposeLinks) {
			node.prev = null;
			node.next = null;
		}
	}
	
}
}
