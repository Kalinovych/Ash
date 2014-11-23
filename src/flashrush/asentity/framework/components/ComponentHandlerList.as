/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.components {
import flash.utils.Dictionary;

import flashrush.asentity.framework.api.asentity;
import flashrush.collections.LLNode;
import flashrush.collections.LinkedCollection;
import flashrush.collections.list_internal;

public class ComponentHandlerList extends LinkedCollection {
	private var _nodes:Dictionary = new Dictionary();
	
	public function ComponentHandlerList() {}
	
	public final function get firstNode():LLNode {
		return list_internal::first;
	}
	
	public final function get lastNode():LLNode {
		return list_internal::last;
	}
	
	public function add( item:IComponentHandler ):Boolean {
		if ( _nodes[item] )
			return false;
		
		const node:LLNode = new LLNode( item );
		_nodes[item] = node;
		list_internal::linkLast( node );
		return true;
	}
	
	public function remove( item:IComponentHandler ):Boolean {
		const node:LLNode = _nodes[item];
		if ( node ) {
			node.list_internal::item = null;
			delete _nodes[item];
			list_internal::unlink( node );
			return true;
		}
		return false;
	}
	
	asentity function removeAll():void {
		//unlinkAll();
	}
}
}
