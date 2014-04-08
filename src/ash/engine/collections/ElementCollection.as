/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ash.engine.collections {
import ash.engine.lists.AnyElementIterator;
import ash.engine.lists.LinkedHashMap;

public class ElementCollection {
	internal var mElements:LinkedHashMap;
	private var mTypedHandlers:LinkedHashMap/*.<HandlerList>*/;
	private var mHandlers:HandlerList;

	public function ElementCollection() {
		mElements = new LinkedHashMap();
		mTypedHandlers = new LinkedHashMap();
	}

	public function add( key:Object, element:* ):void {
		// if exists, remove and add to the end
		if ( mElements.contains( element ) ) {
			mElements.remove( key );
		}
		mElements.put( key, element );

		var handlers:HandlerList = _handlersOf( key );
		if ( handlers && handlers.length ) {
			var pNode:HandlerNode = handlers._head.next;
			while ( pNode != handlers._tail ) {
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
	
	public function getElementIterator():AnyElementIterator {
		return new AnyElementIterator( mElements );
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
