/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions.componentHandlerMap.api {
import flashrush.asentity.framework.components.IComponentHandler;

public interface IComponentHandlerUnmapper {
	function fromHandler( handler:IComponentHandler ):void;
	
	function fromAll():void;
}
}
