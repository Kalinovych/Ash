/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ash.engine.collections {
import ash.engine.lists.LinkedHashMap;

public class ElementCollection {
	private var mElements:LinkedHashMap;
	private var mTypedHandlers:LinkedHashMap;
	private var mHandlers:HandlerList;

	public function ElementCollection() {
		mElements = new LinkedHashMap();
		mTypedHandlers = new LinkedHashMap();
	}

	public function add( key:Object, element:* ):void {
		if ( mElements.contains( element ) ) {
			mElements.remove( key );
		}
		mElements.put( key, element );

		var processors:HandlerList = _handlersOf( key );
		if ( processors && processors.length ) {
			var pNode:HandlerNode = processors._head.next;
			while ( pNode != processors._tail ) {
				var p:IElementHandler = pNode.handler;
				p.handleElementAdded( element );
				pNode = pNode.next;
			}
		}
	}

	public function contains( key:* ):Boolean {
		return mElements.contains( key );
	}

	public function remove( key:* ):void {
		mElements.remove( key );
	}

	public function addElementHandler( handler:IElementHandler, elementKey:* = null, priority:int = 0 ):void {
		_handlersFor( elementKey ).add( handler, priority );
	}

	public function removeElementHandler( handler:IElementHandler, elementKey:* = null ):void {
		var handlers:HandlerList = _handlersOf( elementKey );
		if ( handlers ) handlers.remove( handler );
	}

	[Inline]
	protected final function _handlersFor( key:* = null ):HandlerList {
		if ( key == null ) {
			return mHandlers ||= new HandlerList();
		}
		var list:HandlerList = new HandlerList();
		mTypedHandlers.put( key, list );
		return list;
	}

	[Inline]
	protected final function _handlersOf( key:* ):HandlerList {
		return (key != null ? mTypedHandlers.get( key ) : mHandlers);
	}

}
}
