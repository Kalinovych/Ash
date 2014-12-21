/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.components {
public class ComponentHandlerNode {
	
	public function ComponentHandlerNode( item:IComponentHandler = null ) {
		handler = item;
	}
	
	public var handler:IComponentHandler;
	
	public var prev:ComponentHandlerNode;
	public var next:ComponentHandlerNode;
}
}
