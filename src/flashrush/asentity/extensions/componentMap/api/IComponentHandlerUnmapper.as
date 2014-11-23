/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions.componentMap.api {
import flashrush.asentity.framework.componentManager.IComponentHandler;

public interface IComponentHandlerUnmapper {
	function fromHandler( handler:IComponentHandler ):void;
	
	function fromAll():void;
}
}
