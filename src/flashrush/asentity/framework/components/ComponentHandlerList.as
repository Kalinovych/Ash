/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.components {
import flash.utils.Dictionary;

import flashrush.asentity.framework.api.asentity;
import flashrush.collections.base.LinkedCollection;
import flashrush.collections.factories.CustomLLNodeFactory;
import flashrush.collections.list_internal;

public class ComponentHandlerList extends LinkedCollection {
	private static var nodeFactory:CustomLLNodeFactory = new CustomLLNodeFactory( ComponentHandlerNode, "handler" );
	
	private var _nodes:Dictionary = new Dictionary();
	
	public function ComponentHandlerList() {
		super( nodeFactory );
	}
	
	public final function get firstNode():ComponentHandlerNode {
		return list_internal::first;
	}
	
	public final function get lastNode():ComponentHandlerNode {
		return list_internal::last;
	}
	
	public function add( item:IComponentHandler ):Boolean {
		if ( _nodes[item] )
			return false;
		
		const node:ComponentHandlerNode = _nodeFactory.createNode( item );
		list_internal::linkLast( node );
		return true;
	}
	
	public function remove( item:IComponentHandler ):Boolean {
		const node:ComponentHandlerNode = _nodes[item];
		if ( node ) {
			delete _nodes[item];
			list_internal::unlink( node );
			_nodeFactory.disposeNode( node );
			return true;
		}
		return false;
	}
	
	asentity function removeAll():void {
		list_internal::unlinkAll( null );
	}
}
}
