/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.components {
import flashrush.collections.base.LLNodeBase;
import flashrush.collections.list_internal;

use namespace list_internal;

public class ComponentHandlerNode extends LLNodeBase {
	
	public function ComponentHandlerNode( item:IComponentHandler = null ) {
		super( item );
	}
	
	public var handler:IComponentHandler;
	
	/*public final function get handler():IComponentHandler {
		return list_internal::item;
	}*/
	
	public final function get nextNode():ComponentHandlerNode {
		return list_internal::next;
	}
	
	public final function get prevNode():ComponentHandlerNode {
		return list_internal::prev;
	}
	
}
}
